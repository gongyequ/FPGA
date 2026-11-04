module tb;
integer step,j,seed=69042026,mode,target,rv;
integer vectors=0,bit_compares=0,known_bits=0,x_bits=0,z_bits=0,errors=0;
function state4;input integer v;begin case(v&3) 0:state4=0;1:state4=1;2:state4=1'bx;3:state4=1'bz;endcase end endfunction
reg [11:0] a0;
reg [35:0] b0;
reg [2:0] s0;
reg [11:0] a1;
reg [35:0] b1;
reg [2:0] s1;
reg [11:0] a2;
reg [35:0] b2;
reg [2:0] s2;
reg [35:0] b3;
reg [2:0] s3;
reg [11:0] a4;
reg [35:0] b4;
reg [2:0] s4;
reg [11:0] a5;
reg [35:0] b5;
reg [2:0] s5;
reg [35:0] b6;
reg [2:0] s6;
reg [11:0] a7;
reg [35:0] b7;
reg [2:0] s7;
reg [11:0] a8;
reg [35:0] b8;
reg [2:0] s8;
reg [35:0] b9;
reg [2:0] s9;
reg [11:0] a10;
reg [35:0] b10;
reg [2:0] s10;
reg [11:0] a11;
reg [35:0] b11;
reg [2:0] s11;
reg [35:0] b12;
reg [2:0] s12;
reg [11:0] a13;
reg [35:0] b13;
reg [2:0] s13;
reg [11:0] a14;
reg [35:0] b14;
reg [2:0] s14;
reg [35:0] b15;
reg [2:0] s15;
reg [11:0] a16;
reg [35:0] b16;
reg [2:0] s16;
reg [11:0] a17;
reg [35:0] b17;
reg [2:0] s17;
reg [35:0] b18;
reg [2:0] s18;
reg [11:0] a19;
reg [35:0] b19;
reg [2:0] s19;
reg [11:0] a20;
reg [35:0] b20;
reg [2:0] s20;
reg [35:0] b21;
reg [2:0] s21;
reg [11:0] a22;
reg [35:0] b22;
reg [2:0] s22;
reg [11:0] a23;
reg [35:0] b23;
reg [2:0] s23;
reg [35:0] b24;
reg [2:0] s24;
reg [11:0] a25;
reg [35:0] b25;
reg [2:0] s25;
reg [11:0] a26;
reg [35:0] b26;
reg [2:0] s26;
reg [35:0] b27;
reg [2:0] s27;
reg [11:0] a28;
reg [35:0] b28;
reg [2:0] s28;
reg [11:0] a29;
reg [35:0] b29;
reg [2:0] s29;
reg [35:0] b30;
reg [2:0] s30;
reg [11:0] a31;
reg [35:0] b31;
reg [2:0] s31;
reg [11:0] a32;
reg [35:0] b32;
reg [2:0] s32;
reg [35:0] b33;
reg [2:0] s33;
reg [11:0] a34;
reg [35:0] b34;
reg [2:0] s34;
reg [11:0] a35;
reg [35:0] b35;
reg [2:0] s35;
reg [35:0] b36;
reg [2:0] s36;
reg [11:0] a37;
reg [35:0] b37;
reg [2:0] s37;
reg [11:0] a38;
reg [35:0] b38;
reg [2:0] s38;
reg [35:0] b39;
reg [2:0] s39;
reg [11:0] a40;
reg [35:0] b40;
reg [2:0] s40;
reg [11:0] a41;
reg [35:0] b41;
reg [2:0] s41;
reg [35:0] b42;
reg [2:0] s42;
reg [11:0] a43;
reg [35:0] b43;
reg [2:0] s43;
reg [11:0] a44;
reg [35:0] b44;
reg [2:0] s44;
reg [35:0] b45;
reg [2:0] s45;
reg [11:0] a46;
reg [35:0] b46;
reg [2:0] s46;
reg [11:0] a47;
reg [35:0] b47;
reg [2:0] s47;
wire [11:0] ref_out0,cand_out0;
wire [11:0] ref_out1,cand_out1;
wire [11:0] ref_out2,cand_out2;
gold u_gold(.a0(a0),.b0(b0),.s0(s0),.a1(a1),.b1(b1),.s1(s1),.a2(a2),.b2(b2),.s2(s2),.b3(b3),.s3(s3),.a4(a4),.b4(b4),.s4(s4),.a5(a5),.b5(b5),.s5(s5),.b6(b6),.s6(s6),.a7(a7),.b7(b7),.s7(s7),.a8(a8),.b8(b8),.s8(s8),.b9(b9),.s9(s9),.a10(a10),.b10(b10),.s10(s10),.a11(a11),.b11(b11),.s11(s11),.b12(b12),.s12(s12),.a13(a13),.b13(b13),.s13(s13),.a14(a14),.b14(b14),.s14(s14),.b15(b15),.s15(s15),.a16(a16),.b16(b16),.s16(s16),.a17(a17),.b17(b17),.s17(s17),.b18(b18),.s18(s18),.a19(a19),.b19(b19),.s19(s19),.a20(a20),.b20(b20),.s20(s20),.b21(b21),.s21(s21),.a22(a22),.b22(b22),.s22(s22),.a23(a23),.b23(b23),.s23(s23),.b24(b24),.s24(s24),.a25(a25),.b25(b25),.s25(s25),.a26(a26),.b26(b26),.s26(s26),.b27(b27),.s27(s27),.a28(a28),.b28(b28),.s28(s28),.a29(a29),.b29(b29),.s29(s29),.b30(b30),.s30(s30),.a31(a31),.b31(b31),.s31(s31),.a32(a32),.b32(b32),.s32(s32),.b33(b33),.s33(s33),.a34(a34),.b34(b34),.s34(s34),.a35(a35),.b35(b35),.s35(s35),.b36(b36),.s36(s36),.a37(a37),.b37(b37),.s37(s37),.a38(a38),.b38(b38),.s38(s38),.b39(b39),.s39(s39),.a40(a40),.b40(b40),.s40(s40),.a41(a41),.b41(b41),.s41(s41),.b42(b42),.s42(s42),.a43(a43),.b43(b43),.s43(s43),.a44(a44),.b44(b44),.s44(s44),.b45(b45),.s45(s45),.a46(a46),.b46(b46),.s46(s46),.a47(a47),.b47(b47),.s47(s47),.out0(ref_out0),.out1(ref_out1),.out2(ref_out2));
gate u_gate(.a0(a0),.b0(b0),.s0(s0),.a1(a1),.b1(b1),.s1(s1),.a2(a2),.b2(b2),.s2(s2),.b3(b3),.s3(s3),.a4(a4),.b4(b4),.s4(s4),.a5(a5),.b5(b5),.s5(s5),.b6(b6),.s6(s6),.a7(a7),.b7(b7),.s7(s7),.a8(a8),.b8(b8),.s8(s8),.b9(b9),.s9(s9),.a10(a10),.b10(b10),.s10(s10),.a11(a11),.b11(b11),.s11(s11),.b12(b12),.s12(s12),.a13(a13),.b13(b13),.s13(s13),.a14(a14),.b14(b14),.s14(s14),.b15(b15),.s15(s15),.a16(a16),.b16(b16),.s16(s16),.a17(a17),.b17(b17),.s17(s17),.b18(b18),.s18(s18),.a19(a19),.b19(b19),.s19(s19),.a20(a20),.b20(b20),.s20(s20),.b21(b21),.s21(s21),.a22(a22),.b22(b22),.s22(s22),.a23(a23),.b23(b23),.s23(s23),.b24(b24),.s24(s24),.a25(a25),.b25(b25),.s25(s25),.a26(a26),.b26(b26),.s26(s26),.b27(b27),.s27(s27),.a28(a28),.b28(b28),.s28(s28),.a29(a29),.b29(b29),.s29(s29),.b30(b30),.s30(s30),.a31(a31),.b31(b31),.s31(s31),.a32(a32),.b32(b32),.s32(s32),.b33(b33),.s33(s33),.a34(a34),.b34(b34),.s34(s34),.a35(a35),.b35(b35),.s35(s35),.b36(b36),.s36(s36),.a37(a37),.b37(b37),.s37(s37),.a38(a38),.b38(b38),.s38(s38),.b39(b39),.s39(s39),.a40(a40),.b40(b40),.s40(s40),.a41(a41),.b41(b41),.s41(s41),.b42(b42),.s42(s42),.a43(a43),.b43(b43),.s43(s43),.a44(a44),.b44(b44),.s44(s44),.b45(b45),.s45(s45),.a46(a46),.b46(b46),.s46(s46),.a47(a47),.b47(b47),.s47(s47),.out0(cand_out0),.out1(cand_out1),.out2(cand_out2));
initial begin
for(step=0;step<768;step=step+1) begin
mode=step%12;target=(step/12)%48;
for(j=0;j<12;j=j+1) begin
if(mode==6) a0[j]=1'bz;else if(mode==9) a0[j]=1'bx;
else if(mode==1 || mode==10) a0[j]=$random(seed)&1;
else a0[j]=state4($random(seed));end
for(j=0;j<36;j=j+1) begin
if(mode==6) b0[j]=1'bz;else if(mode==9) b0[j]=1'bx;
else if(mode==1 || mode==10) b0[j]=$random(seed)&1;
else b0[j]=state4($random(seed));end
s0=0;
s0[(step/12)%3]=1;
if(mode==0) s0=0;
if(mode==2) for(j=0;j<3;j=j+1) s0[j]=$random(seed)&1;
if(mode==3 && target==0) begin s0=0;s0[(step/12)%3]=1'bx;end
if(mode==4 && target==0) begin s0=0;s0[(step/12)%3]=1'bz;end
if(mode==5) s0=3'bzzz;
if(mode==7) s0=3'b111;
if(mode==8 && target==0) s0[(step/12+1)%3]=1'bx;
if(mode==11 && target==0) for(j=0;j<3;j=j+1) s0[j]=state4($random(seed));
for(j=0;j<12;j=j+1) begin
if(mode==6) a1[j]=1'bz;else if(mode==9) a1[j]=1'bx;
else if(mode==1 || mode==10) a1[j]=$random(seed)&1;
else a1[j]=state4($random(seed));end
for(j=0;j<36;j=j+1) begin
if(mode==6) b1[j]=1'bz;else if(mode==9) b1[j]=1'bx;
else if(mode==1 || mode==10) b1[j]=$random(seed)&1;
else b1[j]=state4($random(seed));end
s1=0;
s1[(step/12)%3]=1;
if(mode==0) s1=0;
if(mode==2) for(j=0;j<3;j=j+1) s1[j]=$random(seed)&1;
if(mode==3 && target==1) begin s1=0;s1[(step/12)%3]=1'bx;end
if(mode==4 && target==1) begin s1=0;s1[(step/12)%3]=1'bz;end
if(mode==5) s1=3'bzzz;
if(mode==7) s1=3'b111;
if(mode==8 && target==1) s1[(step/12+1)%3]=1'bx;
if(mode==11 && target==1) for(j=0;j<3;j=j+1) s1[j]=state4($random(seed));
for(j=0;j<12;j=j+1) begin
if(mode==6) a2[j]=1'bz;else if(mode==9) a2[j]=1'bx;
else if(mode==1 || mode==10) a2[j]=$random(seed)&1;
else a2[j]=state4($random(seed));end
for(j=0;j<36;j=j+1) begin
if(mode==6) b2[j]=1'bz;else if(mode==9) b2[j]=1'bx;
else if(mode==1 || mode==10) b2[j]=$random(seed)&1;
else b2[j]=state4($random(seed));end
s2=0;
s2[(step/12)%3]=1;
if(mode==0) s2=0;
if(mode==2) for(j=0;j<3;j=j+1) s2[j]=$random(seed)&1;
if(mode==3 && target==2) begin s2=0;s2[(step/12)%3]=1'bx;end
if(mode==4 && target==2) begin s2=0;s2[(step/12)%3]=1'bz;end
if(mode==5) s2=3'bzzz;
if(mode==7) s2=3'b111;
if(mode==8 && target==2) s2[(step/12+1)%3]=1'bx;
if(mode==11 && target==2) for(j=0;j<3;j=j+1) s2[j]=state4($random(seed));
for(j=0;j<36;j=j+1) begin
if(mode==6) b3[j]=1'bz;else if(mode==9) b3[j]=1'bx;
else if(mode==1 || mode==10) b3[j]=$random(seed)&1;
else b3[j]=state4($random(seed));end
s3=0;
s3[(step/12)%3]=1;
if(mode==0) s3=0;
if(mode==2) for(j=0;j<3;j=j+1) s3[j]=$random(seed)&1;
if(mode==3 && target==3) begin s3=0;s3[(step/12)%3]=1'bx;end
if(mode==4 && target==3) begin s3=0;s3[(step/12)%3]=1'bz;end
if(mode==5) s3=3'bzzz;
if(mode==7) s3=3'b111;
if(mode==8 && target==3) s3[(step/12+1)%3]=1'bx;
if(mode==11 && target==3) for(j=0;j<3;j=j+1) s3[j]=state4($random(seed));
for(j=0;j<12;j=j+1) begin
if(mode==6) a4[j]=1'bz;else if(mode==9) a4[j]=1'bx;
else if(mode==1 || mode==10) a4[j]=$random(seed)&1;
else a4[j]=state4($random(seed));end
for(j=0;j<36;j=j+1) begin
if(mode==6) b4[j]=1'bz;else if(mode==9) b4[j]=1'bx;
else if(mode==1 || mode==10) b4[j]=$random(seed)&1;
else b4[j]=state4($random(seed));end
s4=0;
s4[(step/12)%3]=1;
if(mode==0) s4=0;
if(mode==2) for(j=0;j<3;j=j+1) s4[j]=$random(seed)&1;
if(mode==3 && target==4) begin s4=0;s4[(step/12)%3]=1'bx;end
if(mode==4 && target==4) begin s4=0;s4[(step/12)%3]=1'bz;end
if(mode==5) s4=3'bzzz;
if(mode==7) s4=3'b111;
if(mode==8 && target==4) s4[(step/12+1)%3]=1'bx;
if(mode==11 && target==4) for(j=0;j<3;j=j+1) s4[j]=state4($random(seed));
for(j=0;j<12;j=j+1) begin
if(mode==6) a5[j]=1'bz;else if(mode==9) a5[j]=1'bx;
else if(mode==1 || mode==10) a5[j]=$random(seed)&1;
else a5[j]=state4($random(seed));end
for(j=0;j<36;j=j+1) begin
if(mode==6) b5[j]=1'bz;else if(mode==9) b5[j]=1'bx;
else if(mode==1 || mode==10) b5[j]=$random(seed)&1;
else b5[j]=state4($random(seed));end
s5=0;
s5[(step/12)%3]=1;
if(mode==0) s5=0;
if(mode==2) for(j=0;j<3;j=j+1) s5[j]=$random(seed)&1;
if(mode==3 && target==5) begin s5=0;s5[(step/12)%3]=1'bx;end
if(mode==4 && target==5) begin s5=0;s5[(step/12)%3]=1'bz;end
if(mode==5) s5=3'bzzz;
if(mode==7) s5=3'b111;
if(mode==8 && target==5) s5[(step/12+1)%3]=1'bx;
if(mode==11 && target==5) for(j=0;j<3;j=j+1) s5[j]=state4($random(seed));
for(j=0;j<36;j=j+1) begin
if(mode==6) b6[j]=1'bz;else if(mode==9) b6[j]=1'bx;
else if(mode==1 || mode==10) b6[j]=$random(seed)&1;
else b6[j]=state4($random(seed));end
s6=0;
s6[(step/12)%3]=1;
if(mode==0) s6=0;
if(mode==2) for(j=0;j<3;j=j+1) s6[j]=$random(seed)&1;
if(mode==3 && target==6) begin s6=0;s6[(step/12)%3]=1'bx;end
if(mode==4 && target==6) begin s6=0;s6[(step/12)%3]=1'bz;end
if(mode==5) s6=3'bzzz;
if(mode==7) s6=3'b111;
if(mode==8 && target==6) s6[(step/12+1)%3]=1'bx;
if(mode==11 && target==6) for(j=0;j<3;j=j+1) s6[j]=state4($random(seed));
for(j=0;j<12;j=j+1) begin
if(mode==6) a7[j]=1'bz;else if(mode==9) a7[j]=1'bx;
else if(mode==1 || mode==10) a7[j]=$random(seed)&1;
else a7[j]=state4($random(seed));end
for(j=0;j<36;j=j+1) begin
if(mode==6) b7[j]=1'bz;else if(mode==9) b7[j]=1'bx;
else if(mode==1 || mode==10) b7[j]=$random(seed)&1;
else b7[j]=state4($random(seed));end
s7=0;
s7[(step/12)%3]=1;
if(mode==0) s7=0;
if(mode==2) for(j=0;j<3;j=j+1) s7[j]=$random(seed)&1;
if(mode==3 && target==7) begin s7=0;s7[(step/12)%3]=1'bx;end
if(mode==4 && target==7) begin s7=0;s7[(step/12)%3]=1'bz;end
if(mode==5) s7=3'bzzz;
if(mode==7) s7=3'b111;
if(mode==8 && target==7) s7[(step/12+1)%3]=1'bx;
if(mode==11 && target==7) for(j=0;j<3;j=j+1) s7[j]=state4($random(seed));
for(j=0;j<12;j=j+1) begin
if(mode==6) a8[j]=1'bz;else if(mode==9) a8[j]=1'bx;
else if(mode==1 || mode==10) a8[j]=$random(seed)&1;
else a8[j]=state4($random(seed));end
for(j=0;j<36;j=j+1) begin
if(mode==6) b8[j]=1'bz;else if(mode==9) b8[j]=1'bx;
else if(mode==1 || mode==10) b8[j]=$random(seed)&1;
else b8[j]=state4($random(seed));end
s8=0;
s8[(step/12)%3]=1;
if(mode==0) s8=0;
if(mode==2) for(j=0;j<3;j=j+1) s8[j]=$random(seed)&1;
if(mode==3 && target==8) begin s8=0;s8[(step/12)%3]=1'bx;end
if(mode==4 && target==8) begin s8=0;s8[(step/12)%3]=1'bz;end
if(mode==5) s8=3'bzzz;
if(mode==7) s8=3'b111;
if(mode==8 && target==8) s8[(step/12+1)%3]=1'bx;
if(mode==11 && target==8) for(j=0;j<3;j=j+1) s8[j]=state4($random(seed));
for(j=0;j<36;j=j+1) begin
if(mode==6) b9[j]=1'bz;else if(mode==9) b9[j]=1'bx;
else if(mode==1 || mode==10) b9[j]=$random(seed)&1;
else b9[j]=state4($random(seed));end
s9=0;
s9[(step/12)%3]=1;
if(mode==0) s9=0;
if(mode==2) for(j=0;j<3;j=j+1) s9[j]=$random(seed)&1;
if(mode==3 && target==9) begin s9=0;s9[(step/12)%3]=1'bx;end
if(mode==4 && target==9) begin s9=0;s9[(step/12)%3]=1'bz;end
if(mode==5) s9=3'bzzz;
if(mode==7) s9=3'b111;
if(mode==8 && target==9) s9[(step/12+1)%3]=1'bx;
if(mode==11 && target==9) for(j=0;j<3;j=j+1) s9[j]=state4($random(seed));
for(j=0;j<12;j=j+1) begin
if(mode==6) a10[j]=1'bz;else if(mode==9) a10[j]=1'bx;
else if(mode==1 || mode==10) a10[j]=$random(seed)&1;
else a10[j]=state4($random(seed));end
for(j=0;j<36;j=j+1) begin
if(mode==6) b10[j]=1'bz;else if(mode==9) b10[j]=1'bx;
else if(mode==1 || mode==10) b10[j]=$random(seed)&1;
else b10[j]=state4($random(seed));end
s10=0;
s10[(step/12)%3]=1;
if(mode==0) s10=0;
if(mode==2) for(j=0;j<3;j=j+1) s10[j]=$random(seed)&1;
if(mode==3 && target==10) begin s10=0;s10[(step/12)%3]=1'bx;end
if(mode==4 && target==10) begin s10=0;s10[(step/12)%3]=1'bz;end
if(mode==5) s10=3'bzzz;
if(mode==7) s10=3'b111;
if(mode==8 && target==10) s10[(step/12+1)%3]=1'bx;
if(mode==11 && target==10) for(j=0;j<3;j=j+1) s10[j]=state4($random(seed));
for(j=0;j<12;j=j+1) begin
if(mode==6) a11[j]=1'bz;else if(mode==9) a11[j]=1'bx;
else if(mode==1 || mode==10) a11[j]=$random(seed)&1;
else a11[j]=state4($random(seed));end
for(j=0;j<36;j=j+1) begin
if(mode==6) b11[j]=1'bz;else if(mode==9) b11[j]=1'bx;
else if(mode==1 || mode==10) b11[j]=$random(seed)&1;
else b11[j]=state4($random(seed));end
s11=0;
s11[(step/12)%3]=1;
if(mode==0) s11=0;
if(mode==2) for(j=0;j<3;j=j+1) s11[j]=$random(seed)&1;
if(mode==3 && target==11) begin s11=0;s11[(step/12)%3]=1'bx;end
if(mode==4 && target==11) begin s11=0;s11[(step/12)%3]=1'bz;end
if(mode==5) s11=3'bzzz;
if(mode==7) s11=3'b111;
if(mode==8 && target==11) s11[(step/12+1)%3]=1'bx;
if(mode==11 && target==11) for(j=0;j<3;j=j+1) s11[j]=state4($random(seed));
for(j=0;j<36;j=j+1) begin
if(mode==6) b12[j]=1'bz;else if(mode==9) b12[j]=1'bx;
else if(mode==1 || mode==10) b12[j]=$random(seed)&1;
else b12[j]=state4($random(seed));end
s12=0;
s12[(step/12)%3]=1;
if(mode==0) s12=0;
if(mode==2) for(j=0;j<3;j=j+1) s12[j]=$random(seed)&1;
if(mode==3 && target==12) begin s12=0;s12[(step/12)%3]=1'bx;end
if(mode==4 && target==12) begin s12=0;s12[(step/12)%3]=1'bz;end
if(mode==5) s12=3'bzzz;
if(mode==7) s12=3'b111;
if(mode==8 && target==12) s12[(step/12+1)%3]=1'bx;
if(mode==11 && target==12) for(j=0;j<3;j=j+1) s12[j]=state4($random(seed));
for(j=0;j<12;j=j+1) begin
if(mode==6) a13[j]=1'bz;else if(mode==9) a13[j]=1'bx;
else if(mode==1 || mode==10) a13[j]=$random(seed)&1;
else a13[j]=state4($random(seed));end
for(j=0;j<36;j=j+1) begin
if(mode==6) b13[j]=1'bz;else if(mode==9) b13[j]=1'bx;
else if(mode==1 || mode==10) b13[j]=$random(seed)&1;
else b13[j]=state4($random(seed));end
s13=0;
s13[(step/12)%3]=1;
if(mode==0) s13=0;
if(mode==2) for(j=0;j<3;j=j+1) s13[j]=$random(seed)&1;
if(mode==3 && target==13) begin s13=0;s13[(step/12)%3]=1'bx;end
if(mode==4 && target==13) begin s13=0;s13[(step/12)%3]=1'bz;end
if(mode==5) s13=3'bzzz;
if(mode==7) s13=3'b111;
if(mode==8 && target==13) s13[(step/12+1)%3]=1'bx;
if(mode==11 && target==13) for(j=0;j<3;j=j+1) s13[j]=state4($random(seed));
for(j=0;j<12;j=j+1) begin
if(mode==6) a14[j]=1'bz;else if(mode==9) a14[j]=1'bx;
else if(mode==1 || mode==10) a14[j]=$random(seed)&1;
else a14[j]=state4($random(seed));end
for(j=0;j<36;j=j+1) begin
if(mode==6) b14[j]=1'bz;else if(mode==9) b14[j]=1'bx;
else if(mode==1 || mode==10) b14[j]=$random(seed)&1;
else b14[j]=state4($random(seed));end
s14=0;
s14[(step/12)%3]=1;
if(mode==0) s14=0;
if(mode==2) for(j=0;j<3;j=j+1) s14[j]=$random(seed)&1;
if(mode==3 && target==14) begin s14=0;s14[(step/12)%3]=1'bx;end
if(mode==4 && target==14) begin s14=0;s14[(step/12)%3]=1'bz;end
if(mode==5) s14=3'bzzz;
if(mode==7) s14=3'b111;
if(mode==8 && target==14) s14[(step/12+1)%3]=1'bx;
if(mode==11 && target==14) for(j=0;j<3;j=j+1) s14[j]=state4($random(seed));
for(j=0;j<36;j=j+1) begin
if(mode==6) b15[j]=1'bz;else if(mode==9) b15[j]=1'bx;
else if(mode==1 || mode==10) b15[j]=$random(seed)&1;
else b15[j]=state4($random(seed));end
s15=0;
s15[(step/12)%3]=1;
if(mode==0) s15=0;
if(mode==2) for(j=0;j<3;j=j+1) s15[j]=$random(seed)&1;
if(mode==3 && target==15) begin s15=0;s15[(step/12)%3]=1'bx;end
if(mode==4 && target==15) begin s15=0;s15[(step/12)%3]=1'bz;end
if(mode==5) s15=3'bzzz;
if(mode==7) s15=3'b111;
if(mode==8 && target==15) s15[(step/12+1)%3]=1'bx;
if(mode==11 && target==15) for(j=0;j<3;j=j+1) s15[j]=state4($random(seed));
for(j=0;j<12;j=j+1) begin
if(mode==6) a16[j]=1'bz;else if(mode==9) a16[j]=1'bx;
else if(mode==1 || mode==10) a16[j]=$random(seed)&1;
else a16[j]=state4($random(seed));end
for(j=0;j<36;j=j+1) begin
if(mode==6) b16[j]=1'bz;else if(mode==9) b16[j]=1'bx;
else if(mode==1 || mode==10) b16[j]=$random(seed)&1;
else b16[j]=state4($random(seed));end
s16=0;
s16[(step/12)%3]=1;
if(mode==0) s16=0;
if(mode==2) for(j=0;j<3;j=j+1) s16[j]=$random(seed)&1;
if(mode==3 && target==16) begin s16=0;s16[(step/12)%3]=1'bx;end
if(mode==4 && target==16) begin s16=0;s16[(step/12)%3]=1'bz;end
if(mode==5) s16=3'bzzz;
if(mode==7) s16=3'b111;
if(mode==8 && target==16) s16[(step/12+1)%3]=1'bx;
if(mode==11 && target==16) for(j=0;j<3;j=j+1) s16[j]=state4($random(seed));
for(j=0;j<12;j=j+1) begin
if(mode==6) a17[j]=1'bz;else if(mode==9) a17[j]=1'bx;
else if(mode==1 || mode==10) a17[j]=$random(seed)&1;
else a17[j]=state4($random(seed));end
for(j=0;j<36;j=j+1) begin
if(mode==6) b17[j]=1'bz;else if(mode==9) b17[j]=1'bx;
else if(mode==1 || mode==10) b17[j]=$random(seed)&1;
else b17[j]=state4($random(seed));end
s17=0;
s17[(step/12)%3]=1;
if(mode==0) s17=0;
if(mode==2) for(j=0;j<3;j=j+1) s17[j]=$random(seed)&1;
if(mode==3 && target==17) begin s17=0;s17[(step/12)%3]=1'bx;end
if(mode==4 && target==17) begin s17=0;s17[(step/12)%3]=1'bz;end
if(mode==5) s17=3'bzzz;
if(mode==7) s17=3'b111;
if(mode==8 && target==17) s17[(step/12+1)%3]=1'bx;
if(mode==11 && target==17) for(j=0;j<3;j=j+1) s17[j]=state4($random(seed));
for(j=0;j<36;j=j+1) begin
if(mode==6) b18[j]=1'bz;else if(mode==9) b18[j]=1'bx;
else if(mode==1 || mode==10) b18[j]=$random(seed)&1;
else b18[j]=state4($random(seed));end
s18=0;
s18[(step/12)%3]=1;
if(mode==0) s18=0;
if(mode==2) for(j=0;j<3;j=j+1) s18[j]=$random(seed)&1;
if(mode==3 && target==18) begin s18=0;s18[(step/12)%3]=1'bx;end
if(mode==4 && target==18) begin s18=0;s18[(step/12)%3]=1'bz;end
if(mode==5) s18=3'bzzz;
if(mode==7) s18=3'b111;
if(mode==8 && target==18) s18[(step/12+1)%3]=1'bx;
if(mode==11 && target==18) for(j=0;j<3;j=j+1) s18[j]=state4($random(seed));
for(j=0;j<12;j=j+1) begin
if(mode==6) a19[j]=1'bz;else if(mode==9) a19[j]=1'bx;
else if(mode==1 || mode==10) a19[j]=$random(seed)&1;
else a19[j]=state4($random(seed));end
for(j=0;j<36;j=j+1) begin
if(mode==6) b19[j]=1'bz;else if(mode==9) b19[j]=1'bx;
else if(mode==1 || mode==10) b19[j]=$random(seed)&1;
else b19[j]=state4($random(seed));end
s19=0;
s19[(step/12)%3]=1;
if(mode==0) s19=0;
if(mode==2) for(j=0;j<3;j=j+1) s19[j]=$random(seed)&1;
if(mode==3 && target==19) begin s19=0;s19[(step/12)%3]=1'bx;end
if(mode==4 && target==19) begin s19=0;s19[(step/12)%3]=1'bz;end
if(mode==5) s19=3'bzzz;
if(mode==7) s19=3'b111;
if(mode==8 && target==19) s19[(step/12+1)%3]=1'bx;
if(mode==11 && target==19) for(j=0;j<3;j=j+1) s19[j]=state4($random(seed));
for(j=0;j<12;j=j+1) begin
if(mode==6) a20[j]=1'bz;else if(mode==9) a20[j]=1'bx;
else if(mode==1 || mode==10) a20[j]=$random(seed)&1;
else a20[j]=state4($random(seed));end
for(j=0;j<36;j=j+1) begin
if(mode==6) b20[j]=1'bz;else if(mode==9) b20[j]=1'bx;
else if(mode==1 || mode==10) b20[j]=$random(seed)&1;
else b20[j]=state4($random(seed));end
s20=0;
s20[(step/12)%3]=1;
if(mode==0) s20=0;
if(mode==2) for(j=0;j<3;j=j+1) s20[j]=$random(seed)&1;
if(mode==3 && target==20) begin s20=0;s20[(step/12)%3]=1'bx;end
if(mode==4 && target==20) begin s20=0;s20[(step/12)%3]=1'bz;end
if(mode==5) s20=3'bzzz;
if(mode==7) s20=3'b111;
if(mode==8 && target==20) s20[(step/12+1)%3]=1'bx;
if(mode==11 && target==20) for(j=0;j<3;j=j+1) s20[j]=state4($random(seed));
for(j=0;j<36;j=j+1) begin
if(mode==6) b21[j]=1'bz;else if(mode==9) b21[j]=1'bx;
else if(mode==1 || mode==10) b21[j]=$random(seed)&1;
else b21[j]=state4($random(seed));end
s21=0;
s21[(step/12)%3]=1;
if(mode==0) s21=0;
if(mode==2) for(j=0;j<3;j=j+1) s21[j]=$random(seed)&1;
if(mode==3 && target==21) begin s21=0;s21[(step/12)%3]=1'bx;end
if(mode==4 && target==21) begin s21=0;s21[(step/12)%3]=1'bz;end
if(mode==5) s21=3'bzzz;
if(mode==7) s21=3'b111;
if(mode==8 && target==21) s21[(step/12+1)%3]=1'bx;
if(mode==11 && target==21) for(j=0;j<3;j=j+1) s21[j]=state4($random(seed));
for(j=0;j<12;j=j+1) begin
if(mode==6) a22[j]=1'bz;else if(mode==9) a22[j]=1'bx;
else if(mode==1 || mode==10) a22[j]=$random(seed)&1;
else a22[j]=state4($random(seed));end
for(j=0;j<36;j=j+1) begin
if(mode==6) b22[j]=1'bz;else if(mode==9) b22[j]=1'bx;
else if(mode==1 || mode==10) b22[j]=$random(seed)&1;
else b22[j]=state4($random(seed));end
s22=0;
s22[(step/12)%3]=1;
if(mode==0) s22=0;
if(mode==2) for(j=0;j<3;j=j+1) s22[j]=$random(seed)&1;
if(mode==3 && target==22) begin s22=0;s22[(step/12)%3]=1'bx;end
if(mode==4 && target==22) begin s22=0;s22[(step/12)%3]=1'bz;end
if(mode==5) s22=3'bzzz;
if(mode==7) s22=3'b111;
if(mode==8 && target==22) s22[(step/12+1)%3]=1'bx;
if(mode==11 && target==22) for(j=0;j<3;j=j+1) s22[j]=state4($random(seed));
for(j=0;j<12;j=j+1) begin
if(mode==6) a23[j]=1'bz;else if(mode==9) a23[j]=1'bx;
else if(mode==1 || mode==10) a23[j]=$random(seed)&1;
else a23[j]=state4($random(seed));end
for(j=0;j<36;j=j+1) begin
if(mode==6) b23[j]=1'bz;else if(mode==9) b23[j]=1'bx;
else if(mode==1 || mode==10) b23[j]=$random(seed)&1;
else b23[j]=state4($random(seed));end
s23=0;
s23[(step/12)%3]=1;
if(mode==0) s23=0;
if(mode==2) for(j=0;j<3;j=j+1) s23[j]=$random(seed)&1;
if(mode==3 && target==23) begin s23=0;s23[(step/12)%3]=1'bx;end
if(mode==4 && target==23) begin s23=0;s23[(step/12)%3]=1'bz;end
if(mode==5) s23=3'bzzz;
if(mode==7) s23=3'b111;
if(mode==8 && target==23) s23[(step/12+1)%3]=1'bx;
if(mode==11 && target==23) for(j=0;j<3;j=j+1) s23[j]=state4($random(seed));
for(j=0;j<36;j=j+1) begin
if(mode==6) b24[j]=1'bz;else if(mode==9) b24[j]=1'bx;
else if(mode==1 || mode==10) b24[j]=$random(seed)&1;
else b24[j]=state4($random(seed));end
s24=0;
s24[(step/12)%3]=1;
if(mode==0) s24=0;
if(mode==2) for(j=0;j<3;j=j+1) s24[j]=$random(seed)&1;
if(mode==3 && target==24) begin s24=0;s24[(step/12)%3]=1'bx;end
if(mode==4 && target==24) begin s24=0;s24[(step/12)%3]=1'bz;end
if(mode==5) s24=3'bzzz;
if(mode==7) s24=3'b111;
if(mode==8 && target==24) s24[(step/12+1)%3]=1'bx;
if(mode==11 && target==24) for(j=0;j<3;j=j+1) s24[j]=state4($random(seed));
for(j=0;j<12;j=j+1) begin
if(mode==6) a25[j]=1'bz;else if(mode==9) a25[j]=1'bx;
else if(mode==1 || mode==10) a25[j]=$random(seed)&1;
else a25[j]=state4($random(seed));end
for(j=0;j<36;j=j+1) begin
if(mode==6) b25[j]=1'bz;else if(mode==9) b25[j]=1'bx;
else if(mode==1 || mode==10) b25[j]=$random(seed)&1;
else b25[j]=state4($random(seed));end
s25=0;
s25[(step/12)%3]=1;
if(mode==0) s25=0;
if(mode==2) for(j=0;j<3;j=j+1) s25[j]=$random(seed)&1;
if(mode==3 && target==25) begin s25=0;s25[(step/12)%3]=1'bx;end
if(mode==4 && target==25) begin s25=0;s25[(step/12)%3]=1'bz;end
if(mode==5) s25=3'bzzz;
if(mode==7) s25=3'b111;
if(mode==8 && target==25) s25[(step/12+1)%3]=1'bx;
if(mode==11 && target==25) for(j=0;j<3;j=j+1) s25[j]=state4($random(seed));
for(j=0;j<12;j=j+1) begin
if(mode==6) a26[j]=1'bz;else if(mode==9) a26[j]=1'bx;
else if(mode==1 || mode==10) a26[j]=$random(seed)&1;
else a26[j]=state4($random(seed));end
for(j=0;j<36;j=j+1) begin
if(mode==6) b26[j]=1'bz;else if(mode==9) b26[j]=1'bx;
else if(mode==1 || mode==10) b26[j]=$random(seed)&1;
else b26[j]=state4($random(seed));end
s26=0;
s26[(step/12)%3]=1;
if(mode==0) s26=0;
if(mode==2) for(j=0;j<3;j=j+1) s26[j]=$random(seed)&1;
if(mode==3 && target==26) begin s26=0;s26[(step/12)%3]=1'bx;end
if(mode==4 && target==26) begin s26=0;s26[(step/12)%3]=1'bz;end
if(mode==5) s26=3'bzzz;
if(mode==7) s26=3'b111;
if(mode==8 && target==26) s26[(step/12+1)%3]=1'bx;
if(mode==11 && target==26) for(j=0;j<3;j=j+1) s26[j]=state4($random(seed));
for(j=0;j<36;j=j+1) begin
if(mode==6) b27[j]=1'bz;else if(mode==9) b27[j]=1'bx;
else if(mode==1 || mode==10) b27[j]=$random(seed)&1;
else b27[j]=state4($random(seed));end
s27=0;
s27[(step/12)%3]=1;
if(mode==0) s27=0;
if(mode==2) for(j=0;j<3;j=j+1) s27[j]=$random(seed)&1;
if(mode==3 && target==27) begin s27=0;s27[(step/12)%3]=1'bx;end
if(mode==4 && target==27) begin s27=0;s27[(step/12)%3]=1'bz;end
if(mode==5) s27=3'bzzz;
if(mode==7) s27=3'b111;
if(mode==8 && target==27) s27[(step/12+1)%3]=1'bx;
if(mode==11 && target==27) for(j=0;j<3;j=j+1) s27[j]=state4($random(seed));
for(j=0;j<12;j=j+1) begin
if(mode==6) a28[j]=1'bz;else if(mode==9) a28[j]=1'bx;
else if(mode==1 || mode==10) a28[j]=$random(seed)&1;
else a28[j]=state4($random(seed));end
for(j=0;j<36;j=j+1) begin
if(mode==6) b28[j]=1'bz;else if(mode==9) b28[j]=1'bx;
else if(mode==1 || mode==10) b28[j]=$random(seed)&1;
else b28[j]=state4($random(seed));end
s28=0;
s28[(step/12)%3]=1;
if(mode==0) s28=0;
if(mode==2) for(j=0;j<3;j=j+1) s28[j]=$random(seed)&1;
if(mode==3 && target==28) begin s28=0;s28[(step/12)%3]=1'bx;end
if(mode==4 && target==28) begin s28=0;s28[(step/12)%3]=1'bz;end
if(mode==5) s28=3'bzzz;
if(mode==7) s28=3'b111;
if(mode==8 && target==28) s28[(step/12+1)%3]=1'bx;
if(mode==11 && target==28) for(j=0;j<3;j=j+1) s28[j]=state4($random(seed));
for(j=0;j<12;j=j+1) begin
if(mode==6) a29[j]=1'bz;else if(mode==9) a29[j]=1'bx;
else if(mode==1 || mode==10) a29[j]=$random(seed)&1;
else a29[j]=state4($random(seed));end
for(j=0;j<36;j=j+1) begin
if(mode==6) b29[j]=1'bz;else if(mode==9) b29[j]=1'bx;
else if(mode==1 || mode==10) b29[j]=$random(seed)&1;
else b29[j]=state4($random(seed));end
s29=0;
s29[(step/12)%3]=1;
if(mode==0) s29=0;
if(mode==2) for(j=0;j<3;j=j+1) s29[j]=$random(seed)&1;
if(mode==3 && target==29) begin s29=0;s29[(step/12)%3]=1'bx;end
if(mode==4 && target==29) begin s29=0;s29[(step/12)%3]=1'bz;end
if(mode==5) s29=3'bzzz;
if(mode==7) s29=3'b111;
if(mode==8 && target==29) s29[(step/12+1)%3]=1'bx;
if(mode==11 && target==29) for(j=0;j<3;j=j+1) s29[j]=state4($random(seed));
for(j=0;j<36;j=j+1) begin
if(mode==6) b30[j]=1'bz;else if(mode==9) b30[j]=1'bx;
else if(mode==1 || mode==10) b30[j]=$random(seed)&1;
else b30[j]=state4($random(seed));end
s30=0;
s30[(step/12)%3]=1;
if(mode==0) s30=0;
if(mode==2) for(j=0;j<3;j=j+1) s30[j]=$random(seed)&1;
if(mode==3 && target==30) begin s30=0;s30[(step/12)%3]=1'bx;end
if(mode==4 && target==30) begin s30=0;s30[(step/12)%3]=1'bz;end
if(mode==5) s30=3'bzzz;
if(mode==7) s30=3'b111;
if(mode==8 && target==30) s30[(step/12+1)%3]=1'bx;
if(mode==11 && target==30) for(j=0;j<3;j=j+1) s30[j]=state4($random(seed));
for(j=0;j<12;j=j+1) begin
if(mode==6) a31[j]=1'bz;else if(mode==9) a31[j]=1'bx;
else if(mode==1 || mode==10) a31[j]=$random(seed)&1;
else a31[j]=state4($random(seed));end
for(j=0;j<36;j=j+1) begin
if(mode==6) b31[j]=1'bz;else if(mode==9) b31[j]=1'bx;
else if(mode==1 || mode==10) b31[j]=$random(seed)&1;
else b31[j]=state4($random(seed));end
s31=0;
s31[(step/12)%3]=1;
if(mode==0) s31=0;
if(mode==2) for(j=0;j<3;j=j+1) s31[j]=$random(seed)&1;
if(mode==3 && target==31) begin s31=0;s31[(step/12)%3]=1'bx;end
if(mode==4 && target==31) begin s31=0;s31[(step/12)%3]=1'bz;end
if(mode==5) s31=3'bzzz;
if(mode==7) s31=3'b111;
if(mode==8 && target==31) s31[(step/12+1)%3]=1'bx;
if(mode==11 && target==31) for(j=0;j<3;j=j+1) s31[j]=state4($random(seed));
for(j=0;j<12;j=j+1) begin
if(mode==6) a32[j]=1'bz;else if(mode==9) a32[j]=1'bx;
else if(mode==1 || mode==10) a32[j]=$random(seed)&1;
else a32[j]=state4($random(seed));end
for(j=0;j<36;j=j+1) begin
if(mode==6) b32[j]=1'bz;else if(mode==9) b32[j]=1'bx;
else if(mode==1 || mode==10) b32[j]=$random(seed)&1;
else b32[j]=state4($random(seed));end
s32=0;
s32[(step/12)%3]=1;
if(mode==0) s32=0;
if(mode==2) for(j=0;j<3;j=j+1) s32[j]=$random(seed)&1;
if(mode==3 && target==32) begin s32=0;s32[(step/12)%3]=1'bx;end
if(mode==4 && target==32) begin s32=0;s32[(step/12)%3]=1'bz;end
if(mode==5) s32=3'bzzz;
if(mode==7) s32=3'b111;
if(mode==8 && target==32) s32[(step/12+1)%3]=1'bx;
if(mode==11 && target==32) for(j=0;j<3;j=j+1) s32[j]=state4($random(seed));
for(j=0;j<36;j=j+1) begin
if(mode==6) b33[j]=1'bz;else if(mode==9) b33[j]=1'bx;
else if(mode==1 || mode==10) b33[j]=$random(seed)&1;
else b33[j]=state4($random(seed));end
s33=0;
s33[(step/12)%3]=1;
if(mode==0) s33=0;
if(mode==2) for(j=0;j<3;j=j+1) s33[j]=$random(seed)&1;
if(mode==3 && target==33) begin s33=0;s33[(step/12)%3]=1'bx;end
if(mode==4 && target==33) begin s33=0;s33[(step/12)%3]=1'bz;end
if(mode==5) s33=3'bzzz;
if(mode==7) s33=3'b111;
if(mode==8 && target==33) s33[(step/12+1)%3]=1'bx;
if(mode==11 && target==33) for(j=0;j<3;j=j+1) s33[j]=state4($random(seed));
for(j=0;j<12;j=j+1) begin
if(mode==6) a34[j]=1'bz;else if(mode==9) a34[j]=1'bx;
else if(mode==1 || mode==10) a34[j]=$random(seed)&1;
else a34[j]=state4($random(seed));end
for(j=0;j<36;j=j+1) begin
if(mode==6) b34[j]=1'bz;else if(mode==9) b34[j]=1'bx;
else if(mode==1 || mode==10) b34[j]=$random(seed)&1;
else b34[j]=state4($random(seed));end
s34=0;
s34[(step/12)%3]=1;
if(mode==0) s34=0;
if(mode==2) for(j=0;j<3;j=j+1) s34[j]=$random(seed)&1;
if(mode==3 && target==34) begin s34=0;s34[(step/12)%3]=1'bx;end
if(mode==4 && target==34) begin s34=0;s34[(step/12)%3]=1'bz;end
if(mode==5) s34=3'bzzz;
if(mode==7) s34=3'b111;
if(mode==8 && target==34) s34[(step/12+1)%3]=1'bx;
if(mode==11 && target==34) for(j=0;j<3;j=j+1) s34[j]=state4($random(seed));
for(j=0;j<12;j=j+1) begin
if(mode==6) a35[j]=1'bz;else if(mode==9) a35[j]=1'bx;
else if(mode==1 || mode==10) a35[j]=$random(seed)&1;
else a35[j]=state4($random(seed));end
for(j=0;j<36;j=j+1) begin
if(mode==6) b35[j]=1'bz;else if(mode==9) b35[j]=1'bx;
else if(mode==1 || mode==10) b35[j]=$random(seed)&1;
else b35[j]=state4($random(seed));end
s35=0;
s35[(step/12)%3]=1;
if(mode==0) s35=0;
if(mode==2) for(j=0;j<3;j=j+1) s35[j]=$random(seed)&1;
if(mode==3 && target==35) begin s35=0;s35[(step/12)%3]=1'bx;end
if(mode==4 && target==35) begin s35=0;s35[(step/12)%3]=1'bz;end
if(mode==5) s35=3'bzzz;
if(mode==7) s35=3'b111;
if(mode==8 && target==35) s35[(step/12+1)%3]=1'bx;
if(mode==11 && target==35) for(j=0;j<3;j=j+1) s35[j]=state4($random(seed));
for(j=0;j<36;j=j+1) begin
if(mode==6) b36[j]=1'bz;else if(mode==9) b36[j]=1'bx;
else if(mode==1 || mode==10) b36[j]=$random(seed)&1;
else b36[j]=state4($random(seed));end
s36=0;
s36[(step/12)%3]=1;
if(mode==0) s36=0;
if(mode==2) for(j=0;j<3;j=j+1) s36[j]=$random(seed)&1;
if(mode==3 && target==36) begin s36=0;s36[(step/12)%3]=1'bx;end
if(mode==4 && target==36) begin s36=0;s36[(step/12)%3]=1'bz;end
if(mode==5) s36=3'bzzz;
if(mode==7) s36=3'b111;
if(mode==8 && target==36) s36[(step/12+1)%3]=1'bx;
if(mode==11 && target==36) for(j=0;j<3;j=j+1) s36[j]=state4($random(seed));
for(j=0;j<12;j=j+1) begin
if(mode==6) a37[j]=1'bz;else if(mode==9) a37[j]=1'bx;
else if(mode==1 || mode==10) a37[j]=$random(seed)&1;
else a37[j]=state4($random(seed));end
for(j=0;j<36;j=j+1) begin
if(mode==6) b37[j]=1'bz;else if(mode==9) b37[j]=1'bx;
else if(mode==1 || mode==10) b37[j]=$random(seed)&1;
else b37[j]=state4($random(seed));end
s37=0;
s37[(step/12)%3]=1;
if(mode==0) s37=0;
if(mode==2) for(j=0;j<3;j=j+1) s37[j]=$random(seed)&1;
if(mode==3 && target==37) begin s37=0;s37[(step/12)%3]=1'bx;end
if(mode==4 && target==37) begin s37=0;s37[(step/12)%3]=1'bz;end
if(mode==5) s37=3'bzzz;
if(mode==7) s37=3'b111;
if(mode==8 && target==37) s37[(step/12+1)%3]=1'bx;
if(mode==11 && target==37) for(j=0;j<3;j=j+1) s37[j]=state4($random(seed));
for(j=0;j<12;j=j+1) begin
if(mode==6) a38[j]=1'bz;else if(mode==9) a38[j]=1'bx;
else if(mode==1 || mode==10) a38[j]=$random(seed)&1;
else a38[j]=state4($random(seed));end
for(j=0;j<36;j=j+1) begin
if(mode==6) b38[j]=1'bz;else if(mode==9) b38[j]=1'bx;
else if(mode==1 || mode==10) b38[j]=$random(seed)&1;
else b38[j]=state4($random(seed));end
s38=0;
s38[(step/12)%3]=1;
if(mode==0) s38=0;
if(mode==2) for(j=0;j<3;j=j+1) s38[j]=$random(seed)&1;
if(mode==3 && target==38) begin s38=0;s38[(step/12)%3]=1'bx;end
if(mode==4 && target==38) begin s38=0;s38[(step/12)%3]=1'bz;end
if(mode==5) s38=3'bzzz;
if(mode==7) s38=3'b111;
if(mode==8 && target==38) s38[(step/12+1)%3]=1'bx;
if(mode==11 && target==38) for(j=0;j<3;j=j+1) s38[j]=state4($random(seed));
for(j=0;j<36;j=j+1) begin
if(mode==6) b39[j]=1'bz;else if(mode==9) b39[j]=1'bx;
else if(mode==1 || mode==10) b39[j]=$random(seed)&1;
else b39[j]=state4($random(seed));end
s39=0;
s39[(step/12)%3]=1;
if(mode==0) s39=0;
if(mode==2) for(j=0;j<3;j=j+1) s39[j]=$random(seed)&1;
if(mode==3 && target==39) begin s39=0;s39[(step/12)%3]=1'bx;end
if(mode==4 && target==39) begin s39=0;s39[(step/12)%3]=1'bz;end
if(mode==5) s39=3'bzzz;
if(mode==7) s39=3'b111;
if(mode==8 && target==39) s39[(step/12+1)%3]=1'bx;
if(mode==11 && target==39) for(j=0;j<3;j=j+1) s39[j]=state4($random(seed));
for(j=0;j<12;j=j+1) begin
if(mode==6) a40[j]=1'bz;else if(mode==9) a40[j]=1'bx;
else if(mode==1 || mode==10) a40[j]=$random(seed)&1;
else a40[j]=state4($random(seed));end
for(j=0;j<36;j=j+1) begin
if(mode==6) b40[j]=1'bz;else if(mode==9) b40[j]=1'bx;
else if(mode==1 || mode==10) b40[j]=$random(seed)&1;
else b40[j]=state4($random(seed));end
s40=0;
s40[(step/12)%3]=1;
if(mode==0) s40=0;
if(mode==2) for(j=0;j<3;j=j+1) s40[j]=$random(seed)&1;
if(mode==3 && target==40) begin s40=0;s40[(step/12)%3]=1'bx;end
if(mode==4 && target==40) begin s40=0;s40[(step/12)%3]=1'bz;end
if(mode==5) s40=3'bzzz;
if(mode==7) s40=3'b111;
if(mode==8 && target==40) s40[(step/12+1)%3]=1'bx;
if(mode==11 && target==40) for(j=0;j<3;j=j+1) s40[j]=state4($random(seed));
for(j=0;j<12;j=j+1) begin
if(mode==6) a41[j]=1'bz;else if(mode==9) a41[j]=1'bx;
else if(mode==1 || mode==10) a41[j]=$random(seed)&1;
else a41[j]=state4($random(seed));end
for(j=0;j<36;j=j+1) begin
if(mode==6) b41[j]=1'bz;else if(mode==9) b41[j]=1'bx;
else if(mode==1 || mode==10) b41[j]=$random(seed)&1;
else b41[j]=state4($random(seed));end
s41=0;
s41[(step/12)%3]=1;
if(mode==0) s41=0;
if(mode==2) for(j=0;j<3;j=j+1) s41[j]=$random(seed)&1;
if(mode==3 && target==41) begin s41=0;s41[(step/12)%3]=1'bx;end
if(mode==4 && target==41) begin s41=0;s41[(step/12)%3]=1'bz;end
if(mode==5) s41=3'bzzz;
if(mode==7) s41=3'b111;
if(mode==8 && target==41) s41[(step/12+1)%3]=1'bx;
if(mode==11 && target==41) for(j=0;j<3;j=j+1) s41[j]=state4($random(seed));
for(j=0;j<36;j=j+1) begin
if(mode==6) b42[j]=1'bz;else if(mode==9) b42[j]=1'bx;
else if(mode==1 || mode==10) b42[j]=$random(seed)&1;
else b42[j]=state4($random(seed));end
s42=0;
s42[(step/12)%3]=1;
if(mode==0) s42=0;
if(mode==2) for(j=0;j<3;j=j+1) s42[j]=$random(seed)&1;
if(mode==3 && target==42) begin s42=0;s42[(step/12)%3]=1'bx;end
if(mode==4 && target==42) begin s42=0;s42[(step/12)%3]=1'bz;end
if(mode==5) s42=3'bzzz;
if(mode==7) s42=3'b111;
if(mode==8 && target==42) s42[(step/12+1)%3]=1'bx;
if(mode==11 && target==42) for(j=0;j<3;j=j+1) s42[j]=state4($random(seed));
for(j=0;j<12;j=j+1) begin
if(mode==6) a43[j]=1'bz;else if(mode==9) a43[j]=1'bx;
else if(mode==1 || mode==10) a43[j]=$random(seed)&1;
else a43[j]=state4($random(seed));end
for(j=0;j<36;j=j+1) begin
if(mode==6) b43[j]=1'bz;else if(mode==9) b43[j]=1'bx;
else if(mode==1 || mode==10) b43[j]=$random(seed)&1;
else b43[j]=state4($random(seed));end
s43=0;
s43[(step/12)%3]=1;
if(mode==0) s43=0;
if(mode==2) for(j=0;j<3;j=j+1) s43[j]=$random(seed)&1;
if(mode==3 && target==43) begin s43=0;s43[(step/12)%3]=1'bx;end
if(mode==4 && target==43) begin s43=0;s43[(step/12)%3]=1'bz;end
if(mode==5) s43=3'bzzz;
if(mode==7) s43=3'b111;
if(mode==8 && target==43) s43[(step/12+1)%3]=1'bx;
if(mode==11 && target==43) for(j=0;j<3;j=j+1) s43[j]=state4($random(seed));
for(j=0;j<12;j=j+1) begin
if(mode==6) a44[j]=1'bz;else if(mode==9) a44[j]=1'bx;
else if(mode==1 || mode==10) a44[j]=$random(seed)&1;
else a44[j]=state4($random(seed));end
for(j=0;j<36;j=j+1) begin
if(mode==6) b44[j]=1'bz;else if(mode==9) b44[j]=1'bx;
else if(mode==1 || mode==10) b44[j]=$random(seed)&1;
else b44[j]=state4($random(seed));end
s44=0;
s44[(step/12)%3]=1;
if(mode==0) s44=0;
if(mode==2) for(j=0;j<3;j=j+1) s44[j]=$random(seed)&1;
if(mode==3 && target==44) begin s44=0;s44[(step/12)%3]=1'bx;end
if(mode==4 && target==44) begin s44=0;s44[(step/12)%3]=1'bz;end
if(mode==5) s44=3'bzzz;
if(mode==7) s44=3'b111;
if(mode==8 && target==44) s44[(step/12+1)%3]=1'bx;
if(mode==11 && target==44) for(j=0;j<3;j=j+1) s44[j]=state4($random(seed));
for(j=0;j<36;j=j+1) begin
if(mode==6) b45[j]=1'bz;else if(mode==9) b45[j]=1'bx;
else if(mode==1 || mode==10) b45[j]=$random(seed)&1;
else b45[j]=state4($random(seed));end
s45=0;
s45[(step/12)%3]=1;
if(mode==0) s45=0;
if(mode==2) for(j=0;j<3;j=j+1) s45[j]=$random(seed)&1;
if(mode==3 && target==45) begin s45=0;s45[(step/12)%3]=1'bx;end
if(mode==4 && target==45) begin s45=0;s45[(step/12)%3]=1'bz;end
if(mode==5) s45=3'bzzz;
if(mode==7) s45=3'b111;
if(mode==8 && target==45) s45[(step/12+1)%3]=1'bx;
if(mode==11 && target==45) for(j=0;j<3;j=j+1) s45[j]=state4($random(seed));
for(j=0;j<12;j=j+1) begin
if(mode==6) a46[j]=1'bz;else if(mode==9) a46[j]=1'bx;
else if(mode==1 || mode==10) a46[j]=$random(seed)&1;
else a46[j]=state4($random(seed));end
for(j=0;j<36;j=j+1) begin
if(mode==6) b46[j]=1'bz;else if(mode==9) b46[j]=1'bx;
else if(mode==1 || mode==10) b46[j]=$random(seed)&1;
else b46[j]=state4($random(seed));end
s46=0;
s46[(step/12)%3]=1;
if(mode==0) s46=0;
if(mode==2) for(j=0;j<3;j=j+1) s46[j]=$random(seed)&1;
if(mode==3 && target==46) begin s46=0;s46[(step/12)%3]=1'bx;end
if(mode==4 && target==46) begin s46=0;s46[(step/12)%3]=1'bz;end
if(mode==5) s46=3'bzzz;
if(mode==7) s46=3'b111;
if(mode==8 && target==46) s46[(step/12+1)%3]=1'bx;
if(mode==11 && target==46) for(j=0;j<3;j=j+1) s46[j]=state4($random(seed));
for(j=0;j<12;j=j+1) begin
if(mode==6) a47[j]=1'bz;else if(mode==9) a47[j]=1'bx;
else if(mode==1 || mode==10) a47[j]=$random(seed)&1;
else a47[j]=state4($random(seed));end
for(j=0;j<36;j=j+1) begin
if(mode==6) b47[j]=1'bz;else if(mode==9) b47[j]=1'bx;
else if(mode==1 || mode==10) b47[j]=$random(seed)&1;
else b47[j]=state4($random(seed));end
s47=0;
s47[(step/12)%3]=1;
if(mode==0) s47=0;
if(mode==2) for(j=0;j<3;j=j+1) s47[j]=$random(seed)&1;
if(mode==3 && target==47) begin s47=0;s47[(step/12)%3]=1'bx;end
if(mode==4 && target==47) begin s47=0;s47[(step/12)%3]=1'bz;end
if(mode==5) s47=3'bzzz;
if(mode==7) s47=3'b111;
if(mode==8 && target==47) s47[(step/12+1)%3]=1'bx;
if(mode==11 && target==47) for(j=0;j<3;j=j+1) s47[j]=state4($random(seed));
#1;
vectors=vectors+1;bit_compares=bit_compares+12;
if(ref_out0 !== cand_out0) begin errors=errors+1;if(errors<8)$display("DIFF case=fixed_random_dag_n48_w12 out=out0 step=%0d ref=%b cand=%b",step,ref_out0,cand_out0);end
for(j=0;j<12;j=j+1) begin
if(ref_out0[j]===1'b0 || ref_out0[j]===1'b1) known_bits=known_bits+1;
else if(ref_out0[j]===1'bz) z_bits=z_bits+1;else x_bits=x_bits+1;end
vectors=vectors+1;bit_compares=bit_compares+12;
if(ref_out1 !== cand_out1) begin errors=errors+1;if(errors<8)$display("DIFF case=fixed_random_dag_n48_w12 out=out1 step=%0d ref=%b cand=%b",step,ref_out1,cand_out1);end
for(j=0;j<12;j=j+1) begin
if(ref_out1[j]===1'b0 || ref_out1[j]===1'b1) known_bits=known_bits+1;
else if(ref_out1[j]===1'bz) z_bits=z_bits+1;else x_bits=x_bits+1;end
vectors=vectors+1;bit_compares=bit_compares+12;
if(ref_out2 !== cand_out2) begin errors=errors+1;if(errors<8)$display("DIFF case=fixed_random_dag_n48_w12 out=out2 step=%0d ref=%b cand=%b",step,ref_out2,cand_out2);end
for(j=0;j<12;j=j+1) begin
if(ref_out2[j]===1'b0 || ref_out2[j]===1'b1) known_bits=known_bits+1;
else if(ref_out2[j]===1'bz) z_bits=z_bits+1;else x_bits=x_bits+1;end
end
$display("RESULT vectors=%0d bits=%0d known=%0d x=%0d z=%0d errors=%0d",vectors,bit_compares,known_bits,x_bits,z_bits,errors);
if(errors || known_bits==0)$fatal(1,"Mismatch or no known-output coverage");$finish;end endmodule
