"""Actual-pass four-state regressions for zero select arms and column sharing."""
from pathlib import Path
import argparse,ctypes,json,os,shutil,subprocess,tempfile
from 公共辅助 import ROOT,SUITE,write,pmux
def module(name,tag):
    width=4 if name=='columns' else 2
    t=f'''module \\{name}_{tag}
  wire width 2 input 1 \\a
  wire width 2 input 2 \\b
  wire width 2 input 3 \\c
  wire width 2 input 4 \\s
  wire width {width} output 5 \\y
'''
    patterns={
        'zero_mid':('\\a','{ \\c \\a \\b }',"{ \\s [1] 1'0 \\s [0] }",2,3),
        'zero_one':('\\a','{ \\c \\b }',"{ 1'0 \\s [0] }",2,2),
        'zero_all':('\\a','{ \\c \\b }',"2'00",2,2),
        'same_default':('\\a','{ \\b \\a }','\\s',2,2),
        'columns':('{ \\a \\a }','{ \\c \\c \\b \\b }','\\s',4,2)}
    a,b,s,w,sw=patterns[name]
    return t+pmux(a,b,s,'\\y',w,sw)+'end\n'
def wide(tag):
    data='{ \\a [0] \\a [256] \\a }'
    return f'''module \\wide_{tag}
  wire width 257 input 1 \\a
  wire input 2 \\s
  wire width 259 output 3 \\y
'''+pmux(data,data,'\\s','\\y',259,1)+'end\n'
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--candidate-yosys',type=Path,required=True)
    ap.add_argument('--output',default='低分配版_基础清理实际验证');args=ap.parse_args();out=ROOT/args.output
    if out.exists():raise SystemExit('Preserve existing evidence')
    out.mkdir();ctypes.windll.kernel32.SetErrorMode(0x8003)
    env=os.environ.copy();env['PATH']=str(SUITE/'bin')+';'+str(SUITE/'lib')+';'+env.get('PATH','')
    cases=['zero_mid','zero_one','zero_all','same_default','columns']
    with tempfile.TemporaryDirectory(prefix='pmux-base-') as td:
        tmp=Path(td)
        for tag in ['ref','cand']:
            write(tmp/(tag+'.il'),'autoidx 1\n'+''.join(module(n,tag) for n in cases)+wide(tag))
            commands=[f'read_rtlil {tag}.il']+(['pmux_opt'] if tag=='cand' else [])+['check',f'write_verilog -noattr -noexpr {tag}.v',f'write_json {tag}.json']
            write(tmp/(tag+'.ys'),'\n'.join(commands)+'\n')
            exe=args.candidate_yosys if tag=='cand' else SUITE/'bin/yosys.exe'
            p=subprocess.run([str(exe),'-Q','-s',tag+'.ys'],cwd=tmp,env=env,capture_output=True,timeout=60)
            text=(p.stdout+p.stderr).decode('utf-8',errors='replace');write(out/(tag+'.log'),text);assert p.returncode==0,text
            for ext in ['.il','.ys','.v','.json']:shutil.copy2(tmp/(tag+ext),out/(tag+ext))
        mods=json.loads((tmp/'cand.json').read_text())['modules']
        assert not mods['zero_all_cand']['cells']
        for name,sw,width in [('zero_mid',2,2),('zero_one',1,2),('same_default',2,2),('columns',2,2),('wide',1,258)]:
            cell=mods[name+'_cand']['cells']['p']
            assert cell['type']=='$pmux' and int(cell['parameters']['S_WIDTH'],2)==sw and int(cell['parameters']['WIDTH'],2)==width,(name,cell)
        wports=mods['wide_cand']['ports']['y']['bits']
        assert wports[258]==wports[0] and wports[257]!=wports[256],'representative cap behavior changed'
        tb='''`timescale 1ns/1ps
module tb;
reg [1:0]a,b,c,s;reg [256:0]wa;reg ws;
integer pattern,code,i,phase,errors=0,samples=0,seed=6913;
function fourstate;input integer x;begin case(x)0:fourstate=0;1:fourstate=1;2:fourstate=1'bx;3:fourstate=1'bz;endcase end endfunction
'''
        checks=[]
        for i,name in enumerate(cases):
            width=4 if name=='columns' else 2
            tb+=f'wire [{width-1}:0]r{i},c{i};{name}_ref r_{i}(a,b,c,s,r{i});{name}_cand c_{i}(a,b,c,s,c{i});\n'
            checks.append(f'if(r{i} !== c{i})begin errors=errors+1;if(errors<8)$display("DIFF {name} a=%b b=%b c=%b s=%b r=%b c=%b",a,b,c,s,r{i},c{i});end')
        tb+='''wire [258:0]wr,wc;wide_ref wide_r(wa,ws,wr);wide_cand wide_c(wa,ws,wc);
initial begin wa=0;ws=0;
 for(pattern=0;pattern<65536;pattern=pattern+1)begin
  code=pattern;
  for(i=0;i<2;i=i+1)begin a[i]=fourstate(code%4);code=code/4;end
  for(i=0;i<2;i=i+1)begin b[i]=fourstate(code%4);code=code/4;end
  for(i=0;i<2;i=i+1)begin c[i]=fourstate(code%4);code=code/4;end
  for(i=0;i<2;i=i+1)begin s[i]=fourstate(code%4);code=code/4;end
  #1;
'''+ '\n'.join(checks)+'''
  samples=samples+5;
 end
 for(pattern=0;pattern<16;pattern=pattern+1)begin
  if(pattern<4)wa={257{fourstate(pattern)}};
  else for(i=0;i<257;i=i+1)wa[i]=$random(seed);
  for(phase=0;phase<4;phase=phase+1)begin ws=fourstate(phase);#1;
   if(wr !== wc)begin errors=errors+1;$display("WIDE_DIFF");end
   samples=samples+1;
  end
 end
 $display("RESULT samples=%0d errors=%0d",samples,errors);
 if(errors)$fatal(1,"FAIL");$display("PASS");$finish;
end
endmodule
'''
        write(tmp/'tb.sv',tb);shutil.copy2(tmp/'tb.sv',out/'tb.sv');shutil.copy2(SUITE/'share/yosys/simlib.v',tmp/'simlib.v')
        for command,log in [([str(SUITE/'bin/iverilog.exe'),'-g2012','-s','tb','-o','sim.vvp','ref.v','cand.v','simlib.v','tb.sv'],'compile.log'),([str(SUITE/'bin/vvp.exe'),'sim.vvp'],'simulation.log')]:
            p=subprocess.run(command,cwd=tmp,env=env,capture_output=True,timeout=120);text=(p.stdout+p.stderr).decode('utf-8',errors='replace');write(out/log,text);assert p.returncode==0,text
        write(out/'summary.json',json.dumps(dict(comparisons=327744,exit_code=p.returncode,actual_pass_executed=True,candidate_binary=str(args.candidate_yosys),structure_guards_passed=True),ensure_ascii=False,indent=2));print(text)
if __name__=='__main__':main()
