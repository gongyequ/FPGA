"""真实工具录屏辅助。只输出实际结果，不改参赛源码或提交RAR。"""
from pathlib import Path
from contextlib import ExitStack
from datetime import datetime
import argparse,ctypes,hashlib,importlib.util,json,os,re,shutil,subprocess,sys
sys.dont_write_bytecode=True
if hasattr(sys.stdout,'reconfigure'):sys.stdout.reconfigure(encoding='utf-8')
HERE=Path(__file__).resolve().parent
TOP='pmux_case04_feedback'
CALL='pmux_opt -order-decode -flatten-fallback -uniform-abc -flatten-data-arm'
EXPECTED={'original':'b8a51e5bd03e12384a39b47d2f0b3f185722a076cff6f94d0bc5aca70f5954a4','optimized':'a603b6e7b900fa3ca8410b25d37c6b4aa26c12f22e6bd9f3dba0958e6d389b53'}

def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):return json.loads(Path(p).read_text(encoding='utf-8-sig'))
def save(p,x):Path(p).write_text(json.dumps(x,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
def load(name,p):
    spec=importlib.util.spec_from_file_location(name,p);m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m);return m
def newdir(kind):
    d=HERE/'运行记录'/(datetime.now().strftime('%Y%m%d_%H%M%S_%f')+'_'+kind);d.mkdir(parents=True);return d
def check():
    for role,folder in [('original','原版程序'),('optimized','优化程序')]:
        if sha(PACK/folder/'yosys.exe')!=EXPECTED[role]:raise RuntimeError('提交程序身份不符：'+role)
    return common.official_cases(PACK/'官方测试用例')
def copy_input(d):
    src=PACK/'官方测试用例/zip_case04.v';shutil.copy2(src,d/'zip_case04.v')
    if sha(src)!=sha(d/'zip_case04.v'):raise RuntimeError('输入副本校验失败')

def yosys(role,d,script,label):
    program=PACK/('原版程序' if role=='original' else '优化程序')
    prior=ctypes.windll.kernel32.SetErrorMode(0x8003)
    try:
        with ExitStack() as stack:
            pp=stack.enter_context(loc.ascii_directory(program,force=True)).rstrip('/')
            wd=stack.enter_context(loc.ascii_directory(d,force=True)).rstrip('/')
            env=os.environ.copy();env.update(TCL_LIBRARY=pp+'/tcl8.6',YOSYS_DATDIR=pp+'/share',ABC=pp+'/yosys-abc.exe',PYTHONDONTWRITEBYTECODE='1')
            env['PATH']=pp+';'+env.get('PATH','')
            args=[pp+'/yosys.exe','-Q','-T','-c',wd+'/'+script]
            result=subprocess.run(args,cwd=wd+'/',env=env,capture_output=True,timeout=120,creationflags=subprocess.CREATE_NO_WINDOW)
            data=result.stdout+result.stderr;(d/(label+'.log')).write_bytes(data)
            save(d/(label+'_执行.json'),{'argv':args,'returncode':result.returncode,'exe_sha256':sha(program/'yosys.exe'),'tcl_sha256':sha(d/script)})
            if result.returncode:raise RuntimeError(f'真实Yosys失败，见 {d/(label+".log")}')
            return data.decode('utf-8','replace').replace('\r\n','\n').replace('\r','')
    finally:ctypes.windll.kernel32.SetErrorMode(prior)

def command_demo():
    d=newdir('Tcl命令');copy_input(d)
    # This is a labelled command demonstration, not a replacement area flow.
    # These are the official pre-pass statements up to the integration location.
    prep='''yosys -import
read_verilog -sv zip_case04.v
hierarchy -check -top pmux_case04_feedback
synth_intel -family cycloneiv -top pmux_case04_feedback -run begin:coarse
yosys proc
flatten
tribuf -logic
deminout
opt_expr
check
opt_clean
opt -nodffe -nosdff
fsm
opt
wreduce
peepopt
opt_clean
write_rtlil pre_pmux.il
'''
    (d/'prepare.tcl').write_text(prep,encoding='ascii')
    yosys('original',d,'prepare.tcl','前处理')
    shutil.copy2(HERE/'command_demo.tcl',d/'command_demo.tcl')
    print('实际执行的Tcl脚本：\n',flush=True)
    print((d/'command_demo.tcl').read_text(encoding='ascii'),flush=True)
    log=yosys('optimized',d,'command_demo.tcl','自定义命令')
    print('以下为真实Yosys日志中的规则计数：')
    lines=[s for s in log.splitlines() if 'PMUX' in s or 'pmux_opt' in s]
    if not any('PMUX structural optimization:' in s for s in lines):raise RuntimeError('没有真实自研pass执行记录')
    print('\n'.join(lines));print('\n这是规则调用演示；面积对比使用下一步未额外插入命令的正式流程。')
    print('完整Tcl、改写前后IL和原始日志：',d)

def area_demo():
    d=newdir('面积对比');copy_input(d);rows={}
    for role in ['original','optimized']:
        script=f'''yosys -import
read_verilog -sv zip_case04.v
hierarchy -check -top {TOP}
synth_intel -family cycloneiv -top {TOP} -run begin:map_cells
stat
write_rtlil {role}.il
write_json {role}.json
'''
        (d/(role+'.tcl')).write_text(script,encoding='ascii')
        print('正在运行真实'+('原版' if role=='original' else '优化版')+'综合……',flush=True)
        log=yosys(role,d,role+'.tcl',role)
        rows[role]=common.parse_area(d/(role+'.json'),TOP)
        rows[role]['raw_il_sha256']=sha(d/(role+'.il'));rows[role]['raw_json_sha256']=sha(d/(role+'.json'))
        print('真实stat节选：')
        block=re.search(r'=== '+re.escape(TOP)+r' ===\r?\n(.*?)(?=\n\d+\.|\Z)',log,re.S)
        if block is None:raise RuntimeError('真实日志没有最终stat统计段')
        print('=== '+TOP+' ===\n'+block.group(1).strip())
    b,c=rows['original'],rows['optimized']
    if b['dff']!=c['dff'] or b['ports']!=c['ports']:raise RuntimeError('DFF或端口变化')
    result={'case':'zip_case04','top':TOP,'input_sha256':sha(d/'zip_case04.v'),'programs':EXPECTED,'rows':rows,'reduction_percent':(b['logic_area']-c['logic_area'])/b['logic_area']*100}
    save(d/'本次面积结果.json',result);save(HERE/'最近面积运行.json',{'directory':str(d)})
    print('\n用例 zip_case04 / '+TOP)
    print(f"逻辑资源 LUT+NOT：{b['logic_area']} -> {c['logic_area']}，下降 {result['reduction_percent']:.4f}%")
    print(f"触发器：{b['dff']} -> {c['dff']}；顶层IO位数：{b['io_bits']} -> {c['io_bits']}")
    print('面积观察点：ABC后、最终器件单元映射前；不是含触发器的所有单元总数。')
    print('本次真实网表与完整日志：',d)

def eqy_demo():
    marker=HERE/'最近面积运行.json'
    if not marker.is_file():raise RuntimeError('请先运行“对比”，生成本次两份真实网表。')
    area=Path(read(marker)['directory']);data=read(area/'本次面积结果.json')
    if data['programs']!=EXPECTED:raise RuntimeError('网表程序身份不同')
    if sha(area/'zip_case04.v')!=data['input_sha256']:raise RuntimeError('输入变化')
    for role in ['original','optimized']:
        for ext,key in [('il','raw_il_sha256'),('json','raw_json_sha256')]:
            if sha(area/(role+'.'+ext))!=data['rows'][role][key]:raise RuntimeError('网表文件变化')
    d=newdir('EQY验证')
    prep=load('video_prep',PACK/'等价验证/生成正式验证输入.py')
    audit=load('video_audit',PACK/'等价验证/核验适配边界.py')
    runner=load('video_eqy',PACK/'等价验证/官方等价验证入口.py')
    print('对刚才实际生成的两份ABC后网表运行官方EQY……',flush=True)
    inputs=prep.prepare(area/'original.il',area/'optimized.il',TOP,d/'验证输入')
    save(d/'适配边界.json',audit.audit(d/'验证输入'))
    execution,log=runner.run_eqy(d/'验证输入',d/'官方EQY结果',timeout=300)
    passed=common.real_eqy_pass(execution,log,d/'官方EQY结果')
    save(d/'本次EQY结果.json',{'case':'zip_case04','area_directory':str(area),'inputs':inputs,'execution':execution,'pass':passed,'scope':'ABC后两网表；受限dffeas逆适配；opt_clean与setundef -zero -init后SAT归纳'})
    print('\n以下为官方EQY本次真实日志末尾：\n')
    print('\n'.join(log.splitlines()[-13:]))
    if not passed:raise RuntimeError('本次EQY没有通过，不能展示为PASS')
    print('\n证明范围：按技术文档披露的触发器适配和初值/X归一化策略，优化前后功能等价。')
    print('不是两份网表文本逐字一致，也不是未经归一化的全四态形式证明。')
    print('真实proof/PASS及完整日志：',d/'官方EQY结果/proof')

def nine_demo():
    folder=PACK/'实测记录/B臂集成F4c_面积等价_01'
    report=read(folder/'报告.json')
    print('九例正式验收记录汇总（已有完整验收证据，不冒充本次重跑九例）\n')
    print(f"{'用例':<16}{'原版':>7}{'优化版':>8}{'下降比例':>12}    EQY")
    for r in report['area']['cases']:
        p=folder/'eqy'/r['case']/'官方EQY结果/proof'
        log=(p/'logfile.txt').read_text(encoding='utf-8',errors='replace')
        if not (p/'PASS').is_file() or 'DONE (PASS, rc=0)' not in log:raise RuntimeError('已有证明证据缺失')
        print(f"{r['case']:<18}{r['original']:>5}{r['optimized']:>8}{r['reduction_percent']:>11.2f}%    PASS")
    print(f"\n逐例平均下降 {report['area']['mean_reduction_percent']:.4f}%")
    print(f"总资源 {report['area']['original_total']} -> {report['area']['optimized_total']}，总量下降 {report['area']['total_reduction_percent']:.4f}%")
    print('九例LUT不反增；DFF及IO不变；真实EQY 9/9 PASS。')
    print('证据目录：',folder)

def main():
    global PACK,common,loc
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('阶段',choices=['命令','对比','等价','九例'])
    p.add_argument('--代码目录',type=Path,default=HERE.parent/'零点六九新版正式提交_20261104/代码包内容')
    a=p.parse_args();PACK=a.代码目录.resolve(strict=True)
    if os.name!='nt':raise RuntimeError('演示程序面向Windows x64')
    os.environ['PYTHONDONTWRITEBYTECODE']='1'
    os.environ['PMUX_OSS_CAD_SUITE']=str(PACK/'官方工具/oss-cad-suite')
    os.environ['PMUX_EQY_MAKE']=str(PACK/'等价验证/官方依赖/make-4.4.1/WinRel/gnumake.exe')
    common=load('video_common',PACK/'验证脚本/复测公共.py')
    loc=load('video_locations',PACK/'等价验证/工具定位.py')
    check()
    {'命令':command_demo,'对比':area_demo,'等价':eqy_demo,'九例':nine_demo}[a.阶段]()
    check()
if __name__=='__main__':
    try:main()
    except Exception as e:print('演示停止：'+str(e),file=sys.stderr);raise SystemExit(1)
