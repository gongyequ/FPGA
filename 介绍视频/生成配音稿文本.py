from pathlib import Path
import json,re

root=Path(__file__).resolve().parent
rows=json.loads((root/'配音稿_段落.json').read_text('utf-8'))
def fmt(s):return f'{int(s)//60:02d}:{int(s)%60:02d}'
txt='''PMUX作品介绍｜三分钟增强版配音稿
总时长：2分54秒，共12段。
以下时间对应无配音视频的预设镜头区间，供后期录音使用，不是已录语音的自动对齐结果。
英文命令可直接展示在画面中，无需逐字念参数；技术缩写按自己的口播习惯读。

'''
txt+='\n\n'.join(f"{i+1:02d}  {fmt(r['start'])}–{fmt(r['end'])}\n{r['text']}" for i,r in enumerate(rows))
(root/'配音稿_带时间点.txt').write_text(txt+'\n',encoding='utf-8-sig')
dur=[r['end']-r['start'] for r in rows]
assert dur==[10,14,18,12,18,16,12,16,16,16,16,10]
assert rows[-1]['end']==174
print('hanzi',sum(len(re.findall(r'[\u4e00-\u9fff]',r['text'])) for r in rows))
print('chars',sum(len(r['text']) for r in rows))
print('durations',dur)
print('BOM',(root/'配音稿_带时间点.txt').read_bytes()[:3].hex())
