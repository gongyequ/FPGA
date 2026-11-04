"""研究复测的纯数据检查；不运行、替代或模拟 EDA 工具。"""
from pathlib import Path
import hashlib, json, math, os, re, stat, statistics
from fractions import Fraction

CASE_ORDER = ['rar_test1', 'rar_test2', 'rar_test3', 'rar_test4',
              'zip_case01', 'zip_case02', 'zip_case03', 'zip_case04', 'zip_case05']
EXPECTED_ABC = '60e1136f56b0eb4d256246aa6accfa36a8d97af2dc0693269ad62ba2359b33e5'
EXPECTED_SUITE_YOSYS = 'a9a1b18604fd984972e8c6786a52261cee9e6cbe002b65e5ca353beacbd65e90'

def save(path, value):
    path = Path(path); path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

def read(path): return json.loads(Path(path).read_text(encoding='utf-8-sig'))

def sha(path):
    h = hashlib.sha256()
    with Path(path).open('rb') as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b''): h.update(block)
    return h.hexdigest()

def digest(value):
    return hashlib.sha256(json.dumps(value, ensure_ascii=False, sort_keys=True,
                                    separators=(',', ':')).encode('utf-8')).hexdigest()

def file_info(path):
    path = Path(path)
    if not path.is_file(): raise FileNotFoundError(path)
    before = path.stat(); value = {'bytes': before.st_size, 'sha256': sha(path)}
    after = path.stat()
    if (before.st_size, before.st_mtime_ns) != (after.st_size, after.st_mtime_ns):
        raise RuntimeError('文件在读取时变化：' + str(path))
    return value

def tree_info(root):
    root = Path(root).resolve(strict=True)
    if not root.is_dir(): raise NotADirectoryError(root)
    rows = []
    for directory, dirs, files in os.walk(root, followlinks=False):
        dirs[:] = sorted(name for name in dirs if name not in ('.git', '__pycache__'))
        for name in dirs + files:
            if name in ('.git', '__pycache__'): continue
            file = Path(directory) / name
            if getattr(file.lstat(), 'st_file_attributes', 0) & stat.FILE_ATTRIBUTE_REPARSE_POINT:
                raise RuntimeError('身份快照不接受未绑定的目录联接或符号链接：' + str(file))
        for name in sorted(files):
            if name in ('.git',): continue
            file = Path(directory) / name
            rows.append({'file': file.relative_to(root).as_posix(), **file_info(file)})
    if not rows: raise ValueError('空目录不能作为源码/运行环境：' + str(root))
    return {'file_count': len(rows), 'tree_sha256': digest(rows), 'files': rows}

def abc_override(path):
    if path is None: return None
    path = Path(path)
    raw = path.read_text(encoding='utf-8-sig')
    lines = [line for line in raw.splitlines() if not line.lstrip().startswith('#')]
    normalized = ' '.join(' '.join(lines).split()).strip()
    if not normalized or not normalized.isascii(): raise ValueError('ABC研究脚本须为非空ASCII命令')
    # This interface accepts an ABC command sequence, not another Yosys script.
    if any(c in normalized for c in ['\x00', '"', "'", '\\', '#']):
        raise ValueError('ABC脚本不支持引号、反斜线或行尾注释；使用独立的纯命令序列')
    if normalized.startswith('+'): raise ValueError('请提供普通ABC命令，不要预先添加+或逗号编码')
    unknown = set(re.findall(r'\{[^}]*\}', normalized)) - {'{W}', '{D}', '{R}'}
    if unknown: raise ValueError('未知ABC占位符：' + repr(sorted(unknown)))
    return {'original_sha256': sha(path), 'normalized': normalized,
            'normalized_sha256': hashlib.sha256(normalized.encode('ascii')).hexdigest(),
            'scratchpad': '+' + normalized.replace(' ', ',')}

def official_cases(directory):
    directory = Path(directory)
    cases = read(directory / '用例来源.json')
    if [c['case'] for c in cases] != CASE_ORDER: raise ValueError('必须使用固定顺序的9个官方用例')
    answer = []
    for case in cases:
        if not re.fullmatch(r'[A-Za-z_][A-Za-z0-9_$]*', case['top']): raise ValueError('非法顶层名')
        if Path(case['file']).name != case['file'] or not case['file'].isascii():
            raise ValueError('用例文件须为目录内ASCII文件名')
        if case.get('parameters') != 'official defaults': raise ValueError('禁止修改官方默认参数')
        actual = file_info(directory / case['file'])
        if actual['sha256'] != case['sha256']: raise ValueError('官方RTL哈希不匹配：' + case['case'])
        answer.append({key: case[key] for key in ['case', 'top', 'file', 'sha256', 'parameters']})
    return answer

def parse_area(path, top):
    design = read(path)
    modules = design.get('modules', {})
    if top not in modules: raise ValueError('面积网表缺少指定顶层')
    # Official write_json also preserves uninstantiated Intel/ABC9 library modules.
    # Only the top's actual cells count; another live RTL hierarchy is rejected.
    def enabled(value):
        if isinstance(value, int): return value != 0
        return isinstance(value, str) and bool(re.fullmatch('[01]+', value)) and int(value, 2) != 0
    for name, other in modules.items():
        if name == top: continue
        attrs = other.get('attributes', {})
        if not any(enabled(attrs.get(flag, 0)) for flag in ['blackbox', 'whitebox']):
            raise ValueError('存在未展开的非库模块：' + name)
    module = modules[top]; counts = {}
    for cell in module['cells'].values(): counts[cell['type']] = counts.get(cell['type'], 0) + 1
    unexpected = set(counts) - {'$lut', '$_NOT_', '$not', 'dffeas'}
    if unexpected: raise ValueError('ABC后网表仍有未计量单元：' + repr(sorted(unexpected)))
    ports = {name: {'direction': port['direction'], 'width': len(port['bits'])}
             for name, port in module['ports'].items()}
    lut = counts.get('$lut', 0); inv = counts.get('$_NOT_', 0) + counts.get('$not', 0)
    if lut <= 0: raise ValueError('未找到实际ABC映射后的$lut')
    return {'cell_types': counts, 'lut': lut, 'inverters': inv, 'logic_area': lut + inv,
            'dff': counts.get('dffeas', 0), 'io_bits': sum(p['width'] for p in ports.values()), 'ports': ports}

