from pathlib import Path
import json,subprocess,zipfile,hashlib,math
from PIL import Image
import 制作增强版 as v
root=Path(__file__).resolve().parent;qa=root/'检查记录';fd=qa/'成片关键帧';fd.mkdir(exist_ok=True)
video=root/'PMUX作品介绍_三分钟增强版_无配音.mp4'
timeline=json.loads((root/'视频时间轴.json').read_text('utf-8'))
speech=json.loads((root/'配音稿_段落.json').read_text('utf-8'))
assert [(t['start'],t['end']) for t in timeline]==[(t['start'],t['end']) for t in speech]
assert timeline[-1]['end']==174
for t in timeline:
    subprocess.run([v.ffmpeg(),'-v','error','-y','-ss',str(t['end']-1),'-i',str(video),'-frames:v','1',str(fd/f"{t['id']+1:02d}.png")],check=True,capture_output=True,creationflags=subprocess.CREATE_NO_WINDOW)
sheet=Image.new('RGB',(1920,1440),'white')
for i,p in enumerate(sorted(fd.glob('*.png'))):sheet.paste(Image.open(p).resize((640,360)),((i%3)*640,(i//3)*360))
sheet.save(qa/'成片关键帧总览.jpg',quality=94)
samples=[100,100.25,100.5,101,101.25,115.96,116,116.25,117]
motion=Image.new('RGB',(1920,1080),'white')
for i,sec in enumerate(samples):
    p=fd/f'运动_{i:02d}.png'
    subprocess.run([v.ffmpeg(),'-v','error','-y','-ss',str(sec),'-i',str(video),'-frames:v','1',str(p)],check=True,capture_output=True,creationflags=subprocess.CREATE_NO_WINDOW)
    motion.paste(Image.open(p).resize((640,360)),((i%3)*640,(i//3)*360))
motion.save(qa/'动态与转场采样.jpg',quality=93)
paths=[video]+list(root.glob('*.py'))+list(root.glob('*.txt'))+list(root.glob('*.json'))
paths+=list((root/'证据素材').iterdir())+list((root/'画面素材').glob('*.png'))+list((root/'文档截图').glob('*.png'))+list((root/'文档截图').glob('*.json'))
paths+=[qa/'成品核验.json',qa/'成片关键帧总览.jpg',qa/'全片解码与元数据.txt']
dest=root/'PMUX三分钟增强版_视频与配音素材.zip'
with zipfile.ZipFile(dest,'w',zipfile.ZIP_DEFLATED,compresslevel=6) as z:
    for p in paths:z.write(p,p.relative_to(root))
with zipfile.ZipFile(dest) as z:assert z.testzip() is None
manifest={'duration_seconds':174,'video_bytes':video.stat().st_size,'video_sha256':hashlib.sha256(video.read_bytes()).hexdigest(),'zip_bytes':dest.stat().st_size,'zip_sha256':hashlib.sha256(dest.read_bytes()).hexdigest(),'chapters':12,'document_screenshots':7,'dimensions':[1920,1080],'fps':24,'frames':4176,'audio_tracks':0,'under_three_minutes':True,'voice_script_intervals_match':True,'realtime_player_review':False}
(qa/'交付清单.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps(manifest,ensure_ascii=False))
