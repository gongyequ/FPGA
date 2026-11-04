"""Static syntax/provenance inventory; never starts synthesis or a solver."""
from pathlib import Path
import ast,hashlib,importlib.util,json
ROOT=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('paths',ROOT/'工具定位.py')
paths=importlib.util.module_from_spec(spec);spec.loader.exec_module(paths)
records=[]
for file in sorted(ROOT.glob('*.py')):
    ast.parse(file.read_text(encoding='utf-8'),filename=str(file))
    records.append({'file':'等价验证/'+file.name,'bytes':file.stat().st_size,'sha256':hashlib.sha256(file.read_bytes()).hexdigest(),'syntax':'PASS'})
source=ROOT/'官方依赖/make-4.4.1.tar.gz'
manifest={'python_entry_files':records,'resolved_paths_this_machine':paths.located_configuration(),
 'first_setup_entry_files':['验证脚本/配置官方工具.py','验证脚本/首次配置与复验说明.ps1','验证脚本/配置与启动.py','等价验证/工具定位.py'],
 'frozen_measurement_entry':'验证脚本/运行验收.py (unchanged; configure package/suite before running)',
 'required_runtime':[
   {'name':'Python 3.9+','delivery':'preinstalled or bundled; project helpers use standard library only'},
   {'name':'Official OSS CAD Suite with Yosys 0.69 / EQY / SBY / solvers','preferred_package_path':'toolbin/oss-cad-suite','environment':'PMUX_OSS_CAD_SUITE','must_preserve':'whole original bin/lib/share/Python resources and license files'},
   {'name':'Genuine GNU Make 4.4.1','preferred_package_path':'toolbin/make.exe','source_binary':str(paths.locate_make()),'environment':'PMUX_EQY_MAKE','source_url':'https://ftp.gnu.org/gnu/make/make-4.4.1.tar.gz','source_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),'source_package':'等价验证/官方依赖/make-4.4.1.tar.gz','license_file':'等价验证/官方依赖/make-4.4.1/COPYING','build_log':'等价验证/官方依赖/GNU构建日志.txt','build_flags':'Official build_w32.bat --without-guile; /MT from official script'},
   {'name':'Git for Windows Bash + MSYS utilities','delivery':'preinstalled and auto-located, or complete tree at toolbin/git','environment':'PMUX_GIT_USR_BIN','must_preserve':'usr/bin and its DLL dependencies; preserve full install layout and license notices'}],
 'evidence_directories':['最终零点六九_EQY','可移植入口烟测_20261103_215139','适配烟测_20261103_191626'],
 'evidence_files':['最终零点六九_EQY/正式EQY汇总.json','最终零点六九_EQY/适配边界审计.json','最终零点六九_EQY/输入来源复核.json'],
 'historical_not_needed_for_final_submission':['低分配嵌套F1_current_review_九例EQY','稠密缩位F4_九例正式EQY','基础安全规则_九例正式EQY','译码守卫规则_九例正式EQY','旧候选candidate_final_证明复用核对.json','ABC模板规范化研究'],
 'no_tool_execution_during_inventory':True}
(ROOT/'交付依赖清单.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2),encoding='utf-8')
print(f'Syntax PASS for {len(records)} Python files; dependency manifest written. No synthesis/formal process launched.')
