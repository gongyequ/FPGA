from pathlib import Path
import json,re,hashlib
from PIL import Image,ImageDraw,ImageFont

root=Path(__file__).resolve().parent
out=root/'结果截图'
out.mkdir(exist_ok=True)
area=Path(json.loads((root/'最近面积运行.json').read_text('utf-8'))['directory'])
ar=json.loads((area/'本次面积结果.json').read_text('utf-8'))
eq=max((root/'运行记录').glob('*_EQY验证'))
er=json.loads((eq/'本次EQY结果.json').read_text('utf-8'))
assert er['pass'] and er['execution']['exit_code']==0 and Path(er['area_directory'])==area
assert (eq/'官方EQY结果/proof/PASS').exists()
for role in ['original','optimized']:
    assert hashlib.sha256((area/(role+'.il')).read_bytes()).hexdigest()==ar['rows'][role]['raw_il_sha256']
F=lambda s:ImageFont.truetype('C:/Windows/Fonts/msyh.ttc',s)
M=lambda s:ImageFont.truetype('C:/Windows/Fonts/consola.ttf',s)
ink='#18314c';grey='#536679';blue='#215ba7';green='#087855'
def base(n,title,subtitle):
    im=Image.new('RGB',(1920,1080),'#f4f7fb');d=ImageDraw.Draw(im)
    d.rounded_rectangle((40,32,1880,1048),24,fill='white')
    d.text((90,66),f'PMUX 优化项目  /  实测结果  /  {n:02d}',font=F(25),fill=blue)
    d.text((90,119),title,font=F(50),fill=ink)
    d.text((90,193),subtitle,font=F(27),fill=grey)
    d.line((90,1010,1830,1010),fill='#d8e1ec',width=2)
    d.text((90,1020),'依据真实运行日志整理的结果展示图（非原始窗口截图、非波形仿真）',font=F(19),fill=grey)
    return im,d
im,d=base(1,'优化前后综合资源对比','官方用例 zip_case04  ·  pmux_case04_feedback  ·  固定基线 Yosys 0.69+286')
b,c=ar['rows']['original'],ar['rows']['optimized']
d.rounded_rectangle((90,252,1830,380),16,fill='#e9f5f0')
d.text((120,268),f"{b['lut']} → {c['lut']}",font=F(64),fill=green)
d.text((615,287),f"LUT 减少 {b['lut']-c['lut']} 个，下降 {ar['reduction_percent']:.2f}%",font=F(35),fill=green)
for role,x,title in [('original',90,'优化前：原版 Yosys'),('optimized',980,'优化后：PMUX 优化版')]:
    text=(area/(role+'.log')).read_text('utf-8')
    block=re.search(r'=== '+re.escape(ar['top'])+r' ===\n(.*?)(?=\n\d+\.|\Z)',text,re.S).group(1)
    lines=[s for s in block.splitlines() if re.match(r'\s*\d+\s',s)]
    assert len(lines)==9
    d.text((x,410),title,font=F(32),fill=ink)
    d.rounded_rectangle((x,463,x+850,830),14,fill='#f0f4f9')
    d.text((x+26,480),'stat 原始日志节选',font=F(24),fill=blue)
    for i,line in enumerate(lines):d.text((x+42,525+i*31),line,font=M(28),fill=ink)
d.text((90,859),'面积口径 LUT + NOT：371 → 292；寄存器：16 → 16；IO 位数：115 → 115。',font=F(27),fill=ink)
d.text((90,907),'综合阶段：synth_intel -family cycloneiv -run begin:map_cells',font=F(25),fill=grey)
d.text((90,950),'证据：'+area.name+' / original.log、optimized.log、本次面积结果.json',font=F(21),fill=grey)
im.save(out/'01_优化前后综合资源对比.png')

im,d=base(2,'EQY 形式等价验证通过','官方用例 zip_case04  ·  使用上一张综合对比生成的同一对网表')
d.rounded_rectangle((90,252,1830,380),16,fill='#e9f5f0')
d.text((120,271),'PASS',font=M(72),fill=green)
d.text((440,286),'退出码 0  ·  proof/PASS 存在  ·  输入网表 SHA-256 对应',font=F(32),fill=green)
raw=(eq/'官方EQY结果/eqy-console.log').read_text('utf-8')
lines=raw.strip().splitlines()[-6:]
assert 'DONE (PASS, rc=0)' in lines[-1]
d.text((90,409),'官方 EQY 原始日志末尾（逐行摘录）',font=F(30),fill=ink)
d.rounded_rectangle((90,465,1830,755),14,fill='#f0f4f9')
for i,line in enumerate(lines):d.text((115,491+i*39),line,font=M(26),fill=green if 'PASS' in line or 'Successfully' in line else ink)
d.text((90,789),'验证配置：ABC 后网表，受限 dffeas 逆适配；',font=F(28),fill=ink)
d.text((90,836),'opt_clean; setundef -zero -init 后执行 SAT 归纳验证，已知初始值不变。',font=F(28),fill=ink)
d.text((90,895),'结论：在上述验证配置下，优化前后网表功能等价。',font=F(27),fill=green)
d.text((90,950),'证据：'+eq.name+' / 官方EQY结果 / eqy-console.log',font=F(21),fill=grey)
im.save(out/'02_EQY形式等价验证通过.png')
(out/'图片来源说明.txt').write_text('这两张PNG是依据真实日志整理的高清结果图，不是原始软件窗口截图，也不是波形仿真。\n面积来源：'+str(area)+'\nEQY来源：'+str(eq)+'\n已核查原始网表哈希、EQY退出码、原始PASS日志及proof/PASS文件。\n',encoding='utf-8-sig')
print('Created two 1920x1080 PNGs.')
