"""Independently check that the project adapter did not touch combinational logic."""
from pathlib import Path
import argparse,json

def audit(inputdir):
    inputdir=Path(inputdir)
    manifest=json.loads((inputdir/'验证准备记录.json').read_text(encoding='utf-8'))
    top=manifest['top'];results={}
    for side in ['gold','gate']:
        raw=json.loads((inputdir/(side+'.raw.json')).read_text(encoding='utf-8'))['modules'][top]
        converted=json.loads((inputdir/(side+'.json')).read_text(encoding='utf-8'))['modules'][top]
        assert raw['ports']==converted['ports'],'I/O interface changed'
        assert set(raw['cells'])==set(converted['cells']),'Cell added or removed'
        count=0
        for name,cell in raw['cells'].items():
            output=converted['cells'][name]
            if cell['type']!='dffeas':
                assert cell==output,f'Non-FF cell changed: {name}'
                continue
            count+=1
            assert output['type']=='$_DFFE_PN0P_'
            assert output['parameters']=={}
            expected={new:cell['connections'][old] for old,new in {'d':'D','clk':'C','clrn':'R','ena':'E','q':'Q'}.items()}
            assert expected==output['connections'],f'FF connection changed: {name}'
            init='1' if cell['parameters']['power_up']=='high' else '0'
            q=cell['connections']['q'][0]
            assert any(n['bits']==[q] and n.get('attributes',{}).get('init')==init for n in converted['netnames'].values())
        for name,net in raw['netnames'].items():
            assert converted['netnames'][name]==net,f'Original net changed: {name}'
        results[side]={'cells':len(raw['cells']),'converted_ff_count':count,
                       'unchanged_non_ff_cells':len(raw['cells'])-count,'status':'PASS'}
    return {'top':top,'semantic_scope':'Exact FF replacement only; original ports, all non-FF cells and all original netnames unchanged.','results':results}

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--输入目录',type=Path,required=True)
    p.add_argument('--报告',type=Path,required=True);a=p.parse_args()
    inputs=[a.输入目录] if (a.输入目录/'验证准备记录.json').is_file() else sorted(a.输入目录.glob('*/验证输入'))
    if not inputs:raise RuntimeError('No prepared inputs found')
    results=[{'directory':str(path),**audit(path)} for path in inputs]
    a.报告.write_text(json.dumps(results,ensure_ascii=False,indent=2),encoding='utf-8')
    print(f'PASS: {len(results)} pairs; no non-FF cell or original net/port changed')

if __name__=='__main__':main()
