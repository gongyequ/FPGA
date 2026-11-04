from pathlib import Path
import hashlib,json,subprocess
from PIL import Image

ROOT=Path(__file__).resolve().parent
PROJECT=ROOT.parent.parent
PDF=PROJECT/'零点六九新版正式提交_20261104/设计文档_PMUX结构优化_零点六九_新版.pdf'
LOW=PROJECT/'零点六九新版正式提交_20261104/交付制作记录/文档/设计逐页03'
PAGES=ROOT/'原始页面'
PAGES.mkdir(exist_ok=True)
POPPLER=Path('C:/Users/13889/.cache/codex-runtimes/codex-primary-runtime/dependencies/native/poppler/Library/bin/pdftoppm.exe')
items=[
 ('00_设计文档首页.png',1,(0,0,1132,1600),'正式设计文档首页，含标题、版本、设计约束；仅建议作为封面缩略图。'),
 ('01_整体架构.png',2,(190,220,940,736),'图1 双路径综合与验证架构：同源Yosys基线、PMUX规则、统一映射与ABC后EQY。'),
 ('02_B臂变换图.png',4,(194,948,934,1342),'图2 嵌套数据分支控制与数据重构：宽数据层合并，使用窄控制PMUX。'),
 ('03_B臂控制公式.png',4,(395,812,780,940),'B臂控制公式 h=P(1,0,Si)，G=P(0,[h,Si],t)，Y=P(Ao,[Ai,Bi,Bo],[G,So])。'),
 ('04_执行流程.png',5,(250,725,883,1235),'图3 默认规则与保护条件执行顺序，含统一ABC、PMUX识别、基础清理、默认与数据臂合并、官方映射。'),
 ('05_EQY验证策略.png',8,(163,388,973,990),'7.3 正式EQY与证明范围全文：受限FF逆适配、opt_clean与setundef、SAT归纳、PASS与证明范围。'),
 ('06_实测对照.png',9,(175,655,957,1183),'九个官方用例的原版与优化资源对照表，含逐例下降比例。'),
]
page_set=sorted(set(x[1] for x in items))
for p in page_set:
    target=PAGES/f'设计文档_第{p:02d}页'
    subprocess.run([str(POPPLER),'-f',str(p),'-l',str(p),'-singlefile','-r','240','-png',str(PDF),str(target)],check=True,capture_output=True,creationflags=subprocess.CREATE_NO_WINDOW)
entries=[]
pdf_hash=hashlib.sha256(PDF.read_bytes()).hexdigest()
for name,p,box,summary in items:
    original=PAGES/f'设计文档_第{p:02d}页.png'
    im=Image.open(original)
    sx,sy=im.width/1132,im.height/1600
    rect=tuple(round(v*(sx if i%2==0 else sy)) for i,v in enumerate(box))
    crop=im.crop(rect);output=ROOT/name;crop.save(output)
    entries.append({'file':name,'source_document':str(PDF.resolve()),'source_document_sha256':pdf_hash,'document_page':p,'original_png':str(original.resolve()),'original_png_size':[im.width,im.height],'reviewed_low_resolution_png':str((LOW/f'page-{p:02d}.png').resolve()),'crop_pixels':list(rect),'width':crop.width,'height':crop.height,'content_summary':summary,'source_label':f'设计文档 · 第 {p} 页 · 原文截图','method':'Poppler 240 dpi exact PDF rendering; rectangular crop only; no text or content edits','sha256':hashlib.sha256(output.read_bytes()).hexdigest()})
(ROOT/'截图来源.json').write_text(json.dumps(entries,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps([{'file':e['file'],'page':e['document_page'],'size':[e['width'],e['height']]} for e in entries],ensure_ascii=False))
