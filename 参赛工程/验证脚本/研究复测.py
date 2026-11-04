"""统一研究入口：身份 -> 九例面积 -> 真实官方EQY -> 固定规则性能 -> 报告。

--阶段 area 只做面积；eqy 做面积及证明；all 做完整研究验收。
--阶段 performance 必须提供 --已有证据 或显式 --仅性能诊断。
ABC脚本覆盖只作用于候选，明确标作研究流程，不能当作原样赛事入口。
"""
from pathlib import Path
from contextlib import ExitStack, contextmanager
from datetime import datetime, timezone
import argparse, ctypes, importlib.util, json, os, re, shutil, subprocess, sys, time, traceback
sys.dont_write_bytecode = True
if hasattr(sys.stdout, 'reconfigure'): sys.stdout.reconfigure(encoding='utf-8')
if hasattr(sys.stderr, 'reconfigure'): sys.stderr.reconfigure(encoding='utf-8')
from 复测公共 import (CASE_ORDER, EXPECTED_ABC, EXPECTED_SUITE_YOSYS, save, read, sha, digest,
                     file_info, tree_info, abc_override, official_cases, parse_area,
                     area_summary, needs_review, short_review, performance_summary, real_eqy_pass, actual_abc_commands)

HERE = Path(__file__).resolve().parent
DEFAULT_PACKAGE = HERE.parents[1] / '零点六九参赛交付包_20261103'
PROOF_MODULES = ['工具定位.py', '生成正式验证输入.py', '官方等价验证入口.py',
                 '触发器逆映射适配.py', '核验适配边界.py', '核对证明输入来源.py']

def load(name, file):
    spec = importlib.util.spec_from_file_location(name, file)
    module = importlib.util.module_from_spec(spec); spec.loader.exec_module(module); return module

def parser():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--原版程序', '--baseline-bin', type=Path, required=True)
    p.add_argument('--候选程序', '--candidate-bin', type=Path, required=True)
    p.add_argument('--候选源码', '--candidate-source', type=Path, required=True)
    p.add_argument('--原版源码', '--baseline-source', type=Path,
                   help='可选真实原版源码树；省略时绑定官方提交来源文件+共同兼容补丁，不声称做过重新编译。')
    p.add_argument('--基线包', type=Path, default=DEFAULT_PACKAGE)
    p.add_argument('--候选名称', '--candidate', required=True)
    p.add_argument('--输出目录', '--output', type=Path, required=True)
    p.add_argument('--官方套件', '--suite', type=Path)
    p.add_argument('--GNU-Make', dest='gnu_make', type=Path)
    p.add_argument('--Git工具', dest='git_bin', type=Path)
    p.add_argument('--ABC脚本', '--abc-script', dest='abc_script', type=Path)
    p.add_argument('--阶段', '--stage', choices=['area', 'eqy', 'all', 'performance'], default='all')
    p.add_argument('--已有证据', '--evidence', type=Path)
    p.add_argument('--仅性能诊断', '--diagnostic-only', action='store_true')
    p.add_argument('--检查配置', '--check-only', action='store_true')
    p.add_argument('--综合超时', type=int, default=120)
    p.add_argument('--EQY超时', type=int, default=300)
    return p

def validate_arguments(a):
    if sys.flags.optimize: raise ValueError('不得使用python -O/-OO：冻结适配审计中的assert必须启用')
    if not a.候选名称.strip() or any(c in a.候选名称 for c in '\r\n\x00'):
        raise ValueError('候选名称须为非空单行文本')
    if a.综合超时 < 65 or a.EQY超时 < 1: raise ValueError('综合超时至少65秒；EQY超时必须为正')
    if a.阶段 == 'performance':
        if bool(a.已有证据) == bool(a.仅性能诊断):
            raise ValueError('performance必须二选一：--已有证据 或 --仅性能诊断')
    elif a.已有证据 or a.仅性能诊断:
        raise ValueError('--已有证据/--仅性能诊断只用于performance阶段')
    output = a.输出目录.expanduser().resolve()
    for protected in [a.基线包, a.原版程序, a.候选程序, a.候选源码, a.原版源码]:
        if protected is not None and output.is_relative_to(protected.expanduser().resolve()):
            raise ValueError('输出目录不能位于冻结包、程序目录或被绑定的源码树内')
    if a.已有证据 and output == a.已有证据.expanduser().resolve(): raise ValueError('不得覆盖已有证据目录')
    return output

