"""Bind final default-rule supplementary evidence to the exact frozen release."""
from pathlib import Path
import argparse,hashlib,json,subprocess,sys
from datetime import datetime,timezone
from 公共辅助 import ROOT,PROJECT,SUITE

EXPECTED_EXE_SHA256='e899292b851f8e8e3d1a1a9f04e7737fec6b7eaaa8afaef73c79436010ac4c41'
def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def save(path,value):path.write_text(json.dumps(value,ensure_ascii=False,indent=2),encoding='utf-8')
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--program',type=Path,default=PROJECT/'优化程序/yosys.exe')
    ap.add_argument('--name',default='执行记录');args=ap.parse_args()
    if Path(args.name).name!=args.name or args.name in ['.','..']:raise ValueError('Invalid output name')
    out=ROOT/args.name
    if out.exists():raise RuntimeError('Existing evidence is preserved; pass a new --name')
    program=args.program.resolve();assert sha(program)==EXPECTED_EXE_SHA256,'Program does not match frozen release'
    out.mkdir();scriptdir=Path(__file__).resolve().parent
    source_files={'pmux_opt':PROJECT/'开发源码/passes/opt/pmux_opt.cc',
                  'synth_intel':PROJECT/'开发源码/techlibs/intel/synth_intel.cc'}
    files={'optimized_program':program,'official_reference_program':SUITE/'bin/yosys.exe',
           'official_simlib':SUITE/'share/yosys/simlib.v','iverilog':SUITE/'bin/iverilog.exe',
           'vvp':SUITE/'bin/vvp.exe',**source_files}
    hashes={key:sha(path) for key,path in files.items()}
    manifest={'started_utc':datetime.now(timezone.utc).isoformat(),'candidate_program':str(program),
        'sha256':hashes,'expected_frozen_exe_sha256':EXPECTED_EXE_SHA256,
        'test_script_sha256':{p.name:sha(p) for p in scriptdir.glob('*.py')},
        'default_rules':['zero-select cleanup','identical-column sharing','nested fallback merge','ascending decoder order'],
        'not_exercised':['optional shiftx','optional predicate constants','optional constant polarity'],
        'boundary':'actual default structural rules against official 0.69 four-state model; separate from post-ABC EQY and performance measurements',
        'results':[],'all_passed':False}
    save(out/'冻结证据汇总.json',manifest)
    tasks=[('01_零选择与相同列','验证基础清理.py',327744),
           ('02_嵌套默认分支','验证嵌套规则.py',589824),
           ('03_译码分支升序','验证分支排序.py',57344),
           ('04_连接保护边界','验证嵌套接线保护.py',None)]
    for folder,script,comparisons in tasks:
        command=[sys.executable,str(scriptdir/script),'--candidate-yosys',str(program),'--output',args.name+'/'+folder]
        started=datetime.now(timezone.utc).isoformat()
        p=subprocess.run(command,cwd=scriptdir,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=180)
        log=p.stdout.decode('utf-8',errors='replace');(out/(folder+'_启动日志.txt')).write_text(log,encoding='utf-8')
        record={'folder':folder,'script':script,'command':command,'started_utc':started,'exit_code':p.returncode}
        manifest['results'].append(record);save(out/'冻结证据汇总.json',manifest)
        print(folder+' exit='+str(p.returncode),flush=True)
        if p.returncode!=0:raise RuntimeError('Test failed; original logs preserved: '+folder)
        summary=json.loads((out/folder/'summary.json').read_text(encoding='utf-8'))
        if comparisons is not None:
            assert summary['comparisons']==comparisons and summary['exit_code']==0,(folder,summary)
            record['comparisons']=comparisons
        else:
            assert summary['passed'] and len(summary['checks'])==10,(folder,summary)
            record['connection_modules_checked']=10
        record['passed']=True;save(out/'冻结证据汇总.json',manifest)
    after={key:sha(path) for key,path in files.items()}
    assert after==hashes,'Program, source or reference tools changed during regression'
    manifest.update(finished_utc=datetime.now(timezone.utc).isoformat(),hashes_unchanged=True,
        total_four_state_comparisons=sum(r.get('comparisons',0) for r in manifest['results']),
        connection_modules_checked=sum(r.get('connection_modules_checked',0) for r in manifest['results']),all_passed=True)
    save(out/'冻结证据汇总.json',manifest)
    (out/'阅读说明.txt').write_text(
        '本目录绑定已冻结优化程序，程序SHA256及源码SHA256见冻结证据汇总.json。\n'
        '四项均实际执行已冻结的C++ pass及官方0.69单元模型。\n'
        '总计974912次四态向量比较、10个连接保护模块检查，全部通过。\n'
        '仅重放默认基础清理、相同列共享、嵌套默认分支及升序排序；没有启用shiftx、谓词常量或常量极性。\n'
        '本测试不替代正式九例ABC后EQY、资源统计或效率测试；这些应同时参考冻结发布验收记录。\n'
        '原程序、源码、官方工具及单元模型的运行前后哈希完全一致。\n',encoding='utf-8')
    print('PASS comparisons='+str(manifest['total_four_state_comparisons'])+' connection_modules=10',flush=True)
    print(str(out),flush=True)
if __name__=='__main__':main()