def area_summary(rows):
    indexed = {}
    for row in rows:
        key = (row['case'], row['variant'])
        if key in indexed: raise ValueError('面积记录重复：' + repr(key))
        indexed[key] = row
    expected = {(c, v) for c in CASE_ORDER for v in ['original', 'optimized']}
    if set(indexed) != expected: raise ValueError('面积记录缺少9例成对结果')
    result = []; exact_reductions = []
    for case in CASE_ORDER:
        gold, gate = indexed[case, 'original'], indexed[case, 'optimized']
        if gold['logic_area'] <= 0: raise ValueError('零面积基数不能计算百分比：' + case)
        reduction = Fraction(gold['logic_area'] - gate['logic_area'], gold['logic_area'])
        exact_reductions.append(reduction)
        result.append({'case': case, 'original': gold['logic_area'], 'optimized': gate['logic_area'],
            'reduction_percent': float(100 * reduction), 'no_area_increase': reduction >= 0,
            'dff_unchanged': gold['dff'] == gate['dff'],
            'io_unchanged': gold['ports'] == gate['ports']})
    exact_mean = sum(exact_reductions, Fraction(0)) / len(exact_reductions)
    mean = float(exact_mean * 100)
    b = sum(row['original'] for row in result); g = sum(row['optimized'] for row in result)
    return {'case_count': 9, 'mean_reduction_percent': mean, 'original_total': b, 'optimized_total': g,
        'total_reduction_percent': 100 * (1 - g / b),
        'area_gate_pass': exact_mean >= Fraction(1, 10) and all(r['no_area_increase'] and r['dff_unchanged'] and r['io_unchanged'] for r in result),
        'gate_definition': '逐例下降百分比算术平均>=10%；9例均无面积反增；DFF和顶层IO保持不变。', 'cases': result}

def needs_review(initial):
    for variant in ['original', 'optimized']:
        for metric in ['wall_seconds', 'peak_working_set_bytes']:
            value = initial[variant][metric]
            if not isinstance(value, (int, float)) or not math.isfinite(value) or value <= 0:
                raise ValueError('计时/内存样本必须为正有限数')
    return any(initial['optimized'][m] / initial['original'][m] > 1.05
               for m in ['wall_seconds', 'peak_working_set_bytes'])

def short_review(initial): return needs_review(initial) and max(v['wall_seconds'] for v in initial.values()) < 10

def performance_summary(case, initial, samples):
    review = needs_review(initial)
    count = 5 if short_review(initial) else 1
    if any(len(samples[v]) != count for v in ['original', 'optimized']):
        raise ValueError('性能样本数不符合初测/5对新样本规则')
    item = {'case': case, 'review_triggered': review, 'review_executed': short_review(initial), 'samples_used': count}
    for metric in ['wall_seconds', 'peak_working_set_bytes']:
        b = statistics.mean(r[metric] for r in samples['original'])
        g = statistics.mean(r[metric] for r in samples['optimized'])
        if not math.isfinite(b) or not math.isfinite(g) or min(b, g) <= 0: raise ValueError('非法性能均值')
        item[metric] = {'baseline': b, 'candidate': g, 'overhead_percent': 100 * (g / b - 1)}
    item['within_5_percent'] = all(item[m]['candidate'] / item[m]['baseline'] <= 1.05 for m in ['wall_seconds', 'peak_working_set_bytes'])
    item['within_15_percent'] = all(item[m]['candidate'] / item[m]['baseline'] <= 1.15 for m in ['wall_seconds', 'peak_working_set_bytes'])
    item['within_absolute_limits_2GiB'] = all(r['wall_seconds'] <= 60 and r['peak_working_set_bytes'] <= 2 * 1024**3 for r in samples['optimized'])
    item['within_absolute_limits_2GB_decimal'] = all(r['wall_seconds'] <= 60 and r['peak_working_set_bytes'] <= 2_000_000_000 for r in samples['optimized'])
    item['baseline_exceeds_absolute_limits'] = any(r['wall_seconds'] > 60 or r['peak_working_set_bytes'] > 2_000_000_000 for r in samples['original'])
    item['baseline_exception_requires_separate_interpretation'] = item['baseline_exceeds_absolute_limits'] and not item['within_absolute_limits_2GB_decimal']
    item['score_scope'] = '5%为效率满分相对条件；>15%为效率项0条件，5%-15%之间不猜测未公布扣分公式；绝对限/原版超限例外另列。'
    return item

def real_eqy_pass(execution, log, output):
    return execution.get('exit_code') == 0 and (Path(output) / 'proof/PASS').is_file() and 'DONE (PASS, rc=0)' in log

def actual_abc_commands(log):
    commands = []
    for line in log.splitlines():
        match = re.match(r'^ABC: \+ (.*)$', line)
        if not match: continue
        command = ' '.join(match.group(1).split())
        command = re.sub(r'[^\s"\']+[/\\](lutdefs\.txt|input\.box|input\.xaig|output\.aig)\b',
                         r'<abc-temp-dir>/\1', command)
        commands.append(command)
    if not commands: raise ValueError('真实日志缺少ABC命令回显，无法核验统一脚本')
    return commands