@contextmanager
def environment(overrides):
    old = {name: os.environ.get(name) for name in overrides}
    os.environ.update({name: str(value) for name, value in overrides.items()})
    try: yield
    finally:
        for name, value in old.items():
            if value is None: os.environ.pop(name, None)
            else: os.environ[name] = value

def preflight(a, out):
    package = a.基线包.expanduser().resolve(strict=True)
    loc = load('research_tool_paths', package / '等价验证/工具定位.py')
    suite, make, git = loc.locate_suite(), loc.locate_make(), loc.locate_git_usr_bin()
    if sha(suite / 'bin/yosys-abc.exe') != EXPECTED_ABC: raise ValueError('ABC不是本轮固定官方二进制')
    if sha(suite / 'bin/yosys.exe') != EXPECTED_SUITE_YOSYS: raise ValueError('EQY所用官方0.69套件原件不匹配')
    cases = official_cases(package / '官方测试用例')
    programs = {'original': a.原版程序.expanduser().resolve(strict=True),
                'optimized': a.候选程序.expanduser().resolve(strict=True)}
    required = ['yosys.exe', 'yosys-abc.exe', 'tcl86.dll', 'MSVCP140.dll', 'VCRUNTIME140.dll',
                'VCRUNTIME140_1.dll', 'tcl8.6/init.tcl', 'tcl8.6/msgcat/msgcat.tcl',
                'share/techmap.v', 'share/intel/common/ff_map.v']
    for role, directory in programs.items():
        missing = [f for f in required if not (directory / f).is_file()]
        if missing: raise FileNotFoundError(role + '缺少完整运行依赖：' + ', '.join(missing))
        if sha(directory / 'yosys-abc.exe') != EXPECTED_ABC: raise ValueError(role + '的app-local ABC与固定原件不同')
    # Preserve official DLL/standard-library identity from the frozen dependency inventory.
    dependencies = read(package / '运行依赖来源.json')
    for role, name in [('original', '原版程序'), ('optimized', '优化程序')]:
        for item in dependencies:
            if item['variant'] != name or item['file'] == 'yosys.exe': continue
            file = programs[role] / item['file']
            if not file.is_file() or sha(file) != item['sha256']:
                raise ValueError(role + '的官方运行依赖缺失或变化：' + item['file'])
    abc = abc_override(a.abc_script)
    if abc:
        save(out / 'inputs/ABC研究覆盖.json', abc)
        shutil.copy2(a.abc_script, out / 'inputs/candidate.abc')
    snapshots = {}
    for role, directory in programs.items():
        print('绑定运行目录：' + role, flush=True)
        snapshots[role] = tree_info(directory)
        save(out / ('identity/' + role + '_runtime.json'), snapshots[role])
    print('绑定候选源码快照', flush=True)
    candidate_source = tree_info(a.候选源码)
    save(out / 'identity/candidate_source.json', candidate_source)
    if a.原版源码:
        baseline_source = tree_info(a.原版源码)
        save(out / 'identity/baseline_source.json', baseline_source)
        baseline_basis = {'kind': 'explicit source snapshot', 'tree_sha256': baseline_source['tree_sha256']}
    else:
        baseline_basis = {'kind': 'official commit provenance plus disclosed common compatibility patch; no rebuild claimed',
            'official_provenance': file_info(package / '官方源码来源.json'),
            'shared_patch': file_info(package / '构建工具/共同Tcl兼容补丁.patch')}
    tool_files = {'official_yosys': suite / 'bin/yosys.exe', 'abc': suite / 'bin/yosys-abc.exe',
        'eqy': suite / 'bin/eqy-script.py', 'sby': suite / 'bin/sby-script.py', 'make': make,
        'ff_map': suite / 'share/yosys/intel/common/ff_map.v',
        **{'git_' + name: git / (name + '.exe') for name in ['bash', 'sh', 'grep', 'awk', 'cat']}}
    tools = {name: file_info(file) for name, file in tool_files.items()}
    helper_files = {name: package / '等价验证' / name for name in PROOF_MODULES}
    helper_files.update({'研究复测.py': Path(__file__), '复测公共.py': HERE / '复测公共.py',
                         '官方测量规则参考': package / '验证脚本/运行验收.py'})
    binding = {'schema': 1, 'candidate': a.候选名称,
        'programs': {role: {'binary': file_info(directory / 'yosys.exe'),
                           'runtime_tree_sha256': snapshots[role]['tree_sha256']} for role, directory in programs.items()},
        'candidate_source_tree_sha256': candidate_source['tree_sha256'], 'baseline_source_basis': baseline_basis,
        'tools': tools, 'cases': cases, 'abc_override': abc,
        'helpers': {name: file_info(file) for name, file in helper_files.items()},
        'measurement_policy': '10 baseline zip05 warmups; fixed case order; initial pair; either ratio>1.05 and max(initial wall)<10 -> 5 fresh pairs; ratio of arithmetic means'}
    identity = {'binding_sha256': digest(binding), 'binding': binding,
        'created_utc': datetime.now(timezone.utc).isoformat(),
        'paths': {'package': str(package), 'suite': str(suite), 'make': str(make), 'git': str(git),
                  'programs': {k: str(v) for k, v in programs.items()}, 'candidate_source': str(a.候选源码.resolve())},
        'scope': '研究记录；源码哈希是所提供源码快照身份，不独立证明该EXE由此快照编译；编译日志应另行保留。'}
    save(out / 'identity.json', identity)
    for case in cases:
        target = out / 'inputs/cases' / case['file']; target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(package / '官方测试用例' / case['file'], target)
        if sha(target) != case['sha256']: raise RuntimeError('输入副本哈希不匹配')
    return {'package': package, 'locations': loc, 'suite': suite, 'make': make, 'git': git,
            'programs': programs, 'cases': cases, 'abc': abc, 'identity': identity, 'tool_files': tool_files,
            'helper_files': helper_files, 'candidate_source': a.候选源码.resolve(),
            'baseline_source': a.原版源码.resolve() if a.原版源码 else None,
            'abc_source': a.abc_script.resolve() if a.abc_script else None, 'output': out}

