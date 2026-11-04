"""Seal the forced-rebuilt B-off binary; preserve the mismatched historical build."""
from pathlib import Path
import hashlib,json,shutil,subprocess
from datetime import datetime,timezone

record=Path(__file__).resolve().parent
root=record.parents[1]
off=root/'候选程序/B臂关闭消融F4c'
on=root/'候选程序/B臂集成F4c'
snap_on=root/'构建记录/B臂默认集成构建'
old=root/'候选程序/B臂研究001'
key=b'pmux_opt -order-decode -flatten-fallback -uniform-abc'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def call(p):
    b=p.read_bytes();i=b.find(key);assert i>=0
    return b[i:i+180].split(bytes([0]),1)[0].decode('ascii')
assert not off.exists(),off
assert sha(record/'pmux_opt.cc')==sha(snap_on/'pmux_opt.cc')
assert (record/'synth_intel.cc').read_bytes()==(snap_on/'synth_intel.cc').read_bytes().replace(b' -flatten-data-arm',b'')
assert call(root/'编译输出/yosys.exe')==key.decode()
assert call(on/'yosys.exe')==key.decode()+' -flatten-data-arm'
off.mkdir()
for p in on.iterdir():
    if p.is_file() and p.name!='yosys.exe':shutil.copy2(p,off/p.name)
shutil.copy2(root/'编译输出/yosys.exe',off/'yosys.exe')
for name in ['share','tcl8.6']:
    subprocess.run(['cmd.exe','/d','/c','mklink','/J',str(off/name),str(root/'候选程序'/name)],check=True,capture_output=True)
programs={}
for name,p in [('关闭B的同源码消融',off),('开启B的正式候选',on),('历史研究版_不得作为B关闭消融',old)]:
    programs[name]={'path':str(p/'yosys.exe'),'sha256':sha(p/'yosys.exe'),'compiled_pmux_call':call(p/'yosys.exe')}
report={'created_utc':datetime.now(timezone.utc).isoformat(),'programs':programs,
 'same_pmux_source':True,'pmux_source_sha256':sha(record/'pmux_opt.cc'),
 'synth_off_sha256':sha(record/'synth_intel.cc'),'synth_on_sha256':sha(snap_on/'synth_intel.cc'),
 'only_synth_source_difference':' -flatten-data-arm',
 'forced_synth_recompile':True,'formal_candidate_not_modified':sha(on/'yosys.exe')=='a603b6e7b900fa3ca8410b25d37c6b4aa26c12f22e6bd9f3dba0958e6d389b53',
 'historical_mismatch':'B臂研究001恢复synth源文件保留旧mtime，Ninja仅重编pmux，缓存synth对象仍启用index；不能作为B-off面积对照。此次显式更新synth mtime并检查重编日志、源文件和二进制内实际调用字符串。',
 'formal_performance_executed':False}
(record/'程序身份与历史失配记录.json').write_text(json.dumps(report,ensure_ascii=False,indent=2),encoding='utf-8')
(root/'构建记录/B臂候选构建/身份核对补充_禁止用作B关闭消融.txt').write_text(report['historical_mismatch']+'\n历史程序与日志均保留。修正消融记录见：'+str(record)+'\n',encoding='utf-8')
print(json.dumps(report,ensure_ascii=False,indent=2))
