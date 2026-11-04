"""Mandatory binary/source integration check: actual help_script and ABC setting."""
from pathlib import Path
import ctypes,hashlib,json,os,re,subprocess,tempfile

record=Path(__file__).resolve().parent
root=record.parents[1]
out=record/'三版真实流水线烟测'
out.mkdir(exist_ok=False)
base=root.parent/'零点六九基线重做'
items=[
 ('B关闭消融',root/'候选程序/B臂关闭消融F4c',record/'pmux_opt.cc',record/'synth_intel.cc'),
 ('B开启正式候选',root/'候选程序/B臂集成F4c',root/'构建记录/B臂默认集成构建/pmux_opt.cc',root/'构建记录/B臂默认集成构建/synth_intel.cc'),
 ('早退F4c已验收候选',root/'候选程序/早退F4c',root/'构建记录/索引候选构建/早退F4c原源码.cc',base/'开发源码/techlibs/intel/synth_intel.cc'),
]
expected_abc='+&dch,-f,-r;,&if,{W},{D},{R},-a,-v,-F,4,-c;,&mfs'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
results=[]
for name,programdir,pmux,synth in items:
    dest=out/name;dest.mkdir()
    src=synth.read_text(encoding='utf-8')
    source_calls=re.findall(r'run\("(pmux_opt[^"\n]+)"\)',src)
    assert len(source_calls)==1,source_calls
    assert expected_abc in pmux.read_text(encoding='utf-8')
    assert not ctypes.windll.kernel32.GetLogicalDrives() & (1 << (ord('R')-ord('A')))
    subprocess.run(['subst.exe','R:',str(programdir)],check=True,capture_output=True)
    env=os.environ.copy();env['PATH']='R:/;'+str(root/'suite/bin')+';'+str(root/'suite/lib')+';'+env.get('PATH','')
    env.update(TCL_LIBRARY='R:\\tcl8.6',YOSYS_DATDIR='R:/share',ABC='R:/yosys-abc.exe')
    logs={}
    try:
        with tempfile.TemporaryDirectory(prefix='pmux-config-audit-') as td:
            for label,args in [
                ('版本',['-V']),
                ('实际综合命令',['-Q','-p','help synth_intel']),
                ('自研命令帮助',['-Q','-p','help pmux_opt']),
                ('实际统一ABC配置',['-Q','-p',source_calls[0]+'; scratchpad -get abc9.script']),
            ]:
                argv=['R:/yosys.exe',*args]
                p=subprocess.run(argv,cwd=td,env=env,capture_output=True,timeout=30)
                text=(p.stdout+p.stderr).decode('utf-8',errors='replace');logs[label]=text
                (dest/(label+'.log')).write_text(text,encoding='utf-8')
                (dest/(label+'.command.json')).write_text(json.dumps({'argv':argv,'cwd':td,'returncode':p.returncode},ensure_ascii=False,indent=2),encoding='utf-8')
                assert p.returncode==0,(name,label,p.returncode,text[-500:])
    finally:
        subprocess.run(['subst.exe','R:','/D'],check=True,capture_output=True)
    actual_calls=[s.strip() for s in logs['实际综合命令'].splitlines() if s.strip().startswith('pmux_opt ')]
    assert actual_calls==source_calls,(name,source_calls,actual_calls)
    assert expected_abc in logs['实际统一ABC配置']
    assert '0.69+286' in logs['版本']
    commands=logs['实际综合命令']
    assert commands.index('peepopt')<commands.index('opt_clean',commands.index('peepopt'))<commands.index(source_calls[0])<commands.index('cmp2lut')
    results.append({'name':name,'program':str(programdir/'yosys.exe'),'program_sha256':sha(programdir/'yosys.exe'),
                    'pmux_source_snapshot':str(pmux),'pmux_source_sha256':sha(pmux),'synth_source_snapshot':str(synth),
                    'synth_source_sha256':sha(synth),'source_pmux_call':source_calls[0],'actual_help_pmux_call':actual_calls[0],
                    'abc_script':expected_abc,'source_matches_actual_binary':True,'pass':True})
(out/'三版配置核对汇总.json').write_text(json.dumps({'all_passed':True,'results':results,'performance_executed':False,'area_executed':False},ensure_ascii=False,indent=2),encoding='utf-8')
print('PASS: three binary help_script integration checks and three uniform ABC configuration checks.')
