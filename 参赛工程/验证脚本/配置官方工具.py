"""首次配置本包复验所需的固定官方 OSS CAD Suite；不修改正式测量脚本。

在交付包根目录运行：
  python 验证脚本/配置官方工具.py --工具目录 "E:/EDA/oss-cad-suite"
  python 验证脚本/配置官方工具.py --仅检查
不提供目录时，读取 PMUX_OSS_CAD_SUITE 或查找包内/父目录的官方套件。
本入口只验证版本/文件、建立缺失的 suite 联接、写配置记录，不运行综合测量。
"""
from pathlib import Path
from datetime import datetime,timezone
import argparse,ctypes,hashlib,importlib.util,json,os,re,subprocess,sys

PACKAGE=Path(__file__).resolve().parents[1]
EXPECTED_VERSION='0.69+286'
EXPECTED_COMMIT='37f25dae9'
EXPECTED_ABC_SHA256='60e1136f56b0eb4d256246aa6accfa36a8d97af2dc0693269ad62ba2359b33e5'
EXPECTED_YOSYS_SHA256='a9a1b18604fd984972e8c6786a52261cee9e6cbe002b65e5ca353beacbd65e90'

def load(file,name):
    spec=importlib.util.spec_from_file_location(name,file)
    module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module);return module

def sha(file):
    digest=hashlib.sha256()
    with Path(file).open('rb') as stream:
        for block in iter(lambda:stream.read(1024*1024),b''):digest.update(block)
    return digest.hexdigest()

def suite_candidates(explicit):
    if explicit:
        root=Path(explicit).expanduser()
        return '命令行--工具目录',[root,root/'oss-cad-suite']
    if os.environ.get('PMUX_OSS_CAD_SUITE'):
        root=Path(os.environ['PMUX_OSS_CAD_SUITE']).expanduser()
        return '环境变量PMUX_OSS_CAD_SUITE',[root,root/'oss-cad-suite']
    roots=[PACKAGE/'suite',PACKAGE/'toolbin/oss-cad-suite',PACKAGE/'官方工具/oss-cad-suite',PACKAGE/'oss-cad-suite',
           PACKAGE.parent/'oss-cad-suite',PACKAGE.parent/'oss-cad-suite-windows-x64-20261013/oss-cad-suite']
    for root in sorted(PACKAGE.parent.glob('oss-cad-suite*')):
        if root.is_dir():roots.extend([root,root/'oss-cad-suite'])
    unique=[];seen=set()
    for root in roots:
        path=root.resolve();key=os.path.normcase(str(path))
        if key not in seen:seen.add(key);unique.append(path)
    return '包内及父目录自动查找',unique

def validate_suite(candidate,locations):
    suite=Path(candidate).resolve(strict=True)
    required=['bin/yosys.exe','bin/yosys-abc.exe','bin/eqy.exe','bin/eqy-script.py','bin/sby.exe','bin/sby-script.py',
              'share/yosys/techmap.v','share/yosys/intel/common/ff_map.v','lib/tcl8.6/init.tcl']
    missing=[name for name in required if not (suite/name).is_file()]
    if missing:raise RuntimeError('不是完整官方套件，缺少：'+', '.join(missing))
    abc_hash=sha(suite/'bin/yosys-abc.exe')
    if abc_hash!=EXPECTED_ABC_SHA256:
        raise RuntimeError(f'ABC SHA256与本轮正式基线不同：{abc_hash}；需要 {EXPECTED_ABC_SHA256}')
    yosys_hash=sha(suite/'bin/yosys.exe')
    if yosys_hash!=EXPECTED_YOSYS_SHA256:
        raise RuntimeError(f'官方套件Yosys二进制与本轮固定原件不同：{yosys_hash}')
    old_mode=ctypes.windll.kernel32.SetErrorMode(0x8003)
    try:
        with locations.ascii_directory(suite,force=True) as prefix:
            environment=os.environ.copy();environment['PATH']=prefix+'bin;'+prefix+'lib;'+environment.get('PATH','')
            environment['YOSYSHQ_ROOT']=prefix
            run=subprocess.run([prefix+'bin/yosys.exe','-V'],cwd=prefix,env=environment,
                stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=20,creationflags=subprocess.CREATE_NO_WINDOW)
    finally:ctypes.windll.kernel32.SetErrorMode(old_mode)
    version=run.stdout.decode('utf-8',errors='replace').strip()
    if run.returncode or not re.search(r'\bYosys 0\.69\+286\b',version) or EXPECTED_COMMIT not in version:
        raise RuntimeError(f'实际启动版本校验失败，退出码{run.returncode}：{version}')
    return {'suite':str(suite),'version':version,'abc_sha256':abc_hash,'yosys_sha256':yosys_hash,
            'required_files_checked':required,'suite_version_exit_code':run.returncode}

