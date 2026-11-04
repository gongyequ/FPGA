"""PMUX evidence-led silent presentation. Python + Pillow + local FFmpeg.
Run: python 制作介绍视频.py --frames ; python 制作介绍视频.py --render
All clips are authored graphics. Log and code panels reproduce saved real files.
"""
from pathlib import Path
import argparse, json, hashlib, shutil, re, math, subprocess, sys, functools
sys.path.insert(0,str(Path(__file__).resolve().parent/'制作工具'))
from PIL import Image, ImageDraw, ImageFont

ROOT=Path(__file__).resolve().parent
PROJECT=ROOT.parent
DEMO=PROJECT/'视频演示_20261104'
PACK=PROJECT/'零点六九新版正式提交_20261104/代码包内容'
ASSETS=ROOT/'证据素材'; FRAMES=ROOT/'画面素材'; QA=ROOT/'检查记录'
for directory in [ASSETS,FRAMES,QA]:directory.mkdir(exist_ok=True)
W,H,FPS=1920,1080,24
BG='#f5f6f2'; INK='#152f45'; MUTED='#586e7d'; BLUE='#255cba'; TEAL='#087c69'; LIGHT='#e5efe9'; LINE='#ccd8dc'; WHITE='#ffffff'
YFONT='C:/Windows/Fonts/msyh.ttc'; MFONT='C:/Windows/Fonts/consola.ttf'
DUR=[12,18,20,12,20,20,16,14,18,14,20,18,18,12]
TITLES=['让 PMUX 结构更紧凑','在综合流程中完成结构优化','新增命令：通过 Tcl 调用 pmux_opt','真实命令执行：本例命中了什么','识别嵌套的数据分支','合并宽数据层，重构窄控制逻辑','通用规则由保护条件约束','结构优化之后，使用统一映射配置','同一用例，比较映射后的 LUT','核对原始 stat：单元数量与寄存器','九个官方用例：完整验收记录','用同一对综合网表进行形式验证','EQY 原始日志：证明通过','源码、结果与验证记录可以复验']
CHAPTERS=['设计思路','设计思路','自定义 Tcl 命令','自定义 Tcl 命令','优化算法','优化算法','优化算法','优化算法','优化前后对比','优化前后对比','优化前后对比','EQY 形式等价验证','EQY 形式等价验证','成果与复验']
SUB=['保持电路功能等价，减少综合后的逻辑资源。','自研部分是 PMUX 结构规则与统一映射配置。','实际脚本 command_demo.tcl；通过 Yosys 官方 Tcl 桥接调用。','ZIP04 的实际执行日志节选；不把零次触发的规则计为收益。','外层 PMUX 的一个 B 数据输入，来自另一个 PMUX。','减少宽数据选择层，加入保持选择语义的窄 PMUX 控制网络。','不满足条件时保留原结构；不新增寄存器，不按用例名特判。','后端继续调用官方 ABC；全部设计采用同一组面积参数。','官方反馈型 zip_case04 · 顶层 pmux_case04_feedback','本例逻辑面积按 LUT + NOT 统计；NOT 数量为 0。','展示既有完整验收证据；不是本视频现场重跑九例。','gold 与 gate 对应前面资源对比生成的原始网表。','验证配置已披露；PASS 表示此配置下功能等价。','固定 Yosys 0.69+286 基线，保留完整证据与复验入口。']
BEATS=[[0,3,7],[0,3,6,9,12],[0,5,11],[0,4,8],[0,5,11],[0,5,11],[0,4,9],[0,4,9],[0,4,10],[0,4,9],[0,5,11],[0,5,11],[0,4,10],[0,4,8]]

