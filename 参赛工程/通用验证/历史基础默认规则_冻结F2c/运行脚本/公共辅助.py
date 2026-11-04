"""Small standalone helpers for the final default-rule regressions only."""
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
PROJECT=ROOT.parent.parent
SUITE=PROJECT/'suite'
def write(path,text):path.write_text(text,encoding='utf-8')
def pmux(a,b,s,y,width,sw):
    return f'''  cell $pmux \\p
    parameter \\WIDTH {width}
    parameter \\S_WIDTH {sw}
    connect \\A {a}
    connect \\B {b}
    connect \\S {s}
    connect \\Y {y}
  end
'''
def make_module(name,n,codes,mode):
    sw=len(codes)
    result=f'''module \\{name}
  wire width {n} input 1 \\ctrl
  wire width 4 input 2 \\a
  wire width {sw*4} input 3 \\b
  wire width 4 output 4 \\y
  wire width {sw} \\decoded
'''
    for i,value in enumerate(codes):
        signed=mode.startswith('signed')
        if signed:
            number=value if value<2**(n-1) else value-2**n
            width=next(w for w in range(1,n+1) if -(2**(w-1))<=number<2**(w-1))
        else:width=max(1,value.bit_length())
        literal=f"{width}'{value&((1<<width)-1):0{width}b}"
        aw,bw,aa,bb=n,width,'\\ctrl',literal
        if mode.endswith('swapped'):aw,bw,aa,bb=bw,aw,bb,aa
        result+=f'''  cell $eq \\e{i}
    parameter \\A_WIDTH {aw}
    parameter \\B_WIDTH {bw}
    parameter \\Y_WIDTH 1
    parameter \\A_SIGNED {int(signed)}
    parameter \\B_SIGNED {int(signed)}
    connect \\A {aa}
    connect \\B {bb}
    connect \\Y \\decoded [{i}]
  end
'''
    return result+pmux('\\a','\\b','\\decoded','\\y',4,sw)+'end\n'