class Counters(ctypes.Structure):
    _fields_ = [('cb', ctypes.c_ulong), ('PageFaultCount', ctypes.c_ulong)] + [
        (name, ctypes.c_size_t) for name in ['PeakWorkingSetSize', 'WorkingSetSize',
        'QuotaPeakPagedPoolUsage', 'QuotaPagedPoolUsage', 'QuotaPeakNonPagedPoolUsage',
        'QuotaNonPagedPoolUsage', 'PagefileUsage', 'PeakPagefileUsage']]

class Synthesis:
    def __init__(self, config, out, timeout): self.config, self.out, self.timeout = config, out, timeout
    def __enter__(self):
        self.stack = ExitStack(); self.stack.__enter__()
        self.old_mode = ctypes.windll.kernel32.SetErrorMode(0x8003)
        try:
            loc = self.config['locations']
            self.work = self.stack.enter_context(loc.ascii_directory(self.out, force=True)).rstrip('/')
            self.suite = self.stack.enter_context(loc.ascii_directory(self.config['suite'], force=True)).rstrip('/')
            self.programs = {role: self.stack.enter_context(loc.ascii_directory(path, force=True)).rstrip('/')
                             for role, path in self.config['programs'].items()}
            self.psapi = ctypes.WinDLL('psapi', use_last_error=True)
            self.psapi.GetProcessMemoryInfo.argtypes = [ctypes.c_void_p, ctypes.POINTER(Counters), ctypes.c_ulong]
            self.psapi.GetProcessMemoryInfo.restype = ctypes.c_int
            return self
        except BaseException:
            self.stack.close(); ctypes.windll.kernel32.SetErrorMode(self.old_mode); raise
    def __exit__(self, *args):
        try: self.stack.__exit__(*args)
        finally: ctypes.windll.kernel32.SetErrorMode(self.old_mode)
    def runtime(self, path): return self.work + '/' + path.relative_to(self.out).as_posix()
    def execute(self, role, arguments, stem):
        stem.parent.mkdir(parents=True, exist_ok=True)
        prefix = self.programs[role]; env = os.environ.copy()
        env['PATH'] = ';'.join([prefix, self.suite + '/bin', self.suite + '/lib', env.get('PATH', '')])
        env['TCL_LIBRARY'] = (prefix + '/tcl8.6').replace('/', '\\')
        env['YOSYS_DATDIR'] = prefix + '/share'; env['YOSYSHQ_ROOT'] = self.suite + '/'
        env['ABC'] = self.suite + '/bin/yosys-abc.exe'
        command = [prefix + '/yosys.exe', *arguments]
        record = {'command': command, 'variant': role, 'started_utc': datetime.now(timezone.utc).isoformat(),
                  'binary_sha256': self.config['identity']['binding']['programs'][role]['binary']['sha256'],
                  'timeout_seconds': self.timeout}
        peak = samples = 0; final_ok = False; child = None; timed_out = False
        try:
            with stem.with_suffix('.log').open('wb') as log:
                start = time.perf_counter()
                child = subprocess.Popen(command, cwd=self.work + '/', env=env, stdout=log,
                    stderr=subprocess.STDOUT, creationflags=subprocess.CREATE_NO_WINDOW)
                while True:
                    c = Counters(); c.cb = ctypes.sizeof(c)
                    if self.psapi.GetProcessMemoryInfo(int(child._handle), ctypes.byref(c), ctypes.sizeof(c)):
                        peak = max(peak, c.PeakWorkingSetSize); samples += 1
                    code = child.poll()
                    if code is not None:
                        final = Counters(); final.cb = ctypes.sizeof(final)
                        final_ok = bool(self.psapi.GetProcessMemoryInfo(int(child._handle), ctypes.byref(final), ctypes.sizeof(final)))
                        if final_ok: peak = max(peak, final.PeakWorkingSetSize)
                        break
                    if time.perf_counter() - start > self.timeout:
                        subprocess.run(['taskkill.exe', '/PID', str(child.pid), '/T', '/F'],
                            stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, creationflags=subprocess.CREATE_NO_WINDOW)
                        child.wait(timeout=20); code = 124; timed_out = True; break
                    time.sleep(0.001)
                elapsed = time.perf_counter() - start
            record.update(exit_code=code, wall_seconds=elapsed, peak_working_set_bytes=peak,
                          memory_samples=samples, final_memory_query_ok=final_ok, timed_out=timed_out)
        except BaseException as error:
            record['error'] = repr(error)
            if child is not None and child.poll() is None:
                subprocess.run(['taskkill.exe', '/PID', str(child.pid), '/T', '/F'],
                    stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, creationflags=subprocess.CREATE_NO_WINDOW)
                child.wait(timeout=20)
            raise
        finally: save(stem.with_suffix('.command.json'), record)
        if code != 0 or not peak or not final_ok:
            raise RuntimeError(f'真实工具运行失败或内存采样无效：{stem.name}，exit={code}，peak={peak}，final_query={final_ok}')
        return record
    def case(self, case, role, phase, suffix, area=False):
        stem = self.out / phase / case['case'] / (role + '-' + suffix)
        stem.parent.mkdir(parents=True, exist_ok=True)
        commands = []
        if role == 'optimized' and self.config['abc']:
            commands.append('scratchpad -set abc9.script ' + self.config['abc']['scratchpad'])
        commands += [f'read_verilog -sv {self.work}/inputs/cases/{case["file"]}',
                     f'hierarchy -check -top {case["top"]}',
                     f'scratchpad -set abc9.exe {self.suite}/bin/yosys-abc.exe',
                     f'synth_intel -family cycloneiv -top {case["top"]}' + (' -run begin:map_cells' if area else '')]
        if area: commands += [f'write_rtlil {self.runtime(stem.with_suffix(".il"))}',
                              f'write_json {self.runtime(stem.with_suffix(".json"))}']
        commands += ['stat']; stem.with_suffix('.ys').write_text('\n'.join(commands) + '\n', encoding='ascii')
        rec = self.execute(role, ['-Q', '-s', self.runtime(stem.with_suffix('.ys'))], stem)
        rec.update(case=case['case'], top=case['top'], variant=role, script_sha256=sha(stem.with_suffix('.ys')))
        log = stem.with_suffix('.log').read_text(encoding='utf-8', errors='replace')
        rec['abc_process_count'] = len(re.findall(r'Running ABC command:', log))
        rec['pmux_messages'] = [line for line in log.splitlines() if 'PMUX structural optimization:' in line]
        if rec['abc_process_count'] != 1: raise RuntimeError('预期一次实际ABC子进程，日志计数不符：' + str(stem))
        rec['actual_abc_commands'] = actual_abc_commands(log)
        sequences = self.config.setdefault('actual_abc_sequences', {})
        if role not in sequences: sequences[role] = rec['actual_abc_commands']
        if sequences[role] != rec['actual_abc_commands']:
            save(stem.with_suffix('.record.json'), rec)
            raise RuntimeError('同一版本跨用例/面积性能阶段使用的实际ABC命令不同：' + role + '/' + case['case'])
        if area:
            rec.update(parse_area(stem.with_suffix('.json'), case['top']))
            rec['raw_il_sha256'] = sha(stem.with_suffix('.il')); rec['raw_json_sha256'] = sha(stem.with_suffix('.json'))
        save(stem.with_suffix('.record.json'), rec)
        return rec

