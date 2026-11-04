"""Project-owned, fail-closed inverse of official intel/common/ff_map.v.

Only the exact dffeas primitive configuration emitted by ff_map.v is accepted.
No LUT, combinational connection, input, or output is altered. The reference
proof model is Yosys's native $_DFFE_PN0P_, not the incomplete Intel sim stub.
"""
from pathlib import Path
import argparse, copy, hashlib, json

FIXED={'prn':['1'],'asdata':['0'],'aload':['0'],'sclr':['0'],'sload':['0']}
PORTS={'d':'D','clk':'C','clrn':'R','ena':'E','q':'Q'}

def normalize(source,destination,top,report_path=None):
    source=Path(source);destination=Path(destination)
    original=json.loads(source.read_text(encoding='utf-8'))
    if top not in original['modules']:raise ValueError('Top module absent')
    module=copy.deepcopy(original['modules'][top]);converted=[]
    for name,c in module.get('cells',{}).items():
        if c['type']!='dffeas':
            if not c['type'].startswith('$'):raise ValueError(f'Unsupported non-native cell: {name} {c["type"]}')
            continue
        con=c['connections'];par=c.get('parameters',{})
        if set(con)!=set(FIXED)|set(PORTS):raise ValueError(f'{name}: unexpected port set')
        for port,value in FIXED.items():
            if con[port]!=value:raise ValueError(f'{name}: {port} must be {value}, received {con[port]}')
        if set(par)!={'power_up','is_wysiwyg'} or par['power_up'] not in ['low','high'] or par['is_wysiwyg']!='TRUE':
            raise ValueError(f'{name}: unsupported dffeas parameters {par}')
        if any(len(con[p])!=1 for p in PORTS):raise ValueError(f'{name}: non-scalar port')
        q=con['q'][0]
        if not isinstance(q,int):raise ValueError(f'{name}: output must be a real wire')
        init='1' if par['power_up']=='high' else '0'
        # Any existing init must agree. Preserve native initial-state semantics.
        for net in module.get('netnames',{}).values():
            if q in net['bits'] and 'init' in net.get('attributes',{}):
                for i,bit in enumerate(net['bits']):
                    if bit==q and net['attributes']['init'][len(net['bits'])-1-i] not in (init,'x'):
                        raise ValueError(f'{name}: conflicting initialization')
        module.setdefault('netnames',{})['$eqy_ff_initial_'+name]={
            'hide_name':1,'bits':[q],'attributes':{'init':init}}
        converted.append(dict(cell=name,power_up=par['power_up'],original_connections=copy.deepcopy(con)))
        c['type']='$_DFFE_PN0P_';c['parameters']={}
        c['connections']={new:con[old] for old,new in PORTS.items()}
        c['port_directions']={p:('output' if p=='Q' else 'input') for p in PORTS.values()}
    result={'creator':original.get('creator','')+'; project ff_map inverse adapter','modules':{top:module}}
    destination.parent.mkdir(parents=True,exist_ok=True)
    destination.write_text(json.dumps(result,indent=2),encoding='utf-8')
    report=dict(source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),
       result_sha256=hashlib.sha256(destination.read_bytes()).hexdigest(),top=top,converted_ff_count=len(converted),
       changes=converted,reference='Official share/yosys/intel/common/ff_map.v; exact inverse, no general dffeas emulation.',
       status='ACCEPTED_EXACT_CONFIGURATION')
    if report_path:Path(report_path).write_text(json.dumps(report,indent=2),encoding='utf-8')
    return report

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--输入',type=Path,required=True);p.add_argument('--输出',type=Path,required=True)
    p.add_argument('--顶层',required=True);p.add_argument('--记录',type=Path)
    a=p.parse_args();print(json.dumps(normalize(a.输入,a.输出,a.顶层,a.记录)))

if __name__=='__main__':main()
