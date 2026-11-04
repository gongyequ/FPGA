"""Run all nine official post-ABC comparisons through genuine EQY."""
from pathlib import Path
from datetime import datetime,timezone
import argparse, importlib.util, json, traceback
ROOT=Path(__file__).resolve().parent
def load(name,file):
    spec=importlib.util.spec_from_file_location(name,ROOT/file)
    module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module);return module
prep=load('prepare','生成正式验证输入.py');runner=load('runner','官方等价验证入口.py')

def run(goldroot,gateroot,outdir,timeout=300,cases=None):
    goldroot=Path(goldroot);gateroot=Path(gateroot);outdir=Path(outdir)
    if outdir.exists():raise RuntimeError('Output exists; keep prior validation evidence')
    outdir.mkdir(parents=True)
    manifest=json.loads((ROOT.parent/'官方测试用例/用例来源.json').read_text(encoding='utf-8'))
    if cases:manifest=[m for m in manifest if m['case'] in cases]
    rows=[]
    for case in manifest:
        name=case['case'];row={'case':name,'top':case['top'],'status':'ERROR','started_utc':datetime.now(timezone.utc).isoformat()}
        try:
            gold=goldroot/name/'original-area.il';gate=gateroot/name/'optimized-area.il'
            for path in (gold,gate):
                if not path.is_file():raise FileNotFoundError(path)
            info=prep.prepare(gold,gate,case['top'],outdir/name/'验证输入')
            execution,log=runner.run_eqy(outdir/name/'验证输入',outdir/name/'官方EQY结果',timeout=timeout)
            row.update(exit_code=execution['exit_code'],wall_seconds=execution['wall_seconds'],inputs=info['inputs'])
            if execution['exit_code']==0 and (outdir/name/'官方EQY结果/proof/PASS').is_file() and 'DONE (PASS, rc=0)' in log:
                row['status']='PASS'
            elif execution['exit_code']==124:row['status']='TIMEOUT'
            elif 'DONE (FAIL' in log:row['status']='FAIL'
            else:row['status']='ERROR'
        except Exception as error:
            row['error']=str(error);(outdir/(name+'_error.txt')).write_text(traceback.format_exc(),encoding='utf-8')
        rows.append(row)
        summary={'official_case_count':9,'executed_case_count':len(rows),'pass_count':sum(r['status']=='PASS' for r in rows),
                 'all_nine_pass':len(rows)==9 and all(r['status']=='PASS' for r in rows),'cases':rows}
        (outdir/'正式EQY汇总.json').write_text(json.dumps(summary,ensure_ascii=False,indent=2),encoding='utf-8')
        print(name,row['status'],f'exit={row.get("exit_code")}',f'seconds={row.get("wall_seconds")}',flush=True)
    return summary

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--基线目录',type=Path,required=True);p.add_argument('--优化目录',type=Path,required=True)
    p.add_argument('--输出目录',type=Path,required=True);p.add_argument('--单例超时',type=int,default=300)
    p.add_argument('--用例',nargs='+')
    a=p.parse_args();result=run(a.基线目录,a.优化目录,a.输出目录,a.单例超时,a.用例)
    requested_pass=(result['executed_case_count']>0 and all(row['status']=='PASS' for row in result['cases']))
    raise SystemExit(0 if requested_pass else 1)

if __name__=='__main__':main()
