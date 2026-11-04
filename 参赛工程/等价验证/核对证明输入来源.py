"""Bind a completed genuine EQY run to the exact newly generated raw netlists."""
from pathlib import Path
from datetime import datetime,timezone
import argparse,hashlib,json
def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def check(proof_dir,raw_dir):
    proof_dir=Path(proof_dir);raw_dir=Path(raw_dir)
    summary=json.loads((proof_dir/'正式EQY汇总.json').read_text(encoding='utf-8'))
    rows=[]
    for case in summary['cases']:
        name=case['case'];work=proof_dir/name;details={};ok=case['status']=='PASS'
        for side,file in [('gold','original-area.il'),('gate','optimized-area.il')]:
            source=raw_dir/name/file
            hashes={'release_raw':sha(source),'summary_raw':case['inputs'][side]['sha256'],
                    'prepared_raw':sha(work/'验证输入'/(side+'.raw.il')),
                    'executed_raw':sha(work/'官方EQY结果'/(side+'.raw.il'))}
            normalized=[sha(work/'验证输入'/(side+'.il')),sha(work/'官方EQY结果'/(side+'.il'))]
            same=len(set(hashes.values()))==1 and normalized[0]==normalized[1]
            ok=ok and same;details[side]={'source':str(source.resolve()),'raw_sha256':hashes,
                                        'normalized_sha256':normalized[0],'all_identical':same}
        run=json.loads((work/'官方EQY结果/execution.json').read_text(encoding='utf-8'))
        ok=ok and run['exit_code']==0 and (work/'官方EQY结果/proof/PASS').is_file()
        ok=ok and sha(work/'验证输入/proof.eqy')==sha(work/'官方EQY结果/proof.eqy')
        rows.append({'case':name,'inputs_match_executed_proof':ok,'inputs':details,
                     'eqy_config_sha256':sha(work/'验证输入/proof.eqy')})
    return {'checked_utc':datetime.now(timezone.utc).isoformat(),'raw_directory':str(raw_dir.resolve()),
            'case_count':len(rows),'all_nine_bound_to_new_raw_netlists':len(rows)==9 and all(r['inputs_match_executed_proof'] for r in rows),
            'scope':'Source, prepared raw, executed raw and summary hashes agree; adapted ILANG/config also agree with actual executed inputs; genuine EQY PASS present.',
            'cases':rows}
if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__)
    for name in ['证明目录','原始网表目录','报告']:p.add_argument('--'+name,required=True,type=Path)
    a=p.parse_args();result=check(a.证明目录,a.原始网表目录)
    a.报告.write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
    print('all_nine_bound_to_new_raw_netlists='+str(result['all_nine_bound_to_new_raw_netlists']))
    raise SystemExit(0 if result['all_nine_bound_to_new_raw_netlists'] else 1)
