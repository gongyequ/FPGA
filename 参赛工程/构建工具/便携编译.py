"""从包内完整源码独立重建；仅写新的输出目录，不覆盖已验收程序。"""
from pathlib import Path
import argparse,importlib.util,json,os,shutil,subprocess,sys
ROOT=Path(__file__).resolve().parents[1]
def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--输出目录',type=Path,required=True)
    p.add_argument('--原版',action='store_true')
    p.add_argument('--VS目录',type=Path,help='可选 Visual Studio/Build Tools 安装目录')
    p.add_argument('--仅生成命令',action='store_true')
    a=p.parse_args();out=a.输出目录.resolve()
    if out.exists():raise RuntimeError('输出目录必须是尚不存在的新目录。')
    if out.is_relative_to(ROOT):raise RuntimeError('编译输出不能位于提交内容内。')
    vs=a.VS目录
    if vs is None:
        finder=Path(os.environ.get('ProgramFiles(x86)',r'C:\Program Files (x86)'))/'Microsoft Visual Studio/Installer/vswhere.exe'
        if not finder.is_file():raise RuntimeError('请安装 Visual Studio C++ Build Tools，或用 --VS目录 指定现有安装。')
        result=subprocess.run([str(finder),'-latest','-products','*','-requires','Microsoft.VisualStudio.Component.VC.Tools.x86.x64','-property','installationPath'],capture_output=True,text=True,check=True)
        vs=Path(result.stdout.strip())
    vc=vs/'VC/Auxiliary/Build/vcvars64.bat'
    cmake=shutil.which('cmake') or str(vs/'Common7/IDE/CommonExtensions/Microsoft/CMake/CMake/bin/cmake.exe')
    ninja=shutil.which('ninja') or str(vs/'Common7/IDE/CommonExtensions/Microsoft/CMake/Ninja/ninja.exe')
    for f in [vc,Path(cmake),Path(ninja)]:
        if not f.is_file():raise FileNotFoundError(f)
    out.mkdir(parents=True)
    spec=importlib.util.spec_from_file_location('loc',ROOT/'等价验证/工具定位.py');loc=importlib.util.module_from_spec(spec);spec.loader.exec_module(loc)
    for name,target in [('source',ROOT/('原版源码' if a.原版 else '开发源码')),('deps',ROOT/'构建工具'),('suite',ROOT/'官方工具/oss-cad-suite')]:
        subprocess.run(['cmd.exe','/d','/c','mklink','/J',str(out/name),str(target)],capture_output=True,check=True)
    with loc.ascii_directory(out,force=True) as prefix:
        config='add_library(PkgConfig::tcl INTERFACE IMPORTED GLOBAL)\nset_target_properties(PkgConfig::tcl PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "'+prefix+'deps/tcl头文件8615" INTERFACE_LINK_LIBRARIES "'+prefix+'deps/tcl86.lib")\nset(tcl_FOUND TRUE CACHE BOOL "Official Tcl DLL with MSVC import library")\n'
        # Tcl include path is also aliased to ASCII for MSVC/CMake tool compatibility.
        subprocess.run(['cmd.exe','/d','/c','mklink','/J',str(out/'tclinclude'),str(ROOT/'构建工具/tcl头文件8615')],capture_output=True,check=True)
        config=config.replace(prefix+'deps/tcl头文件8615',prefix+'tclinclude')
        (out/'tcl.cmake').write_text(config,encoding='utf-8')
        args=[cmake,'-S',prefix+'source','-B',prefix+'build','-G','Ninja','-DCMAKE_MAKE_PROGRAM='+ninja,
          '-DCMAKE_BUILD_TYPE=Release','-DCMAKE_PROJECT_yosys_INCLUDE='+prefix+'tcl.cmake',
          '-DPython3_EXECUTABLE='+sys.executable,'-DYOSYS_ENABLE_UNIT_TESTS=OFF','-DYOSYS_WITHOUT_SLANG=ON',
          '-DYOSYS_WITHOUT_TCL=OFF','-DYOSYS_WITHOUT_READLINE=ON','-DYOSYS_WITHOUT_EDITLINE=ON',
          '-DYOSYS_ABC_EXECUTABLE='+prefix+'suite/bin/yosys-abc.exe',
          '-DFLEX_EXECUTABLE='+prefix+'deps/winflexbison/flex.exe','-DBISON_EXECUTABLE='+prefix+'deps/winflexbison/bison.exe',
          '-DYOSYS_CHECKOUT_INFO=37f25dae9'+('' if a.原版 else '-pmux-F4c-Barm')]
        commands=[args,[cmake,'--build',prefix+'build','--parallel','4']]
        (out/'构建命令.json').write_text(json.dumps({'commands':commands,'source_commit':'37f25dae90177888ac89573be92c3826da71f26e','note':'源码已去除Git工作缓存，因此重建版本字符串可能为0.69+post；这不是替换提交的已验收二进制。'},ensure_ascii=False,indent=2),encoding='utf-8')
        bat='@echo off\r\nsetlocal\r\ncall '+subprocess.list2cmdline([str(vc)])+' >nul\r\nif errorlevel 1 exit /b 1\r\n'
        bat+='set "PATH='+prefix+'suite/bin;'+prefix+'suite/lib;%PATH%"\r\nset PYTHONDONTWRITEBYTECODE=1\r\n'
        for cmd in commands:bat+=subprocess.list2cmdline(cmd)+'\r\nif errorlevel 1 exit /b 1\r\n'
        (out/'build.cmd').write_text(bat,encoding='mbcs')
        if not a.仅生成命令:
            with (out/'编译日志.txt').open('wb') as log:
                result=subprocess.run(['cmd.exe','/d','/c',prefix+'build.cmd'],cwd=prefix,stdout=log,stderr=subprocess.STDOUT)
            if result.returncode:raise RuntimeError('编译失败，见输出目录编译日志。')
            print('重建完成：'+str(out/'build/yosys.exe'))
        else:print('仅生成命令；临时盘符将在退出时释放。请用本脚本以新目录执行正式重建。')
if __name__=='__main__':main()
