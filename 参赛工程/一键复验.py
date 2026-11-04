"""便携复验入口：固定本包原版/优化版与官方依赖，不选择或替换算法。"""
from pathlib import Path
import argparse,ctypes,hashlib,importlib.util,json,os,re,subprocess,sys,tempfile
from datetime import datetime
sys.dont_write_bytecode=True
ROOT=Path(__file__).resolve().parent
EXPECTED={'原版程序':'b8a51e5bd03e12384a39b47d2f0b3f185722a076cff6f94d0bc5aca70f5954a4',
          '优化程序':'a603b6e7b900fa3ca8410b25d37c6b4aa26c12f22e6bd9f3dba0958e6d389b53'}
ABC='+&dch,-f,-r;,&if,{W},{D},{R},-a,-v,-F,4,-c;,&mfs'
CALL='pmux_opt -order-decode -flatten-fallback -uniform-abc -flatten-data-arm'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def save(p,x):p.parent.mkdir(parents=True,exist_ok=True);p.write_text(json.dumps(x,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
def load(name,p):
    spec=importlib.util.spec_from_file_location(name,p);m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m);return m
def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--阶段',choices=['配置','面积','等价','性能','全部'],default='等价')
    p.add_argument('--输出目录',type=Path)
    p.add_argument('--已有证据',type=Path,help='性能单独运行时，指向先前本入口等价/面积结果目录')
    a=p.parse_args()
    if os.name!='nt':raise RuntimeError('此预编译包面向 Windows x64。')
    if sys.version_info<(3,10):raise RuntimeError('配套脚本需要 Python 3.10 或更新版本。')
    out=(a.输出目录 or ROOT.parent/'复验输出'/datetime.now().strftime('%Y%m%d_%H%M%S_%f')).resolve()
    if out.exists():raise RuntimeError('输出目录已存在，不覆盖既有证据：'+str(out))
    if out.is_relative_to(ROOT):raise RuntimeError('复验输出必须放在代码包内容目录之外，以保持提交文件完整。')
    out.mkdir(parents=True)
    suite=ROOT/'官方工具/oss-cad-suite'
    env=os.environ.copy();env['PYTHONDONTWRITEBYTECODE']='1';env['PYTHONIOENCODING']='utf-8'
    env['PMUX_OSS_CAD_SUITE']=str(suite)
    env['PMUX_EQY_MAKE']=str(ROOT/'等价验证/官方依赖/make-4.4.1/WinRel/gnumake.exe')
    os.environ.update({k:env[k] for k in ['PMUX_OSS_CAD_SUITE','PMUX_EQY_MAKE']})
    loc=load('package_tools',ROOT/'等价验证/工具定位.py')
    configuration=loc.located_configuration()
    identities={name:sha(ROOT/name/'yosys.exe') for name in EXPECTED}
    assert identities==EXPECTED,'本包程序身份不匹配'
    checks=[]
    for role in ['原版程序','优化程序']:
        with loc.ascii_directory(ROOT/role,force=True) as prefix:
            eenv=env.copy();eenv['PATH']=prefix+';'+str(suite/'bin')+';'+str(suite/'lib')+';'+eenv.get('PATH','')
            eenv.update(TCL_LIBRARY=prefix+'tcl8.6',YOSYS_DATDIR=prefix+'share',ABC=prefix+'yosys-abc.exe')
            for label,args in [('版本',['-V']),('实际综合默认流程',['-Q','-p','help synth_intel'])]+([('实际ABC配置',['-Q','-p',CALL+'; scratchpad -get abc9.script'])] if role=='优化程序' else []):
                result=subprocess.run([prefix+'yosys.exe',*args],cwd=prefix,env=eenv,capture_output=True,timeout=30)
                text=(result.stdout+result.stderr).decode('utf-8',errors='replace')
                (out/(role+'_'+label+'.log')).write_text(text,encoding='utf-8')
                assert result.returncode==0,(role,label,result.returncode)
                if label=='实际综合默认流程':
                    actual=[x.strip() for x in text.splitlines() if x.strip().startswith('pmux_opt ')]
                    assert actual==([CALL] if role=='优化程序' else []),(role,actual)
                if label=='实际ABC配置':assert ABC in text
                checks.append({'variant':role,'check':label,'passed':True,'exit_code':result.returncode})
    save(out/'便携配置核验.json',{'dependencies':configuration,'binary_sha256':identities,'checks':checks,
         'package_root':str(ROOT),'official_tools_inside_package':True,'default_pass':CALL,'uniform_abc':ABC})
    if a.阶段=='配置':print('配置核验通过：'+str(out));return
    stage={'面积':'area','等价':'eqy','性能':'performance','全部':'all'}[a.阶段]
    command=[sys.executable,str(ROOT/'验证脚本/研究复测.py'),'--原版程序',str(ROOT/'原版程序'),
        '--候选程序',str(ROOT/'优化程序'),'--原版源码',str(ROOT/'原版源码'),'--候选源码',str(ROOT/'开发源码'),
        '--基线包',str(ROOT),'--候选名称','Barm_F4c_portable','--输出目录',str(out/'正式复验'),
        '--官方套件',str(suite),'--GNU-Make',env['PMUX_EQY_MAKE'],'--阶段',stage]
    if stage=='performance':
        if a.已有证据 is None:raise RuntimeError('性能单独运行需要 --已有证据；先运行等价阶段。')
        command.extend(['--已有证据',str(a.已有证据.resolve())])
    save(out/'运行命令.json',{'argv':command,'algorithm_or_abc_override':False})
    with (out/'复验控制台.log').open('wb') as f:
        result=subprocess.run(command,cwd=ROOT,env=env,stdout=f,stderr=subprocess.STDOUT)
    save(out/'执行结束.json',{'returncode':result.returncode,'programs_unchanged':{n:sha(ROOT/n/'yosys.exe')==h for n,h in EXPECTED.items()}})
    if result.returncode:raise RuntimeError('真实复验未通过；见 '+str(out/'复验控制台.log'))
    print('真实复验完成：'+str(out))
if __name__=='__main__':
    if hasattr(sys.stdout,'reconfigure'):sys.stdout.reconfigure(encoding='utf-8')
    main()
