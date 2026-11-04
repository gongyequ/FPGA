"""Actual compiled ordering rule: signed/shortened/swapped/duplicate decoders."""
from pathlib import Path
import argparse,ctypes,itertools,json,os,random,shutil,subprocess,tempfile
from 公共辅助 import ROOT,SUITE,make_module,write
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--candidate-yosys',type=Path,required=True)
    ap.add_argument('--desc',action='store_true');ap.add_argument('--output',default='分支排序实际Pass验证')
    args=ap.parse_args();out=ROOT/args.output
    if out.exists():raise SystemExit('Preserve existing evidence')
    out.mkdir();ctypes.windll.kernel32.SetErrorMode(0x8003)
    env=os.environ.copy();env['PATH']=str(SUITE/'bin')+';'+str(SUITE/'lib')+';'+env.get('PATH','')
    tables=[(2,list(c)) for count in [3,4] for c in itertools.combinations(range(4),count)]
    tables += [(3,list(c)) for c in itertools.combinations(range(8),7)]+[(2,[2,1,1,0])]
    rng=random.Random(6913);cases=[]
    for n,codes in tables:
        for mode in ['unsigned','unsigned-swapped','signed','signed-swapped']:
            shuffled=codes.copy();rng.shuffle(shuffled);cases.append((n,shuffled,mode))
    with tempfile.TemporaryDirectory(prefix='pmux-order-') as td:
        tmp=Path(td)
        for tag in ['ref','cand']:
            write(tmp/(tag+'.il'),'autoidx 1\n'+''.join(make_module(f'c{i}_{tag}',n,c,mode) for i,(n,c,mode) in enumerate(cases)))
            commands=[f'read_rtlil {tag}.il']
            if tag=='cand':commands+=['pmux_opt -order-decode'+(' -desc-order' if args.desc else '')]
            commands+=['check',f'write_verilog -noattr -noexpr {tag}.v',f'write_json {tag}.json']
            write(tmp/(tag+'.ys'),'\n'.join(commands)+'\n')
            exe=args.candidate_yosys if tag=='cand' else SUITE/'bin/yosys.exe'
            p=subprocess.run([str(exe),'-Q','-s',tag+'.ys'],cwd=tmp,env=env,capture_output=True,timeout=60)
            txt=(p.stdout+p.stderr).decode('utf-8',errors='replace');write(out/(tag+'.log'),txt);assert p.returncode==0,txt
            for ext in ['.il','.ys','.v','.json']:shutil.copy2(tmp/(tag+ext),out/(tag+ext))
        mods=json.loads((tmp/'cand.json').read_text())['modules'];checks=[];changed=0
        for i,(n,codes,mode) in enumerate(cases):
            m=mods[f'c{i}_cand'];cell=m['cells']['p'];conn=cell['connections']
            order=sorted(range(len(codes)),key=lambda k:codes[k],reverse=args.desc)
            changed+=order!=list(range(len(codes)))
            expected_s=[m['netnames']['decoded']['bits'][j] for j in order]
            expected_b=[bit for j in order for bit in m['ports']['b']['bits'][4*j:4*j+4]]
            assert cell['type']=='$pmux' and conn['A']==m['ports']['a']['bits'],(i,'A/type changed')
            assert conn['S']==expected_s and conn['B']==expected_b,(i,codes,order,conn)
            assert int(cell['parameters']['S_WIDTH'],2)==len(codes),(i,'arm lost')
            checks.append(dict(case=i,source_codes=codes,order=order,ordered_codes=[codes[j] for j in order]))
        assert changed>0,'no-op regression'
        write(out/'structure_checks.json',json.dumps(checks,indent=2))
        tb='''`timescale 1ns/1ps
module tb;
reg [2:0]ctrl;reg [3:0]a;reg [31:0]b;
integer errors=0,samples=0;
''';checks=[]
        for i,(n,codes,mode) in enumerate(cases):
            tb+=f'wire [3:0]r{i},c{i};c{i}_ref r_{i}(ctrl[{n-1}:0],a,b[{len(codes)*4-1}:0],r{i});c{i}_cand c_{i}(ctrl[{n-1}:0],a,b[{len(codes)*4-1}:0],c{i});\n'
            checks.append(f'if(r{i} !== c{i})begin errors=errors+1;if(errors<8)$display("DIFF case={i} ctrl=%b a=%b b=%b",ctrl,a,b);end')
        tb+='task check;begin\n'+'\n'.join(checks)+f'\nsamples=samples+{len(cases)};end endtask\ninitial begin\n'
        for pattern in itertools.product('01xz',repeat=3):
            for mode in range(16):
                aval=['0000','1111','xxxx','zzzz','x01z'][mode] if mode<5 else f'{rng.randrange(16):04b}'
                bval=['0'*32,'1'*32,'x'*32,'z'*32][mode] if mode<4 else f'{rng.getrandbits(32):032b}'
                tb+=f"ctrl=3'b{''.join(pattern)};a=4'b{aval};b=32'b{bval};#1;check;\n"
        tb+='$display("RESULT samples=%0d errors=%0d",samples,errors);if(errors)$fatal(1,"FAIL");$display("PASS");$finish;end\nendmodule\n'
        write(tmp/'tb.sv',tb);shutil.copy2(tmp/'tb.sv',out/'tb.sv');shutil.copy2(SUITE/'share/yosys/simlib.v',tmp/'simlib.v')
        for cmd,log in [([str(SUITE/'bin/iverilog.exe'),'-g2012','-s','tb','-o','sim.vvp','ref.v','cand.v','simlib.v','tb.sv'],'compile.log'),([str(SUITE/'bin/vvp.exe'),'sim.vvp'],'simulation.log')]:
            p=subprocess.run(cmd,cwd=tmp,env=env,capture_output=True,timeout=60);txt=(p.stdout+p.stderr).decode('utf-8',errors='replace');write(out/log,txt);assert p.returncode==0,txt
        write(out/'summary.json',json.dumps(dict(cases=len(cases),changed_cases=changed,comparisons=len(cases)*64*16,
            actual_pass_executed=True,descending=args.desc,exit_code=p.returncode,stable_duplicates_checked=True),ensure_ascii=False,indent=2));print(txt)
if __name__=='__main__':main()
