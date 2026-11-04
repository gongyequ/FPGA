"""Copy exact official runtime files, preserving their hashes and provenance."""
from pathlib import Path
import hashlib, json, re, shutil, subprocess
ROOT=Path(__file__).resolve().parents[1]
SUITE=ROOT/'suite'
REDIST=Path('C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Redist/MSVC/14.44.35112/x64/Microsoft.VC143.CRT')
DUMP=Path('C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.44.35207/bin/Hostx64/x64/dumpbin.exe')
records=[]
for kind in ['原版程序','优化程序']:
    folder=ROOT/kind
    queue=[folder/'yosys.exe',SUITE/'bin/yosys-abc.exe']; visited=set()
    while queue:
        source=queue.pop(0)
        key=source.name.lower()
        if key in visited:continue
        visited.add(key)
        destination=folder/source.name
        if source.resolve()!=destination.resolve():shutil.copy2(source,destination)
        records.append(dict(variant=kind,file=source.name,source=str(source.resolve()),
                            sha256=hashlib.sha256(destination.read_bytes()).hexdigest()))
        result=subprocess.run([str(DUMP),'/DEPENDENTS',str(source)],capture_output=True,check=True)
        imports=re.findall(r'^\s+([\w.+-]+\.dll)\s*$',result.stdout.decode(errors='replace'),re.M|re.I)
        for name in imports:
            if name.lower() in visited:continue
            candidates=[SUITE/'lib'/name,SUITE/'bin'/name,REDIST/name]
            dependency=next((p for p in candidates if p.is_file()),None)
            if dependency is not None:queue.append(dependency)
            elif not (Path('C:/Windows/System32')/name).exists() and not name.lower().startswith('api-ms-win-'):
                raise FileNotFoundError('Unresolved runtime dependency: '+name)
    tcl_source=SUITE/'lib/tcl8.6'
    shutil.copytree(tcl_source,folder/'tcl8.6',dirs_exist_ok=True)
    for source in sorted(tcl_source.rglob('*')):
        if not source.is_file():continue
        relative=Path('tcl8.6')/source.relative_to(tcl_source)
        records.append(dict(variant=kind,file=relative.as_posix(),source=str(source.resolve()),
                            sha256=hashlib.sha256((folder/relative).read_bytes()).hexdigest()))
    # This suite release has clock.tcl but omits its standard msgcat package.
    # Keep the exact 8.6.15 upstream package and license, never a substitute.
    official_modules=ROOT/'构建工具/Tcl官方模块'
    module_sources=json.loads((official_modules/'来源.json').read_text(encoding='utf-8'))
    for origin in module_sources:
        source=official_modules/origin['file']
        data=source.read_bytes()
        if hashlib.sha256(data).hexdigest()!=origin['sha256']:
            raise RuntimeError('Official Tcl module hash mismatch: '+str(source))
        relative=Path('tcl8.6')/origin['file']
        destination=folder/relative;destination.parent.mkdir(parents=True,exist_ok=True)
        shutil.copy2(source,destination)
        records.append(dict(variant=kind,file=relative.as_posix(),source=origin['url'],
                            sha256=origin['sha256']))
(ROOT/'运行依赖来源.json').write_text(json.dumps(records,ensure_ascii=False,indent=2),encoding='utf-8')
print('Collected exact runtime files for both binaries:',len(records))
