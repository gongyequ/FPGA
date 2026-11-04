"""Prepare genuine post-ABC ILANG for official EQY; preserve every raw artifact.

The only semantic adapter is the documented exact ff_map inverse.  X/Z constants
and otherwise undefined initial values are resolved to zero in EQY's input stage,
as disclosed in the generated manifest; this is a project strategy choice.
"""
from pathlib import Path
from contextlib import contextmanager
import argparse, ctypes, hashlib, importlib.util, json, os, shutil, subprocess

ROOT=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('eqy_tool_paths',ROOT/'工具定位.py')
tool_paths=importlib.util.module_from_spec(spec);spec.loader.exec_module(tool_paths)
SUITE=tool_paths.locate_suite()
spec=importlib.util.spec_from_file_location('ff_inverse',ROOT/'触发器逆映射适配.py')
ff_inverse=importlib.util.module_from_spec(spec);spec.loader.exec_module(ff_inverse)

@contextmanager
def official_environment():
    ctypes.windll.kernel32.SetErrorMode(0x0001|0x0002|0x8000)
    with tool_paths.ascii_directory(SUITE,force=True) as prefix:
        drive=prefix.rstrip('/');env=os.environ.copy()
        env['PATH']=';'.join([drive+'/bin',drive+'/lib',env.get('PATH','')])
        env['YOSYSHQ_ROOT']=prefix
        yield drive,env

def yosys(drive,env,stage,commands,label):
    script=Path(stage)/(label+'.ys');script.write_text(commands,encoding='utf-8')
    env=env.copy();env['TEMP']=env['TMP']=env['TMPDIR']=Path(stage).as_posix()
    p=subprocess.run([drive+'/bin/yosys.exe','-s',script.name],env=env,cwd=stage,
                     stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=240)
    (Path(stage)/(label+'.log')).write_bytes(p.stdout)
    if p.returncode:raise RuntimeError(f'Official Yosys failed at {label}, exit {p.returncode}')
    return p

def proof_config(top,ports,depth=20):
    # Only top-level I/O is matched, so no internal cuts assume a disputed state.
    matches='\n'.join('gold-match '+name for name in ports)
    return f'''[options]
splitnets off

[gold]
read_rtlil gold.il
opt_clean
setundef -zero -init
prep -top {top}

[gate]
read_rtlil gate.il
opt_clean
setundef -zero -init
prep -top {top}

[match *]
nodefault
{matches}

[collect *]
group *

[strategy sat]
use sat
depth {depth}
'''

def prepare(gold,gate,top,outdir,require_luts=True):
    gold=Path(gold);gate=Path(gate);outdir=Path(outdir)
    if outdir.exists():raise RuntimeError('Output exists; preserve old evidence')
    outdir.mkdir(parents=True)
    result={'top':top,'inputs':{},'normalization':
        'After raw post-ABC ILANG and exact FF inverse, EQY applies setundef -zero -init to both sides. Known initial values remain unchanged. This is our disclosed strategy, not a supplied official normalization script.',
        'partition':'Whole design: only top I/O matched, all output cones grouped.',
        'official_model_reference':str(SUITE/'share/yosys/intel/common/ff_map.v')}
    with tool_paths.ascii_temporary_directory(prefix='eqy-inputs-') as stage,official_environment() as (drive,env):
        try:
            for side,source in [('gold',gold),('gate',gate)]:
                shutil.copy2(source,stage/(side+'.raw.il'))
                yosys(drive,env,stage,f'read_rtlil {side}.raw.il\nwrite_json {side}.raw.json\n',side+'_export')
                raw=json.loads((stage/(side+'.raw.json')).read_text(encoding='utf-8'))
                counts={}
                for c in raw['modules'][top]['cells'].values():counts[c['type']]=counts.get(c['type'],0)+1
                if require_luts and counts.get('$lut',0)==0:raise ValueError('No $lut cells: expected the real post-ABC snapshot')
                report=ff_inverse.normalize(stage/(side+'.raw.json'),stage/(side+'.json'),top,stage/(side+'.adapter.json'))
                yosys(drive,env,stage,f'read_json {side}.json\nwrite_rtlil {side}.il\n',side+'_ilang')
                ports=raw['modules'][top]['ports']
                result['inputs'][side]={'sha256':hashlib.sha256(source.read_bytes()).hexdigest(),'raw_cell_counts':counts,
                   'converted_ff_count':report['converted_ff_count'],'ports':{n:{'direction':p['direction'],'width':len(p['bits'])} for n,p in ports.items()}}
            if result['inputs']['gold']['ports']!=result['inputs']['gate']['ports']:raise ValueError('Top-level interface mismatch')
            (stage/'proof.eqy').write_text(proof_config(top,ports),encoding='utf-8')
            (stage/'验证准备记录.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
        finally:shutil.copytree(stage,outdir,dirs_exist_ok=True)
    return result

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--基线网表',required=True,type=Path);p.add_argument('--优化网表',required=True,type=Path)
    p.add_argument('--顶层',required=True);p.add_argument('--输出目录',required=True,type=Path)
    p.add_argument('--允许无LUT烟测',action='store_true')
    a=p.parse_args();print(json.dumps(prepare(a.基线网表,a.优化网表,a.顶层,a.输出目录,not a.允许无LUT烟测),ensure_ascii=False,indent=2))

if __name__=='__main__':main()
