"""Reproducible official ff_map round-trip and post-ABC sequential smoke proofs."""
from pathlib import Path
import copy, importlib.util, json, shutil
from datetime import datetime
ROOT=Path(__file__).resolve().parent
def load(name,file):
    spec=importlib.util.spec_from_file_location(name,ROOT/file)
    module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module);return module
prep=load('prepare','生成正式验证输入.py');runner=load('runner','官方等价验证入口.py')

def main():
    run_root=ROOT/('适配烟测_'+datetime.now().strftime('%Y%m%d_%H%M%S'))
    run_root.mkdir()
    evidence=run_root/'触发器往返自检'
    if evidence.exists():raise RuntimeError('Do not overwrite existing evidence')
    evidence.mkdir()
    with prep.tool_paths.ascii_temporary_directory(prefix='eqy-ff-') as stage,prep.official_environment() as (drive,env):
        try:
            (stage/'top.v').write_text('''module top(input clk, rst_n, en, d0, d1, output reg q0, q1);
initial begin q0=1'b0; q1=1'b1; end
always @(posedge clk or negedge rst_n)
  if (!rst_n) begin q0<=0; q1<=0; end
  else if (en) begin q0<=d0; q1<=d1; end
endmodule
''',encoding='utf-8')
            prep.yosys(drive,env,stage,'''read_verilog top.v
hierarchy -check -top top
proc
opt
techmap
opt
dfflegalize -cell $_DFFE_PN0P_ 01
write_rtlil original.il
read_verilog -lib +/intel/cycloneiv/cells_sim.v
techmap -map +/intel/common/ff_map.v
write_json mapped.json
write_rtlil mapped.il
''','official_map')
            raw=json.loads((stage/'mapped.json').read_text(encoding='utf-8'))
            report=prep.ff_inverse.normalize(stage/'mapped.json',stage/'restored.json','top',stage/'adapter.json')
            assert report['converted_ff_count']==2
            assert sorted(c['power_up'] for c in report['changes'])==['high','low']
            prep.yosys(drive,env,stage,'read_json restored.json\nwrite_rtlil restored.il\n','restored')
            invalid=copy.deepcopy(raw)
            ff=next(c for c in invalid['modules']['top']['cells'].values() if c['type']=='dffeas')
            ff['connections']['prn']=['0']
            (stage/'unsupported.json').write_text(json.dumps(invalid),encoding='utf-8')
            try:prep.ff_inverse.normalize(stage/'unsupported.json',stage/'should_not_exist.json','top')
            except ValueError as error:
                (stage/'fail_closed.txt').write_text('REJECTED as required: '+str(error),encoding='utf-8')
            else:raise AssertionError('Invalid primitive was accepted')
            shutil.copy2(stage/'original.il',stage/'gold.il');shutil.copy2(stage/'restored.il',stage/'gate.il')
            (stage/'proof.eqy').write_text(prep.proof_config('top',['clk','rst_n','en','d0','d1','q0','q1']),encoding='utf-8')
        finally:shutil.copytree(stage,evidence,dirs_exist_ok=True)
    info,log=runner.run_eqy(evidence,run_root/'触发器往返证明',timeout=120)
    print(log)
    if info['exit_code']:raise RuntimeError('Roundtrip proof failed')

    sby_inputs=run_root/'官方SBY烟测输入';sby_inputs.mkdir()
    for name in ['gold.il','gate.il']:shutil.copy2(evidence/name,sby_inputs/name)
    config=(evidence/'proof.eqy').read_text(encoding='utf-8')
    config=config.replace('[strategy sat]\nuse sat\ndepth 20','[strategy smtbmc]\nuse sby\nengine smtbmc z3\ndepth 20\ntimeout 60')
    (sby_inputs/'proof.eqy').write_text(config,encoding='utf-8')
    info,log=runner.run_eqy(sby_inputs,run_root/'官方SBY烟测证明',timeout=120)
    print(log)
    if info['exit_code']:raise RuntimeError('Official SBY smoke failed')

    evidence=run_root/'官方第二例ABC后烟测网表'
    if evidence.exists():raise RuntimeError('Do not overwrite existing evidence')
    evidence.mkdir()
    with prep.tool_paths.ascii_temporary_directory(prefix='eqy-postabc-') as stage,prep.official_environment() as (drive,env):
        try:
            shutil.copy2(ROOT.parent/'官方测试用例/zip_case02.v',stage/'input.v')
            prep.yosys(drive,env,stage,'''read_verilog input.v
synth_intel -family cycloneiv -top pmux_case02_pipeline -run begin:map_cells
write_rtlil postabc.il
write_json postabc.json
''','postabc')
        finally:shutil.copytree(stage,evidence,dirs_exist_ok=True)
    prepared=run_root/'官方第二例ABC后烟测输入'
    prep.prepare(evidence/'postabc.il',evidence/'postabc.il','pmux_case02_pipeline',prepared)
    info,log=runner.run_eqy(prepared,run_root/'官方第二例ABC后烟测证明',timeout=180)
    print(log)
    if info['exit_code']:raise RuntimeError('Post-ABC sequential smoke failed')

if __name__=='__main__':main()
