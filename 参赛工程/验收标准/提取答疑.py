from pathlib import Path
import sys
import hashlib, json, posixpath, zipfile, xml.etree.ElementTree as ET

source=Path(r'C:\Users\13889\Downloads\FPGA创新大赛问题汇总 (1).xlsx')
sys.stdout.reconfigure(encoding='utf-8')
out=Path(__file__).resolve().parent
ns={'s':'http://schemas.openxmlformats.org/spreadsheetml/2006/main','r':'http://schemas.openxmlformats.org/officeDocument/2006/relationships'}
def texts(node):
    return ''.join(node.itertext()) if node is not None else ''
def cell_text(cell,shared):
    typ=cell.attrib.get('t','')
    if typ=='inlineStr':return ''.join(t.text or '' for t in cell.findall('.//s:t',ns))
    value=cell.find('s:v',ns)
    if value is None:return ''
    if typ=='s':return shared[int(value.text)]
    return value.text or ''
result={'source':str(source),'sha256':hashlib.sha256(source.read_bytes()).hexdigest(),'sheets':[]}
with zipfile.ZipFile(source) as z:
    shared=[]
    if 'xl/sharedStrings.xml' in z.namelist():
        root=ET.fromstring(z.read('xl/sharedStrings.xml'))
        shared=[''.join(t.text or '' for t in si.findall('.//s:t',ns)) for si in root.findall('s:si',ns)]
    book=ET.fromstring(z.read('xl/workbook.xml'))
    rel=ET.fromstring(z.read('xl/_rels/workbook.xml.rels'))
    paths={e.attrib['Id']:posixpath.normpath('xl/'+e.attrib['Target']) if not e.attrib['Target'].startswith('/') else e.attrib['Target'].lstrip('/') for e in rel}
    for sheet in book.findall('s:sheets/s:sheet',ns):
        path=paths[sheet.attrib['{'+ns['r']+'}id']]
        root=ET.fromstring(z.read(path))
        cells=[]
        for c in root.findall('.//s:sheetData/s:row/s:c',ns):
            value=cell_text(c,shared)
            if value or c.find('s:f',ns) is not None:
                cells.append({'cell':c.attrib['r'],'value':value,'formula':texts(c.find('s:f',ns)) or None})
        result['sheets'].append({'name':sheet.attrib['name'],'state':sheet.attrib.get('state','visible'),'path':path,
                                 'merged_cells':[m.attrib['ref'] for m in root.findall('s:mergeCells/s:mergeCell',ns)],'cells':cells})
(out/'答疑原文_完整提取.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
lines=[f'源文件：{source}',f'SHA256：{result["sha256"]}']
for s in result['sheets']:
    lines.append('\n工作表：'+s['name']+'（'+s['state']+'）')
    for c in s['cells']:
        lines.append(f'[{s["name"]}!{c["cell"]}]\n{c["value"]}')
(out/'答疑原文_完整提取.txt').write_text('\n\n'.join(lines),encoding='utf-8')
print('\n\n'.join(lines))
