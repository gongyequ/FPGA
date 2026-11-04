module tb;
integer step,j,seed=69042026,mode,target,rv;
integer vectors=0,bit_compares=0,known_bits=0,x_bits=0,z_bits=0,errors=0;
function state4;input integer v;begin case(v&3) 0:state4=0;1:state4=1;2:state4=1'bx;3:state4=1'bz;endcase end endfunction
reg [15:0] a0;
reg [47:0] b0;
reg [2:0] s0;
reg [47:0] b1;
reg [2:0] s1;
reg [47:0] b2;
reg [2:0] s2;
reg [47:0] b3;
reg [2:0] s3;
reg [47:0] b4;
reg [2:0] s4;
reg [47:0] b5;
reg [2:0] s5;
wire [15:0] ref_out0,cand_out0;
gold u_gold(.a0(a0),.b0(b0),.s0(s0),.b1(b1),.s1(s1),.b2(b2),.s2(s2),.b3(b3),.s3(s3),.b4(b4),.s4(s4),.b5(b5),.s5(s5),.out0(ref_out0));
gate u_gate(.a0(a0),.b0(b0),.s0(s0),.b1(b1),.s1(s1),.b2(b2),.s2(s2),.b3(b3),.s3(s3),.b4(b4),.s4(s4),.b5(b5),.s5(s5),.out0(cand_out0));
initial begin
for(step=0;step<512;step=step+1) begin
mode=step%12;target=(step/12)%6;
for(j=0;j<16;j=j+1) begin
if(mode==6) a0[j]=1'bz;else if(mode==9) a0[j]=1'bx;
else if(mode==1 || mode==10) a0[j]=$random(seed)&1;
else a0[j]=state4($random(seed));end
for(j=0;j<48;j=j+1) begin
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
for(j=0;j<48;j=j+1) begin
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
for(j=0;j<48;j=j+1) begin
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
for(j=0;j<48;j=j+1) begin
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
for(j=0;j<48;j=j+1) begin
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
for(j=0;j<48;j=j+1) begin
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
#1;
vectors=vectors+1;bit_compares=bit_compares+16;
if(ref_out0 !== cand_out0) begin errors=errors+1;if(errors<8)$display("DIFF case=fallback_d6_w16_k3 out=out0 step=%0d ref=%b cand=%b",step,ref_out0,cand_out0);end
for(j=0;j<16;j=j+1) begin
if(ref_out0[j]===1'b0 || ref_out0[j]===1'b1) known_bits=known_bits+1;
else if(ref_out0[j]===1'bz) z_bits=z_bits+1;else x_bits=x_bits+1;end
end
$display("RESULT vectors=%0d bits=%0d known=%0d x=%0d z=%0d errors=%0d",vectors,bit_compares,known_bits,x_bits,z_bits,errors);
if(errors || known_bits==0)$fatal(1,"Mismatch or no known-output coverage");$finish;end endmodule
