"""174-second silent PMUX explainer with genuine design-document extracts."""
from pathlib import Path
import sys,json,subprocess,hashlib,argparse,math,re
sys.path.insert(0,str(Path(__file__).resolve().parent/'制作工具'))
from PIL import Image,ImageDraw,ImageFont
import 基础渲染 as b

ROOT=Path(__file__).resolve().parent
DOC=ROOT/'文档截图';A=ROOT/'证据素材';QA=ROOT/'检查记录';FR=ROOT/'画面素材'
for p in [QA,FR]:p.mkdir(exist_ok=True)
DUR=[10,14,18,12,18,16,12,16,16,16,16,10]
TITLES=['保持功能等价，减少 PMUX 逻辑资源','设计方案：双路径综合与验证架构','自定义 Tcl 命令与四个正式开关','命令注册与实际执行记录','设计方案：嵌套数据分支如何重构','控制公式：保留默认、多选与未知行为','实现细节：连接保护、成本约束与预算','ZIP04：同时核对面积、寄存器与接口','公开九例：文档结果与统计口径对应','形式验证方案：输入、适配与证明范围','实际 EQY 结果：在所示配置下功能等价','可调用、可检查、可复验的交付成果']
SUB=['官方 Yosys 0.69+286 基线 · 通用 PMUX 变换 · 无配音介绍视频','原版与优化版保持相同输入和工具基线，在同一截面比较结果。','读取真实脚本；正式 synth_intel 已集成此命令，无需重复手工插入。','以下源码与计数均来自已交付版本及实际运行日志。','消除一个宽数据选择层，增加窄 PMUX 控制网络。','P(A,B,S) 表示固定官方 PMUX 模型；Ai / Bi / Si 为内层端口。','算法依据连接与位宽判断，不以用例名称作为条件。','同一官方反馈型用例 · 相同默认参数 · 映射后资源计数','九例表来自已完成验收；平均降幅与总量降幅分别计算。','gold / gate 使用前述综合生成的同一对真实网表。','真实工具日志、退出码、PASS 文件和输入身份共同核查。','完整源码、正式设计文档、原始日志与复验入口一并保留。']
CH=['设计目标','整体架构','Tcl 命令','源码与日志','嵌套变换','控制语义','工程实现','单例对比','九例汇总','验证方案','验证结果','交付成果']
b.DUR=DUR;b.TITLES=TITLES;b.SUB=SUB;b.CHAPTERS=CH;b.BEATS=[[0,3,6] for _ in DUR]
text=b.text;center=b.center;line=b.line;node=b.node
INK=b.INK;BLUE=b.BLUE;TEAL=b.TEAL;MUTED=b.MUTED;WHITE=b.WHITE;LIGHT=b.LIGHT
def foot(d,s):text(d,(88,943),s,24,MUTED)
def para(d,x,y,lines,size=30,color=INK,step=48):
    for j,s in enumerate(lines):text(d,(x,y+j*step),s,size,color)
def panel(d,box,title,accent=BLUE):
    d.rectangle(box,fill=WHITE,outline='#d3dee3',width=2)
    d.rectangle((box[0],box[1],box[0]+7,box[3]),fill=accent)
    text(d,(box[0]+24,box[1]+15),title,28,accent)
def doc(im,d,name,box,label,highlight=False):
    img=Image.open(DOC/name).convert('RGB')
    if name=='01_整体架构.png':img=img.crop((0,0,img.width,790))
    avail=(box[2]-box[0]-20,box[3]-box[1]-52)
    ratio=min(avail[0]/img.width,avail[1]/img.height)
    scaled=img.resize((round(img.width*ratio),round(img.height*ratio)),Image.Resampling.LANCZOS)
    d.rectangle(box,fill=WHITE,outline=TEAL if highlight else '#c8d4df',width=4 if highlight else 2)
    text(d,(box[0]+14,box[1]+9),label,23,TEAL if highlight else MUTED)
    x=box[0]+(box[2]-box[0]-scaled.width)//2;y=box[1]+43+(avail[1]-scaled.height)//2
    im.paste(scaled,(x,y))
