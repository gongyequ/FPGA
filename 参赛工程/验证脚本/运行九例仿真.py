"""0.69 project simulation regression; real tools, never copied historical scores.

Compare unchanged official RTL, original 0.69 build, and optimized 0.69 build.
This ends before Intel FF mapping/ABC9 and does not replace post-ABC EQY.
"""
from pathlib import Path
import argparse, csv, ctypes, hashlib, json, os, random, re, shutil, subprocess, tempfile, time
from datetime import datetime, timezone

ROOT = Path(__file__).resolve().parents[1]
SEEDS = [101, 202, 303, 404, 505]

def sha(path): return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def write(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(value, encoding='utf-8')
def jwrite(path, value): write(path, json.dumps(value, ensure_ascii=False, indent=2))
def csvout(path, rows):
    if not rows: return
    with path.open('w', encoding='utf-8-sig', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=list(rows[0]))
        writer.writeheader(); writer.writerows(rows)

def stimuli(case, inputs, cycles, seed):
    rng = random.Random(seed); widths = dict(inputs)
    vectors = []
    for k in range(cycles):
        values = {name:rng.getrandbits(width) for name,width in inputs}
        # These are testbench reset/control stimuli, not optimization rules.
        # Official source, parameters, port names, and top modules are unchanged.
        if case.startswith('zip'):
            values['rst'] = int(k < 3 or k % 113 == 0)
            values['en'] = 0 if 3 <= k < 8 or k % 17 == 0 else 1
            if k < 264:
                word = (k // 4) % 256
                values['ctrl_in'] = sum(((word | (word << 8)) << (16*j)) for j in range(widths['ctrl_in']//16))
        elif case == 'rar_test1':
            values['reset'] = int(k < 3 or k % 113 == 0)
            values['valid'] = int(k % 23 != 0)
        elif case == 'rar_test2':
            for j,name in enumerate(['a','b','c','d']):
                if k < 64: values[name] = ((k % 16) >> j) & 1
        elif case == 'rar_test3':
            # The official serial circuit has no reset. Load opcode AA to
            # initialize GPIO through its public interface, not force/deposit.
            if k < 8: values.update(cs=0, sr_in=(0xAA >> (7-k)) & 1)
            elif k == 8: values['cs'] = 1
        elif case == 'rar_test4':
            values['reset_n'] = int(k >= 3 and k % 113 != 0)
            values['ena'] = int(k >= 4 and k % 17 != 0)
            if k < 128: values['datain'] = k % 32
        packed = 0
        for name,width in inputs:
            assert 0 <= values[name] < 2**width, (case,name,width,values[name])
            packed = (packed << width) | values[name]
        vectors.append(f'{packed:0{(sum(widths.values())+3)//4}x}')
    return '\n'.join(vectors)+'\n'

def testbench(top, inputs, outputs, clock, cycles, seed, dump):
    data_inputs = [(name,width) for name,width in inputs if name != clock]
    nbits = sum(width for _,width in data_inputs); obits = sum(width for _,width in outputs)
    declarations = [f'reg [{width-1}:0] {name};' for name,width in inputs]
    for tag in ['rtl','original','optimized']:
        declarations += [f'wire [{width-1}:0] {name}_{tag};' for name,width in outputs]
    instances = []
    for tag,module in [('rtl',top),('original',top+'_original'),('optimized',top+'_optimized')]:
        connections = [f'.{name}({name})' for name,_ in inputs]
        connections += [f'.{name}({name}_{tag})' for name,_ in outputs]
        instances.append(f'{module} dut_{tag}('+','.join(connections)+');')
    def flat(tag): return '{'+','.join(name+'_'+tag for name,_ in outputs)+'}'
    template = '''`timescale 1ns/1ps
module tb;
@DECL@
@INST@
reg [@NBITS@-1:0] vectors[0:@CYCLES@-1];
wire [@OBITS@-1:0] rv=@RV@, bv=@BV@, cv=@CV@;
integer k,bit_index,errors_bc=0,errors_rtl_b=0,errors_rtl_c=0;
integer unknown_rtl=0,unknown_base=0,unknown_candidate=0,checked_bits=0,samples=0;
task check_outputs;
begin
 samples=samples+1;
 for(bit_index=0;bit_index<@OBITS@;bit_index=bit_index+1) begin
  // Original versus optimized is strict four-state case inequality.
  if(bv[bit_index] !== cv[bit_index]) begin
   errors_bc=errors_bc+1;
   if(errors_bc<6)$display("MISMATCH_BASE_CAND cycle=%0d bit=%0d base=%b cand=%b",k,bit_index,bv[bit_index],cv[bit_index]);
  end
  if(bv[bit_index]!==1'b0 && bv[bit_index]!==1'b1)unknown_base=unknown_base+1;
  if(cv[bit_index]!==1'b0 && cv[bit_index]!==1'b1)unknown_candidate=unknown_candidate+1;
  // Synthesis may resolve unspecified RTL outputs. Those positions are counted
  // and explicitly excluded ONLY from RTL-versus-netlist comparison.
  if(rv[bit_index]===1'b0 || rv[bit_index]===1'b1) begin
   checked_bits=checked_bits+1;
   if(rv[bit_index] !== bv[bit_index]) begin
    errors_rtl_b=errors_rtl_b+1;
    if(errors_rtl_b<6)$display("MISMATCH_RTL_BASE cycle=%0d bit=%0d rtl=%b base=%b",k,bit_index,rv[bit_index],bv[bit_index]);
   end
   if(rv[bit_index] !== cv[bit_index]) begin
    errors_rtl_c=errors_rtl_c+1;
    if(errors_rtl_c<6)$display("MISMATCH_RTL_CAND cycle=%0d bit=%0d rtl=%b cand=%b",k,bit_index,rv[bit_index],cv[bit_index]);
   end
  end else unknown_rtl=unknown_rtl+1;
 end
end
endtask
initial begin
 $readmemh("seed-@SEED@.hex", vectors);
 @CLOCK@=0;
 @DUMP@
 for(k=0;k<@CYCLES@;k=k+1) begin
  {@INPUTS@}=vectors[k];
  #2; @CLOCK@=1; #2;
  check_outputs;
  @CLOCK@=0; #1;
  @DUMP_STOP@
 end
 $display("RESULT samples=%0d checked_bits=%0d unknown_rtl=%0d unknown_base=%0d unknown_candidate=%0d base_candidate_errors=%0d rtl_base_errors=%0d rtl_candidate_errors=%0d",samples,checked_bits,unknown_rtl,unknown_base,unknown_candidate,errors_bc,errors_rtl_b,errors_rtl_c);
 if(errors_bc || errors_rtl_b || errors_rtl_c)$fatal(1,"SIMULATION_FAIL");
 $display("SIMULATION_PASS");$finish;
end
endmodule
'''
    replace = dict(DECL='\n'.join(declarations), INST='\n'.join(instances), NBITS=nbits, OBITS=obits,
        CYCLES=cycles, SEED=seed, RV=flat('rtl'), BV=flat('original'), CV=flat('optimized'), CLOCK=clock,
        INPUTS=','.join(name for name,_ in data_inputs),
        DUMP='$dumpfile("sample-first80.vcd");$dumpvars(0,tb);' if dump else '',
        DUMP_STOP='if(k==79)$dumpoff;' if dump else '')
    for key,value in replace.items(): template = template.replace('@'+key+'@',str(value))
    assert not re.search(r'@[A-Z_]+@',template)
    return template

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--name',default='九例三方仿真_'+datetime.now().strftime('%Y%m%d_%H%M%S'))
    parser.add_argument('--cycles',type=int,default=1000)
    args = parser.parse_args()
    if args.cycles < 1 or Path(args.name).name != args.name or args.name in ['.','..']:
        raise ValueError('Invalid cycle count or output folder name')
    if os.name != 'nt': raise RuntimeError('This runner uses the Windows 0.69 workspace')
    output = ROOT/'实测记录'/args.name
    if output.exists(): raise RuntimeError('Existing evidence is preserved; use a new --name')
    output.mkdir(parents=True)
    ctypes.windll.kernel32.SetErrorMode(0x8003)
    drive = None
    for letter in ['P:','Q:','R:']:
        if not Path(letter+'/').exists():
            subprocess.run(['subst',letter,str(ROOT)],capture_output=True,check=True)
            drive = letter; break
    if drive is None: raise RuntimeError('No free ASCII drive for upstream Windows tools')
    suite = drive+'/suite'
    executables = {name:drive+'/'+name+'/yosys.exe' for name in ['original','optimized']}
    env = os.environ.copy(); env['PATH'] = suite+'/bin;'+suite+'/lib;'+env.get('PATH','')
    env['YOSYS_DATDIR'] = suite+'/share/yosys'; env['TCL_LIBRARY'] = suite+'/lib/tcl8.6'
    env['YOSYSHQ_ROOT'] = suite
    # Package-local aliases only; this does not modify the selected synthesis flow.
    import importlib.util
    spec=importlib.util.spec_from_file_location('simulation_launcher',ROOT/'验证脚本/配置与启动.py')
    launcher=importlib.util.module_from_spec(spec);spec.loader.exec_module(launcher)
    for alias,relative in {'suite':'官方工具/oss-cad-suite','original':'原版程序','optimized':'优化程序'}.items():
        launcher.ensure_junction(ROOT/alias,ROOT/relative)
    cases = json.loads((ROOT/'官方测试用例/用例来源.json').read_text(encoding='utf-8'))
    def run(command, cwd, logfile, timeout=60):
        started = datetime.now(timezone.utc).isoformat(); start = time.perf_counter()
        try:
            p = subprocess.run(command,cwd=cwd,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=timeout)
            code,data = p.returncode,p.stdout
        except subprocess.TimeoutExpired as e: code,data = 124,(e.stdout or b'')+b'\nTIMEOUT\n'
        elapsed = time.perf_counter()-start
        text = data.decode('utf-8',errors='replace'); write(logfile,text)
        jwrite(logfile.with_suffix('.command.json'),dict(command=command,cwd=str(cwd),started_utc=started,
            exit_code=code,wall_seconds=elapsed,timing_is_simulation_diagnostic_only=True))
        return code,text,elapsed
    rows = []
    manifest = dict(started_utc=datetime.now(timezone.utc).isoformat(),seeds=SEEDS,cycles_per_seed=args.cycles,
        expected_cases=9,expected_records=45,baseline='0.69 original build in 原版程序; optimized build in 优化程序',
        simulation_boundary='synth_intel -family cycloneiv -run begin:map_ffs; BEFORE Intel FF mapping and ABC9',
        equivalence_boundary_warning='This is random simulation of generic pre-FF gates, not official post-ABC EQY.',
        rtl_unknown_policy='When RTL is X/Z, skip that bit only for RTL-vs-netlist; count every skipped bit. Original-vs-optimized always uses strict four-state !==.',
        input_policy='Binary randomized stimulus plus reset/control sweeps, five fixed seeds; no X/Z input injection in this regression.',
        limitations=['Finite simulation does not prove all states or all inputs.',
                     'Unknown RTL positions are not validated against netlists; counts are reported, never called full four-state RTL equivalence.',
                     'Recorded simulation process durations are not synthesis efficiency, FPGA Fmax, or hardware speedup.',
                     'Official rar_test2 has an incomplete sensitivity list; source is preserved verbatim.'],
        area_measured=False,competition_efficiency_measured=False,official_EQY_run=False,source_modified=False,versions={},sha256={})
    try:
        assert len(cases)==9,'Expected the official four RAR and five ZIP cases'
        for name,path in executables.items():
            assert Path(path).is_file(),path
            code,text,_ = run([path,'-V'],drive+'/',output/('version-'+name+'.log')); assert code==0,text
            assert re.search(r'\bYosys 0\.69(?:\D|$)',text),text
            manifest['versions'][name]=text.strip();manifest['sha256'][name+'_yosys']=sha(path)
        for name in ['iverilog','vvp']:
            code,text,_=run([suite+'/bin/'+name+'.exe','-V'],drive+'/',output/('version-'+name+'.log'));assert code==0,text
            manifest['versions'][name]=text.splitlines()[0];manifest['sha256'][name]=sha(suite+'/bin/'+name+'.exe')
        manifest['sha256']['official_simcells']=sha(suite+'/share/yosys/simcells.v')
        manifest['sha256']['runner']=sha(__file__)
        manifest['sha256']['candidate_pass_source']=sha(ROOT/'开发源码/passes/opt/pmux_opt.cc')
        manifest['cases']=cases
        for case in cases:
            path=ROOT/'官方测试用例'/case['file'];actual=sha(path)
            assert actual==case['sha256'],('official source changed',case['case'])
            manifest['sha256'][case['file']]=actual
        jwrite(output/'manifest.json',manifest)
        with tempfile.TemporaryDirectory(prefix='pmux-sim069-') as work:
            for case in cases:
                name,top=case['case'],case['top'];dest=output/name;dest.mkdir()
                temp=Path(work)/name;temp.mkdir()
                shutil.copy2(ROOT/'官方测试用例'/case['file'],temp/'input.v')
                shutil.copy2(suite+'/share/yosys/simcells.v',temp/'simcells.v')
                try:
                    for variant,exe in executables.items():
                        script=[f'read_verilog -sv input.v',f'hierarchy -check -top {top}',
                            f'synth_intel -family cycloneiv -top {top} -run begin:map_ffs',
                            f'write_json {variant}-generic.json',f'rename {top} {top}_{variant}',
                            f'write_verilog -noattr {variant}-generic.v']
                        write(temp/(variant+'.ys'),'\n'.join(script)+'\n')
                        code,text,_=run([exe,'-Q','-s',variant+'.ys'],temp,dest/(variant+'.log'));assert code==0,(name,variant,text[-1500:])
                    ports=json.loads((temp/'original-generic.json').read_text())['modules'][top]['ports']
                    assert all(p['direction'] in ['input','output'] for p in ports.values()),'Inout is not supported by this testbench'
                    inputs=[(n,len(p['bits'])) for n,p in ports.items() if p['direction']=='input']
                    outputs=[(n,len(p['bits'])) for n,p in ports.items() if p['direction']=='output']
                    clock='clock' if 'clock' in dict(inputs) else 'clk'
                    assert dict(inputs).get(clock)==1 and outputs,(name,'unsupported clock/output shape')
                    data_inputs=[(n,w) for n,w in inputs if n!=clock]
                    for seed in SEEDS:
                        write(temp/f'seed-{seed}.hex',stimuli(name,data_inputs,args.cycles,seed))
                        write(temp/f'tb-{seed}.sv',testbench(top,inputs,outputs,clock,args.cycles,seed,seed==SEEDS[0]))
                        compile_command=[suite+'/bin/iverilog.exe','-g2012','-s','tb','-o',f'sim-{seed}.vvp',
                            'input.v','original-generic.v','optimized-generic.v','simcells.v',f'tb-{seed}.sv']
                        code,text,_=run(compile_command,temp,dest/f'compile-{seed}.log');assert code==0,(name,seed,text[-1500:])
                        code,text,elapsed=run([suite+'/bin/vvp.exe',f'sim-{seed}.vvp'],temp,dest/f'sim-{seed}.log')
                        fields=['samples','checked_bits','unknown_rtl','unknown_base','unknown_candidate',
                                'base_candidate_errors','rtl_base_errors','rtl_candidate_errors']
                        values={k:int(v) for k,v in re.findall(r'(samples|checked_bits|unknown_rtl|unknown_base|unknown_candidate|base_candidate_errors|rtl_base_errors|rtl_candidate_errors)=(\d+)',text)}
                        passed=code==0 and 'SIMULATION_PASS' in text and values.get('samples')==args.cycles and len(values)==8
                        rows.append(dict(case=name,seed=seed,cycles=args.cycles,exit_code=code,passed=passed,
                            simulation_seconds=round(elapsed,6),**{key:values.get(key,0) for key in fields}))
                        print(f'{name} seed={seed} PASS={passed} {values}',flush=True)
                        jwrite(output/'仿真记录.json',rows);csvout(output/'仿真记录.csv',rows)
                finally:
                    # Preserve all inputs, generated netlists, scripts, waveforms,
                    # and binaries even when a real tool reports a failure.
                    for artifact in temp.iterdir():
                        if artifact.is_file():shutil.copy2(artifact,dest/artifact.name)
        summary=[]
        for case in cases:
            records=[r for r in rows if r['case']==case['case']]
            summary.append(dict(case=case['case'],records=len(records),passed_records=sum(r['passed'] for r in records),
                sampled_cycles=sum(r.get('samples',0) for r in records),
                known_rtl_bits_checked=sum(r.get('checked_bits',0) for r in records),
                unknown_rtl_bits_excluded=sum(r.get('unknown_rtl',0) for r in records),
                original_optimized_errors=sum(r.get('base_candidate_errors',0) for r in records),
                rtl_original_errors=sum(r.get('rtl_base_errors',0) for r in records),
                rtl_optimized_errors=sum(r.get('rtl_candidate_errors',0) for r in records)))
        jwrite(output/'仿真汇总.json',summary);csvout(output/'仿真汇总.csv',summary)
        for variant,path in executables.items():
            assert sha(path)==manifest['sha256'][variant+'_yosys'],('executable changed during regression',variant)
        manifest['finished_utc']=datetime.now(timezone.utc).isoformat()
        manifest['actual_records']=len(rows);manifest['all_passed']=len(rows)==45 and all(r['passed'] for r in rows)
        jwrite(output/'manifest.json',manifest)
        write(output/'阅读说明.txt','这是0.69九个官方用例的真实随机仿真记录。\n'
            '每例5个固定种子，每种子默认1000周期；原RTL、原版网表、优化网表同时接受相同刺激。\n'
            '综合边界在Intel寄存器映射和ABC9之前，因此此记录不验证统一ABC脚本，不替代正式ABC后EQY。\n'
            '原版与优化网表逐位严格比较0/1/X/Z。原RTL输出为X/Z的位只计数，不参加RTL对网表比较。\n'
            '请查看仿真汇总中的unknown_rtl_bits_excluded，不能把跳过的未知位宣称为已验证。\n'
            '所有工具日志、返回码、网表、测试台、随机向量及首80周期VCD均保留。\n'
            '这里的耗时仅是仿真进程诊断时间，不是赛事综合效率或硬件速度；没有复制旧0.70成绩。\n')
        print('DONE '+str(output),flush=True)
        if not manifest['all_passed']:raise SystemExit(1)
    finally:
        subprocess.run(['subst',drive,'/d'],capture_output=True)

if __name__=='__main__':main()
