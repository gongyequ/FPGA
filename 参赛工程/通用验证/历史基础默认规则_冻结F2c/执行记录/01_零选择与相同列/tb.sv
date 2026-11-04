`timescale 1ns/1ps
module tb;
reg [1:0]a,b,c,s;reg [256:0]wa;reg ws;
integer pattern,code,i,phase,errors=0,samples=0,seed=6913;
function fourstate;input integer x;begin case(x)0:fourstate=0;1:fourstate=1;2:fourstate=1'bx;3:fourstate=1'bz;endcase end endfunction
wire [1:0]r0,c0;zero_mid_ref r_0(a,b,c,s,r0);zero_mid_cand c_0(a,b,c,s,c0);
wire [1:0]r1,c1;zero_one_ref r_1(a,b,c,s,r1);zero_one_cand c_1(a,b,c,s,c1);
wire [1:0]r2,c2;zero_all_ref r_2(a,b,c,s,r2);zero_all_cand c_2(a,b,c,s,c2);
wire [1:0]r3,c3;same_default_ref r_3(a,b,c,s,r3);same_default_cand c_3(a,b,c,s,c3);
wire [3:0]r4,c4;columns_ref r_4(a,b,c,s,r4);columns_cand c_4(a,b,c,s,c4);
wire [258:0]wr,wc;wide_ref wide_r(wa,ws,wr);wide_cand wide_c(wa,ws,wc);
initial begin wa=0;ws=0;
 for(pattern=0;pattern<65536;pattern=pattern+1)begin
  code=pattern;
  for(i=0;i<2;i=i+1)begin a[i]=fourstate(code%4);code=code/4;end
  for(i=0;i<2;i=i+1)begin b[i]=fourstate(code%4);code=code/4;end
  for(i=0;i<2;i=i+1)begin c[i]=fourstate(code%4);code=code/4;end
  for(i=0;i<2;i=i+1)begin s[i]=fourstate(code%4);code=code/4;end
  #1;
if(r0 !== c0)begin errors=errors+1;if(errors<8)$display("DIFF zero_mid a=%b b=%b c=%b s=%b r=%b c=%b",a,b,c,s,r0,c0);end
if(r1 !== c1)begin errors=errors+1;if(errors<8)$display("DIFF zero_one a=%b b=%b c=%b s=%b r=%b c=%b",a,b,c,s,r1,c1);end
if(r2 !== c2)begin errors=errors+1;if(errors<8)$display("DIFF zero_all a=%b b=%b c=%b s=%b r=%b c=%b",a,b,c,s,r2,c2);end
if(r3 !== c3)begin errors=errors+1;if(errors<8)$display("DIFF same_default a=%b b=%b c=%b s=%b r=%b c=%b",a,b,c,s,r3,c3);end
if(r4 !== c4)begin errors=errors+1;if(errors<8)$display("DIFF columns a=%b b=%b c=%b s=%b r=%b c=%b",a,b,c,s,r4,c4);end
  samples=samples+5;
 end
 for(pattern=0;pattern<16;pattern=pattern+1)begin
  if(pattern<4)wa={257{fourstate(pattern)}};
  else for(i=0;i<257;i=i+1)wa[i]=$random(seed);
  for(phase=0;phase<4;phase=phase+1)begin ws=fourstate(phase);#1;
   if(wr !== wc)begin errors=errors+1;$display("WIDE_DIFF");end
   samples=samples+1;
  end
 end
 $display("RESULT samples=%0d errors=%0d",samples,errors);
 if(errors)$fatal(1,"FAIL");$display("PASS");$finish;
end
endmodule
