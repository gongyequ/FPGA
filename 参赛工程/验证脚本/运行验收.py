"""Project audit runner. Runs real tools; never substitutes their PASS status.
Windows main-process peak working set and process-launch-to-exit wall time.
"""
from pathlib import Path
import argparse, ctypes, hashlib, json, os, statistics, subprocess, time
from datetime import datetime, timezone

ROOT = Path(__file__).resolve().parents[1]

def save(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2), encoding='utf-8')

def sha(path): return hashlib.sha256(path.read_bytes()).hexdigest()

class Counters(ctypes.Structure):
    _fields_ = [('cb', ctypes.c_ulong), ('PageFaultCount', ctypes.c_ulong)] + [
        (name, ctypes.c_size_t) for name in ['PeakWorkingSetSize', 'WorkingSetSize',
        'QuotaPeakPagedPoolUsage', 'QuotaPagedPoolUsage', 'QuotaPeakNonPagedPoolUsage',
        'QuotaNonPagedPoolUsage', 'PagefileUsage', 'PeakPagefileUsage']]

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--mode', choices=['area', 'performance'], default='area')
    ap.add_argument('--name', required=True)
    ap.add_argument('--variants', nargs='+', default=['original', 'optimized'])
    args = ap.parse_args()
    if not args.name.isascii() or '/' in args.name or '\\' in args.name: raise ValueError('ASCII run name required')
    ctypes.windll.kernel32.SetErrorMode(0x8003)
    psapi = ctypes.WinDLL('psapi', use_last_error=True)
    psapi.GetProcessMemoryInfo.argtypes = [ctypes.c_void_p, ctypes.POINTER(Counters), ctypes.c_ulong]
    psapi.GetProcessMemoryInfo.restype = ctypes.c_int
    output = ROOT/'实测记录'/args.name
    if output.exists(): raise RuntimeError('Existing evidence is not overwritten: '+str(output))
    output.mkdir(parents=True)
    drive = None
    for letter in ['S:', 'T:', 'U:']:
        if not Path(letter+'/').exists():
            subprocess.run(['subst', letter, str(ROOT)], check=True, capture_output=True)
            drive = letter; break
    if drive is None: raise RuntimeError('No free audit drive')
    # Junction names are ASCII solely for upstream Windows EDA path compatibility.
    aliases = {'cases':'官方测试用例', 'out':'实测记录', 'original':'原版程序', 'optimized':'优化程序'}
    for alias, real in aliases.items():
        dest = ROOT/real; dest.mkdir(exist_ok=True)
        link = ROOT/alias
        if not link.exists():
            subprocess.run(['cmd','/d','/c','mklink','/J',str(link),str(dest)],check=True,capture_output=True)
    suite = drive+'/suite'
    env = os.environ.copy()
    env['PATH'] = suite+'/bin;'+suite+'/lib;'+env.get('PATH','')
    env['TCL_LIBRARY'] = suite+'/lib/tcl8.6'
    env['YOSYSHQ_ROOT'] = suite
    env['YOSYS_DATDIR'] = suite+'/share/yosys'
    cases = json.loads((ROOT/'官方测试用例/用例来源.json').read_text(encoding='utf-8'))
    def runtime(p):
        parts = p.relative_to(ROOT).parts
        reverse = {v:k for k,v in aliases.items()}
        return drive+'/'+ '/'.join([reverse.get(parts[0],parts[0]),*parts[1:]])
    def exe(variant):
        return suite+'/bin/yosys.exe' if variant=='upstream' else drive+'/'+variant+'/yosys.exe'
    def execute(cmd, stem, limit=65):
        peak=0; samples=0; final_memory_ok=False
        started=datetime.now(timezone.utc).isoformat()
        with stem.with_suffix('.log').open('wb') as log:
            start=time.perf_counter()
            p=subprocess.Popen(cmd,cwd=drive+'/',env=env,stdout=log,stderr=subprocess.STDOUT)
            while True:
                c=Counters();c.cb=ctypes.sizeof(c)
                ok=psapi.GetProcessMemoryInfo(int(p._handle),ctypes.byref(c),ctypes.sizeof(c))
                if ok: peak=max(peak,c.PeakWorkingSetSize);samples+=1
                code=p.poll()
                if code is not None:
                    c=Counters();c.cb=ctypes.sizeof(c)
                    final_memory_ok=bool(psapi.GetProcessMemoryInfo(int(p._handle),ctypes.byref(c),ctypes.sizeof(c)))
                    if final_memory_ok:peak=max(peak,c.PeakWorkingSetSize)
                    break
                if time.perf_counter()-start>limit:
                    p.kill();p.wait();code=124;break
                time.sleep(0.001)
            elapsed=time.perf_counter()-start
        record=dict(command=cmd,started_utc=started,exit_code=code,wall_seconds=elapsed,
                    peak_working_set_bytes=peak,memory_samples=samples,final_memory_query_ok=final_memory_ok)
        save(stem.with_suffix('.command.json'),record)
        if code!=0 or not peak:raise RuntimeError(f'Execution failed: {stem}, rc={code}, peak={peak}')
        return record
    def run(case,variant,suffix,area=False):
        directory=output/case['case'];directory.mkdir(exist_ok=True)
        stem=directory/(variant+'-'+suffix)
        script=[f'read_verilog -sv {drive}/cases/{case["file"]}',
                f'hierarchy -check -top {case["top"]}']
        # ABC executable is identical for both variants, with no ABC script injected here.
        script.append(f'scratchpad -set abc9.exe {suite}/bin/yosys-abc.exe')
        script.append(f'synth_intel -family cycloneiv -top {case["top"]}'+(' -run begin:map_cells' if area else ''))
        if area:
            script += [f'write_rtlil {runtime(stem.with_suffix(".il"))}',f'write_json {runtime(stem.with_suffix(".json"))}']
        script += ['stat']
        stem.with_suffix('.ys').write_text('\n'.join(script)+'\n',encoding='ascii')
        rec=execute([exe(variant),'-Q','-s',runtime(stem.with_suffix('.ys'))],stem)
        rec.update(case=case['case'],variant=variant)
        if area:
            design=json.loads(stem.with_suffix('.json').read_text())
            module=design['modules'][case['top']];counts={}
            for cell in module['cells'].values():counts[cell['type']]=counts.get(cell['type'],0)+1
            rec.update(cell_types=counts,lut=counts.get('$lut',0),inverters=counts.get('$_NOT_',0)+counts.get('$not',0),
                       dff=counts.get('dffeas',0),io_bits=sum(len(p['bits']) for p in module['ports'].values()))
            rec['logic_area']=rec['lut']+rec['inverters']
        return rec
    try:
        manifest={'mode':args.mode,'cases':cases,'variants':args.variants,
                  'area_boundary':'after ABC9/clean/opt/autoname, before map_cells',
                  'timing_boundary':'full read/hierarchy/synth_intel/stat; parent wall time includes ABC child',
                  'memory':'Windows GetProcessMemoryInfo PeakWorkingSetSize; main yosys only',
                  'repeat_policy':'10 baseline nested warmups; initial pair; if either overhead >5%, 5 fresh pairs, arithmetic means',
                  'versions':{},'sha256':{}}
        for v in args.variants:
            execute([exe(v),'-V'],output/('version-'+v))
            manifest['versions'][v]=(output/('version-'+v+'.log')).read_text(errors='replace').strip()
            manifest['sha256'][v]=sha(Path(exe(v)))
            if '0.69' not in manifest['versions'][v]: raise RuntimeError('Baseline must be Yosys 0.69')
        manifest['sha256']['abc']=sha(Path(suite+'/bin/yosys-abc.exe'))
        save(output/'manifest.json',manifest)
        rows=[]
        if args.mode=='area':
            for c in cases:
                for v in args.variants:
                    row=run(c,v,'area',True);rows.append(row)
                    print(c['case'],v,row['logic_area'],flush=True)
                    save(output/'results.json',rows)
        else:
            if args.variants != ['original','optimized']:raise RuntimeError('Performance requires original and optimized only')
            for i in range(10):run(cases[-1],'original',f'warmup{i+1:02d}')
            summary=[]
            for c in cases:
                initial={v:run(c,v,'initial') for v in args.variants}
                rows.extend(initial.values())
                metrics=['wall_seconds','peak_working_set_bytes']
                review=any(initial['optimized'][m]/initial['original'][m]>1.05 for m in metrics)
                samples={v:[initial[v]] for v in args.variants}
                if review and max(r['wall_seconds'] for r in initial.values())<10:
                    samples={v:[] for v in args.variants}
                    for i in range(5):
                        for v in args.variants:
                            r=run(c,v,f'review{i+1}');rows.append(r);samples[v].append(r)
                item={'case':c['case'],'review_triggered':review,'samples_used':len(samples['original'])}
                for m in metrics:
                    b=statistics.mean(r[m] for r in samples['original'])
                    g=statistics.mean(r[m] for r in samples['optimized'])
                    item[m]={'baseline':b,'candidate':g,'overhead_percent':100*(g/b-1)}
                item['within_absolute_limits']=all(r['wall_seconds']<=60 and r['peak_working_set_bytes']<=2*1024**3 for r in samples['optimized'])
                item['within_5_percent']=all(item[m]['overhead_percent']<=5 for m in metrics)
                item['within_15_percent']=all(item[m]['overhead_percent']<=15 for m in metrics)
                summary.append(item);save(output/'results.json',rows);save(output/'summary.json',summary)
                print(json.dumps(item,ensure_ascii=True),flush=True)
    finally:
        subprocess.run(['subst',drive,'/d'],capture_output=True)

if __name__=='__main__':main()