def read(p):return json.loads(Path(p).read_text('utf-8-sig'))
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def save(p,v):Path(p).write_text(json.dumps(v,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
def collect():
    manifest=ROOT/'素材来源与哈希.json'
    if manifest.exists():
        for entry in read(manifest):
            assert sha(ASSETS/entry['asset'])==entry['sha256'],entry['asset']
        assert read(ASSETS/'单例EQY.json')['pass']
        assert read(ASSETS/'九例EQY.json')['pass_count']==9
        return read(ASSETS/'单例面积.json'),read(ASSETS/'九例面积.json')
    area=Path(read(DEMO/'最近面积运行.json')['directory'])
    eq=max((DEMO/'运行记录').glob('*_EQY验证'))
    cmd=min((DEMO/'运行记录').glob('*_Tcl命令'))
    mapping={
      'command_demo.tcl':DEMO/'command_demo.tcl','命令运行.log':cmd/'自定义命令.log','命令执行.json':cmd/'自定义命令_执行.json',
      'original.log':area/'original.log','optimized.log':area/'optimized.log','单例面积.json':area/'本次面积结果.json',
      '单例EQY.json':eq/'本次EQY结果.json','eqy-console.log':eq/'官方EQY结果/eqy-console.log','EQY_PASS':eq/'官方EQY结果/proof/PASS',
      '九例面积.json':PACK/'实测记录/B臂集成F4c_面积等价_01/area/summary.json',
      '九例EQY.json':PACK/'实测记录/B臂集成F4c_面积等价_01/eqy/正式EQY汇总.json',
      'pmux_opt.cc':PACK/'开发源码/passes/opt/pmux_opt.cc'}
    provenance=[]
    for name,p in mapping.items():
        dest=ASSETS/name
        if not dest.exists():shutil.copyfile(p,dest)
        assert sha(dest)==sha(p),name
        provenance.append({'asset':name,'original':str(p),'sha256':sha(dest)})
    a=read(ASSETS/'单例面积.json');e=read(ASSETS/'单例EQY.json')
    assert Path(e['area_directory'])==area and e['pass'] and e['execution']['exit_code']==0
    for role in ['original','optimized']:
        assert sha(area/(role+'.il'))==a['rows'][role]['raw_il_sha256']
    assert read(ASSETS/'九例EQY.json')['pass_count']==9
    assert read(ASSETS/'命令执行.json')['returncode']==0
    assert 'DONE (PASS, rc=0)' in (ASSETS/'eqy-console.log').read_text('utf-8')
    save(ROOT/'素材来源与哈希.json',provenance)
    return a,read(ASSETS/'九例面积.json')
A,NINE=collect()

@functools.lru_cache(None)
def font(size,mono=False):return ImageFont.truetype(MFONT if mono else YFONT,size)
def text(d,xy,s,size=36,color=INK,mono=False):
    f=font(size,mono);box=d.textbbox(xy,s,font=f)
    if box[2]>1845 or box[3]>1070:raise ValueError(('Text out of bounds',s,box))
    d.text(xy,s,font=f,fill=color)
def center(d,box,s,size=32,color=INK,mono=False):
    f=font(size,mono);b=d.textbbox((0,0),s,font=f)
    x=(box[0]+box[2]-(b[2]-b[0]))/2;y=(box[1]+box[3]-(b[3]-b[1]))/2-b[1]
    text(d,(x,y),s,size,color,mono)
def line(d,a,b,c=BLUE,width=6,arrow=True):
    d.line((a,b),fill=c,width=width)
    if arrow:
        angle=math.atan2(b[1]-a[1],b[0]-a[0]);r=17
        pts=[b,(b[0]-r*math.cos(angle-.45),b[1]-r*math.sin(angle-.45)),(b[0]-r*math.cos(angle+.45),b[1]-r*math.sin(angle+.45))]
        d.polygon(pts,fill=c)
def node(d,box,label,c=BLUE,size=32):
    d.rectangle(box,fill=WHITE,outline=c,width=4);center(d,box,label,size,c)
def base(i):
    im=Image.new('RGB',(W,H),BG);d=ImageDraw.Draw(im)
    text(d,(88,54),f'{i+1:02d}  /  {CHAPTERS[i]}',26,BLUE)
    text(d,(88,112),TITLES[i],52)
    text(d,(88,192),SUB[i],29,MUTED)
    d.line((88,994,1832,994),fill=LINE,width=2)
    text(d,(88,1016),'Yosys 0.69+286  ·  PMUX 项目介绍  ·  代码与实际日志可追溯',21,MUTED)
    text(d,(1510,1016),'无配音演示版',21,MUTED)
    return im,d
def note(d,s,y=920):text(d,(88,y),s,27,MUTED)
def stat(role):
    v=(ASSETS/(role+'.log')).read_text('utf-8')
    b=re.search(r'=== '+re.escape(A['top'])+r' ===\n(.*?)(?=\n\d+\.|\Z)',v,re.S).group(1)
    return [s for s in b.splitlines() if re.match(r'\s*\d+\s',s)]

def scene(i,stage=2,bar=1.0):
    im,d=base(i)
    if i==0:
        text(d,(140,330),'PMUX',130,BLUE,True)
        text(d,(145,500),'结构重构',86)
        if stage>=1:
            text(d,(950,355),'保持功能等价',58)
            line(d,(950,465),(1630,465),TEAL)
            text(d,(950,505),'减少逻辑资源',58,TEAL)
        if stage>=2:note(d,'官方测试 RTL  +  自研优化命令  +  官方 ABC 与 EQY',805)
    elif i==1:
        nodes=[('官方 RTL',BLUE),('Yosys 前处理',BLUE),('pmux_opt',TEAL),('官方 ABC',BLUE),('EQY 验证',BLUE)]
        for j,(name,col) in enumerate(nodes[:stage+1]):
            x=90+j*355;node(d,(x,390,x+305,550),name,col,34)
            if j:line(d,(x-50,470),(x-9,470),col)
        if stage>=2:text(d,(790,590),'自研结构变换',30,TEAL)
        if stage>=4:
            text(d,(90,730),'前处理后识别 PMUX → 重构连接 → 映射后统计 → 验证功能等价',37)
            note(d,'流程示意：EQY 比较原版与优化版生成的两份网表。')
    elif i==2:
        code=(ASSETS/'command_demo.tcl').read_text('ascii').splitlines()[1:]
        d.rectangle((88,278,1832,810),fill='#e9eef4')
        for j,s in enumerate(code):
            y=320+j*65
            if (stage==1 and j==0) or (stage>=2 and s.startswith('pmux_opt')):d.rectangle((104,y-5,1814,y+51),fill='#d2e9df')
            text(d,(124,y),s,32,INK,True)
        text(d,(90,850),'实际调用：yosys -c command_demo.tcl',33,BLUE)
        note(d,'命令已经集成到正式 synth_intel 流程；正式综合无需重复手工插入。')
    elif i==3:
        text(d,(110,310),'自定义命令的真实运行日志',34)
        if stage>=1:
            text(d,(115,390),'2',125,TEAL,True);text(d,(290,440),'次嵌套数据分支合并',44)
            text(d,(115,568),'PMUX data-arm flattening: merged 2 single-use nested data arms.',29,MUTED,True)
        if stage>=2:
            text(d,(115,655),'8',125,BLUE,True);text(d,(290,705),'处译码表重排',44)
            text(d,(115,840),'... reordered 8 decoder tables.',31,MUTED,True)
        note(d,'来源：命令运行.log；本例默认分支合并、零选择臂清理等计数为 0。')
    elif i==4:
        text(d,(100,300),'变换前 / 概念结构示意',30,BLUE)
        node(d,(390,435,735,650),'内层宽 PMUX',BLUE,36)
        text(d,(104,435),'Ai / Bi',36,INK,True);line(d,(250,505),(380,505))
        text(d,(445,730),'Si：内层选择',30);line(d,(550,712),(550,660))
        if stage>=1:
            node(d,(1175,435,1520,650),'外层宽 PMUX',BLUE,36)
            line(d,(745,540),(1165,540));text(d,(790,475),'W 位，接入 B 分支',30)
            text(d,(1125,330),'Ao / 其他数据分支',28);line(d,(1345,383),(1345,425))
            text(d,(1140,735),'t / 其他选择信号',29);line(d,(1345,716),(1345,660))
            line(d,(1530,540),(1720,540));text(d,(1750,515),'Y',43,INK,True)
        if stage>=2:
            d.rectangle((765,585,1150,653),fill=LIGHT);text(d,(795,595),'完整总线 + 单消费者',29,TEAL)
        note(d,'目标：把内层的宽数据选择并入外层，而不是改变时序状态。')
    elif i==5:
        text(d,(100,280),'变换后 / 概念结构示意',30,TEAL)
        node(d,(1110,560,1560,760),'重构后的宽 PMUX',TEAL,37)
        text(d,(100,600),'Ai、Bi、其余数据',36);line(d,(490,660),(1100,660),TEAL)
        text(d,(1015,830),'原外层默认输入 Ao 保持',29);line(d,(1335,817),(1335,770),TEAL)
        line(d,(1570,660),(1730,660),TEAL);text(d,(1760,635),'Y',44,INK,True)
        if stage>=1:
            node(d,(570,335,1000,460),'窄 PMUX 控制网络',BLUE,34)
            text(d,(145,360),'Si、t',42,INK);line(d,(330,399),(560,399))
            d.line(((1010,399),(1335,399)),fill=BLUE,width=6);line(d,(1335,399),(1335,550));text(d,(1128,337),'新选择信号 G',30,BLUE)
            text(d,(1430,448),'其余选择 So（保持）',26,BLUE);line(d,(1505,505),(1505,550))
        if stage>=2:
            text(d,(100,480),'外层未选中：屏蔽内层',30,BLUE)
            text(d,(100,535),'外层选中：转交默认数据或内层分支',30,BLUE)
        note(d,'窄控制网络继续使用 PMUX，以保持固定官方模型的 X / Z 选择行为。')
    elif i==6:
        items=[('01','连接约束','完整输出总线、单一消费者；排除不支持的切片或共享连接。'),('02','收益与规模','W > K内 + 1；合并后选择分支数量不超过 16。'),('03','运行边界','每模块 B 臂合并最多 32 次；不满足守卫则保留原结构。')]
        for j,(num,title,body) in enumerate(items[:stage+1]):
            y=315+j*176;text(d,(105,y),num,61,TEAL,True);text(d,(240,y+8),title,40);text(d,(240,y+75),body,32,MUTED)
        note(d,'通用规则依据连接与位宽判断，不使用官方用例名称作为判断条件。')
    elif i==7:
        text(d,(100,325),'PMUX 结构规则',62,TEAL)
        if stage>=1:
            text(d,(920,325),'官方 ABC 映射',62,BLUE)
            line(d,(650,385),(840,385),BLUE)
            text(d,(100,510),'全部设计采用同一配置',46)
            text(d,(100,600),'&dch -f -r; &if {W} {D} {R} -a -v -F 4 -c; &mfs',35,BLUE,True)
        if stage>=2:
            text(d,(100,755),'最终面积收益 = 结构规则与统一映射配置共同作用',39,TEAL)
        note(d,'这是项目选定的官方 ABC 参数组合，不是自研 ABC，也不冒充官方默认参数。')
    elif i==8:
        ox=450;scale=3.15
        text(d,(100,325),'逻辑资源 / LUT 数量',33)
        for yy,name,val,col in [(440,'优化前',371,BLUE),(650,'优化后',292,TEAL)]:
            text(d,(120,yy+25),name,43)
            shown=val if name=='优化前' else val*bar
            if stage>=1 or name=='优化前':
                d.rectangle((ox,yy,ox+shown*scale,yy+105),fill=col)
                text(d,(ox+shown*scale+24,yy+26),str(round(shown)),43,col,True)
        d.line((ox,410,ox,790),fill=INK,width=3)
        for v in [0,100,200,300,400]:text(d,(ox+v*scale-12,805),str(v),22,MUTED,True)
        if stage>=2:text(d,(100,900),'减少 79 个 LUT   ·   下降 21.29%',48,TEAL)
    elif i==9:
        for role,x,label,col in [('original',88,'原版 Yosys',BLUE),('optimized',980,'PMUX 优化版',TEAL)]:
            text(d,(x,280),label,36,col)
            d.rectangle((x,350,x+852,829),fill=WHITE)
            text(d,(x+24,368),'stat 原始统计段',26,MUTED)
            for j,s in enumerate(stat(role)):
                y=424+j*42
                if stage>=1 and ('cells' in s or '$lut' in s):d.rectangle((x+16,y-3,x+836,y+38),fill=LIGHT)
                text(d,(x+42,y),s,32,INK,True)
        if stage>=2:text(d,(100,865),'总 cells：387 → 308    寄存器：16 → 16    IO 位数：115 → 115',34,TEAL)
        note(d,'原始日志节选；总 cells 包含触发器，不能直接等同于 LUT 面积。',932)
    elif i==10:
        cols=[100,500,760,1040];headers=['官方用例','优化前','优化后','下降比例']
        d.rectangle((88,280,1300,342),fill='#e0e8ef')
        for x,s in zip(cols,headers):text(d,(x,291),s,28)
        for j,c in enumerate(NINE['cases']):
            y=354+j*55
            if c['case']=='zip_case04':d.rectangle((88,y-3,1300,y+47),fill=LIGHT)
            values=[c['case'],str(c['original']),str(c['optimized']),f"{c['reduction_percent']:.2f}%"]
            for x,s in zip(cols,values):text(d,(x,y),s,30,TEAL if c['case']=='zip_case04' else INK,True)
        if stage>=1:
            text(d,(1390,345),'逐例平均',32);text(d,(1380,405),'14.08%',65,TEAL,True)
            text(d,(1390,550),'总量下降',32);text(d,(1380,610),'11.47%',65,BLUE,True)
        if stage>=2:
            text(d,(100,882),'资源总量 2389 → 2115  ·  九例无反增  ·  DFF / IO 均保持',33,TEAL)
        note(d,'左表口径：LUT + NOT；逐例平均与总量下降是两个不同的统计指标。',937)
    elif i==11:
        node(d,(100,350,600,500),'原版网表：gold',BLUE,39)
        node(d,(100,640,600,790),'优化网表：gate',TEAL,39)
        if stage>=1:
            node(d,(840,445,1260,690),'一致的输入适配',BLUE,35)
            line(d,(610,425),(830,500));line(d,(610,715),(830,625),TEAL)
        if stage>=2:
            node(d,(1490,445,1810,690),'官方 EQY',TEAL,43);line(d,(1270,568),(1480,568),TEAL)
            text(d,(1380,740),'SAT 归纳验证',32,TEAL)
        note(d,'适配：受限 dffeas 逆适配；opt_clean; setundef -zero -init。',890)
        note(d,'在已披露的归一化配置下比较功能；已知初始值保持不变。',938)
    elif i==12:
        raw=(ASSETS/'eqy-console.log').read_text('utf-8').strip().splitlines()
        relevant=[s for s in raw if 'Successfully proved designs equivalent' in s or 'DONE (PASS' in s]
        text(d,(100,280),'eqy-console.log / 实际运行日志节选',28,MUTED)
        d.rectangle((88,350,1832,565),fill=WHITE)
        text(d,(120,385),relevant[0],31,INK,True)
        if stage>=1:text(d,(120,472),relevant[1],37,TEAL,True)
        if stage>=2:
            text(d,(110,645),'PASS',100,TEAL,True)
            text(d,(560,675),'验证配置下，优化前后网表功能等价',42)
            text(d,(560,760),'退出码 0  ·  PASS 文件存在  ·  输入哈希对应',31,MUTED)
        note(d,'验证范围：ABC 后网表，经受限触发器适配和初值 / 未知值归一化后验证。')
    elif i==13:
        metrics=[('14.08%','九例逐例平均面积下降',TEAL),('9 / 9','官方用例 EQY 通过',BLUE),('0','新增寄存器',TEAL)]
        for j,(val,lab,col) in enumerate(metrics[:stage+1]):
            x=100+600*j;text(d,(x,365),val,92,col,True);text(d,(x,520),lab,31)
        if stage>=2:
            text(d,(100,740),'可调用的命令  ·  通用结构规则  ·  完整源码与原始验证记录',39)
            text(d,(100,840),'pmux_opt',43,TEAL,True)
        note(d,'EQY 结论对应前述适配与归一化配置；公开用例结果不代表组委会最终认证。')
    return im

def timeline():
    start=0;items=[]
    for i,seconds in enumerate(DUR):
        frames=seconds*FPS
        events=[{'start_frame':start+round(t*FPS),'settled_frame':start+round(t*FPS)+8,'hold_end_frame':start+round((BEATS[i][j+1] if j+1<len(BEATS[i]) else seconds)*FPS),'stage':j} for j,t in enumerate(BEATS[i])]
        items.append({'id':i,'title':TITLES[i],'chapter':CHAPTERS[i],'start':start/FPS,'end':(start+frames)/FPS,'start_frame':start,'end_frame':start+frames,'duration':seconds,'events':events,'content_type':'authored graphic with cited real evidence'})
        start+=frames
    return items
def make_frames():
    contact=Image.new('RGB',(1920,math.ceil(len(DUR)/3)*360),WHITE)
    for i in range(len(DUR)):
        im=scene(i,len(BEATS[i])-1);im.save(FRAMES/f'{i+1:02d}_{CHAPTERS[i]}.png')
        small=im.resize((640,360),Image.Resampling.LANCZOS);contact.paste(small,((i%3)*640,(i//3)*360))
    contact.save(QA/'全片画面总览.jpg',quality=92)
    save(ROOT/'视频时间轴.json',timeline())
    save(ROOT/'制作配置.json',{'width':W,'height':H,'fps':FPS,'duration_seconds':sum(DUR),'audio':'none; user will record later','style':'Swiss precision: navy typography, blue baseline, teal optimized result, measured bars and engineering diagrams','fonts':[YFONT,MFONT],'animation':'short state reveals; stable reading holds; hard chapter cuts','source_note':'Not a terminal recording; actual saved code and logs are reproduced as labelled evidence panels.','color':'sRGB artwork converted to limited-range Rec.709','excluded':'fake terminal UI, fabricated live timing, invented PASS, benchmark name-specific rules'})
    print('Frames and timeline ready.',flush=True)
def ffmpeg():
    paths=list((ROOT/'制作工具/imageio_ffmpeg/binaries').glob('ffmpeg*.exe'))
    if len(paths)!=1:raise RuntimeError('Expected one project-local FFmpeg binary')
    return str(paths[0])
def encode():
    make_frames();dest=ROOT/'PMUX作品介绍_无配音_1080P.mp4'
    if dest.exists():raise FileExistsError(dest)
    args=[ffmpeg(),'-hide_banner','-nostdin','-y','-f','rawvideo','-pix_fmt','rgb24','-s','1920x1080','-r',str(FPS),'-i','pipe:0','-an','-vf','scale=in_range=pc:out_range=tv:out_color_matrix=bt709,format=yuv420p','-c:v','libx264','-preset','veryfast','-crf','18','-threads','4','-color_primaries','bt709','-color_trc','bt709','-colorspace','bt709','-color_range','tv','-movflags','+faststart',str(dest)]
    save(QA/'编码命令.json',args)
    with (QA/'编码日志.txt').open('wb') as log:
        proc=subprocess.Popen(args,stdin=subprocess.PIPE,stderr=log,stdout=subprocess.DEVNULL,creationflags=subprocess.CREATE_NO_WINDOW)
        try:
            for i,seconds in enumerate(DUR):
                states=[scene(i,j) for j in range(len(BEATS[i]))];cache=[v.tobytes() for v in states]
                for f in range(seconds*FPS):
                    t=f/FPS;j=max(k for k,b in enumerate(BEATS[i]) if b<=t);local=f-round(BEATS[i][j]*FPS)
                    if i==8 and j==1 and local<36:
                        u=min(1,local/35);u=1-(1-u)**3;data=scene(i,j,bar=u).tobytes()
                    elif j>0 and local<8:
                        data=Image.blend(states[j-1],states[j],(local+1)/8).tobytes()
                    else:data=cache[j]
                    proc.stdin.write(data)
                print(f'Scene {i+1:02d}/14 encoded.',flush=True)
        finally:proc.stdin.close()
        code=proc.wait()
        if code:raise RuntimeError('FFmpeg failed; see 编码日志.txt')
    # Full decode catches truncation and corrupt frames without running EDA again.
    check=subprocess.run([ffmpeg(),'-v','error','-i',str(dest),'-map','0:v:0','-f','null','-'],capture_output=True,creationflags=subprocess.CREATE_NO_WINDOW)
    (QA/'全片解码检查.txt').write_bytes(check.stderr)
    if check.returncode or check.stderr:raise RuntimeError('Decode validation failed')
    # FFmpeg input metadata, plus a counted decode, provides observable runtime/frame evidence.
    info=subprocess.run([ffmpeg(),'-hide_banner','-i',str(dest),'-map','0:v:0','-f','null','-'],capture_output=True,creationflags=subprocess.CREATE_NO_WINDOW)
    metadata=info.stderr.decode('utf-8','replace');(QA/'视频元数据与帧数.txt').write_text(metadata,encoding='utf-8')
    assert '1920x1080' in metadata and '24 fps' in metadata and '00:03:52' in metadata
    assert re.search(r'frame=\s*5568',metadata),metadata[-2000:]
    assert 'Audio:' not in metadata
    save(QA/'成品核验.json',{'file':dest.name,'bytes':dest.stat().st_size,'sha256':sha(dest),'width':W,'height':H,'fps':FPS,'frames':sum(DUR)*FPS,'duration_seconds':sum(DUR),'audio_tracks':0,'full_decode_exit':check.returncode,'evidence_hashes_verified':True,'visual_review':'representative frame and transitions reviewed separately; no audible track'})
    print('VIDEO_READY '+str(dest),flush=True)

if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--frames',action='store_true');p.add_argument('--render',action='store_true');args=p.parse_args()
    if args.render:encode()
    else:make_frames()