def run_versions(config, out, timeout):
    versions = {}
    with Synthesis(config, out, timeout) as run:
        for role in ['original', 'optimized']:
            stem = out / 'identity' / ('version_' + role)
            run.execute(role, ['-V'], stem)
            text = stem.with_suffix('.log').read_text(encoding='utf-8', errors='replace').strip()
            if not re.search(r'\bYosys 0\.69(?:\+|\s|$)', text): raise ValueError('真实程序不是0.69：' + text)
            versions[role] = text
    save(out / 'identity/versions.json', versions)

def area(config, out, timeout):
    rows = []
    with Synthesis(config, out, timeout) as run:
        for case in config['cases']:
            for role in ['original', 'optimized']:
                row = run.case(case, role, 'area', 'area', True); rows.append(row)
                save(out / 'area/results.json', rows)
                print(case['case'], role, 'area=' + str(row['logic_area']), flush=True)
    summary = area_summary(rows); save(out / 'area/summary.json', summary)
    save(out / 'area/统一ABC核验.json', {'all_nine_uniform_per_variant': True,
        'actual_sequences': config['actual_abc_sequences']})
    return summary

def eqy(config, out, timeout):
    verify_area_files(out)
    base = config['package'] / '等价验证'
    prep = load('research_prepare', base / '生成正式验证输入.py')
    runner = load('research_eqy', base / '官方等价验证入口.py')
    audit = load('research_boundary', base / '核验适配边界.py')
    binding = load('research_bind', base / '核对证明输入来源.py')
    proof = out / 'eqy'; proof.mkdir()
    rows, boundaries = [], []
    for case in config['cases']:
        name = case['case']; work = proof / name
        row = {'case': name, 'top': case['top'], 'status': 'ERROR'}
        try:
            info = prep.prepare(out / 'area' / name / 'original-area.il', out / 'area' / name / 'optimized-area.il',
                                case['top'], work / '验证输入')
            boundaries.append({'case': name, **audit.audit(work / '验证输入')})
            save(proof / '适配边界审计.json', boundaries)
            execution, log = runner.run_eqy(work / '验证输入', work / '官方EQY结果', timeout=timeout)
            row.update(inputs=info['inputs'], exit_code=execution['exit_code'], wall_seconds=execution['wall_seconds'])
            row['status'] = 'PASS' if real_eqy_pass(execution, log, work / '官方EQY结果') else 'FAIL'
            if row['status'] != 'PASS': raise RuntimeError('真实EQY未通过：' + name)
        except BaseException as error:
            row['error'] = repr(error); raise
        finally:
            rows.append(row)
            summary = {'official_case_count': 9, 'executed_case_count': len(rows),
                'pass_count': sum(r['status'] == 'PASS' for r in rows),
                'all_nine_pass': len(rows) == 9 and all(r['status'] == 'PASS' for r in rows), 'cases': rows}
            save(proof / '正式EQY汇总.json', summary)
            print('EQY', name, row['status'], flush=True)
    check = binding.check(proof, out / 'area'); save(proof / '输入来源复核.json', check)
    if not check['all_nine_bound_to_new_raw_netlists']: raise RuntimeError('EQY证明与本轮原始输入不匹配')
    verify_area_files(out)
    evidence = {p.relative_to(out).as_posix(): file_info(p) for folder in [out / 'area', out / 'eqy']
                for p in sorted(folder.rglob('*')) if p.is_file()}
    save(out / '面积与证明证据清单.json', evidence)
    return summary

