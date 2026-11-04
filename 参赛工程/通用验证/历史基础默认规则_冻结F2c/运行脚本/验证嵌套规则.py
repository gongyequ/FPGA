"""Verify the nested-fallback relation against the official four-state cell model.
Without --candidate-yosys this tests a direct relation template, not compiled pass code.
With that flag it instead runs the real pmux_opt -flatten-fallback implementation.
"""
from pathlib import Path
import argparse, ctypes, json, os, shutil, subprocess, tempfile

from 公共辅助 import ROOT,SUITE
def write(p,text):p.write_text(text,encoding='utf-8')
def pmux(name,a,b,s,y,width,sw):
    return f'''  cell $pmux \\{name}
    parameter \\WIDTH {width}
    parameter \\S_WIDTH {sw}
    connect \\A {a}
    connect \\B {b}
    connect \\S {s}
    connect \\Y {y}
  end
'''
def module(i,ni,no,tag):
    text=f'''module \\case{i}_{tag}
  wire width 4 input 1 \\a
  wire width {4*ni} input 2 \\bi
  wire width {4*no} input 3 \\bo
  wire width {ni} input 4 \\si
  wire width {no} input 5 \\so
  wire width 4 output 6 \\y
'''
    if tag=='ref':
        text+='  wire width 4 \\inner\n'
        text+=pmux('inner_p','\\a','\\bi','\\si','\\inner',4,ni)
        text+=pmux('outer_p','\\inner','\\bo','\\so','\\y',4,no)
    else:
        text+=f'  wire width {ni} \\gated\n'
        text+=pmux('control_gate','\\si',f"{ni*no}'"+'0'*(ni*no),'\\so','\\gated',ni,no)
        text+=pmux('combined','\\a','{ \\bo \\bi }','{ \\so \\gated }','\\y',4,ni+no)
    return text+'end\n'
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--candidate-yosys',type=Path);ap.add_argument('--output',default='嵌套规则四态模板验证')
    args=ap.parse_args();out=ROOT/args.output
    if out.exists():raise SystemExit('Preserve existing output')
    out.mkdir();ctypes.windll.kernel32.SetErrorMode(0x0001|0x0002|0x8000)
    env=os.environ.copy();env['PATH']=str(SUITE/'bin')+';'+str(SUITE/'lib')+';'+env.get('PATH','')
    cases=[(ni,no) for ni in range(1,4) for no in range(1,4)]
    with tempfile.TemporaryDirectory(prefix='pmux-nested-') as td:
        temp=Path(td)
        for tag in ['ref','cand']:
            source_tag='ref' if args.candidate_yosys else tag
            write(temp/(tag+'.il'),'autoidx 1\n'+''.join(module(i,ni,no,source_tag) for i,(ni,no) in enumerate(cases)))
            commands=[f'read_rtlil {tag}.il']
            if args.candidate_yosys and tag=='cand':
                commands+=['pmux_opt -flatten-fallback']+[f'rename case{i}_ref case{i}_cand' for i in range(9)]
            commands+=['check',f'write_verilog -noexpr -noattr {tag}.v',f'write_json {tag}.json']
            write(temp/(tag+'.ys'),'\n'.join(commands)+'\n')
            exe=args.candidate_yosys if tag=='cand' and args.candidate_yosys else SUITE/'bin/yosys.exe'
            p=subprocess.run([str(exe),'-Q','-s',tag+'.ys'],cwd=temp,env=env,capture_output=True,timeout=60)
            txt=(p.stdout+p.stderr).decode('utf-8',errors='replace');write(out/(tag+'.log'),txt);assert p.returncode==0,txt
            for ext in ['.il','.ys','.v','.json']:shutil.copy2(temp/(tag+ext),out/(tag+ext))
        # A no-op implementation is not an acceptable successful regression.
        if args.candidate_yosys:
            netlist=json.loads((temp/'cand.json').read_text(encoding='utf-8'))
            checks=[]
            for i,(ni,no) in enumerate(cases):
                cells=netlist['modules'][f'case{i}_cand']['cells']
                gates=[c for c in cells.values() if c.get('attributes',{}).get('pmux_opt_control_gate')=='00000000000000000000000000000001']
                assert len(gates)==1,(i,'expected exactly one generated control PMUX',cells)
                data=[c for c in cells.values() if c['type']=='$pmux' and c not in gates]
                assert len(data)==1,(i,'expected one merged data PMUX',cells)
                assert int(data[0]['parameters']['S_WIDTH'],2)==ni+no,(i,'incorrect combined width')
                checks.append(dict(case=i,control_pmuxes=len(gates),combined_branches=ni+no))
            write(out/'structure_checks.json',json.dumps(checks,ensure_ascii=False,indent=2))
        bench='''`timescale 1ns/1ps
module tb;
reg [3:0] a; reg [11:0] bi,bo; reg [2:0] si,so;
integer control_pattern, data_pattern, bit_index, code, seed=6913, samples=0, errors=0;
function fourstate;
 input integer x;
 begin case(x) 0:fourstate=0;1:fourstate=1;2:fourstate=1'bx;3:fourstate=1'bz;endcase end
endfunction
'''
        checks=[]
        for i,(ni,no) in enumerate(cases):
            bench+=f'wire [3:0] r{i},c{i};case{i}_ref dr{i}(a,bi[{4*ni-1}:0],bo[{4*no-1}:0],si[{ni-1}:0],so[{no-1}:0],r{i});case{i}_cand dc{i}(a,bi[{4*ni-1}:0],bo[{4*no-1}:0],si[{ni-1}:0],so[{no-1}:0],c{i});\n'
            checks.append(f'if(r{i} !== c{i}) begin errors=errors+1;if(errors<12)$display("DIFF case={i} si=%b so=%b ref=%b cand=%b",si,so,r{i},c{i});end')
        bench+='''initial begin
for(control_pattern=0;control_pattern<4096;control_pattern=control_pattern+1) begin
 code=control_pattern;
 for(bit_index=0;bit_index<3;bit_index=bit_index+1) begin si[bit_index]=fourstate(code%4);code=code/4;end
 for(bit_index=0;bit_index<3;bit_index=bit_index+1) begin so[bit_index]=fourstate(code%4);code=code/4;end
 for(data_pattern=0;data_pattern<16;data_pattern=data_pattern+1) begin
  case(data_pattern)
   0:begin a=0;bi=0;bo=0;end
   1:begin a='1;bi='1;bo='1;end
   2:begin a='x;bi='x;bo='x;end
   3:begin a='z;bi='z;bo='z;end
   4:begin a=4'bx01z;bi=12'bz001x010zzxx;bo=12'b0000xxxxzzzz;end
   default:begin a=$random(seed);bi=$random(seed);bo=$random(seed);end
  endcase
  #1;
'''+ '\n'.join(checks)+'''
  samples=samples+9;
 end
end
$display("RESULT samples=%0d errors=%0d",samples,errors);
if(errors)$fatal(1,"FAIL");$display("PASS");$finish;
end
endmodule
'''
        write(temp/'tb.sv',bench);shutil.copy2(temp/'tb.sv',out/'tb.sv');shutil.copy2(SUITE/'share/yosys/simlib.v',temp/'simlib.v')
        p=subprocess.run([str(SUITE/'bin/iverilog.exe'),'-g2012','-s','tb','-o','sim.vvp','ref.v','cand.v','simlib.v','tb.sv'],cwd=temp,env=env,capture_output=True,timeout=60)
        txt=(p.stdout+p.stderr).decode('utf-8',errors='replace');write(out/'compile.log',txt);assert p.returncode==0,txt
        p=subprocess.run([str(SUITE/'bin/vvp.exe'),'sim.vvp'],cwd=temp,env=env,capture_output=True,timeout=60)
        txt=(p.stdout+p.stderr).decode('utf-8',errors='replace');write(out/'simulation.log',txt)
        write(out/'summary.json',json.dumps(dict(cases=cases,comparisons=9*4096*16,exit_code=p.returncode,
            actual_pass_executed=bool(args.candidate_yosys),candidate_binary=str(args.candidate_yosys) if args.candidate_yosys else None,
            model=str(SUITE/'share/yosys/simlib.v'),scope='finite four-state structural regression, not official EQY'),ensure_ascii=False,indent=2))
        print(txt);raise SystemExit(p.returncode)
if __name__=='__main__':main()
