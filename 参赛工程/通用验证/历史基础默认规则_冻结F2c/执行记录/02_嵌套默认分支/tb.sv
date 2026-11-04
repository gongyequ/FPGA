`timescale 1ns/1ps
module tb;
reg [3:0] a; reg [11:0] bi,bo; reg [2:0] si,so;
integer control_pattern, data_pattern, bit_index, code, seed=6913, samples=0, errors=0;
function fourstate;
 input integer x;
 begin case(x) 0:fourstate=0;1:fourstate=1;2:fourstate=1'bx;3:fourstate=1'bz;endcase end
endfunction
wire [3:0] r0,c0;case0_ref dr0(a,bi[3:0],bo[3:0],si[0:0],so[0:0],r0);case0_cand dc0(a,bi[3:0],bo[3:0],si[0:0],so[0:0],c0);
wire [3:0] r1,c1;case1_ref dr1(a,bi[3:0],bo[7:0],si[0:0],so[1:0],r1);case1_cand dc1(a,bi[3:0],bo[7:0],si[0:0],so[1:0],c1);
wire [3:0] r2,c2;case2_ref dr2(a,bi[3:0],bo[11:0],si[0:0],so[2:0],r2);case2_cand dc2(a,bi[3:0],bo[11:0],si[0:0],so[2:0],c2);
wire [3:0] r3,c3;case3_ref dr3(a,bi[7:0],bo[3:0],si[1:0],so[0:0],r3);case3_cand dc3(a,bi[7:0],bo[3:0],si[1:0],so[0:0],c3);
wire [3:0] r4,c4;case4_ref dr4(a,bi[7:0],bo[7:0],si[1:0],so[1:0],r4);case4_cand dc4(a,bi[7:0],bo[7:0],si[1:0],so[1:0],c4);
wire [3:0] r5,c5;case5_ref dr5(a,bi[7:0],bo[11:0],si[1:0],so[2:0],r5);case5_cand dc5(a,bi[7:0],bo[11:0],si[1:0],so[2:0],c5);
wire [3:0] r6,c6;case6_ref dr6(a,bi[11:0],bo[3:0],si[2:0],so[0:0],r6);case6_cand dc6(a,bi[11:0],bo[3:0],si[2:0],so[0:0],c6);
wire [3:0] r7,c7;case7_ref dr7(a,bi[11:0],bo[7:0],si[2:0],so[1:0],r7);case7_cand dc7(a,bi[11:0],bo[7:0],si[2:0],so[1:0],c7);
wire [3:0] r8,c8;case8_ref dr8(a,bi[11:0],bo[11:0],si[2:0],so[2:0],r8);case8_cand dc8(a,bi[11:0],bo[11:0],si[2:0],so[2:0],c8);
initial begin
for(control_pattern=0;control_pattern<4096;control_pattern=control_pattern+1) begin
 code=control_pattern;
 for(bit_index=0;bit_index<3;bit_index=bit_index+1) begin si[bit_index]=fourstate(code%4);code=code/4;end
 for(bit_index=0;bit_index<3;bit_index=bit_index+1) begin so[bit_index]=fourstate(code%4);code=code/4;end
 for(data_pattern=0;data_pattern<16;data_pattern=data_pattern+1) begin
  case(data_pattern)
   0:begin a=0;bi=0;bo=0;end
   1:begin a='1;bi='1;bo='1;end
   2:begin a='x;bi='x;bo='x;end
   3:begin a='z;bi='z;bo='z;end
   4:begin a=4'bx01z;bi=12'bz001x010zzxx;bo=12'b0000xxxxzzzz;end
   default:begin a=$random(seed);bi=$random(seed);bo=$random(seed);end
  endcase
  #1;
if(r0 !== c0) begin errors=errors+1;if(errors<12)$display("DIFF case=0 si=%b so=%b ref=%b cand=%b",si,so,r0,c0);end
if(r1 !== c1) begin errors=errors+1;if(errors<12)$display("DIFF case=1 si=%b so=%b ref=%b cand=%b",si,so,r1,c1);end
if(r2 !== c2) begin errors=errors+1;if(errors<12)$display("DIFF case=2 si=%b so=%b ref=%b cand=%b",si,so,r2,c2);end
if(r3 !== c3) begin errors=errors+1;if(errors<12)$display("DIFF case=3 si=%b so=%b ref=%b cand=%b",si,so,r3,c3);end
if(r4 !== c4) begin errors=errors+1;if(errors<12)$display("DIFF case=4 si=%b so=%b ref=%b cand=%b",si,so,r4,c4);end
if(r5 !== c5) begin errors=errors+1;if(errors<12)$display("DIFF case=5 si=%b so=%b ref=%b cand=%b",si,so,r5,c5);end
if(r6 !== c6) begin errors=errors+1;if(errors<12)$display("DIFF case=6 si=%b so=%b ref=%b cand=%b",si,so,r6,c6);end
if(r7 !== c7) begin errors=errors+1;if(errors<12)$display("DIFF case=7 si=%b so=%b ref=%b cand=%b",si,so,r7,c7);end
if(r8 !== c8) begin errors=errors+1;if(errors<12)$display("DIFF case=8 si=%b so=%b ref=%b cand=%b",si,so,r8,c8);end
  samples=samples+9;
 end
end
$display("RESULT samples=%0d errors=%0d",samples,errors);
if(errors)$fatal(1,"FAIL");$display("PASS");$finish;
end
endmodule