def verify_area_files(out):
    rows = read(out / 'area/results.json')
    area_summary(rows)
    for row in rows:
        stem = out / 'area' / row['case'] / (row['variant'] + '-area')
        for extension, key in [('.il', 'raw_il_sha256'), ('.json', 'raw_json_sha256'), ('.ys', 'script_sha256')]:
            if sha(stem.with_suffix(extension)) != row[key]: raise RuntimeError('面积输入/输出被修改：' + str(stem))
        actual = parse_area(stem.with_suffix('.json'), row['top'])
        if any(actual[k] != row[k] for k in actual): raise RuntimeError('面积计数与实际网表不符')

def prior_evidence(config, path):
    path = Path(path).resolve(strict=True)
    identity = read(path / 'identity.json')
    if identity['binding_sha256'] != config['identity']['binding_sha256']:
        raise ValueError('已有面积/EQY证据的源码、程序、脚本、输入或工具身份不同，禁止复用')
    status = read(path / '运行状态.json')
    if status.get('status') not in ['EQY_COMPLETE', 'COMPLETE'] or not {'area', 'eqy'} <= set(status.get('completed_stages', [])):
        raise ValueError('已有记录未完成面积和正式EQY')
    for relative, expected in read(path / '面积与证明证据清单.json').items():
        if file_info(path / relative) != expected: raise ValueError('已有证据被修改：' + relative)
    summary = area_summary(read(path / 'area/results.json'))
    if not summary['area_gate_pass']: raise ValueError('已有面积结果未通过当前门槛')
    binding = load('research_reuse_binding', config['package'] / '等价验证/核对证明输入来源.py')
    proof = binding.check(path / 'eqy', path / 'area')
    if not proof['all_nine_bound_to_new_raw_netlists']: raise ValueError('已有EQY没有真实匹配的9例证明')
    for row in read(path / 'area/results.json'):
        role = row['variant']; commands = row['actual_abc_commands']
        sequences = config.setdefault('actual_abc_sequences', {})
        if role in sequences and sequences[role] != commands: raise ValueError('已有面积记录的ABC脚本不统一')
        sequences[role] = commands
    return {'source': str(path), 'identity_sha256': sha(path / 'identity.json'),
            'area': summary, 'eqy': read(path / 'eqy/正式EQY汇总.json'), 'inputs': proof}

