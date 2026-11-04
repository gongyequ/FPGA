"""Prepare a fixed structural regression; execute only after root schedules it.

No frozen input/source is edited.  This is supplemental regression, NOT the
official nine-case score.  Uses actual baseline/candidate EXEs and unmodified
official simlib; never setundef/opt/techmap before the four-state comparison.
"""
from pathlib import Path
from contextlib import ExitStack, contextmanager
import argparse, ctypes, hashlib, importlib.util, json, os, random, shutil
import subprocess, sys, tempfile, time

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
WORKSPACE = HERE.parent
FROZEN = HERE.parent
MODEL = FROZEN / "开发源码/techlibs/common/simlib.v"


def sha(file):
    h = hashlib.sha256()
    with Path(file).open('rb') as stream:
        for block in iter(lambda: stream.read(1024*1024), b''): h.update(block)
    return h.hexdigest()


def save(path, value):
    Path(path).parent.mkdir(parents=True, exist_ok=True)
    Path(path).write_text(json.dumps(value, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')


def concat(low_first):
    return low_first[0] if len(low_first) == 1 else '{ ' + ' '.join(reversed(low_first)) + ' }'


class Circuit:
    def __init__(self, name, description):
        self.name, self.description = name, description
        self.wires, self.ports, self.cells, self.connections, self.nodes = [], [], [], [], []
        self.selection = None
        self.expect_unchanged = False
        self.min_removed_with_default = 0
        self.min_removed_with_b = 0
        self.simulate = True
        self.samples = 512

    def wire(self, name, width, direction=None, kind='data'):
        if width < 1: raise ValueError('Positive signal width required')
        if any(p['name'] == name for p in self.wires): raise ValueError(name)
        row = dict(name=name, width=width, direction=direction, kind=kind)
        self.wires.append(row)
        if direction: self.ports.append(row)
        return '\\'+name

    def input(self, name, width, kind='data'):
        return self.wire(name, width, 'input', kind)

    def pmux(self, width, k=2, default=None, children=None, permute=None):
        n = len(self.nodes)
        a = self.input(f'a{n}', width) if default is None else default
        b = self.input(f'b{n}', width*k)
        s = self.input(f's{n}', k, 'select')
        y = self.wire(f'y{n}', width)
        arms = [f'{b} [{j*width+width-1}:{j*width}]' for j in range(k)]
        for position, child in (children or {}).items(): arms[position] = child
        order = list(range(k)) if permute is None else list(permute)
        if sorted(order) != list(range(k)): raise ValueError('Invalid arm permutation')
        conn = dict(A=a, B=concat([arms[j] for j in order]),
                    S=concat([f'{s} [{j}]' for j in order]), Y=y)
        self.cells.append(dict(name=f'p{n}', type='$pmux', width=width, k=k, connections=conn))
        self.nodes.append(dict(cell=f'p{n}', y=y, width=width, k=k))
        return y

    def output(self, signal, width, name=None):
        name = name or f'out{sum(p["direction"] == "output" for p in self.ports)}'
        y = self.wire(name, width, 'output')
        self.connections.append((y, signal))

    def rtlil(self):
        lines = ['autoidx 1', 'attribute \\top 1', 'module \\'+self.name]
        port_ids = {p['name']: n+1 for n,p in enumerate(self.ports)}
        for wire in self.wires:
            port = f' {wire["direction"]} {port_ids[wire["name"]]}' if wire['direction'] else ''
            lines.append(f'  wire width {wire["width"]}{port} \\{wire["name"]}')
        for cell in self.cells:
            lines += [f'  cell {cell["type"]} \\{cell["name"]}',
                      f'    parameter \\WIDTH {cell["width"]}',
                      f'    parameter \\S_WIDTH {cell["k"]}']
            lines += [f'    connect \\{port} {sig}' for port,sig in cell['connections'].items()]
            lines += ['  end']
        lines += [f'  connect {a} {b}' for a,b in self.connections]
        return '\n'.join(lines+['end', ''])

    def metadata(self):
        return dict(name=self.name, description=self.description, input_pmux_count=len(self.cells),
                    ports=self.ports, selection=self.selection, expect_unchanged=self.expect_unchanged,
                    min_removed_with_default=self.min_removed_with_default,
                    min_removed_with_b=self.min_removed_with_b,
                    simulate=self.simulate, samples=self.samples,
                    scope='supplemental structural regression; not official nine-case area/performance')


def designs():
    result=[]
    for depth,width,k in [(4,8,2),(8,5,2),(6,16,3)]:
        c=Circuit(f'fallback_d{depth}_w{width}_k{k}', '多层默认A嵌套，含成本/分支上限造成的部分合并')
        y=c.pmux(width,k)
        for _ in range(depth-1): y=c.pmux(width,k,default=y)
        c.output(y,width); c.min_removed_with_default=2; result.append(c)
    for depth,width,k in [(4,8,2),(6,12,3)]:
        c=Circuit(f'data_arm_d{depth}_w{width}_k{k}', '多层B臂链，各层被替换臂交替，B规则关闭时不要求命中')
        y=c.pmux(width,k)
        for level in range(1,depth): y=c.pmux(width,k,children={level%k:y},permute=list(reversed(range(k))))
        c.output(y,width); c.min_removed_with_b=2; result.append(c)
    c=Circuit('mixed_chain_d7_w12_k2','默认A与B臂交替嵌套；两规则及辅助门标签相互作用')
    y=c.pmux(12,2)
    for level in range(1,7):
        y=c.pmux(12,2,default=y) if level%2 else c.pmux(12,2,children={level%2:y},permute=[1,0])
    c.output(y,12); c.min_removed_with_default=2;result.append(c)

    c=Circuit('shared_child_a_and_b','同一内层同时作为A和B消费；不得删除共享驱动')
    inner=c.pmux(8,2); left=c.pmux(8,2,default=inner);right=c.pmux(8,2,children={1:inner})
    c.output(left,8);c.output(right,8);c.expect_unchanged=True;result.append(c)
    c=Circuit('shared_child_top_output','内层同时为顶层输出与外层B；顶层输出必须计入扇出')
    inner=c.pmux(8,2);outer=c.pmux(8,2,children={0:inner});c.output(inner,8);c.output(outer,8)
    c.expect_unchanged=True;result.append(c)
    c=Circuit('partial_slice_shared','外层默认A只取内层一半；另半部分保留在顶层')
    inner=c.pmux(8,2);outer=c.pmux(4,2,default=inner+' [3:0]');c.output(outer,4);c.output(inner+' [7:4]',4)
    c.expect_unchanged=True;result.append(c)
    c=Circuit('reordered_data_bits','内层完整输出以反序位接入外层B，不满足同序守卫')
    inner=c.pmux(8,2);rev=concat([inner+f' [{7-i}]' for i in range(8)])
    outer=c.pmux(8,2,children={1:rev});c.output(outer,8);c.expect_unchanged=True;result.append(c)
    for kind in ['outer_only','inner_only']:
        c=Circuit('partial_selection_'+kind,'部分选区：不允许删除选区外内层或更改选区外外层')
        inner=c.pmux(8,2);outer=c.pmux(8,2,default=inner);c.output(outer,8)
        c.selection=['p1'] if kind=='outer_only' else ['p0'];c.expect_unchanged=True;result.append(c)
    c=Circuit('no_matching_pmux_width','W=2、K=3嵌套，命中成本限制而保留结构')
    inner=c.pmux(2,3);outer=c.pmux(2,3,default=inner);c.output(outer,2);c.expect_unchanged=True;result.append(c)

    for count,width,k,seed in [(12,8,2,690411),(48,12,3,690412)]:
        c=Circuit(f'fixed_random_dag_n{count}_w{width}', '固定种子DAG：分支臂序、嵌套与共享混合；不是按官方用例拼接')
        rng=random.Random(seed);previous=[]
        for i in range(count):
            default=None;children={}
            if previous:
                source=previous[rng.randrange(len(previous))]
                if i%3==0: default=source
                else:children[rng.randrange(k)]=source
                if i%7==0:children[(i+1)%k]=source
            order=list(range(k));rng.shuffle(order)
            previous.append(c.pmux(width,k,default=default,children=children,permute=order))
        for signal in previous[-3:]:c.output(signal,width)
        c.samples=768;result.append(c)

    for count in [998,1000,1002]:
        c=Circuit(f'scale_{count}_pmux_cells','约1000节点边界：独立二层对，半数A嵌套半数B嵌套；仅结构/单pass时间记录')
        for pair in range(count//2):
            inner=c.pmux(8,2)
            outer=c.pmux(8,2,default=inner) if pair%2==0 else c.pmux(8,2,children={pair%2:inner})
            c.output(outer,8)
        c.simulate=False;c.samples=0;c.min_removed_with_default=2;result.append(c)
    return result


def prepare(out):
    if out.exists():raise RuntimeError('Output exists; preserve old plan/results')
    out.mkdir(parents=True)
    cases=[]
    for circuit in designs():
        folder=out/circuit.name;folder.mkdir()
        (folder/'input.il').write_text(circuit.rtlil(),encoding='ascii')
        meta=circuit.metadata();meta['input_sha256']=sha(folder/'input.il');cases.append(meta)
        save(folder/'case.json',meta)
    plan=dict(status='PREPARED_NOT_EXECUTED',seed_policy='explicit fixed seeds; no random search for passing inputs',
              generator_sha256=sha(__file__),official_model_sha256=sha(MODEL),cases=cases,
              normal_case_count=sum(c['simulate'] for c in cases),scale_case_count=sum(not c['simulate'] for c in cases),
              ordinary_input_vectors=sum(c['samples'] for c in cases),
              scale_scope='standalone read/check/pass/export elapsed time, not complete synth_intel or official efficiency score')
    save(out/'计划.json',plan)
    print(json.dumps({k:plan[k] for k in ['status','normal_case_count','scale_case_count','ordinary_input_vectors']},ensure_ascii=False))


def testbench(case):
    inputs=[p for p in case['ports'] if p['direction']=='input'];outputs=[p for p in case['ports'] if p['direction']=='output']
    select_count=sum(p['kind']=='select' for p in inputs)
    lines=['module tb;','integer step,j,seed=69042026,mode,target,rv;','integer vectors=0,bit_compares=0,known_bits=0,x_bits=0,z_bits=0,errors=0;',
           'function state4;input integer v;begin case(v&3) 0:state4=0;1:state4=1;2:state4=1\'bx;3:state4=1\'bz;endcase end endfunction']
    for port in inputs:lines.append(f'reg [{port["width"]-1}:0] {port["name"]};')
    for port in outputs:
        lines += [f'wire [{port["width"]-1}:0] ref_{port["name"]},cand_{port["name"]};']
    for module,prefix in [('gold','ref_'),('gate','cand_')]:
        conns=[f'.{p["name"]}({p["name"] if p["direction"]=="input" else prefix+p["name"]})' for p in case['ports']]
        lines.append(module+' u_'+module+'('+','.join(conns)+');')
    lines += ['initial begin',f'for(step=0;step<{case["samples"]};step=step+1) begin',
              f'mode=step%12;target=(step/12)%{max(select_count,1)};']
    si=0
    for port in inputs:
        n,w=port['name'],port['width']
        if port['kind']=='select':
            lines += [f'{n}=0;',f'{n}[(step/12)%{w}]=1;',f'if(mode==0) {n}=0;',
                      f'if(mode==2) for(j=0;j<{w};j=j+1) {n}[j]=$random(seed)&1;',
                      f'if(mode==3 && target=={si}) begin {n}=0;{n}[(step/12)%{w}]=1\'bx;end',
                      f'if(mode==4 && target=={si}) begin {n}=0;{n}[(step/12)%{w}]=1\'bz;end',
                      f'if(mode==5) {n}={w}\'b'+('z'*w)+';',
                      f'if(mode==7) {n}={w}\'b'+('1'*w)+';',
                      f'if(mode==8 && target=={si}) {n}[(step/12+1)%{w}]=1\'bx;',
                      f'if(mode==11 && target=={si}) for(j=0;j<{w};j=j+1) {n}[j]=state4($random(seed));']
            si+=1
        else:
            lines += [f'for(j=0;j<{w};j=j+1) begin',
                      f'if(mode==6) {n}[j]=1\'bz;else if(mode==9) {n}[j]=1\'bx;',
                      f'else if(mode==1 || mode==10) {n}[j]=$random(seed)&1;',
                      f'else {n}[j]=state4($random(seed));end']
    lines += ['#1;']
    for port in outputs:
        n,w=port['name'],port['width']
        lines += [f'vectors=vectors+1;bit_compares=bit_compares+{w};',
                  f'if(ref_{n} !== cand_{n}) begin errors=errors+1;if(errors<8)$display("DIFF case={case["name"]} out={n} step=%0d ref=%b cand=%b",step,ref_{n},cand_{n});end',
                  f'for(j=0;j<{w};j=j+1) begin',
                  f'if(ref_{n}[j]===1\'b0 || ref_{n}[j]===1\'b1) known_bits=known_bits+1;',
                  f'else if(ref_{n}[j]===1\'bz) z_bits=z_bits+1;else x_bits=x_bits+1;end']
    lines += ['end','$display("RESULT vectors=%0d bits=%0d known=%0d x=%0d z=%0d errors=%0d",vectors,bit_compares,known_bits,x_bits,z_bits,errors);',
              'if(errors || known_bits==0)$fatal(1,"Mismatch or no known-output coverage");$finish;end endmodule']
    return '\n'.join(lines)+'\n'


def load_locator():
    spec=importlib.util.spec_from_file_location('regression_tools',FROZEN/'等价验证/工具定位.py')
    module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module);return module


@contextmanager
def dedicated_drive(path, letter):
    """Only use our explicitly assigned O/N/M drives, never existing mappings."""
    drive=letter.upper()+':'
    if ctypes.windll.kernel32.GetLogicalDrives() & (1 << (ord(letter.upper())-ord('A'))):
        raise RuntimeError('Reserved drive already occupied; will not replace: '+drive)
    subprocess.run(['subst',drive,str(Path(path).resolve(strict=True))],check=True,capture_output=True,
                   creationflags=subprocess.CREATE_NO_WINDOW)
    query=ctypes.windll.kernel32.QueryDosDeviceW
    query.argtypes=[ctypes.c_wchar_p,ctypes.c_wchar_p,ctypes.c_ulong]
    buf=ctypes.create_unicode_buffer(32768)
    if not query(drive,buf,len(buf)):raise RuntimeError('Cannot verify own drive mapping')
    owned_target=buf.value
    try:yield drive+'/'
    finally:
        current=ctypes.create_unicode_buffer(32768)
        if query(drive,current,len(current)) and current.value==owned_target:
            subprocess.run(['subst',drive,'/D'],check=True,capture_output=True,creationflags=subprocess.CREATE_NO_WINDOW)


def execute(command, cwd, env, path, timeout):
    start=time.perf_counter()
    child=subprocess.Popen(command,cwd=cwd,env=env,stdout=subprocess.PIPE,stderr=subprocess.PIPE,
                           creationflags=subprocess.CREATE_NO_WINDOW)
    try:
        stdout,stderr=child.communicate(timeout=timeout)
    except subprocess.TimeoutExpired as error:
        subprocess.run(['taskkill.exe','/PID',str(child.pid),'/T','/F'],capture_output=True,
                       creationflags=subprocess.CREATE_NO_WINDOW)
        stdout,stderr=child.communicate(timeout=20)
        path.with_suffix('.log').write_bytes(stdout+stderr)
        save(path.with_suffix('.command.json'),dict(command=command,status='TIMEOUT',wall_seconds=time.perf_counter()-start,scope='supplemental isolated tool call'))
        raise
    wall=time.perf_counter()-start;path.with_suffix('.log').write_bytes(stdout+stderr)
    record=dict(command=command,exitcode=child.returncode,wall_seconds=wall,scope='supplemental isolated tool call; not official efficiency score')
    save(path.with_suffix('.command.json'),record)
    if child.returncode:raise RuntimeError('Tool failed: '+str(path)+' exit='+str(child.returncode))
    return record,(stdout+stderr).decode('utf-8',errors='replace')


def run(args,out):
    import re
    if os.name!='nt':raise RuntimeError('Windows tools are required')
    if not args.原版程序 or not args.候选程序:raise ValueError('Actual baseline/candidate directories are required')
    if (out/'运行身份.json').exists():raise RuntimeError('Execution already attempted; prepare a new output directory')
    plan=json.loads((out/'计划.json').read_text(encoding='utf-8'))
    if plan['generator_sha256']!=sha(__file__) or plan['official_model_sha256']!=sha(MODEL):raise RuntimeError('Generator/model changed since preparation')
    suite=(args.官方套件 or WORKSPACE/'官方工具/oss-cad-suite').resolve(strict=True)
    bins={role:p.resolve(strict=True) for role,p in [('original',args.原版程序),('optimized',args.候选程序)]}
    bins={r:p.parent if p.is_file() else p for r,p in bins.items()}
    flags='-order-decode -flatten-fallback -uniform-abc'+(' -flatten-data-arm' if args.包括B臂 else '')
    identity=dict(programs={r:dict(path=str(p),sha256=sha(p/'yosys.exe')) for r,p in bins.items()},
                  model_sha256=sha(MODEL),iverilog_sha256=sha(suite/'bin/iverilog.exe'),vvp_sha256=sha(suite/'bin/vvp.exe'),
                  pass_command='pmux_opt '+flags,scope='supplemental original-model regression; no ABC or official score')
    save(out/'运行身份.json',identity)
    rows=[];old_mode=ctypes.windll.kernel32.SetErrorMode(0x8003)
    try:
        with ExitStack() as stack:
            prefixes={role:stack.enter_context(dedicated_drive(p,letter)).rstrip('/')
                      for (role,p),letter in zip(bins.items(),['O','N'])}
            suite_ascii=stack.enter_context(dedicated_drive(suite,'M')).rstrip('/')
            for case in plan['cases']:
                folder=out/case['name'];src=folder/'input.il'
                if sha(src)!=case['input_sha256']:raise RuntimeError('Generated input changed: '+case['name'])
                row=dict(case=case['name'],input_pmux_count=case['input_pmux_count'],simulation_requested=case['simulate'])
                with tempfile.TemporaryDirectory(prefix='pmux-expanded-') as d:
                    temp=Path(d);shutil.copy2(src,temp/'input.il');shutil.copy2(MODEL,temp/'simlib.v')
                    models={}
                    for role,tag in [('original','gold'),('optimized','gate')]:
                        commands=['read_rtlil input.il','check -assert']
                        if role=='optimized':
                            selection=' '.join(case['name']+'/'+cell for cell in case['selection']) if case['selection'] else case['name']
                            commands += ['pmux_opt '+flags+' '+selection,'select *','check -assert']
                        commands += [f'rename {case["name"]} {tag}',f'write_json {tag}.json',f'write_rtlil {tag}.il']
                        if case['simulate']:commands += [f'write_verilog -noexpr -noattr {tag}.v']
                        commands += ['stat']
                        (temp/(tag+'.ys')).write_text('\n'.join(commands)+'\n',encoding='ascii')
                        env=os.environ.copy();prefix=prefixes[role]
                        env['PATH']=prefix+';'+suite_ascii+'/bin;'+suite_ascii+'/lib;'+env.get('PATH','')
                        env['YOSYS_DATDIR']=prefix+'/share';env['TCL_LIBRARY']=(prefix+'/tcl8.6').replace('/','\\')
                        env['ABC']=suite_ascii+'/bin/yosys-abc.exe';env['YOSYSHQ_ROOT']=suite_ascii+'/'
                        record,log=execute([prefix+'/yosys.exe','-Q','-s',tag+'.ys'],temp,env,folder/tag,args.单次超时)
                        row[role]=record
                        for ext in ['ys','il','json']+(['v'] if case['simulate'] else []):shutil.copy2(temp/(tag+'.'+ext),folder/(tag+'.'+ext))
                        model=json.loads((temp/(tag+'.json')).read_text(encoding='utf-8'))['modules'][tag];models[tag]=model
                    gold,gate=models['gold'],models['gate']
                    if gold['ports']!=gate['ports']:raise RuntimeError('Port mapping changed: '+case['name'])
                    gold_cells,gate_cells=gold['cells'],gate['cells']
                    if case['expect_unchanged'] and gold_cells!=gate_cells:raise RuntimeError('Protected/nonmatching structure changed: '+case['name'])
                    required=max(case['min_removed_with_default'],case['min_removed_with_b'] if args.包括B臂 else 0)
                    removed=sorted(set(gold_cells)-set(gate_cells))
                    if len(removed)<required:raise RuntimeError('Expected multi-level rewrite did not fire: '+case['name']+' '+repr(removed))
                    row.update(structure_check='PASS',cells_before=len(gold_cells),cells_after=len(gate_cells),
                               required_min_removed=required,removed_names=removed,
                               model_sha256={tag:sha(folder/(tag+'.v')) for tag in ['gold','gate']} if case['simulate'] else {})
                    if case['simulate']:
                        (temp/'test.v').write_text(testbench(case),encoding='ascii');shutil.copy2(temp/'test.v',folder/'test.v')
                        env=os.environ.copy();env['PATH']=suite_ascii+'/bin;'+suite_ascii+'/lib;'+env.get('PATH','')
                        execute([suite_ascii+'/bin/iverilog.exe','-g2012','-s','tb','-o','sim.vvp','simlib.v','gold.v','gate.v','test.v'],temp,env,folder/'compile',args.单次超时)
                        sim,log=execute([suite_ascii+'/bin/vvp.exe','sim.vvp'],temp,env,folder/'simulation',args.单次超时)
                        match=re.search(r'RESULT vectors=(\d+) bits=(\d+) known=(\d+) x=(\d+) z=(\d+) errors=(\d+)',log)
                        if not match:raise RuntimeError('Missing real simulation result')
                        values=dict(zip(['vectors','bits','known_bits','x_bits','z_bits','errors'],map(int,match.groups())))
                        outputs=[p for p in case['ports'] if p['direction']=='output']
                        if values['vectors']!=case['samples']*len(outputs) or values['bits']!=case['samples']*sum(p['width'] for p in outputs) or values['errors'] or not values['known_bits']:
                            raise RuntimeError('Simulation count/error/coverage mismatch')
                        row['simulation']=values
                    else:
                        row['scale_record_scope']='standalone read/check/one custom pass/export, no synth_intel/ABC; not official nine-case timing'
                rows.append(row);save(out/'逐例结果.json',rows)
                print(case['name'],'PASS',flush=True)
        for role,path in bins.items():
            if sha(path/'yosys.exe')!=identity['programs'][role]['sha256']:raise RuntimeError('Program changed during regression')
        summary=dict(status='SUPPLEMENTAL_REGRESSION_PASS',cases=len(rows),simulation_cases=sum('simulation' in r for r in rows),
                     vectors=sum(r.get('simulation',{}).get('vectors',0) for r in rows),
                     bits=sum(r.get('simulation',{}).get('bits',0) for r in rows),errors=0,
                     identity_sha256=sha(out/'运行身份.json'),scope='finite supplemental structural regression; not official EQY, area, efficiency or certification')
        save(out/'结果汇总.json',summary);print(json.dumps(summary,ensure_ascii=False))
    except BaseException as error:
        save(out/'失败.json',dict(status='FAILED',error=repr(error),completed_cases=len(rows)))
        raise
    finally:ctypes.windll.kernel32.SetErrorMode(old_mode)


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--输出目录',type=Path,default=HERE.parent.parent/'复验输出/扩展结构回归001')
    p.add_argument('--运行',action='store_true',help='Starts actual EDA tools; schedule outside official performance windows')
    p.add_argument('--原版程序',type=Path);p.add_argument('--候选程序',type=Path);p.add_argument('--官方套件',type=Path)
    p.add_argument('--包括B臂',action='store_true');p.add_argument('--单次超时',type=int,default=180)
    a=p.parse_args();out=a.输出目录.resolve()
    run(a,out) if a.运行 else prepare(out)
