"""Locate genuine dependencies and provide temporary ASCII paths on Windows.

This file supplies paths only. It never substitutes a synthesis/proof/make tool.
Environment overrides are explicit and fail if invalid; otherwise package-relative
locations are preferred. No global PATH, installed files, or occupied drives change.
"""
from contextlib import contextmanager
from pathlib import Path
import argparse,json,os,shutil,subprocess,tempfile

ROOT=Path(__file__).resolve().parent
PACKAGE=ROOT.parent
DRIVES=['X:','W:','V:','U:','T:','P:','Q:']  # R: and S: belong to other build tasks.

def _choose(variable,candidates,validator,explanation):
    explicit=os.environ.get(variable)
    if explicit:
        path=Path(explicit).expanduser().resolve()
        if not validator(path):raise FileNotFoundError(f'{variable} is invalid: {path}. {explanation}')
        return path
    for candidate in candidates:
        path=Path(candidate).expanduser().resolve()
        if validator(path):return path
    raise FileNotFoundError(f'{explanation} Set {variable} explicitly or provide the documented package-relative dependency.')

def locate_suite():
    candidates=[PACKAGE/'toolbin/oss-cad-suite',PACKAGE/'官方工具/oss-cad-suite',
                PACKAGE/'oss-cad-suite',PACKAGE/'suite',ROOT/'官方依赖/oss-cad-suite']
    return _choose('PMUX_OSS_CAD_SUITE',candidates,
        lambda p:all((p/f).is_file() for f in ['bin/yosys.exe','bin/eqy.exe','bin/eqy-script.py','bin/sby-script.py','share/yosys/intel/common/ff_map.v']),
        'An unmodified OSS CAD Suite containing Yosys 0.69, EQY and SBY is required.')

def locate_make():
    candidates=[PACKAGE/'toolbin/make.exe',PACKAGE/'toolbin/gnumake.exe',ROOT/'官方依赖/make.exe',
                ROOT/'官方依赖/make-4.4.1/WinRel/gnumake.exe']
    return _choose('PMUX_EQY_MAKE',candidates,lambda p:p.is_file() and p.suffix.lower()=='.exe',
                   'A genuine native GNU Make executable is required; .cmd/.py make simulators are not accepted.')

def locate_git_usr_bin():
    candidates=[PACKAGE/'toolbin/git/usr/bin',PACKAGE/'官方工具/Git/usr/bin',
                ROOT/'官方依赖/git/usr/bin']
    git=shutil.which('git.exe') or shutil.which('git')
    if git:
        for base in Path(git).resolve().parents:
            if len(base.parts)>1:candidates.append(base/'usr/bin')
    # Common install locations and the Git for Windows installer registry key.
    for key in ['ProgramW6432','ProgramFiles','ProgramFiles(x86)']:
        if os.environ.get(key):candidates.append(Path(os.environ[key])/'Git/usr/bin')
    if os.environ.get('LOCALAPPDATA'):candidates.append(Path(os.environ['LOCALAPPDATA'])/'Programs/Git/usr/bin')
    if os.name=='nt':
        import winreg
        for hive in [winreg.HKEY_CURRENT_USER,winreg.HKEY_LOCAL_MACHINE]:
            for access in [winreg.KEY_READ|winreg.KEY_WOW64_64KEY,winreg.KEY_READ|winreg.KEY_WOW64_32KEY]:
                try:
                    with winreg.OpenKey(hive,r'SOFTWARE\GitForWindows',0,access) as key:
                        candidates.append(Path(winreg.QueryValueEx(key,'InstallPath')[0])/'usr/bin')
                except OSError:pass
    required=['bash.exe','sh.exe','grep.exe','awk.exe','cat.exe']
    return _choose('PMUX_GIT_USR_BIN',candidates,lambda p:all((p/f).is_file() for f in required),
                   'Git for Windows usr/bin with bash, sh, grep, awk and cat is required. WSL bash.exe alone is insufficient.')

@contextmanager
def ascii_directory(path,force=False):
    path=Path(path).resolve()
    if not path.is_dir():raise NotADirectoryError(path)
    text=path.as_posix()
    if not force and text.isascii() and not any(c.isspace() for c in text):
        yield text;return
    drive=None
    for letter in DRIVES:
        if not Path(letter+'/').exists() and subprocess.run(['subst',letter,str(path)],capture_output=True).returncode==0:
            drive=letter;break
    if drive is None:raise RuntimeError('No free temporary ASCII drive (R: and S: are deliberately excluded)')
    try:yield drive+'/'
    finally:subprocess.run(['subst',drive,'/d'],capture_output=True)

@contextmanager
def ascii_temporary_directory(prefix):
    configured=os.environ.get('PMUX_EQY_STAGE_ROOT')
    parent=Path(configured).expanduser().resolve() if configured else None
    if parent is not None and not parent.is_dir():
        raise NotADirectoryError(f'PMUX_EQY_STAGE_ROOT must be an existing writable directory: {parent}')
    with tempfile.TemporaryDirectory(prefix=prefix,dir=parent) as td:
        with ascii_directory(td) as alias:yield Path(alias)

@contextmanager
def ascii_git_bin(git_bin):
    git_bin=Path(git_bin).resolve()
    # Preserve Git's usr/bin layout so the MSYS runtime finds its installation root.
    if git_bin.name.lower()=='bin' and git_bin.parent.name.lower()=='usr':
        with ascii_directory(git_bin.parent.parent) as prefix:
            yield prefix.rstrip('/')+'/usr/bin'
    else:
        with ascii_directory(git_bin) as prefix:yield prefix.rstrip('/')

def located_configuration():
    return {'suite':str(locate_suite()),'gnu_make':str(locate_make()),'git_usr_bin':str(locate_git_usr_bin()),
            'stage_root':os.environ.get('PMUX_EQY_STAGE_ROOT',tempfile.gettempdir()),
            'temporary_drive_candidates':DRIVES,'tool_execution':'none; path inspection only'}

if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--检查配置',action='store_true');p.parse_args()
    print(json.dumps(located_configuration(),ensure_ascii=False,indent=2))