def performance(config, out, timeout):
    rows, summary = [], []
    with Synthesis(config, out, timeout) as run:
        for i in range(10):
            run.case(config['cases'][-1], 'original', 'performance', f'warmup{i + 1:02d}')
        for case in config['cases']:
            initial = {}
            for role in ['original', 'optimized']:
                initial[role] = run.case(case, role, 'performance', 'initial')
                rows.append(initial[role]); save(out / 'performance/results.json', rows)
            samples = {role: [initial[role]] for role in ['original', 'optimized']}
            if short_review(initial):
                samples = {'original': [], 'optimized': []}
                for i in range(5):
                    for role in ['original', 'optimized']:
                        row = run.case(case, role, 'performance', f'review{i + 1}')
                        samples[role].append(row); rows.append(row); save(out / 'performance/results.json', rows)
            item = performance_summary(case['case'], initial, samples)
            summary.append(item); save(out / 'performance/summary.json', summary)
            print(case['case'], 'time%=' + str(item['wall_seconds']['overhead_percent']),
                  'memory%=' + str(item['peak_working_set_bytes']['overhead_percent']), flush=True)
    return summary

def unchanged(config):
    for role, root in config['programs'].items():
        if tree_info(root)['tree_sha256'] != config['identity']['binding']['programs'][role]['runtime_tree_sha256']:
            raise RuntimeError('测量期间程序或运行依赖发生变化：' + role)
    for name, file in config['tool_files'].items():
        if file_info(file) != config['identity']['binding']['tools'][name]: raise RuntimeError('工具身份变化：' + name)
    for name, file in config['helper_files'].items():
        if file_info(file) != config['identity']['binding']['helpers'][name]: raise RuntimeError('复测/证明脚本在运行中变化：' + name)
    if tree_info(config['candidate_source'])['tree_sha256'] != config['identity']['binding']['candidate_source_tree_sha256']:
        raise RuntimeError('候选源码快照在运行中变化')
    basis = config['identity']['binding']['baseline_source_basis']
    if config['baseline_source']:
        if tree_info(config['baseline_source'])['tree_sha256'] != basis['tree_sha256']:
            raise RuntimeError('原版源码快照在运行中变化')
    else:
        if file_info(config['package'] / '官方源码来源.json') != basis['official_provenance'] or file_info(config['package'] / '构建工具/共同Tcl兼容补丁.patch') != basis['shared_patch']:
            raise RuntimeError('原版来源/共同补丁在运行中变化')
    for case in config['cases']:
        for file in [config['package'] / '官方测试用例' / case['file'], config['output'] / 'inputs/cases' / case['file']]:
            if sha(file) != case['sha256']: raise RuntimeError('官方输入或实际输入副本在运行中变化')
    if config['abc']:
        for file in [config['abc_source'], config['output'] / 'inputs/candidate.abc']:
            if sha(file) != config['abc']['original_sha256']: raise RuntimeError('研究ABC脚本原件或副本变化')
    save(config['output'] / '身份结束复核.json', {'all_bound_files_unchanged': True,
        'scope': '两版程序及完整运行依赖、候选/原版源码依据、工具、复测/证明脚本、官方RTL及输入副本、ABC覆盖原件与副本',
        'binding_sha256': config['identity']['binding_sha256']})

