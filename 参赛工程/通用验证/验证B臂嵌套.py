"""Actual -flatten-data-arm implementation, guards and official four-state model."""
from pathlib import Path
import argparse,hashlib,json,os,shutil,subprocess,tempfile
from datetime import datetime,timezone
ROOT=Path(__file__).resolve().parents[1];SUITE=ROOT/'官方工具/oss-cad-suite'
MODEL_RECORD=ROOT/'通用验证/B臂模型模板'
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def write(p,t):p.write_text(t,encoding='utf-8')
def save(p,x):write(p,json.dumps(x,ensure_ascii=False,indent=2))
def pmux(name,w,n,a,b,s,y,attr=''):
    return (f'  attribute \\{attr} 1\n' if attr else '')+f'''  cell $pmux \\{name}
    parameter \\WIDTH {w}
    parameter \\S_WIDTH {n}
    connect \\A {a}
    connect \\B {b}
    connect \\S {s}
    connect \\Y {y}
  end
'''
def module(c,tag,mode=''):
    w=c['width'];ki=c['ki'];ko=c['ko'];arm=c['arm'];name=c['name']+'_'+tag
    text=f'''module \\{name}
  wire width {w} input 1 \\ao
  wire width {w} input 2 \\ai
  wire width {ki*w} input 3 \\bi
  wire width {ko*w} input 4 \\bo
  wire width {ki} input 5 \\si
  wire width {ko} input 6 \\so
  wire width {w} output 7 \\y
  wire width {w}{' output 8' if mode=='top_output' else ''} \\t
'''
    data=[]
    for j in range(ko):
        sig='\\t' if j==arm else f'\\bo [{(j+1)*w-1}:{j*w}]'
        if j==arm:
            if mode=='partial':sig=f'{{ \\t [{w-1}:1] \\ai [0] }}'
            if mode=='reordered':sig='{ '+' '.join(f'\\t [{b}]' for b in range(w))+' }'
            if mode=='self_loop':sig='\\y'
        data.append(sig)
    text+=pmux('inner',w,ki,'\\ai','\\bi','\\si','\\t',
                'pmux_opt_data_gate' if mode=='marked_inner' else '')
    text+=pmux('outer',w,ko,'\\ao','{ '+' '.join(reversed(data))+' }','\\so','\\y',
                'pmux_opt_control_gate' if mode=='marked_outer' else '')
    if mode=='ambiguous':text+=pmux('second_driver',w,ki,'\\ai','\\bi','\\si','\\t')
    if mode=='unknown_consumer':text+='  cell \\unknown_user_cell \\consumer\n    connect \\P \\t\n  end\n'
    if mode=='fanout':
        text+=f'''  wire width {w} \\extra
  cell $not \\consumer
    parameter \\A_SIGNED 0
    parameter \\A_WIDTH {w}
    parameter \\Y_WIDTH {w}
    connect \\A \\t
    connect \\Y \\extra
  end
'''
    return text+'end\n'

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--program',type=Path,required=True)
    ap.add_argument('--name',default='B臂嵌套_实际C++验证');args=ap.parse_args()
    out=ROOT.parent/'复验输出/通用验证'/args.name
    if out.exists():raise RuntimeError('Preserve existing evidence')
    out.mkdir(parents=True);program=args.program.resolve()
    plan=json.loads((MODEL_RECORD/'实验计划.json').read_text(encoding='utf-8'));cases=plan['cases']
    env=os.environ.copy();env['PATH']=str(program.parent)+';'+str(SUITE/'bin')+';'+str(SUITE/'lib')+';'+env.get('PATH','')
    env['ABC']=str(program.parent/'yosys-abc.exe');env['YOSYS_DATDIR']=str(program.parent/'share')
    manifest={'started_utc':datetime.now(timezone.utc).isoformat(),'program':str(program),'program_sha256':sha(program),
        'source_sha256':sha(ROOT/'开发源码/passes/opt/pmux_opt.cc'),'model_sha256':sha(SUITE/'share/yosys/simlib.v'),
        'script_sha256':sha(Path(__file__)),'scope':'actual optional C++ rule; finite official four-state simulation, not EQY or performance',
        'positive_checks':[],'guard_checks':[],'all_passed':False}
    save(out/'验证汇总.json',manifest)
    def run(cmd,label,cwd):
        p=subprocess.run([str(x) for x in cmd],cwd=cwd,env=env,capture_output=True,timeout=120)
        text=(p.stdout+p.stderr).decode('utf-8',errors='replace');write(out/(label+'.log'),text)
        save(out/(label+'.command.json'),{'argv':[str(x) for x in cmd],'exit_code':p.returncode})
        assert p.returncode==0,(label,p.returncode,text[-2500:]);return text
    with tempfile.TemporaryDirectory(prefix='pmux-data-arm-') as td:
        tmp=Path(td)
        for tag in ['ref','cand']:
            write(tmp/(tag+'.il'),'autoidx 1\n'+''.join(module(c,tag) for c in cases))
            commands=[f'read_rtlil {tag}.il']
            if tag=='cand':commands+=['pmux_opt -flatten-data-arm','write_json once.json',
                                      'pmux_opt -flatten-fallback -flatten-data-arm']
            commands+=['check',f'write_json {tag}.json',f'write_verilog -noattr -noexpr {tag}.v']
            write(tmp/(tag+'.ys'),'\n'.join(commands)+'\n')
            text=run([program if tag=='cand' else SUITE/'bin/yosys.exe','-Q','-s',tag+'.ys'],tag,tmp)
            if tag=='cand':
                assert 'merged 18 single-use nested data arms' in text,text
                assert 'merged 0 single-use nested data arms' in text,text
            for ext in ['.il','.ys','.json','.v']:shutil.copy2(tmp/(tag+ext),out/(tag+ext))
        cand=json.loads((tmp/'cand.json').read_text());once=json.loads((tmp/'once.json').read_text())
        assert cand==once,'Repeated fallback/data pass changed generated control gates'
        for c in cases:
            cells=cand['modules'][c['name']+'_cand']['cells'];eligible=c['width']>c['ki']+1
            gates=[v for v in cells.values() if v.get('attributes',{}).get('pmux_opt_data_gate')=='00000000000000000000000000000001']
            if eligible:
                assert len(gates)==2 and len(cells)==3,c['name']
                outer=cells['outer'];assert int(outer['parameters']['S_WIDTH'],2)==c['ki']+c['ko']
                assert all(g['type']=='$pmux' for g in gates)
                assert sorted((int(g['parameters']['WIDTH'],2),int(g['parameters']['S_WIDTH'],2)) for g in gates)==[(1,c['ki']),(c['ki']+1,1)]
                manifest['positive_checks'].append({'case':c['name'],'width':c['width'],'inner_arms':c['ki'],'outer_arms':c['ko'],'arm':c['arm'],'passed':True})
            else:
                assert not gates and len(cells)==2,c['name']
                manifest['guard_checks'].append({'case':c['name'],'reason':'width cost guard','passed':True})
        manifest['guard_checks'].append({'case':'repeat_with_fallback_and_data','reason':'all helper PMUX gates preserved; exact JSON stable','passed':True})
        guards=[]
        for mode in ['fanout','top_output','partial','reordered','inner_unselected','outer_unselected',
                     'ambiguous','self_loop','unknown_consumer','marked_inner','marked_outer','width_limit','arm_limit']:
            c={'name':'reject_'+mode,'width':4,'ki':2,'ko':2,'arm':0,'mode':mode}
            if mode=='width_limit':c['width']=3
            if mode=='arm_limit':c.update(width=10,ki=8,ko=9)
            guards.append(c)
        write(tmp/'guards.il','autoidx 1\n'+''.join(module(c,'guard',c['mode']) for c in guards))
        selection=[c['name']+'_guard' for c in guards if c['mode'] not in ['inner_unselected','outer_unselected']]
        selection+=['reject_inner_unselected_guard/c:outer','reject_outer_unselected_guard/c:inner']
        write(tmp/'guards.ys','read_rtlil guards.il\nwrite_json before.json\nselect '+' '.join(selection)+
              '\npmux_opt -flatten-data-arm\nselect *\nwrite_json after.json\n')
        text=run([program,'-Q','-s','guards.ys'],'guards',tmp)
        assert 'merged 0 single-use nested data arms' in text
        before=json.loads((tmp/'before.json').read_text());after=json.loads((tmp/'after.json').read_text())
        assert before==after,'Rejected guard fixture changed'
        for c in guards:manifest['guard_checks'].append({'case':c['name'],'reason':c['mode'],'passed':True})
        for n in ['guards.il','guards.ys','before.json','after.json','once.json']:shutil.copy2(tmp/n,out/n)
        write(tmp/'off.ys','read_rtlil ref.il\npmux_opt -order-decode -flatten-fallback -uniform-abc\nwrite_json off.json\n')
        run([program,'-Q','-s','off.ys'],'default_off',tmp)
        off=json.loads((tmp/'off.json').read_text())['modules']
        assert all(len(m['cells'])==2 and all('pmux_opt_data_gate' not in c.get('attributes',{}) for c in m['cells'].values()) for m in off.values())
        manifest['guard_checks'].append({'case':'manual_command_default_off','passed':True})
        shutil.copy2(tmp/'off.json',out/'off.json')
        wrappers=''
        for c in cases:
            name=c['name'];ki=c['ki'];ko=c['ko'];w=c['width']
            wrappers+=f'''module {name}(input [{w-1}:0]ao,ai,input [{ki*w-1}:0]bi,input [{ko*w-1}:0]bo,
input [{ki-1}:0]si,input [{ko-1}:0]so,output [{w-1}:0]reference_y,candidate_y);
{name}_ref r(.ao(ao),.ai(ai),.bi(bi),.bo(bo),.si(si),.so(so),.y(reference_y));
{name}_cand c(.ao(ao),.ai(ai),.bi(bi),.bo(bo),.si(si),.so(so),.y(candidate_y));
endmodule
'''
        original_bench=(MODEL_RECORD/'模型与测试台.v').read_text(encoding='ascii')
        bench='`timescale 1ns/1ps\n'+wrappers+original_bench[original_bench.index('module tb;'):]
        write(tmp/'tb.sv',bench);shutil.copy2(tmp/'tb.sv',out/'tb.sv');shutil.copy2(SUITE/'share/yosys/simlib.v',tmp/'simlib.v')
        run([SUITE/'bin/iverilog.exe','-g2012','-s','tb','-o','sim.vvp','ref.v','cand.v','simlib.v','tb.sv'],'iverilog',tmp)
        text=run([SUITE/'bin/vvp.exe','sim.vvp'],'four_state_simulation',tmp)
        assert f"RESULT samples={plan['expected_comparisons']} errors=0" in text,text
    assert sha(program)==manifest['program_sha256']
    manifest.update(all_passed=True,finished_utc=datetime.now(timezone.utc).isoformat(),
                    four_state_comparisons=plan['expected_comparisons'],converted_positive_cases=18,
                    guard_count=len(manifest['guard_checks']))
    save(out/'验证汇总.json',manifest)
    print('PASS comparisons='+str(manifest['four_state_comparisons'])+' guards='+str(manifest['guard_count']),flush=True)
if __name__=='__main__':main()
