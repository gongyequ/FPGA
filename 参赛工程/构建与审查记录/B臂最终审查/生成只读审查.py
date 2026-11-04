"""Inspect existing source and evidence only. No compiler/EDA subprocesses."""
from pathlib import Path
from collections import Counter
import difflib,hashlib,json,re
ROOT=Path(__file__).resolve().parents[2]
OUT=Path(__file__).resolve().parent
BASE=ROOT.parent/'零点六九基线重做'
SNAP=ROOT/'构建记录/B臂默认集成构建'
CAND=ROOT/'验收候选/B臂集成F4c'
AREA=ROOT/'全量验收/B臂集成F4c_面积等价_01'
F4=ROOT/'全量验收/早退F4c_面积等价_01'
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):return Path(p).read_text(encoding='utf-8')
def save(p,v):p.write_text(json.dumps(v,ensure_ascii=False,indent=2),encoding='utf-8')

paths=['passes/opt/pmux_opt.cc','techlibs/intel/synth_intel.cc']
source_records=[];patch=[]
for relative in paths:
    original=BASE/'开发源码'/relative
    candidate=CAND/'源码'/relative
    snapshot=SNAP/Path(relative).name
    assert candidate.read_bytes()==snapshot.read_bytes(),relative
    old,new=read(original),read(candidate)
    patch.extend(difflib.unified_diff(old.splitlines(True),new.splitlines(True),
                                     fromfile='a/'+relative,tofile='b/'+relative))
    source_records.append({'path':relative,'baseline_sha256':sha(original),
                           'candidate_sha256':sha(candidate),'snapshot_sha256':sha(snapshot)})
(OUT/'候选自研增量_相对release_F2c冻结源码.patch').write_text(''.join(patch),encoding='utf-8',newline='\n')
pmux=read(SNAP/'pmux_opt.cc');synth=read(SNAP/'synth_intel.cc')
old_synth=read(BASE/'开发源码/techlibs/intel/synth_intel.cc')
old_call='pmux_opt -order-decode -flatten-fallback -uniform-abc'
new_call=old_call+' -flatten-data-arm'
assert synth.replace(new_call,old_call)==old_synth,'Other synth flow changes'
assert synth.count(new_call)==1 and '-index-full-x' not in synth
assert 'index_full_x = false' in pmux and 'if (index_full_x && index_full_x_decode' in pmux
assert '+&dch,-f,-r;,&if,{W},{D},{R},-a,-v,-F,4,-c;,&mfs' in pmux
assert pmux.index('design->scratchpad_set_string')<pmux.index('bool has_selected_pmux')
unchanged=[]
for relative in ['passes/opt/CMakeLists.txt','techlibs/intel/CMakeLists.txt','kernel/tclapi.cc',
                 'passes/opt/pmux2shiftx.cc','passes/techmap/abc9.cc','passes/techmap/abc9_exe.cc']:
    original=BASE/'开发源码'/relative;candidate=CAND/'源码'/relative
    assert original.read_bytes()==candidate.read_bytes(),relative
    unchanged.append({'path':relative,'sha256':sha(candidate)})

area=json.loads(read(AREA/'area/summary.json'));previous=json.loads(read(F4/'area/summary.json'))
f4_cases={c['case']:c for c in previous['cases']}
dynamic=[]
for c in area['cases']:
    p=AREA/'area'/c['case']/'optimized-area.log';text=p.read_text(encoding='utf-8',errors='replace')
    matches=re.findall(r'PMUX data-arm flattening: merged (\d+) single-use nested data arms\.',text)
    assert len(matches)==1,(c['case'],matches)
    assert 'PMUX full-table indexing:' not in text,'Index option actually enabled'
    assert text.count('Running ABC command')==1,(c['case'],'ABC count')
    # ABC's executed script is printed in one line; check exact F=4 mapping there.
    abc_lines=[x for x in text.splitlines() if 'ABC: +' in x and '&if ' in x]
    assert len(abc_lines)==1 and '-F 4 -c' in abc_lines[0],(c['case'],abc_lines)
    record={**c,'b_arm_merges':int(matches[0]),'f4_without_b':f4_cases[c['case']]['optimized'],
        'additional_reduction_from_b':f4_cases[c['case']]['optimized']-c['optimized'],
        'log':str(p.relative_to(ROOT)),'log_sha256':sha(p),
        'log_line':next(i for i,x in enumerate(text.splitlines(),1) if 'PMUX data-arm flattening:' in x),
        'single_external_abc':True,'index_log_absent':True,'abc_command':abc_lines[0]}
    dynamic.append(record)