def write_report(out, state, report):
    report.update(status=state['status'], completed_stages=state['completed_stages'],
                  qualification='研究工具结果，不是组委会认证；外部ABC覆盖需固化进候选后按相同赛事入口重新验收。')
    save(out / '报告.json', report)
    lines = ['PMUX研究复测报告', '状态：' + state['status'], '候选：' + report['candidate'],
             '完成阶段：' + ', '.join(state['completed_stages'])]
    if 'area' in report:
        s = report['area']; lines += [f'面积逐例平均下降：{s["mean_reduction_percent"]:.6f}%；总量下降：{s["total_reduction_percent"]:.6f}%。',
            '面积门槛：' + ('通过' if s['area_gate_pass'] else '未通过')]
        lines += [f'  {r["case"]}: {r["original"]} -> {r["optimized"]}，下降 {r["reduction_percent"]:.6f}%' for r in s['cases']]
    if 'eqy' in report: lines += ['真实EQY：' + str(report['eqy']['pass_count']) + '/9 PASS']
    if 'performance' in report:
        lines += ['性能：全流程墙钟包含ABC；峰值只计Yosys主进程。']
        lines += [f'  {r["case"]}: 时间{r["wall_seconds"]["overhead_percent"]:+.6f}%，内存{r["peak_working_set_bytes"]["overhead_percent"]:+.6f}%，采用{r["samples_used"]}对样本' for r in report['performance']]
        lines += ['5%为效率满分相对条件，不是资格淘汰线；5%-15%不臆造扣分公式。',
                  '同时列出2GB十进制与2GiB绝对内存判定；原版超绝对限例外单列，不自动包装为基本通过。',
                  '10秒端点沿冻结入口采用严格<10秒；复核为5对新样本，初测不混入均值。']
    if report.get('diagnostic_only'): lines += ['本次为单独性能诊断，未做本轮面积/EQY，不得称完整验收通过。']
    if report.get('abc_override'): lines += ['候选使用明确记录的研究ABC覆盖；原版脚本未注入该覆盖。']
    if state.get('error'): lines += ['失败：' + state['error']]
    lines += [report['qualification']]
    (out / '报告.txt').write_text('\n'.join(lines) + '\n', encoding='utf-8')

