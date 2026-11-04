"""Download unmodified Tcl 8.6.15 msgcat standard package, with provenance."""
from pathlib import Path
import hashlib,json,urllib.request

root=Path(__file__).resolve().parent/'Tcl官方模块'
base='https://raw.githubusercontent.com/tcltk/tcl/core-8-6-15/'
pairs=[('library/msgcat/msgcat.tcl','msgcat/msgcat.tcl'),
       ('library/msgcat/pkgIndex.tcl','msgcat/pkgIndex.tcl'),
       ('license.terms','license.terms')]
rows=[]
for source,destination in pairs:
    url=base+source
    data=urllib.request.urlopen(url,timeout=30).read()
    target=root/destination;target.parent.mkdir(parents=True,exist_ok=True)
    target.write_bytes(data)
    rows.append({'file':destination,'url':url,'sha256':hashlib.sha256(data).hexdigest()})
(root/'来源.json').write_text(json.dumps(rows,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps(rows,ensure_ascii=False,indent=2))
print((root/'msgcat/pkgIndex.tcl').read_text(encoding='utf-8'))
