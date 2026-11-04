from pathlib import Path
import json, html, re, hashlib

root=Path(__file__).resolve().parent
out=root/'结果截图'
out.mkdir(exist_ok=True)
area=Path(json.loads((root/'最近面积运行.json').read_text('utf-8'))['directory'])
ar=json.loads((area/'本次面积结果.json').read_text('utf-8'))
eq=max((root/'运行记录').glob('*_EQY验证'))
er=json.loads((eq/'本次EQY结果.json').read_text('utf-8'))
assert Path(er['area_directory'])==area and er['pass'] and er['execution']['exit_code']==0
assert (eq/'官方EQY结果/proof/PASS').exists()
for role in ['original','optimized']:
    assert hashlib.sha256((area/(role+'.il')).read_bytes()).hexdigest()==ar['rows'][role]['raw_il_sha256']

css='''*{box-sizing:border-box}body{margin:0;background:#eef3f8;color:#182b42;font-family:"Microsoft YaHei","Noto Sans CJK SC",sans-serif}main{width:1240px;min-height:700px;padding:30px 42px;background:#fff;margin:0 auto}.kicker{font-size:14px;font-weight:700;color:#3864ac;letter-spacing:2px}h1{font-size:32px;margin:9px 0 8px}p{margin:8px 0;font-size:16px;color:#536276}.hero{display:flex;align-items:baseline;gap:28px;margin:20px 0;padding:18px 24px;background:#edf6f3;border-left:5px solid #168063}.big{font-size:46px;font-weight:800;color:#126e54}.hero span{font-size:20px}.grid{display:grid;grid-template-columns:1fr 1fr;gap:20px}.label{font-size:17px;font-weight:700;margin-bottom:8px}pre{margin:0;background:#f3f5f9;border:1px solid #dce4ed;padding:14px 18px;font-family:Consolas,"Microsoft YaHei",monospace;font-size:16px;line-height:1.42;white-space:pre-wrap;overflow-wrap:anywhere;color:#22354a}table{width:100%;border-collapse:collapse;margin:14px 0;font-size:16px}td,th{text-align:left;padding:9px 14px;border-bottom:1px solid #dfe6ed}th{background:#eef3f8}.foot{font-size:12px;line-height:1.6;color:#69798a;margin-top:14px;overflow-wrap:anywhere}.note{font-size:15px;line-height:1.6;margin-top:15px}.pass{color:#087448;font-weight:800}.log{font-size:15px;line-height:1.55}.tag{padding:5px 12px;background:#e9f2fc;border-radius:6px;color:#285891;font-size:14px}'''
def page(title,body,name):
    (out/name).write_text('<!doctype html><html lang="zh-CN"><meta charset="utf-8"><title>'+title+'</title><style>'+css+'</style><main>'+body+'</main></html>',encoding='utf-8')
def stats(role):
    text=(area/(role+'.log')).read_text('utf-8')
    block=re.search(r'=== '+re.escape(ar['top'])+r' ===\n(.*?)(?=\n\d+\.|\Z)',text,re.S)
    assert block
    return html.escape(block.group(1).strip())
b,c=ar['rows']['original'],ar['rows']['optimized']
page('PMUX 综合资源对比',f'''<div class="kicker">PMUX 优化项目 · 实测结果展示页 · 01 / 02</div>
<h1>优化前后综合资源对比</h1><p>官方用例 zip_case04 · 顶层 {ar['top']} · Yosys 0.69+286 固定基线</p>
<div class="hero"><div class="big">{b['lut']} → {c['lut']}</div><span>LUT 减少 {b['lut']-c['lut']} 个 · 下降 <b>{ar['reduction_percent']:.2f}%</b></span></div>
<div class="grid"><div><div class="label">原版 Yosys · 原始 stat 日志节选</div><pre>{stats('original')}</pre></div><div><div class="label">PMUX 优化版 · 原始 stat 日志节选</div><pre>{stats('optimized')}</pre></div></div>
<table><tr><th>核对项</th><th>优化前</th><th>优化后</th></tr><tr><td>LUT + NOT（面积统计口径）</td><td>{b['logic_area']}</td><td>{c['logic_area']}</td></tr><tr><td>寄存器 dffeas / IO 位数</td><td>{b['dff']} / {b['io_bits']}</td><td>{c['dff']} / {c['io_bits']}</td></tr></table>
<div class="foot">证据来源：运行记录/{area.name}/original.log、optimized.log、本次面积结果.json<br>统计阶段：synth_intel -family cycloneiv -run begin:map_cells；本页根据实际运行记录排版，属于综合结果。</div>''','01_综合资源对比.html')
raw=(eq/'官方EQY结果/eqy-console.log').read_text('utf-8')
assert 'DONE (PASS, rc=0)' in raw and 'Successfully proved designs equivalent' in raw
lines=raw.strip().splitlines()[-11:]
page('PMUX EQY形式等价验证',f'''<div class="kicker">PMUX 优化项目 · 实测结果展示页 · 02 / 02</div>
<h1>EQY 形式等价验证通过</h1><p>官方用例 zip_case04 · 与上一张综合对比使用同一对网表</p>
<div class="hero"><div class="big">PASS</div><span>EQY 退出码 0 · proof/PASS 文件存在 · 网表 SHA-256 对应</span></div>
<div class="label">官方 EQY 实际输出 · eqy-console.log 末尾原文</div><pre class="log">{html.escape(chr(10).join(lines))}</pre>
<div class="note"><b>验证范围：</b>ABC 后两网表，经受限 dffeas 逆适配及<br><code>opt_clean; setundef -zero -init</code> 后执行 SAT 归纳验证；已知初始值保持不变。</div>
<div class="foot">证据来源：运行记录/{eq.name}/官方EQY结果/eqy-console.log<br>本页根据实际运行记录排版，属于形式验证结果；PASS 表示在上述验证配置下功能等价。</div>''','02_EQY形式等价验证.html')
print(out)