save(OUT/'九例实际命中及面积.json',dynamic)

# Static recognition over the already-exported insertion-point JSON. This is
# analysis of saved data only, not a rerun or substitute for actual C++ counts.
static=[]
for c in area['cases']:
    p=BASE/'算法候选/九例插入点结构'/c['case']/'before.json'
    data=json.loads(read(p))['modules']
    name,m=max(data.items(),key=lambda it:sum(v['type']=='$pmux' for v in it[1]['cells'].values()))
    cells=m['cells'];pmuxes={k:v for k,v in cells.items() if v['type']=='$pmux'}
    users=Counter();drivers={};ambiguous=set()
    for cellname,cell in pmuxes.items():
        for bit in cell['connections']['Y']:
            if bit in drivers:ambiguous.add(bit)
            drivers[bit]=cellname
    for port in m['ports'].values():
        if port['direction'] in ['output','inout']:users.update(port['bits'])
    for cell in cells.values():
        directions=cell.get('port_directions',{})
        for port,bits in cell['connections'].items():
            if not directions or directions.get(port) in ['input','inout']:users.update(bits)
    edges=[]
    for outer_name,outer in pmuxes.items():
        ports=outer['connections'];w=len(ports['A']);ko=len(ports['S'])
        for arm in range(ko):
            bits=ports['B'][arm*w:(arm+1)*w]
            if not bits or bits[0] not in drivers:continue
            inner_name=drivers[bits[0]];inner=pmuxes[inner_name];ip=inner['connections'];ki=len(ip['S'])
            if inner_name==outer_name or ip['Y']!=bits:continue
            single=all(isinstance(b,int) and users[b]==1 and b not in ambiguous for b in bits)
            guard=w>ki+1 and ki+ko<=16
            edges.append({'outer':outer_name,'inner':inner_name,'arm':arm,'width':w,
                          'inner_arms':ki,'outer_arms':ko,'single_consumer':single,
                          'cost_guard':guard,'initially_admitted':single and guard})
    static.append({'case':c['case'],'module':name,'source':str(p),'source_sha256':sha(p),
                   'initial_pmux_count':len(pmuxes),'initial_data_edges':len(edges),
                   'initially_admitted_edges':sum(e['initially_admitted'] for e in edges),'edges':edges,
                   'scope':'saved before-pass snapshot; does not simulate preceding fallback rewrite or sequential merges'})
save(OUT/'九例已有快照静态结构.json',static)
eqy=json.loads(read(AREA/'eqy/正式EQY汇总.json'))
audit={'scope':'read-only source/evidence audit; no build, EDA or performance executed',
    'baseline':'release_F2c frozen modified Yosys source, not pristine official source',
    'source_files':source_records,'unchanged_checked_files':unchanged,
    'default_synth_call':new_call,'synth_delta_only_flag':True,'index_default_off':True,
    'same_abc_script_all_cases':True,'total_b_merges':sum(x['b_arm_merges'] for x in dynamic),
    'mean_reduction_percent':area['mean_reduction_percent'],'total_reduction_percent':area['total_reduction_percent'],
    'f4_without_b_mean_reduction_percent':previous['mean_reduction_percent'],
    'b_increment_total_cells':sum(x['additional_reduction_from_b'] for x in dynamic),
    'eqy_summary_pass_count':eqy['pass_count'],'eqy_all_nine_pass':eqy['all_nine_pass'],
    'performance':'not concluded here; scheduled and audited by root separately',
    'patch_sha256':sha(OUT/'候选自研增量_相对release_F2c冻结源码.patch')}
save(OUT/'只读审查汇总.json',audit)
print(json.dumps({'area_mean':area['mean_reduction_percent'],'b_merges':audit['total_b_merges'],
                  'additional_cells':audit['b_increment_total_cells'],'eqy_pass':audit['eqy_summary_pass_count'],
                  'static':[(x['case'],x['initially_admitted_edges']) for x in static]},ensure_ascii=False))