def check_existing_aliases():
    aliases={'cases':'官方测试用例','out':'实测记录','original':'原版程序','optimized':'优化程序'}
    for alias,real in aliases.items():
        link=PACKAGE/alias;target=PACKAGE/real
        if os.path.lexists(link) and (not link.is_dir() or link.resolve()!=target.resolve()):
            raise RuntimeError(f'已有兼容路径{link}与本包{real}冲突；没有覆盖、删除或重定向。')
    return aliases

def main(argv=None):
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--工具目录',type=Path);p.add_argument('--仅检查',action='store_true',help='只校验；不创建联接、不写配置文件')
    a=p.parse_args(argv)
    if os.name!='nt':raise RuntimeError('此首次配置入口用于Windows x64交付包。')
    locations=load(PACKAGE/'等价验证/工具定位.py','pmux_locations')
    launcher=load(PACKAGE/'验证脚本/配置与启动.py','pmux_launcher')
    source,candidates=suite_candidates(a.工具目录);errors=[];configuration=None
    for candidate in candidates:
        try:configuration=validate_suite(candidate,locations);break
        except (OSError,RuntimeError,subprocess.TimeoutExpired) as error:
            errors.append({'candidate':str(candidate),'reason':str(error)})
    if configuration is None:
        lines='\n'.join('  '+row['candidate']+'：'+row['reason'] for row in errors)
        raise RuntimeError('没有找到本轮固定的官方0.69+286套件。请解压完整官方包，再用--工具目录指定其根目录。\n'+lines)
    suite=Path(configuration['suite']);link=PACKAGE/'suite'
    check_existing_aliases()
    if os.path.lexists(link) and (not link.is_dir() or link.resolve()!=suite):
        raise RuntimeError(f'本包已有suite路径{link}，但未指向已验证的{suite}。未覆盖、删除或重定向；请先自行检查该路径。')
    created=False if a.仅检查 else launcher.ensure_junction(link,suite)
    configuration.update(package=str(PACKAGE),suite_alias=str(link),suite_alias_created=created,
        lookup_source=source,checked_utc=datetime.now(timezone.utc).isoformat(),check_only=a.仅检查,
        expected_version=EXPECTED_VERSION,expected_commit=EXPECTED_COMMIT,expected_abc_sha256=EXPECTED_ABC_SHA256,
        actions='仅运行官方yosys -V；未运行综合、面积、性能或EQY测量；未修改冻结程序与运行验收.py')
    if not a.仅检查:
        directory=PACKAGE/'验证脚本/工具配置记录';directory.mkdir(parents=True,exist_ok=True)
        record=directory/(datetime.now().strftime('%Y%m%d_%H%M%S_%f')+'.json')
        record.write_text(json.dumps(configuration,ensure_ascii=False,indent=2),encoding='utf-8')
        print('配置记录：'+str(record))
    print('官方工具校验通过：'+configuration['version'])
    print('固定ABC SHA256：'+configuration['abc_sha256'])
    print('本包suite：'+str(link)+('（仅检查，未创建）' if a.仅检查 and not link.exists() else ''))
    print('下一步如需完整复验，请手动运行原样入口；名称需为未使用的ASCII目录名：')
    print('  python 验证脚本/运行验收.py --mode area --name my_area_check')
    print('  python 验证脚本/运行验收.py --mode performance --name my_performance_check')
    print('  需要EQY时，按等价验证/可移植交付说明.txt运行；先检查真GNU Make与Git Bash。')
    print('本次没有自动启动上述长时间测量。')
    return configuration

if __name__=='__main__':
    if hasattr(sys.stdout,'reconfigure'):sys.stdout.reconfigure(encoding='utf-8')
    if hasattr(sys.stderr,'reconfigure'):sys.stderr.reconfigure(encoding='utf-8')
    try:main()
    except (OSError,RuntimeError,ValueError) as error:
        print('官方工具配置失败：'+str(error),file=sys.stderr);raise SystemExit(2)
