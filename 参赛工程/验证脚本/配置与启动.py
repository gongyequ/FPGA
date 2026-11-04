"""便携启动原版或优化版Yosys，不改变系统环境或官方工具。

python 验证脚本/配置与启动.py --程序 优化版 --version
python 验证脚本/配置与启动.py --程序 原版 -- -c demo.tcl
python 验证脚本/配置与启动.py -- --help
"""
from contextlib import ExitStack
from pathlib import Path
import argparse, ctypes, importlib.util, json, os, subprocess, sys

PACKAGE=Path(__file__).resolve().parents[1]
VARIANTS={'原版':('原版程序','original'),'优化版':('优化程序','optimized'),
          'original':('原版程序','original'),'optimized':('优化程序','optimized')}

def load_locations():
    source=PACKAGE/'等价验证/工具定位.py'
    if not source.is_file():raise FileNotFoundError(f'缺少工具定位模块：{source}')
    spec=importlib.util.spec_from_file_location('pmux_portable_locations',source)
    module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
    return module

def ensure_junction(link,target):
    """Only create a missing alias; never remove or retarget an existing entry."""
    link=Path(link);target=Path(target).resolve(strict=True)
    if not target.is_dir():raise NotADirectoryError(target)
    if os.path.lexists(link):
        if not link.is_dir() or link.resolve()!=target:
            raise RuntimeError(f'已有路径{link}不是指向{target}的目录；为保护已有内容，不覆盖或重定向。')
        return False
    # cmd's internal mklink requires a command string. Both paths are always
    # quoted; reject expansion characters instead of allowing shell expansion.
    if any(c in str(link)+str(target) for c in ['"','%','\r','\n']):
        raise ValueError('目录路径含cmd不能安全原样传递的双引号、百分号或换行，请换用不含这些字符的解压目录。')
    command=f'mklink /J "{link}" "{target}"'
    # On Windows pass cmd its command line verbatim. list2cmdline would escape
    # the embedded quotes with backslashes; cmd does not use that convention.
    result=subprocess.run('cmd.exe /d /v:off /c '+command,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,
                          creationflags=subprocess.CREATE_NO_WINDOW)
    if result.returncode!=0 or not link.is_dir() or link.resolve()!=target:
        detail=result.stdout.decode('utf-8','replace')
        raise RuntimeError(f'创建兼容目录失败：{link}\n{detail}')
    return True

def runtime_script_arguments(arguments,cwd,stack,locations):
    """Map directories for explicit script filenames; never rewrite command code.

    Keeping the filename preserves Tcl argv0 and the user's working directory.
    Native tool limitations still apply to a non-ASCII filename itself.
    """
    result=list(arguments)
    for i in range(len(result)-1):
        if result[i]=='--':break  # arguments after this belong to Tcl/Python
        if result[i] not in ['-c','-s','--tcl-scriptfile','--scriptfile']:continue
        file=Path(result[i+1]).expanduser()
        if not file.is_absolute():file=cwd/file
        file=file.resolve()
        if not file.is_file():continue  # let Yosys report its own filename error
        parent=stack.enter_context(locations.ascii_directory(file.parent)).rstrip('/')
        result[i+1]=parent+'/'+file.name
    return result

def wait_for_child(command,cwd,environment):
    child=subprocess.Popen(command,cwd=cwd,env=environment,stdin=sys.stdin,stdout=sys.stdout,stderr=sys.stderr,
                           creationflags=subprocess.CREATE_NO_WINDOW)
    try:return child.wait()
    except KeyboardInterrupt:
        # Limit cancellation to this launched process tree; never kill by name.
        subprocess.run(['taskkill.exe','/PID',str(child.pid),'/T','/F'],stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL,
                       creationflags=subprocess.CREATE_NO_WINDOW)
        child.wait()
        return 130

