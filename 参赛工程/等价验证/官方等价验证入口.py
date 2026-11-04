"""Run unchanged official EQY using genuine GNU Make and Git for Windows bash.

This launcher only supplies environment and ASCII staging paths; it never writes
EQY partition status files or replaces EQY/SBY strategy execution.
"""
from pathlib import Path
import argparse, ctypes, hashlib, importlib.util, json, os, shutil, subprocess, time
from datetime import datetime, timezone

ROOT=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('eqy_tool_paths',ROOT/'工具定位.py')
tool_paths=importlib.util.module_from_spec(spec);spec.loader.exec_module(tool_paths)
SUITE=tool_paths.locate_suite()
MAKE=tool_paths.locate_make()

def run_eqy(input_dir,output_dir,config='proof.eqy',timeout=300):
    input_dir=Path(input_dir).resolve();output_dir=Path(output_dir).resolve()
    if output_dir.exists():raise RuntimeError('Output exists; preserve previous evidence.')
    output_dir.mkdir(parents=True)
    ctypes.windll.kernel32.SetErrorMode(0x0001|0x0002|0x8000)
    git_bin=tool_paths.locate_git_usr_bin()
    with tool_paths.ascii_directory(SUITE,force=True) as suite_prefix,tool_paths.ascii_git_bin(git_bin) as git_prefix:
        drive=suite_prefix.rstrip('/')
        with tool_paths.ascii_temporary_directory(prefix='eqy-official-') as stage:
            shutil.copytree(input_dir,stage,dirs_exist_ok=True)
            bindir=stage/'tools';bindir.mkdir();shutil.copy2(MAKE,bindir/'make.exe')
            env=os.environ.copy()
            env['PATH']=';'.join([drive+'/bin',drive+'/lib',str(bindir),git_prefix,env.get('PATH','')])
            env['YOSYSHQ_ROOT']=drive+'/'
            env['SHELL']=git_prefix.rstrip('/')+'/sh.exe'
            env['MAKESHELL']=env['SHELL']
            env['TEMP']=env['TMP']=env['TMPDIR']=stage.as_posix()
            env['PYTHONIOENCODING']='utf-8'
            command=[drive+'/bin/eqy.exe','-f',config]
            started=datetime.now(timezone.utc).isoformat();t=time.perf_counter()
            p=subprocess.Popen(command,cwd=stage,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,
                               creationflags=subprocess.CREATE_NO_WINDOW)
            try:
                data,_=p.communicate(timeout=timeout);ec=p.returncode
            except subprocess.TimeoutExpired:
                # Terminate only our EQY process tree, including its solver children.
                subprocess.run(['taskkill','/PID',str(p.pid),'/T','/F'],capture_output=True)
                data,_=p.communicate(timeout=20);ec=124;data+=b'\nLAUNCHER_TIMEOUT\n'
            (stage/'eqy-console.log').write_bytes(data)
            info=dict(command=command,cwd=str(stage),exit_code=ec,wall_seconds=time.perf_counter()-t,started_utc=started,
                      eqy_sha256=hashlib.sha256((SUITE/'bin/eqy-script.py').read_bytes()).hexdigest(),
                      sby_sha256=hashlib.sha256((SUITE/'bin/sby-script.py').read_bytes()).hexdigest(),
                      yosys_sha256=hashlib.sha256((SUITE/'bin/yosys.exe').read_bytes()).hexdigest(),
                      make_sha256=hashlib.sha256(MAKE.read_bytes()).hexdigest(),
                      resolved_dependencies={'suite':str(SUITE),'gnu_make':str(MAKE),'git_usr_bin':str(git_bin)},
                      note='Official EQY unmodified. GNU Make 4.4.1 built from GNU release sources. No status shims.')
            (stage/'execution.json').write_text(json.dumps(info,ensure_ascii=False,indent=2),encoding='utf-8')
            for path in stage.iterdir():
                if path.name=='tools':continue
                target=output_dir/path.name
                if path.is_dir():shutil.copytree(path,target)
                else:shutil.copy2(path,target)
            return info,data.decode('utf-8',errors='replace')

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--输入目录',type=Path,required=True)
    parser.add_argument('--输出目录',type=Path,required=True)
    parser.add_argument('--配置',default='proof.eqy')
    parser.add_argument('--超时',type=int,default=300)
    args=parser.parse_args();info,log=run_eqy(args.输入目录,args.输出目录,args.配置,args.超时)
    print(log);raise SystemExit(info['exit_code'])

if __name__=='__main__':main()
