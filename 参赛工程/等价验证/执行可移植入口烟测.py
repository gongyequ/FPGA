"""Exercise genuine EQY positive/negative tests with a Chinese/spaced temp root."""
from pathlib import Path
from datetime import datetime
import importlib.util,json,os
ROOT=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('runner',ROOT/'官方等价验证入口.py')
runner=importlib.util.module_from_spec(spec);spec.loader.exec_module(runner)

def main():
    out=ROOT/('可移植入口烟测_'+datetime.now().strftime('%Y%m%d_%H%M%S'));out.mkdir()
    stage_root=out/'临时目录 中文 空格';stage_root.mkdir()
    old=os.environ.get('PMUX_EQY_STAGE_ROOT');os.environ['PMUX_EQY_STAGE_ROOT']=str(stage_root)
    results=[]
    try:
        for title,folder,want in [('正确设计','烟测输入',0),('故意错误设计','烟测反例输入',2)]:
            info,log=runner.run_eqy(ROOT/folder,out/title,timeout=60)
            expected='DONE (PASS, rc=0)' if want==0 else 'DONE (FAIL, rc=2)'
            passed=info['exit_code']==want and expected in log
            results.append({'case':title,'expected_exit':want,'actual_exit':info['exit_code'],'matches_expected':passed,'stage_used':info['cwd']})
            print(title,info['exit_code'],'OK' if passed else 'ERROR',flush=True)
    finally:
        if old is None:os.environ.pop('PMUX_EQY_STAGE_ROOT',None)
        else:os.environ['PMUX_EQY_STAGE_ROOT']=old
        try:stage_root.rmdir()
        except OSError:pass
    result={'scope':'Portable runtime path smoke, not contest performance or final acceptance.',
            'chinese_spaced_temp_root':str(stage_root),'all_expected':all(r['matches_expected'] for r in results),'cases':results}
    (out/'入口烟测汇总.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
    print(str(out));raise SystemExit(0 if result['all_expected'] else 1)

if __name__=='__main__':main()