def main(argv=None):
    parser=argparse.ArgumentParser(description=__doc__,add_help=False)
    parser.add_argument('--帮助','--help-launcher',action='help',help='显示启动器说明；-h保留给Yosys')
    parser.add_argument('--程序','--variant',choices=list(VARIANTS),default='优化版')
    parser.add_argument('--version',action='store_true',help='运行所选真实Yosys的-V')
    parser.add_argument('--检查配置',action='store_true',help='仅检查定位，不运行工具或创建别名')
    parser.add_argument('--工作目录',type=Path,default=Path.cwd())
    args,forwarded=parser.parse_known_args(argv)
    if forwarded and forwarded[0]=='--':forwarded=forwarded[1:]
    if args.version and forwarded:parser.error('--version不能与其他Yosys参数同时使用')
    if os.name!='nt':raise RuntimeError('这个入口用于Windows原生程序。')
    locations=load_locations()
    realname,aliasname=VARIANTS[args.程序]
    program_dir=PACKAGE/realname
    executable=program_dir/'yosys.exe'
    if not executable.is_file():raise FileNotFoundError(f'缺少{args.程序}程序：{executable}')
    if not (program_dir/'share').is_dir():raise FileNotFoundError(f'缺少配套share资料：{program_dir / "share"}')
    local_abc=program_dir/'yosys-abc.exe'
    local_tcl=program_dir/'tcl8.6'
    try:suite=locations.locate_suite()
    except FileNotFoundError:
        # Exact official app-local dependencies can run synthesis without the
        # entire suite. Explicit invalid overrides must still fail, not hide.
        if os.environ.get('PMUX_OSS_CAD_SUITE') or not local_abc.is_file() or not (local_tcl/'init.tcl').is_file():raise
        suite=None
    abc=local_abc if local_abc.is_file() else suite/'bin/yosys-abc.exe'
    tcl=local_tcl if (local_tcl/'init.tcl').is_file() else suite/'lib/tcl8.6'
    if not abc.is_file():raise FileNotFoundError(f'缺少官方配套ABC：{abc}')
    if not (tcl/'init.tcl').is_file():raise FileNotFoundError(f'缺少官方Tcl运行库：{tcl}')
    cwd=args.工作目录.expanduser().resolve(strict=True)
    if not cwd.is_dir():raise NotADirectoryError(cwd)
    configuration={'package':str(PACKAGE),'variant':args.程序,'yosys':str(executable),'official_suite':str(suite) if suite else None,
                   'abc':str(abc),'tcl_library':str(tcl),
                   'cwd':str(cwd),'environment_scope':'child process only','tool_execution':'none' if args.检查配置 else 'real Yosys'}
    if args.检查配置:
        print(json.dumps(configuration,ensure_ascii=False,indent=2));return 0
    if suite is not None:ensure_junction(PACKAGE/'suite',suite)
    ensure_junction(PACKAGE/aliasname,program_dir)
    previous_error_mode=ctypes.windll.kernel32.SetErrorMode(0x8003)
    try:
        with ExitStack() as stack:
            # Map the actual executable directory, not package/optimized's
            # junction. Tcl's native filesystem otherwise normalizes through
            # that junction into non-ASCII paths in this Windows distribution.
            program_alias=stack.enter_context(locations.ascii_directory(program_dir,force=True)).rstrip('/')
            cwd_alias=stack.enter_context(locations.ascii_directory(cwd)).rstrip('/')
            suite_alias=stack.enter_context(locations.ascii_directory(suite)).rstrip('/') if suite is not None else None
            environment=os.environ.copy()
            prefixes=[program_alias]+([suite_alias+'/bin',suite_alias+'/lib'] if suite_alias else [])
            environment['PATH']=';'.join(prefixes+[environment.get('PATH','')])
            environment['TCL_LIBRARY']=(program_alias+'/tcl8.6' if tcl==local_tcl else suite_alias+'/lib/tcl8.6').replace('/','\\')
            if suite_alias:environment['YOSYSHQ_ROOT']=suite_alias
            # init_abc_executable_name in this official 0.69 source uses ABC
            # to override the build-time ABCEXTERNAL path before any -s/-c file.
            environment['ABC']=program_alias+'/yosys-abc.exe' if abc==local_abc else suite_alias+'/bin/yosys-abc.exe'
            environment['YOSYS_DATDIR']=program_alias+'/share'
            actual=['-V'] if args.version else runtime_script_arguments(forwarded,cwd,stack,locations)
            command=[program_alias+'/yosys.exe',*actual]
            return wait_for_child(command,cwd_alias+'/',environment)
    finally:ctypes.windll.kernel32.SetErrorMode(previous_error_mode)

if __name__=='__main__':
    try:code=main()
    except (OSError,RuntimeError,ValueError) as error:
        print('配置与启动失败：'+str(error),file=sys.stderr);code=2
    sys.stdout.flush();sys.stderr.flush()
    if os.name=='nt' and code>0x7fffffff:
        # Preserve native NTSTATUS exit codes rather than overflow sys.exit.
        ctypes.windll.kernel32.ExitProcess(ctypes.c_uint32(code))
    raise SystemExit(code)