def code_excerpt(lines,start,end):return '\n'.join(lines[start-1:end])
SRC=(A/'pmux_opt.cc').read_text('utf-8').splitlines()
REG=code_excerpt(SRC,22,23)
def scene(i,stage=2,bar=1):
    im,d=b.base(i)
    if i==0:
        text(d,(100,298),'PMUX 结构优化器',67,INK)
        para(d,105,400,['输入：官方九个测试 RTL','实现：自研 pmux_opt + 统一 ABC 配置','目标：减少映射后的 LUT + NOT'],35,step=70)
        text(d,(105,655),'14.08%',85,TEAL,True);text(d,(700,655),'9 / 9',85,BLUE,True)
        text(d,(105,760),'九例逐例平均面积下降',30);text(d,(700,760),'EQY 通过',30)
        doc(im,d,'00_设计文档首页.png',(1250,265,1830,925),'正式设计文档 / 第 1 页',stage==2)
        foot(d,'基于真实代码、文档与运行记录制作；画面为讲解编排，不是现场终端录屏。')
    elif i==1:
        doc(im,d,'01_整体架构.png',(88,270,1275,920),'正式设计文档 / 第 2 页 / 图 1 局部',stage==0)
        for j,(title,lines) in enumerate([
          ('固定输入与基线',['官方 RTL 与默认参数一致','同一 Yosys / ABC 基线']),
          ('自研插入位置',['peepopt、opt_clean 之后','cmp2lut 之前执行 pmux_opt']),
          ('统一评价截面',['面积 / EQY：ABC 之后','最终 map_cells 之前'])]):
            x=1313;y=270+j*225;panel(d,(x,y,1832,y+201),title,TEAL if stage==j else BLUE);para(d,x+24,y+66,lines,26,step=48)
        foot(d,'性能测试另行执行完整综合；本视频重点展示设计、面积与等价验证。')
    elif i==2:
        code=(A/'command_demo.tcl').read_text('ascii').splitlines()[1:]
        panel(d,(88,268,1832,687),'command_demo.tcl / 实际脚本')
        for j,s in enumerate(code):
            y=324+j*52
            if (stage==0 and j==0) or (stage>0 and s.startswith('pmux_opt')):d.rectangle((106,y-1,1815,y+46),fill=LIGHT)
            text(d,(122,y),s,30,INK,True)
        roles=[('-order-decode','译码分支稳定排序'),('-flatten-fallback','嵌套默认分支合并'),('-uniform-abc','统一官方 ABC 参数'),('-flatten-data-arm','嵌套数据分支合并')]
        for j,(flag,label) in enumerate(roles):
            x=88+j*441;panel(d,(x,720,x+419,889),label,TEAL if stage==2 else BLUE);text(d,(x+20,795),flag,25,INK,True)
        foot(d,'yosys -import 导入注册命令；实际入口为 yosys -c command_demo.tcl。')
    elif i==3:
        panel(d,(88,268,1832,446),'源码注册 / passes/opt/pmux_opt.cc : 22–23')
        for j,s in enumerate(REG.splitlines()):text(d,(116,327+48*j),s,29,INK,True)
        panel(d,(88,477,912,690),'B 数据分支嵌套合并',TEAL);text(d,(115,530),'2',88,TEAL,True);text(d,(260,558),'次实际命中',39)
        panel(d,(950,477,1832,690),'译码表重排',BLUE);text(d,(980,530),'8',88,BLUE,True);text(d,(1125,558),'处实际命中',39)
        panel(d,(88,721,1832,902),'原始日志节选',TEAL if stage==2 else BLUE)
        text(d,(118,775),'PMUX data-arm flattening: merged 2 single-use nested data arms.',30,INK,True)
        text(d,(118,827),'... reordered 8 decoder tables.',30,INK,True)
        foot(d,'本例默认分支合并、零选择臂清理和同列共享计数为 0；不将其计为本例收益。')
    elif i==4:
        doc(im,d,'02_B臂变换图.png',(88,269,1290,920),'正式设计文档 / 第 4 页 / 图 2',stage==0)
        labels=[('连接前提',['内层完整总线','只由该外层 B 臂消费']),('数据改写',['Ai / Bi 并入','外层宽数据选择']),('控制保留',['新 G 与原外层','其余 So 同时保留'])]
        for j,(a,c) in enumerate(labels):
            x=1328;y=270+j*225;panel(d,(x,y,1832,y+201),a,TEAL if stage==j else BLUE);para(d,x+24,y+66,c,28,step=48)
        foot(d,'PMUX 总数不一定减少；优化目标是最终映射后的逻辑资源，而非中间单元个数。')
    elif i==5:
        doc(im,d,'03_B臂控制公式.png',(88,270,956,650),'正式设计文档 / 第 4 页 / 控制公式',stage==0)
        panel(d,(88,682,956,904),'公式含义',TEAL)
        para(d,112,743,['h：检测内层默认分支命中','G：使用目标选择 t 门控 [h, Si]','Ao 和原外层其余数据 / So 保持'],29,step=46)
        panel(d,(995,270,1832,904),'选择行为 / 固定官方四态模型')
        cases=[('t = 0 / Z','屏蔽内层，不泄漏其未知状态'),('t = 1，Si 无 1 / X','默认命中 h 选择 Ai'),('t = 1，Si 单选且无 X','转交对应 Bi 数据'),('t = X，或选中内层含 X / 多选','保留相应未知传播行为')]
        for j,(a,c) in enumerate(cases):
            y=347+j*130
            if (j//2)==stage-1:d.rectangle((1012,y-7,1816,y+99),fill=LIGHT)
            text(d,(1020,y),a,30,BLUE);text(d,(1020,y+52),c,28)
        foot(d,'控制网络使用窄 PMUX；被选中的数据不布尔化，保留数据中的 Z。')
    elif i==6:
        doc(im,d,'04_执行流程.png',(1045,270,1832,904),'正式设计文档 / 第 5 页 / 图 3',stage==1)
        panel(d,(88,270,1007,549),'结构保护与工程预算',TEAL)
        para(d,115,334,['完整输出、单一消费者，排除不支持连接','W > K内 + 1；合并后选择臂数 ≤ 16','每模块 B 臂合并最多 32 次，改写后重建连接'],29,step=61)
        panel(d,(88,582,1007,904),'源码 206–207 行 / 为显示调整换行')
        block=['if (width <= inner_count + 1 ||','    outer_count + inner_count > 16)','    continue;']
        for j,s in enumerate(block):text(d,(117,654+j*49),s,29,INK,True)
        text(d,(116,825),'守卫失败即跳过；后端统一官方 ABC 参数',27,TEAL)
        text(d,(116,866),'整体收益包含结构规则与映射配置的作用',27)
        foot(d,'工程边界：不新增寄存器、不按用例名特判；统一 ABC 设置不冒充官方默认参数。')
    elif i==7:
        panel(d,(88,270,1110,668),'逻辑资源：LUT + NOT（本例 NOT = 0）')
        for j,(label,value,col) in enumerate([('优化前',371,BLUE),('优化后',292,TEAL)]):
            y=370+j*139;text(d,(116,y+16),label,32)
            shown=value if j==0 else value*bar
            d.rectangle((310,y,310+shown*1.82,y+78),fill=col)
            text(d,(310+shown*1.82+18,y+15),str(round(shown)),36,col,True)
        d.line((310,349,310,625),fill=INK,width=3);text(d,(305,632),'0',20,MUTED,True)
        panel(d,(1150,270,1832,668),'原始 stat 与接口核对',TEAL)
        for j,s in enumerate(['总 cells    387 → 308','dffeas       16 → 16','IO 位数      115 → 115']):text(d,(1180,365+j*91),s,35,INK)
        text(d,(100,739),'减少 79 个 LUT',61,TEAL);text(d,(1080,739),'下降 21.29%',61,TEAL)
        text(d,(100,851),'完整结构优化 + 统一 ABC 参数；两版使用相同输入和默认参数。',34)
        foot(d,'证据：original.log、optimized.log、单例面积.json；总 cells 包含 16 个触发器。')
    elif i==8:
        doc(im,d,'06_实测对照.png',(88,270,1245,910),'正式设计文档 / 第 9 页 / 九例实测表',stage==0)
        for y,val,label,col in [(291,'14.08%','逐例下降率的算术平均',TEAL),(516,'11.47%','总资源数量的下降比例',BLUE)]:
            text(d,(1310,y),val,67,col,True);text(d,(1300,y+100),label,26)
        para(d,1300,763,['总量：2389 → 2115','九例均无面积反增','DFF 与 IO 均保持'],29,step=49)
        foot(d,'数据来自既有完整验收；两种比例不混用，RAR1 / RAR3 为零收益但无反增。')
    elif i==9:
        doc(im,d,'05_EQY验证策略.png',(900,270,1832,903),'正式设计文档 / 第 8 页 / 7.3 验证范围',stage==1)
        node(d,(88,290,785,393),'gold / gate：同一对真实综合网表',BLUE,30)
        line(d,(438,405),(438,445))
        node(d,(88,457,785,575),'受限 dffeas 逆适配',BLUE,33)
        line(d,(438,587),(438,626))
        node(d,(88,638,785,756),'清理与初值 / 未知值归一化',BLUE,30)
        line(d,(438,768),(438,807),TEAL)
        node(d,(88,819,785,906),'官方 EQY：SAT 归纳验证',TEAL,31)
        foot(d,'配置：opt_clean; setundef -zero -init；已知初始值保持不变。')
    elif i==10:
        raw=(A/'eqy-console.log').read_text('utf-8').splitlines()
        lines=[s for s in raw if 'Successfully proved designs equivalent' in s or 'DONE (PASS' in s]
        panel(d,(88,270,1832,490),'eqy-console.log / 真实工具输出',TEAL)
        for j,s in enumerate(lines):text(d,(115,337+j*76),s,33,TEAL if j else INK,True)
        checks=[('退出码','0'),('PASS 文件','存在'),('网表 SHA-256','对应')]
        for j,(a,c) in enumerate(checks):
            x=88+j*590;panel(d,(x,528,x+564,728),a,TEAL if j==stage else BLUE);text(d,(x+27,600),c,53,TEAL)
        text(d,(100,774),'九个官方用例 EQY：9 / 9 PASS',45,TEAL)
        text(d,(100,856),'结论是验证配置下功能等价；网表结构和单元数量已经改变。',32)
        foot(d,'不将归一化后的证明扩大为未经处理的全四态、RTL 到最终器件的全链路证明。')
    elif i==11:
        doc(im,d,'00_设计文档首页.png',(88,270,610,909),'正式设计文档 / 第 1 页',stage==0)
        panel(d,(650,270,1832,539),'工程交付内容',TEAL)
        para(d,679,335,['自研代码：pmux_opt.cc 及综合接入','设计说明：原理、架构、模块接口与测试方案','验证材料：原始统计、实际 EQY 与输入 / 工具哈希'],32,step=62)
        panel(d,(650,570,1832,760),'正式代码包中的复验入口')
        text(d,(679,647),'python 一键复验.py --阶段 等价',38,INK)
        text(d,(679,813),'14.08% 平均面积下降    9 / 9 EQY 通过',42,TEAL)
        foot(d,'公开用例结果限于已披露配置；完整材料便于复现、检查与答辩。')
    return im
b.scene=scene

def ffmpeg():
    for folder in [ROOT/'制作工具/imageio_ffmpeg/binaries',ROOT.parent/'视频制作_20261104/制作工具/imageio_ffmpeg/binaries']:
        paths=list(folder.glob('ffmpeg*.exe'))
        if len(paths)==1:return str(paths[0])
    raise RuntimeError('Install imageio-ffmpeg in 制作工具')
def prepare():
    b.make_frames()
    config=b.read(ROOT/'制作配置.json');config.update(duration_seconds=174,slides=12,source_note='Actual submitted PDF pages rendered and cropped; source code and saved execution records. Not a live terminal recording.',edit_method='Re-authored 12 scenes; no global speed change.',pdf_extracts=b.read(DOC/'截图来源.json'),display_crop_overrides={'01_整体架构.png':[0,0,1315,790]})
    b.save(ROOT/'制作配置.json',config)
    assert [(r['start'],r['end']) for r in b.timeline()]==[(r['start'],r['end']) for r in b.read(ROOT/'配音稿_段落.json')]
def encode():
    prepare();dest=ROOT/'PMUX作品介绍_三分钟增强版_无配音.mp4'
    if dest.exists():raise FileExistsError(dest)
    args=[ffmpeg(),'-hide_banner','-nostdin','-f','rawvideo','-pix_fmt','rgb24','-s','1920x1080','-r','24','-i','pipe:0','-an','-vf','scale=in_range=pc:out_range=tv:out_color_matrix=bt709,format=yuv420p','-c:v','libx264','-preset','veryfast','-crf','17','-threads','4','-color_primaries','bt709','-color_trc','bt709','-colorspace','bt709','-color_range','tv','-movflags','+faststart',str(dest)]
    b.save(QA/'编码命令.json',args)
    with (QA/'编码日志.txt').open('wb') as log:
        p=subprocess.Popen(args,stdin=subprocess.PIPE,stdout=subprocess.DEVNULL,stderr=log,creationflags=subprocess.CREATE_NO_WINDOW)
        try:
            for i,seconds in enumerate(DUR):
                states=[scene(i,j) for j in range(3)];cache=[s.tobytes() for s in states]
                for f in range(seconds*24):
                    t=f/24;j=0 if t<3 else (1 if t<6 else 2);local=f-[0,72,144][j]
                    if i==7 and f<30:
                        u=1-(1-f/29)**3;data=scene(i,j,u).tobytes()
                    elif j>0 and local<6:data=Image.blend(states[j-1],states[j],(local+1)/6).tobytes()
                    else:data=cache[j]
                    p.stdin.write(data)
                print(f'Scene {i+1:02d}/12 encoded',flush=True)
        finally:p.stdin.close()
        if p.wait():raise RuntimeError('Encoding failed')
    res=subprocess.run([ffmpeg(),'-hide_banner','-i',str(dest),'-map','0:v:0','-f','null','-'],capture_output=True,creationflags=subprocess.CREATE_NO_WINDOW)
    meta=res.stderr.decode('utf-8','replace');(QA/'全片解码与元数据.txt').write_text(meta,encoding='utf-8')
    assert res.returncode==0 and '1920x1080' in meta and '24 fps' in meta and '00:02:54' in meta
    assert re.search(r'frame=\s*4176',meta) and 'Audio:' not in meta
    err=subprocess.run([ffmpeg(),'-v','error','-i',str(dest),'-f','null','-'],capture_output=True,creationflags=subprocess.CREATE_NO_WINDOW)
    assert err.returncode==0 and not err.stderr
    b.save(QA/'成品核验.json',{'file':dest.name,'duration_seconds':174,'frames':4176,'fps':24,'resolution':[1920,1080],'audio_tracks':0,'full_decode_exit':0,'bytes':dest.stat().st_size,'sha256':b.sha(dest),'real_time_player_review':False,'review':'encoded keyframes and transition samples'})
    print('VIDEO_READY',flush=True)
if __name__=='__main__':
    parser=argparse.ArgumentParser();parser.add_argument('--render',action='store_true');args=parser.parse_args()
    if args.render:encode()
    else:prepare()
