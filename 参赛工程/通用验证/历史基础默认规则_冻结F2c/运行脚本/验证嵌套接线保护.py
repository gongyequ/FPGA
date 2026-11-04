"""Actual-pass regression for connectivity guards; requires a compiled candidate."""
from pathlib import Path
import argparse, ctypes, json, os, shutil, subprocess, tempfile
from 验证嵌套规则 import ROOT, SUITE, pmux, write

def two(name, width, ni, no, kind='normal'):
    iw=8 if kind=='partial' else width
    text=f'''module \\{name}
  wire width {iw} input 1 \\a
  wire width {iw*ni} input 2 \\bi
  wire width {width*no} input 3 \\bo
  wire width {ni} input 4 \\si
  wire width {no} input 5 \\so
  wire width {width} output 6 \\y
  wire width {iw} \\inner
'''
    if kind=='fanout':text+=f'  wire width {iw} output 7 \\tap\n  connect \\tap \\inner\n'
    if kind=='gate':text+='  attribute \\pmux_opt_control_gate 1\n'
    text+=pmux('inner_p','\\a','\\bi','\\si','\\inner',iw,ni)
    oa='\\inner'; ob='\\bo'
    if kind=='partial':oa='\\inner [3:0]'
    if kind=='permuted':oa='{ \\inner [0] \\inner [1] \\inner [2] \\inner [3] }'
    if kind=='second_consumer':ob='{ \\bo [7:4] \\inner }'
    text+=pmux('outer_p',oa,ob,'\\so','\\y',width,no)
    return text+'end\n'

def chain():
    text='''module \\positive_chain
  wire width 4 input 1 \\a
  wire width 12 input 2 \\b
  wire width 3 input 3 \\s
  wire width 4 output 4 \\y
  wire width 4 \\t0
  wire width 4 \\t1
'''
    for i,(a,y) in enumerate([('\\a','\\t0'),('\\t0','\\t1'),('\\t1','\\y')]):
        text+=pmux(f'p{i}',a,f'\\b [{4*i+3}:{4*i}]',f'\\s [{i}]',y,4,1)
    return text+'end\n'

def active(attr):
    if isinstance(attr,int):return attr!=0
    try:return int(attr,2)!=0
    except ValueError:return False

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--candidate-yosys',type=Path,required=True)
    ap.add_argument('--output',default='嵌套接线保护实际Pass验证');args=ap.parse_args()
    out=ROOT/args.output
    if out.exists():raise SystemExit('Preserve existing output')
    out.mkdir();ctypes.windll.kernel32.SetErrorMode(0x0001|0x0002|0x8000)
    env=os.environ.copy();env['PATH']=str(SUITE/'bin')+';'+str(SUITE/'lib')+';'+env.get('PATH','')
    negative=[('protected_fanout',4,2,2,'fanout'),('protected_partial',4,2,2,'partial'),
              ('protected_permuted',4,2,2,'permuted'),('protected_second_consumer',4,2,2,'second_consumer'),
              ('protected_cost',2,2,1,'normal'),('protected_branch_limit',10,8,9,'normal'),
              ('protected_gate',4,2,2,'gate')]
    text='autoidx 1\n'+''.join(two(*x) for x in negative)+two('positive',4,2,2)+chain()+two('protected_selection',4,2,2)
    expected={x[0]:0 for x in negative};expected.update(positive=1,positive_chain=2,protected_selection=0)
    with tempfile.TemporaryDirectory(prefix='pmux-nested-guard-') as td:
        temp=Path(td);write(temp/'input.il',text)
        modules=' '.join([x[0] for x in negative]+['positive','positive_chain'])
        write(temp/'run.ys',f'read_rtlil input.il\npmux_opt -flatten-fallback {modules}\npmux_opt -flatten-fallback protected_selection/outer_p\nselect *\ncheck\nwrite_json output.json\n')
        p=subprocess.run([str(args.candidate_yosys),'-Q','-s','run.ys'],cwd=temp,env=env,capture_output=True,timeout=60)
        log=(p.stdout+p.stderr).decode('utf-8',errors='replace');write(out/'run.log',log)
        for filename in ['input.il','run.ys']:shutil.copy2(temp/filename,out/filename)
        assert p.returncode==0,log
        shutil.copy2(temp/'output.json',out/'output.json')
        result=json.loads((temp/'output.json').read_text(encoding='utf-8'));checks=[]
        for name,merges in expected.items():
            cells=result['modules'][name]['cells'];original_gate=1 if name=='protected_gate' else 0
            gates=sum(active(c.get('attributes',{}).get('pmux_opt_control_gate','0')) for c in cells.values())
            assert gates==merges+original_gate,(name,'wrong number of generated controls',gates,merges)
            if merges==0:assert 'inner_p' in cells and 'outer_p' in cells,(name,'protected pair altered')
            if name=='positive_chain':
                assert any(c['type']=='$pmux' and int(c['parameters']['S_WIDTH'],2)==3 for c in cells.values()),cells
            checks.append(dict(module=name,expected_merges=merges,generated_controls=gates-original_gate,passed=True))
        write(out/'summary.json',json.dumps(dict(actual_pass_executed=True,candidate_binary=str(args.candidate_yosys),checks=checks,passed=True),ensure_ascii=False,indent=2))
        print(f'PASS actual C++ connectivity guards: {len(checks)} modules')
if __name__=='__main__':main()
