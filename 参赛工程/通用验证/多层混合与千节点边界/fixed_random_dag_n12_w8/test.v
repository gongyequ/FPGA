module tb;
integer step,j,seed=69042026,mode,target,rv;
integer vectors=0,bit_compares=0,known_bits=0,x_bits=0,z_bits=0,errors=0;
function state4;input integer v;begin case(v&3) 0:state4=0;1:state4=1;2:state4=1'bx;3:state4=1'bz;endcase end endfunction
reg [7:0] a0;
reg [15:0] b0;
reg [1:0] s0;
reg [7:0] a1;
reg [15:0] b1;
reg [1:0] s1;
reg [7:0] a2;
reg [15:0] b2;
reg [1:0] s2;
reg [15:0] b3;
reg [1:0] s3;
reg [7:0] a4;
reg [15:0] b4;
reg [1:0] s4;
reg [7:0] a5;
reg [15:0] b5;
reg [1:0] s5;
reg [15:0] b6;
reg [1:0] s6;
reg [7:0] a7;
reg [15:0] b7;
reg [1:0] s7;
reg [7:0] a8;
reg [15:0] b8;
reg [1:0] s8;
reg [15:0] b9;
reg [1:0] s9;
reg [7:0] a10;
reg [15:0] b10;
reg [1:0] s10;
reg [7:0] a11;
reg [15:0] b11;
reg [1:0] s11;
wire [7:0] ref_out0,cand_out0;
wire [7:0] ref_out1,cand_out1;
wire [7:0] ref_out2,cand_out2;
gold u_gold(.a0(a0),.b0(b0),.s0(s0),.a1(a1),.b1(b1),.s1(s1),.a2(a2),.b2(b2),.s2(s2),.b3(b3),.s3(s3),.a4(a4),.b4(b4),.s4(s4),.a5(a5),.b5(b5),.s5(s5),.b6(b6),.s6(s6),.a7(a7),.b7(b7),.s7(s7),.a8(a8),.b8(b8),.s8(s8),.b9(b9),.s9(s9),.a10(a10),.b10(b10),.s10(s10),.a11(a11),.b11(b11),.s11(s11),.out0(ref_out0),.out1(ref_out1),.out2(ref_out2));
gate u_gate(.a0(a0),.b0(b0),.s0(s0),.a1(a1),.b1(b1),.s1(s1),.a2(a2),.b2(b2),.s2(s2),.b3(b3),.s3(s3),.a4(a4),.b4(b4),.s4(s4),.a5(a5),.b5(b5),.s5(s5),.b6(b6),.s6(s6),.a7(a7),.b7(b7),.s7(s7),.a8(a8),.b8(b8),.s8(s8),.b9(b9),.s9(s9),.a10(a10),.b10(b10),.s10(s10),.a11(a11),.b11(b11),.s11(s11),.out0(cand_out0),.out1(cand_out1),.out2(cand_out2));
initial begin
for(step=0;step<768;step=step+1) begin
mode=step%12;target=(step/12)%12;
for(j=0;j<8;j=j+1) begin
if(mode==6) a0[j]=1'bz;else if(mode==9) a0[j]=1'bx;
else if(mode==1 || mode==10) a0[j]=$random(seed)&1;
else a0[j]=state4($random(seed));end
for(j=0;j<16;j=j+1) begin
if(mode==6) b0[j]=1'bz;else if(mode==9) b0[j]=1'bx;
else if(mode==1 || mode==10) b0[j]=$random(seed)&1;
else b0[j]=state4($random(seed));end
s0=0;
s0[(step/12)%2]=1;
if(mode==0) s0=0;
if(mode==2) for(j=0;j<2;j=j+1) s0[j]=$random(seed)&1;
if(mode==3 && target==0) begin s0=0;s0[(step/12)%2]=1'bx;end
if(mode==4 && target==0) begin s0=0;s0[(step/12)%2]=1'bz;end
if(mode==5) s0=2'bzz;
if(mode==7) s0=2'b11;
if(mode==8 && target==0) s0[(step/12+1)%2]=1'bx;
if(mode==11 && target==0) for(j=0;j<2;j=j+1) s0[j]=state4($random(seed));
for(j=0;j<8;j=j+1) begin
if(mode==6) a1[j]=1'bz;else if(mode==9) a1[j]=1'bx;
else if(mode==1 || mode==10) a1[j]=$random(seed)&1;
else a1[j]=state4($random(seed));end
for(j=0;j<16;j=j+1) begin
if(mode==6) b1[j]=1'bz;else if(mode==9) b1[j]=1'bx;
else if(mode==1 || mode==10) b1[j]=$random(seed)&1;
else b1[j]=state4($random(seed));end
s1=0;
s1[(step/12)%2]=1;
if(mode==0) s1=0;
if(mode==2) for(j=0;j<2;j=j+1) s1[j]=$random(seed)&1;
if(mode==3 && target==1) begin s1=0;s1[(step/12)%2]=1'bx;end
if(mode==4 && target==1) begin s1=0;s1[(step/12)%2]=1'bz;end
if(mode==5) s1=2'bzz;
if(mode==7) s1=2'b11;
if(mode==8 && target==1) s1[(step/12+1)%2]=1'bx;
if(mode==11 && target==1) for(j=0;j<2;j=j+1) s1[j]=state4($random(seed));
for(j=0;j<8;j=j+1) begin
if(mode==6) a2[j]=1'bz;else if(mode==9) a2[j]=1'bx;
else if(mode==1 || mode==10) a2[j]=$random(seed)&1;
else a2[j]=state4($random(seed));end
for(j=0;j<16;j=j+1) begin
if(mode==6) b2[j]=1'bz;else if(mode==9) b2[j]=1'bx;
else if(mode==1 || mode==10) b2[j]=$random(seed)&1;
else b2[j]=state4($random(seed));end
s2=0;
s2[(step/12)%2]=1;
if(mode==0) s2=0;
if(mode==2) for(j=0;j<2;j=j+1) s2[j]=$random(seed)&1;
if(mode==3 && target==2) begin s2=0;s2[(step/12)%2]=1'bx;end
if(mode==4 && target==2) begin s2=0;s2[(step/12)%2]=1'bz;end
if(mode==5) s2=2'bzz;
if(mode==7) s2=2'b11;
if(mode==8 && target==2) s2[(step/12+1)%2]=1'bx;
if(mode==11 && target==2) for(j=0;j<2;j=j+1) s2[j]=state4($random(seed));
for(j=0;j<16;j=j+1) begin
if(mode==6) b3[j]=1'bz;else if(mode==9) b3[j]=1'bx;
else if(mode==1 || mode==10) b3[j]=$random(seed)&1;
else b3[j]=state4($random(seed));end
s3=0;
s3[(step/12)%2]=1;
if(mode==0) s3=0;
if(mode==2) for(j=0;j<2;j=j+1) s3[j]=$random(seed)&1;
if(mode==3 && target==3) begin s3=0;s3[(step/12)%2]=1'bx;end
if(mode==4 && target==3) begin s3=0;s3[(step/12)%2]=1'bz;end
if(mode==5) s3=2'bzz;
if(mode==7) s3=2'b11;
if(mode==8 && target==3) s3[(step/12+1)%2]=1'bx;
if(mode==11 && target==3) for(j=0;j<2;j=j+1) s3[j]=state4($random(seed));
for(j=0;j<8;j=j+1) begin
if(mode==6) a4[j]=1'bz;else if(mode==9) a4[j]=1'bx;
else if(mode==1 || mode==10) a4[j]=$random(seed)&1;
else a4[j]=state4($random(seed));end
for(j=0;j<16;j=j+1) begin
if(mode==6) b4[j]=1'bz;else if(mode==9) b4[j]=1'bx;
else if(mode==1 || mode==10) b4[j]=$random(seed)&1;
else b4[j]=state4($random(seed));end
s4=0;
s4[(step/12)%2]=1;
if(mode==0) s4=0;
if(mode==2) for(j=0;j<2;j=j+1) s4[j]=$random(seed)&1;
if(mode==3 && target==4) begin s4=0;s4[(step/12)%2]=1'bx;end
if(mode==4 && target==4) begin s4=0;s4[(step/12)%2]=1'bz;end
if(mode==5) s4=2'bzz;
if(mode==7) s4=2'b11;
if(mode==8 && target==4) s4[(step/12+1)%2]=1'bx;
if(mode==11 && target==4) for(j=0;j<2;j=j+1) s4[j]=state4($random(seed));
for(j=0;j<8;j=j+1) begin
if(mode==6) a5[j]=1'bz;else if(mode==9) a5[j]=1'bx;
else if(mode==1 || mode==10) a5[j]=$random(seed)&1;
else a5[j]=state4($random(seed));end
for(j=0;j<16;j=j+1) begin
if(mode==6) b5[j]=1'bz;else if(mode==9) b5[j]=1'bx;
else if(mode==1 || mode==10) b5[j]=$random(seed)&1;
else b5[j]=state4($random(seed));end
s5=0;
s5[(step/12)%2]=1;
if(mode==0) s5=0;
if(mode==2) for(j=0;j<2;j=j+1) s5[j]=$random(seed)&1;
if(mode==3 && target==5) begin s5=0;s5[(step/12)%2]=1'bx;end
if(mode==4 && target==5) begin s5=0;s5[(step/12)%2]=1'bz;end
if(mode==5) s5=2'bzz;
if(mode==7) s5=2'b11;
if(mode==8 && target==5) s5[(step/12+1)%2]=1'bx;
if(mode==11 && target==5) for(j=0;j<2;j=j+1) s5[j]=state4($random(seed));
for(j=0;j<16;j=j+1) begin
if(mode==6) b6[j]=1'bz;else if(mode==9) b6[j]=1'bx;
else if(mode==1 || mode==10) b6[j]=$random(seed)&1;
else b6[j]=state4($random(seed));end
s6=0;
s6[(step/12)%2]=1;
if(mode==0) s6=0;
if(mode==2) for(j=0;j<2;j=j+1) s6[j]=$random(seed)&1;
if(mode==3 && target==6) begin s6=0;s6[(step/12)%2]=1'bx;end
if(mode==4 && target==6) begin s6=0;s6[(step/12)%2]=1'bz;end
if(mode==5) s6=2'bzz;
if(mode==7) s6=2'b11;
if(mode==8 && target==6) s6[(step/12+1)%2]=1'bx;
if(mode==11 && target==6) for(j=0;j<2;j=j+1) s6[j]=state4($random(seed));
for(j=0;j<8;j=j+1) begin
if(mode==6) a7[j]=1'bz;else if(mode==9) a7[j]=1'bx;
else if(mode==1 || mode==10) a7[j]=$random(seed)&1;
else a7[j]=state4($random(seed));end
for(j=0;j<16;j=j+1) begin
if(mode==6) b7[j]=1'bz;else if(mode==9) b7[j]=1'bx;
else if(mode==1 || mode==10) b7[j]=$random(seed)&1;
else b7[j]=state4($random(seed));end
s7=0;
s7[(step/12)%2]=1;
if(mode==0) s7=0;
if(mode==2) for(j=0;j<2;j=j+1) s7[j]=$random(seed)&1;
if(mode==3 && target==7) begin s7=0;s7[(step/12)%2]=1'bx;end
if(mode==4 && target==7) begin s7=0;s7[(step/12)%2]=1'bz;end
if(mode==5) s7=2'bzz;
if(mode==7) s7=2'b11;
if(mode==8 && target==7) s7[(step/12+1)%2]=1'bx;
if(mode==11 && target==7) for(j=0;j<2;j=j+1) s7[j]=state4($random(seed));
for(j=0;j<8;j=j+1) begin
if(mode==6) a8[j]=1'bz;else if(mode==9) a8[j]=1'bx;
else if(mode==1 || mode==10) a8[j]=$random(seed)&1;
else a8[j]=state4($random(seed));end
for(j=0;j<16;j=j+1) begin
if(mode==6) b8[j]=1'bz;else if(mode==9) b8[j]=1'bx;
else if(mode==1 || mode==10) b8[j]=$random(seed)&1;
else b8[j]=state4($random(seed));end
s8=0;
s8[(step/12)%2]=1;
if(mode==0) s8=0;
if(mode==2) for(j=0;j<2;j=j+1) s8[j]=$random(seed)&1;
if(mode==3 && target==8) begin s8=0;s8[(step/12)%2]=1'bx;end
if(mode==4 && target==8) begin s8=0;s8[(step/12)%2]=1'bz;end
if(mode==5) s8=2'bzz;
if(mode==7) s8=2'b11;
if(mode==8 && target==8) s8[(step/12+1)%2]=1'bx;
if(mode==11 && target==8) for(j=0;j<2;j=j+1) s8[j]=state4($random(seed));
for(j=0;j<16;j=j+1) begin
if(mode==6) b9[j]=1'bz;else if(mode==9) b9[j]=1'bx;
else if(mode==1 || mode==10) b9[j]=$random(seed)&1;
else b9[j]=state4($random(seed));end
s9=0;
s9[(step/12)%2]=1;
if(mode==0) s9=0;
if(mode==2) for(j=0;j<2;j=j+1) s9[j]=$random(seed)&1;
if(mode==3 && target==9) begin s9=0;s9[(step/12)%2]=1'bx;end
if(mode==4 && target==9) begin s9=0;s9[(step/12)%2]=1'bz;end
if(mode==5) s9=2'bzz;
if(mode==7) s9=2'b11;
if(mode==8 && target==9) s9[(step/12+1)%2]=1'bx;
if(mode==11 && target==9) for(j=0;j<2;j=j+1) s9[j]=state4($random(seed));
for(j=0;j<8;j=j+1) begin
if(mode==6) a10[j]=1'bz;else if(mode==9) a10[j]=1'bx;
else if(mode==1 || mode==10) a10[j]=$random(seed)&1;
else a10[j]=state4($random(seed));end
for(j=0;j<16;j=j+1) begin
if(mode==6) b10[j]=1'bz;else if(mode==9) b10[j]=1'bx;
else if(mode==1 || mode==10) b10[j]=$random(seed)&1;
else b10[j]=state4($random(seed));end
s10=0;
s10[(step/12)%2]=1;
if(mode==0) s10=0;
if(mode==2) for(j=0;j<2;j=j+1) s10[j]=$random(seed)&1;
if(mode==3 && target==10) begin s10=0;s10[(step/12)%2]=1'bx;end
if(mode==4 && target==10) begin s10=0;s10[(step/12)%2]=1'bz;end
if(mode==5) s10=2'bzz;
if(mode==7) s10=2'b11;
if(mode==8 && target==10) s10[(step/12+1)%2]=1'bx;
if(mode==11 && target==10) for(j=0;j<2;j=j+1) s10[j]=state4($random(seed));
for(j=0;j<8;j=j+1) begin
if(mode==6) a11[j]=1'bz;else if(mode==9) a11[j]=1'bx;
else if(mode==1 || mode==10) a11[j]=$random(seed)&1;
else a11[j]=state4($random(seed));end
for(j=0;j<16;j=j+1) begin
if(mode==6) b11[j]=1'bz;else if(mode==9) b11[j]=1'bx;
else if(mode==1 || mode==10) b11[j]=$random(seed)&1;
else b11[j]=state4($random(seed));end
s11=0;
s11[(step/12)%2]=1;
if(mode==0) s11=0;
if(mode==2) for(j=0;j<2;j=j+1) s11[j]=$random(seed)&1;
if(mode==3 && target==11) begin s11=0;s11[(step/12)%2]=1'bx;end
if(mode==4 && target==11) begin s11=0;s11[(step/12)%2]=1'bz;end
if(mode==5) s11=2'bzz;
if(mode==7) s11=2'b11;
if(mode==8 && target==11) s11[(step/12+1)%2]=1'bx;
if(mode==11 && target==11) for(j=0;j<2;j=j+1) s11[j]=state4($random(seed));
#1;
vectors=vectors+1;bit_compares=bit_compares+8;
if(ref_out0 !== cand_out0) begin errors=errors+1;if(errors<8)$display("DIFF case=fixed_random_dag_n12_w8 out=out0 step=%0d ref=%b cand=%b",step,ref_out0,cand_out0);end
for(j=0;j<8;j=j+1) begin
if(ref_out0[j]===1'b0 || ref_out0[j]===1'b1) known_bits=known_bits+1;
else if(ref_out0[j]===1'bz) z_bits=z_bits+1;else x_bits=x_bits+1;end
vectors=vectors+1;bit_compares=bit_compares+8;
if(ref_out1 !== cand_out1) begin errors=errors+1;if(errors<8)$display("DIFF case=fixed_random_dag_n12_w8 out=out1 step=%0d ref=%b cand=%b",step,ref_out1,cand_out1);end
for(j=0;j<8;j=j+1) begin
if(ref_out1[j]===1'b0 || ref_out1[j]===1'b1) known_bits=known_bits+1;
else if(ref_out1[j]===1'bz) z_bits=z_bits+1;else x_bits=x_bits+1;end
vectors=vectors+1;bit_compares=bit_compares+8;
if(ref_out2 !== cand_out2) begin errors=errors+1;if(errors<8)$display("DIFF case=fixed_random_dag_n12_w8 out=out2 step=%0d ref=%b cand=%b",step,ref_out2,cand_out2);end
for(j=0;j<8;j=j+1) begin
if(ref_out2[j]===1'b0 || ref_out2[j]===1'b1) known_bits=known_bits+1;
else if(ref_out2[j]===1'bz) z_bits=z_bits+1;else x_bits=x_bits+1;end
end
$display("RESULT vectors=%0d bits=%0d known=%0d x=%0d z=%0d errors=%0d",vectors,bit_compares,known_bits,x_bits,z_bits,errors);
if(errors || known_bits==0)$fatal(1,"Mismatch or no known-output coverage");$finish;end endmodule