def main(argv=None):
    a = parser().parse_args(argv); out = validate_arguments(a)
    out.mkdir(parents=True, exist_ok=False)
    state = {'status': 'STARTED', 'completed_stages': [], 'stage_requested': a.阶段,
             'started_utc': datetime.now(timezone.utc).isoformat()}
    report = {'candidate': a.候选名称, 'abc_override': a.abc_script is not None, 'diagnostic_only': a.仅性能诊断}
    save(out / '运行状态.json', state)
    overrides = {}
    for name, value in [('PMUX_OSS_CAD_SUITE', a.官方套件), ('PMUX_EQY_MAKE', a.gnu_make), ('PMUX_GIT_USR_BIN', a.git_bin)]:
        if value is not None: overrides[name] = value.expanduser().resolve()
    try:
        with environment(overrides):
            config = preflight(a, out)
            # Explicitly carry resolved tools into unchanged official-EQY helpers.
            with environment({'PMUX_OSS_CAD_SUITE': config['suite'], 'PMUX_EQY_MAKE': config['make'], 'PMUX_GIT_USR_BIN': config['git']}):
                state['completed_stages'].append('identity'); report['binding_sha256'] = config['identity']['binding_sha256']
                if a.检查配置:
                    state['status'] = 'CONFIG_ONLY'; return 0
                if os.name != 'nt': raise RuntimeError('当前计时/运行入口仅支持Windows原生环境')
                run_versions(config, out, a.综合超时)
                if a.阶段 == 'performance':
                    if a.已有证据:
                        prior = prior_evidence(config, a.已有证据); save(out / '复用证据核验.json', prior)
                        report.update(area=prior['area'], eqy=prior['eqy']); state['completed_stages'] += ['area_reused', 'eqy_reused']
                else:
                    report['area'] = area(config, out, a.综合超时); state['completed_stages'].append('area')
                    if a.阶段 == 'area': state['status'] = 'AREA_COMPLETE'; unchanged(config); return 0
                    if not report['area']['area_gate_pass']: raise RuntimeError('面积/寄存器/端口门槛未通过，停止后续阶段')
                    report['eqy'] = eqy(config, out, a.EQY超时); state['completed_stages'].append('eqy')
                    if a.阶段 == 'eqy': state['status'] = 'EQY_COMPLETE'; unchanged(config); return 0
                report['performance'] = performance(config, out, a.综合超时)
                state['completed_stages'].append('performance'); unchanged(config)
                full = all(r['within_5_percent'] and r['within_absolute_limits_2GB_decimal'] for r in report['performance'])
                report['all_nine_within_5_percent_and_absolute_limits'] = full
                state['status'] = 'DIAGNOSTIC_COMPLETE' if a.仅性能诊断 else 'COMPLETE'
                return 0 if full else 3
    except BaseException as error:
        state['status'] = 'FAILED'; state['error'] = repr(error)
        (out / '失败详情.txt').write_text(traceback.format_exc(), encoding='utf-8')
        print('研究复测停止：' + str(error), file=sys.stderr, flush=True)
        return 2
    finally:
        state['finished_utc'] = datetime.now(timezone.utc).isoformat()
        save(out / '运行状态.json', state); write_report(out, state, report)

if __name__ == '__main__':
    try: raise SystemExit(main())
    except (OSError, RuntimeError, ValueError) as error:
        print('入口参数/输出目录失败：' + str(error), file=sys.stderr); raise SystemExit(2)
