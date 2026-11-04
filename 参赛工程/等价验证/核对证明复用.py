"""Reuse a prior proof only when every raw baseline/candidate ILANG hash agrees."""
from pathlib import Path
from datetime import datetime,timezone
import argparse,hashlib,json
def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def check(proof,baseline,previous,current):
    data=json.loads((Path(proof)/'正式EQY汇总.json').read_text(encoding='utf-8'))
    records=[]
    for row in data['cases']:
        name=row['case']
        hashes={'proof_gold':row['inputs']['gold']['sha256'],'proof_gate':row['inputs']['gate']['sha256'],
                'baseline':sha(Path(baseline)/name/'original-area.il'),
                'previous':sha(Path(previous)/name/'optimized-area.il'),
                'current':sha(Path(current)/name/'optimized-area.il')}
        exact=(row['status']=='PASS' and hashes['proof_gold']==hashes['baseline'] and
               hashes['proof_gate']==hashes['previous']==hashes['current'])
        records.append({'case':name,'top':row['top'],'exact_raw_netlist_match':exact,'sha256':hashes})
    return {'criterion':'Byte-identical original ILANG, including header, attributes and cell data; prior genuine EQY PASS required.',
        'checked_utc':datetime.now(timezone.utc).isoformat(),
        'scope':'Only the exact recorded raw-netlist SHA256 snapshots. Directory names do not establish that this is the current or final product.',
        'case_count':len(records),'all_nine_exact_and_passed':len(records)==9 and all(r['exact_raw_netlist_match'] for r in records),
        'proof_directory':str(Path(proof).resolve()),'current_netlist_directory':str(Path(current).resolve()),'cases':records}

if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__)
    for name in ['证明目录','基线目录','已证候选目录','最终候选目录','报告']:p.add_argument('--'+name,type=Path,required=True)
    a=p.parse_args();result=check(a.证明目录,a.基线目录,a.已证候选目录,a.最终候选目录)
    a.报告.write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
    print('all_nine_exact_and_passed='+str(result['all_nine_exact_and_passed']))
    raise SystemExit(0 if result['all_nine_exact_and_passed'] else 1)
