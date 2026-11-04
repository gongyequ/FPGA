module k1_o1_arm0(input [2:0] ao,ai,
  input [2:0] bi, input [2:0] bo,
  input [0:0] si, input [0:0] so,
  output [2:0] reference_y,candidate_y);
wire [2:0] inner_y;
wire [2:0] outer_b;
wire h;
wire [1:0] gated;
\$pmux #(.WIDTH(3),.S_WIDTH(1)) original_inner(.A(ai),.B(bi),.S(si),.Y(inner_y));
assign outer_b[0 +: 3] = inner_y;
\$pmux #(.WIDTH(3),.S_WIDTH(1)) original_outer(.A(ao),.B(outer_b),.S(so),.Y(reference_y));
\$pmux #(.WIDTH(1),.S_WIDTH(1)) default_flag(.A(1'b1),.B(1'b0),.S(si),.Y(h));
\$pmux #(.WIDTH(2),.S_WIDTH(1)) selected_gate(.A(2'b00),.B({si,h}),.S(so[0]),.Y(gated));
\$pmux #(.WIDTH(3),.S_WIDTH(2)) candidate_outer(.A(ao),.B({bi,ai}),.S({gated}),.Y(candidate_y));
endmodule

module k1_o2_arm0(input [2:0] ao,ai,
  input [2:0] bi, input [5:0] bo,
  input [0:0] si, input [1:0] so,
  output [2:0] reference_y,candidate_y);
wire [2:0] inner_y;
wire [5:0] outer_b;
wire h;
wire [1:0] gated;
\$pmux #(.WIDTH(3),.S_WIDTH(1)) original_inner(.A(ai),.B(bi),.S(si),.Y(inner_y));
assign outer_b[0 +: 3] = inner_y;
assign outer_b[3 +: 3] = bo[3 +: 3];
\$pmux #(.WIDTH(3),.S_WIDTH(2)) original_outer(.A(ao),.B(outer_b),.S(so),.Y(reference_y));
\$pmux #(.WIDTH(1),.S_WIDTH(1)) default_flag(.A(1'b1),.B(1'b0),.S(si),.Y(h));
\$pmux #(.WIDTH(2),.S_WIDTH(1)) selected_gate(.A(2'b00),.B({si,h}),.S(so[0]),.Y(gated));
\$pmux #(.WIDTH(3),.S_WIDTH(3)) candidate_outer(.A(ao),.B({bo[3 +: 3],bi,ai}),.S({so[1],gated}),.Y(candidate_y));
endmodule

module k1_o2_arm1(input [2:0] ao,ai,
  input [2:0] bi, input [5:0] bo,
  input [0:0] si, input [1:0] so,
  output [2:0] reference_y,candidate_y);
wire [2:0] inner_y;
wire [5:0] outer_b;
wire h;
wire [1:0] gated;
\$pmux #(.WIDTH(3),.S_WIDTH(1)) original_inner(.A(ai),.B(bi),.S(si),.Y(inner_y));
assign outer_b[0 +: 3] = bo[0 +: 3];
assign outer_b[3 +: 3] = inner_y;
\$pmux #(.WIDTH(3),.S_WIDTH(2)) original_outer(.A(ao),.B(outer_b),.S(so),.Y(reference_y));
\$pmux #(.WIDTH(1),.S_WIDTH(1)) default_flag(.A(1'b1),.B(1'b0),.S(si),.Y(h));
\$pmux #(.WIDTH(2),.S_WIDTH(1)) selected_gate(.A(2'b00),.B({si,h}),.S(so[1]),.Y(gated));
\$pmux #(.WIDTH(3),.S_WIDTH(3)) candidate_outer(.A(ao),.B({bi,ai,bo[0 +: 3]}),.S({gated,so[0]}),.Y(candidate_y));
endmodule

module k1_o3_arm0(input [2:0] ao,ai,
  input [2:0] bi, input [8:0] bo,
  input [0:0] si, input [2:0] so,
  output [2:0] reference_y,candidate_y);
wire [2:0] inner_y;
wire [8:0] outer_b;
wire h;
wire [1:0] gated;
\$pmux #(.WIDTH(3),.S_WIDTH(1)) original_inner(.A(ai),.B(bi),.S(si),.Y(inner_y));
assign outer_b[0 +: 3] = inner_y;
assign outer_b[3 +: 3] = bo[3 +: 3];
assign outer_b[6 +: 3] = bo[6 +: 3];
\$pmux #(.WIDTH(3),.S_WIDTH(3)) original_outer(.A(ao),.B(outer_b),.S(so),.Y(reference_y));
\$pmux #(.WIDTH(1),.S_WIDTH(1)) default_flag(.A(1'b1),.B(1'b0),.S(si),.Y(h));
\$pmux #(.WIDTH(2),.S_WIDTH(1)) selected_gate(.A(2'b00),.B({si,h}),.S(so[0]),.Y(gated));
\$pmux #(.WIDTH(3),.S_WIDTH(4)) candidate_outer(.A(ao),.B({bo[6 +: 3],bo[3 +: 3],bi,ai}),.S({so[2],so[1],gated}),.Y(candidate_y));
endmodule

module k1_o3_arm1(input [2:0] ao,ai,
  input [2:0] bi, input [8:0] bo,
  input [0:0] si, input [2:0] so,
  output [2:0] reference_y,candidate_y);
wire [2:0] inner_y;
wire [8:0] outer_b;
wire h;
wire [1:0] gated;
\$pmux #(.WIDTH(3),.S_WIDTH(1)) original_inner(.A(ai),.B(bi),.S(si),.Y(inner_y));
assign outer_b[0 +: 3] = bo[0 +: 3];
assign outer_b[3 +: 3] = inner_y;
assign outer_b[6 +: 3] = bo[6 +: 3];
\$pmux #(.WIDTH(3),.S_WIDTH(3)) original_outer(.A(ao),.B(outer_b),.S(so),.Y(reference_y));
\$pmux #(.WIDTH(1),.S_WIDTH(1)) default_flag(.A(1'b1),.B(1'b0),.S(si),.Y(h));
\$pmux #(.WIDTH(2),.S_WIDTH(1)) selected_gate(.A(2'b00),.B({si,h}),.S(so[1]),.Y(gated));
\$pmux #(.WIDTH(3),.S_WIDTH(4)) candidate_outer(.A(ao),.B({bo[6 +: 3],bi,ai,bo[0 +: 3]}),.S({so[2],gated,so[0]}),.Y(candidate_y));
endmodule

module k1_o3_arm2(input [2:0] ao,ai,
  input [2:0] bi, input [8:0] bo,
  input [0:0] si, input [2:0] so,
  output [2:0] reference_y,candidate_y);
wire [2:0] inner_y;
wire [8:0] outer_b;
wire h;
wire [1:0] gated;
\$pmux #(.WIDTH(3),.S_WIDTH(1)) original_inner(.A(ai),.B(bi),.S(si),.Y(inner_y));
assign outer_b[0 +: 3] = bo[0 +: 3];
assign outer_b[3 +: 3] = bo[3 +: 3];
assign outer_b[6 +: 3] = inner_y;
\$pmux #(.WIDTH(3),.S_WIDTH(3)) original_outer(.A(ao),.B(outer_b),.S(so),.Y(reference_y));
\$pmux #(.WIDTH(1),.S_WIDTH(1)) default_flag(.A(1'b1),.B(1'b0),.S(si),.Y(h));
\$pmux #(.WIDTH(2),.S_WIDTH(1)) selected_gate(.A(2'b00),.B({si,h}),.S(so[2]),.Y(gated));
\$pmux #(.WIDTH(3),.S_WIDTH(4)) candidate_outer(.A(ao),.B({bi,ai,bo[3 +: 3],bo[0 +: 3]}),.S({gated,so[1],so[0]}),.Y(candidate_y));
endmodule

module k2_o1_arm0(input [3:0] ao,ai,
  input [7:0] bi, input [3:0] bo,
  input [1:0] si, input [0:0] so,
  output [3:0] reference_y,candidate_y);
wire [3:0] inner_y;
wire [3:0] outer_b;
wire h;
wire [2:0] gated;
\$pmux #(.WIDTH(4),.S_WIDTH(2)) original_inner(.A(ai),.B(bi),.S(si),.Y(inner_y));
assign outer_b[0 +: 4] = inner_y;
\$pmux #(.WIDTH(4),.S_WIDTH(1)) original_outer(.A(ao),.B(outer_b),.S(so),.Y(reference_y));
\$pmux #(.WIDTH(1),.S_WIDTH(2)) default_flag(.A(1'b1),.B(2'b00),.S(si),.Y(h));
\$pmux #(.WIDTH(3),.S_WIDTH(1)) selected_gate(.A(3'b000),.B({si,h}),.S(so[0]),.Y(gated));
\$pmux #(.WIDTH(4),.S_WIDTH(3)) candidate_outer(.A(ao),.B({bi,ai}),.S({gated}),.Y(candidate_y));
endmodule

module k2_o2_arm0(input [3:0] ao,ai,
  input [7:0] bi, input [7:0] bo,
  input [1:0] si, input [1:0] so,
  output [3:0] reference_y,candidate_y);
wire [3:0] inner_y;
wire [7:0] outer_b;
wire h;
wire [2:0] gated;
\$pmux #(.WIDTH(4),.S_WIDTH(2)) original_inner(.A(ai),.B(bi),.S(si),.Y(inner_y));
assign outer_b[0 +: 4] = inner_y;
assign outer_b[4 +: 4] = bo[4 +: 4];
\$pmux #(.WIDTH(4),.S_WIDTH(2)) original_outer(.A(ao),.B(outer_b),.S(so),.Y(reference_y));
\$pmux #(.WIDTH(1),.S_WIDTH(2)) default_flag(.A(1'b1),.B(2'b00),.S(si),.Y(h));
\$pmux #(.WIDTH(3),.S_WIDTH(1)) selected_gate(.A(3'b000),.B({si,h}),.S(so[0]),.Y(gated));
\$pmux #(.WIDTH(4),.S_WIDTH(4)) candidate_outer(.A(ao),.B({bo[4 +: 4],bi,ai}),.S({so[1],gated}),.Y(candidate_y));
endmodule

module k2_o2_arm1(input [3:0] ao,ai,
  input [7:0] bi, input [7:0] bo,
  input [1:0] si, input [1:0] so,
  output [3:0] reference_y,candidate_y);
wire [3:0] inner_y;
wire [7:0] outer_b;
wire h;
wire [2:0] gated;
\$pmux #(.WIDTH(4),.S_WIDTH(2)) original_inner(.A(ai),.B(bi),.S(si),.Y(inner_y));
assign outer_b[0 +: 4] = bo[0 +: 4];
assign outer_b[4 +: 4] = inner_y;
\$pmux #(.WIDTH(4),.S_WIDTH(2)) original_outer(.A(ao),.B(outer_b),.S(so),.Y(reference_y));
\$pmux #(.WIDTH(1),.S_WIDTH(2)) default_flag(.A(1'b1),.B(2'b00),.S(si),.Y(h));
\$pmux #(.WIDTH(3),.S_WIDTH(1)) selected_gate(.A(3'b000),.B({si,h}),.S(so[1]),.Y(gated));
\$pmux #(.WIDTH(4),.S_WIDTH(4)) candidate_outer(.A(ao),.B({bi,ai,bo[0 +: 4]}),.S({gated,so[0]}),.Y(candidate_y));
endmodule

module k2_o3_arm0(input [3:0] ao,ai,
  input [7:0] bi, input [11:0] bo,
  input [1:0] si, input [2:0] so,
  output [3:0] reference_y,candidate_y);
wire [3:0] inner_y;
wire [11:0] outer_b;
wire h;
wire [2:0] gated;
\$pmux #(.WIDTH(4),.S_WIDTH(2)) original_inner(.A(ai),.B(bi),.S(si),.Y(inner_y));
assign outer_b[0 +: 4] = inner_y;
assign outer_b[4 +: 4] = bo[4 +: 4];
assign outer_b[8 +: 4] = bo[8 +: 4];
\$pmux #(.WIDTH(4),.S_WIDTH(3)) original_outer(.A(ao),.B(outer_b),.S(so),.Y(reference_y));
\$pmux #(.WIDTH(1),.S_WIDTH(2)) default_flag(.A(1'b1),.B(2'b00),.S(si),.Y(h));
\$pmux #(.WIDTH(3),.S_WIDTH(1)) selected_gate(.A(3'b000),.B({si,h}),.S(so[0]),.Y(gated));
\$pmux #(.WIDTH(4),.S_WIDTH(5)) candidate_outer(.A(ao),.B({bo[8 +: 4],bo[4 +: 4],bi,ai}),.S({so[2],so[1],gated}),.Y(candidate_y));
endmodule

module k2_o3_arm1(input [3:0] ao,ai,
  input [7:0] bi, input [11:0] bo,
  input [1:0] si, input [2:0] so,
  output [3:0] reference_y,candidate_y);
wire [3:0] inner_y;
wire [11:0] outer_b;
wire h;
wire [2:0] gated;
\$pmux #(.WIDTH(4),.S_WIDTH(2)) original_inner(.A(ai),.B(bi),.S(si),.Y(inner_y));
assign outer_b[0 +: 4] = bo[0 +: 4];
assign outer_b[4 +: 4] = inner_y;
assign outer_b[8 +: 4] = bo[8 +: 4];
\$pmux #(.WIDTH(4),.S_WIDTH(3)) original_outer(.A(ao),.B(outer_b),.S(so),.Y(reference_y));
\$pmux #(.WIDTH(1),.S_WIDTH(2)) default_flag(.A(1'b1),.B(2'b00),.S(si),.Y(h));
\$pmux #(.WIDTH(3),.S_WIDTH(1)) selected_gate(.A(3'b000),.B({si,h}),.S(so[1]),.Y(gated));
\$pmux #(.WIDTH(4),.S_WIDTH(5)) candidate_outer(.A(ao),.B({bo[8 +: 4],bi,ai,bo[0 +: 4]}),.S({so[2],gated,so[0]}),.Y(candidate_y));
endmodule

module k2_o3_arm2(input [3:0] ao,ai,
  input [7:0] bi, input [11:0] bo,
  input [1:0] si, input [2:0] so,
  output [3:0] reference_y,candidate_y);
wire [3:0] inner_y;
wire [11:0] outer_b;
wire h;
wire [2:0] gated;
\$pmux #(.WIDTH(4),.S_WIDTH(2)) original_inner(.A(ai),.B(bi),.S(si),.Y(inner_y));
assign outer_b[0 +: 4] = bo[0 +: 4];
assign outer_b[4 +: 4] = bo[4 +: 4];
assign outer_b[8 +: 4] = inner_y;
\$pmux #(.WIDTH(4),.S_WIDTH(3)) original_outer(.A(ao),.B(outer_b),.S(so),.Y(reference_y));
\$pmux #(.WIDTH(1),.S_WIDTH(2)) default_flag(.A(1'b1),.B(2'b00),.S(si),.Y(h));
\$pmux #(.WIDTH(3),.S_WIDTH(1)) selected_gate(.A(3'b000),.B({si,h}),.S(so[2]),.Y(gated));
\$pmux #(.WIDTH(4),.S_WIDTH(5)) candidate_outer(.A(ao),.B({bi,ai,bo[4 +: 4],bo[0 +: 4]}),.S({gated,so[1],so[0]}),.Y(candidate_y));
endmodule

module k3_o1_arm0(input [4:0] ao,ai,
  input [14:0] bi, input [4:0] bo,
  input [2:0] si, input [0:0] so,
  output [4:0] reference_y,candidate_y);
wire [4:0] inner_y;
wire [4:0] outer_b;
wire h;
wire [3:0] gated;
\$pmux #(.WIDTH(5),.S_WIDTH(3)) original_inner(.A(ai),.B(bi),.S(si),.Y(inner_y));
assign outer_b[0 +: 5] = inner_y;
\$pmux #(.WIDTH(5),.S_WIDTH(1)) original_outer(.A(ao),.B(outer_b),.S(so),.Y(reference_y));
\$pmux #(.WIDTH(1),.S_WIDTH(3)) default_flag(.A(1'b1),.B(3'b000),.S(si),.Y(h));
\$pmux #(.WIDTH(4),.S_WIDTH(1)) selected_gate(.A(4'b0000),.B({si,h}),.S(so[0]),.Y(gated));
\$pmux #(.WIDTH(5),.S_WIDTH(4)) candidate_outer(.A(ao),.B({bi,ai}),.S({gated}),.Y(candidate_y));
endmodule

module k3_o2_arm0(input [4:0] ao,ai,
  input [14:0] bi, input [9:0] bo,
  input [2:0] si, input [1:0] so,
  output [4:0] reference_y,candidate_y);
wire [4:0] inner_y;
wire [9:0] outer_b;
wire h;
wire [3:0] gated;
\$pmux #(.WIDTH(5),.S_WIDTH(3)) original_inner(.A(ai),.B(bi),.S(si),.Y(inner_y));
assign outer_b[0 +: 5] = inner_y;
assign outer_b[5 +: 5] = bo[5 +: 5];
\$pmux #(.WIDTH(5),.S_WIDTH(2)) original_outer(.A(ao),.B(outer_b),.S(so),.Y(reference_y));
\$pmux #(.WIDTH(1),.S_WIDTH(3)) default_flag(.A(1'b1),.B(3'b000),.S(si),.Y(h));
\$pmux #(.WIDTH(4),.S_WIDTH(1)) selected_gate(.A(4'b0000),.B({si,h}),.S(so[0]),.Y(gated));
\$pmux #(.WIDTH(5),.S_WIDTH(5)) candidate_outer(.A(ao),.B({bo[5 +: 5],bi,ai}),.S({so[1],gated}),.Y(candidate_y));
endmodule

module k3_o2_arm1(input [4:0] ao,ai,
  input [14:0] bi, input [9:0] bo,
  input [2:0] si, input [1:0] so,
  output [4:0] reference_y,candidate_y);
wire [4:0] inner_y;
wire [9:0] outer_b;
wire h;
wire [3:0] gated;
\$pmux #(.WIDTH(5),.S_WIDTH(3)) original_inner(.A(ai),.B(bi),.S(si),.Y(inner_y));
assign outer_b[0 +: 5] = bo[0 +: 5];
assign outer_b[5 +: 5] = inner_y;
\$pmux #(.WIDTH(5),.S_WIDTH(2)) original_outer(.A(ao),.B(outer_b),.S(so),.Y(reference_y));
\$pmux #(.WIDTH(1),.S_WIDTH(3)) default_flag(.A(1'b1),.B(3'b000),.S(si),.Y(h));
\$pmux #(.WIDTH(4),.S_WIDTH(1)) selected_gate(.A(4'b0000),.B({si,h}),.S(so[1]),.Y(gated));
\$pmux #(.WIDTH(5),.S_WIDTH(5)) candidate_outer(.A(ao),.B({bi,ai,bo[0 +: 5]}),.S({gated,so[0]}),.Y(candidate_y));
endmodule

module k3_o3_arm0(input [4:0] ao,ai,
  input [14:0] bi, input [14:0] bo,
  input [2:0] si, input [2:0] so,
  output [4:0] reference_y,candidate_y);
wire [4:0] inner_y;
wire [14:0] outer_b;
wire h;
wire [3:0] gated;
\$pmux #(.WIDTH(5),.S_WIDTH(3)) original_inner(.A(ai),.B(bi),.S(si),.Y(inner_y));
assign outer_b[0 +: 5] = inner_y;
assign outer_b[5 +: 5] = bo[5 +: 5];
assign outer_b[10 +: 5] = bo[10 +: 5];
\$pmux #(.WIDTH(5),.S_WIDTH(3)) original_outer(.A(ao),.B(outer_b),.S(so),.Y(reference_y));
\$pmux #(.WIDTH(1),.S_WIDTH(3)) default_flag(.A(1'b1),.B(3'b000),.S(si),.Y(h));
\$pmux #(.WIDTH(4),.S_WIDTH(1)) selected_gate(.A(4'b0000),.B({si,h}),.S(so[0]),.Y(gated));
\$pmux #(.WIDTH(5),.S_WIDTH(6)) candidate_outer(.A(ao),.B({bo[10 +: 5],bo[5 +: 5],bi,ai}),.S({so[2],so[1],gated}),.Y(candidate_y));
endmodule

module k3_o3_arm1(input [4:0] ao,ai,
  input [14:0] bi, input [14:0] bo,
  input [2:0] si, input [2:0] so,
  output [4:0] reference_y,candidate_y);
wire [4:0] inner_y;
wire [14:0] outer_b;
wire h;
wire [3:0] gated;
\$pmux #(.WIDTH(5),.S_WIDTH(3)) original_inner(.A(ai),.B(bi),.S(si),.Y(inner_y));
assign outer_b[0 +: 5] = bo[0 +: 5];
assign outer_b[5 +: 5] = inner_y;
assign outer_b[10 +: 5] = bo[10 +: 5];
\$pmux #(.WIDTH(5),.S_WIDTH(3)) original_outer(.A(ao),.B(outer_b),.S(so),.Y(reference_y));
\$pmux #(.WIDTH(1),.S_WIDTH(3)) default_flag(.A(1'b1),.B(3'b000),.S(si),.Y(h));
\$pmux #(.WIDTH(4),.S_WIDTH(1)) selected_gate(.A(4'b0000),.B({si,h}),.S(so[1]),.Y(gated));
\$pmux #(.WIDTH(5),.S_WIDTH(6)) candidate_outer(.A(ao),.B({bo[10 +: 5],bi,ai,bo[0 +: 5]}),.S({so[2],gated,so[0]}),.Y(candidate_y));
endmodule

module k3_o3_arm2(input [4:0] ao,ai,
  input [14:0] bi, input [14:0] bo,
  input [2:0] si, input [2:0] so,
  output [4:0] reference_y,candidate_y);
wire [4:0] inner_y;
wire [14:0] outer_b;
wire h;
wire [3:0] gated;
\$pmux #(.WIDTH(5),.S_WIDTH(3)) original_inner(.A(ai),.B(bi),.S(si),.Y(inner_y));
assign outer_b[0 +: 5] = bo[0 +: 5];
assign outer_b[5 +: 5] = bo[5 +: 5];
assign outer_b[10 +: 5] = inner_y;
\$pmux #(.WIDTH(5),.S_WIDTH(3)) original_outer(.A(ao),.B(outer_b),.S(so),.Y(reference_y));
\$pmux #(.WIDTH(1),.S_WIDTH(3)) default_flag(.A(1'b1),.B(3'b000),.S(si),.Y(h));
\$pmux #(.WIDTH(4),.S_WIDTH(1)) selected_gate(.A(4'b0000),.B({si,h}),.S(so[2]),.Y(gated));
\$pmux #(.WIDTH(5),.S_WIDTH(6)) candidate_outer(.A(ao),.B({bi,ai,bo[5 +: 5],bo[0 +: 5]}),.S({gated,so[1],so[0]}),.Y(candidate_y));
endmodule

module exhaustive_scalar_k1(input [0:0] ao,ai,
  input [0:0] bi, input [0:0] bo,
  input [0:0] si, input [0:0] so,
  output [0:0] reference_y,candidate_y);
wire [0:0] inner_y;
wire [0:0] outer_b;
wire h;
wire [1:0] gated;
\$pmux #(.WIDTH(1),.S_WIDTH(1)) original_inner(.A(ai),.B(bi),.S(si),.Y(inner_y));
assign outer_b[0 +: 1] = inner_y;
\$pmux #(.WIDTH(1),.S_WIDTH(1)) original_outer(.A(ao),.B(outer_b),.S(so),.Y(reference_y));
\$pmux #(.WIDTH(1),.S_WIDTH(1)) default_flag(.A(1'b1),.B(1'b0),.S(si),.Y(h));
\$pmux #(.WIDTH(2),.S_WIDTH(1)) selected_gate(.A(2'b00),.B({si,h}),.S(so[0]),.Y(gated));
\$pmux #(.WIDTH(1),.S_WIDTH(2)) candidate_outer(.A(ao),.B({bi,ai}),.S({gated}),.Y(candidate_y));
endmodule

module exhaustive_scalar_k2(input [0:0] ao,ai,
  input [1:0] bi, input [0:0] bo,
  input [1:0] si, input [0:0] so,
  output [0:0] reference_y,candidate_y);
wire [0:0] inner_y;
wire [0:0] outer_b;
wire h;
wire [2:0] gated;
\$pmux #(.WIDTH(1),.S_WIDTH(2)) original_inner(.A(ai),.B(bi),.S(si),.Y(inner_y));
assign outer_b[0 +: 1] = inner_y;
\$pmux #(.WIDTH(1),.S_WIDTH(1)) original_outer(.A(ao),.B(outer_b),.S(so),.Y(reference_y));
\$pmux #(.WIDTH(1),.S_WIDTH(2)) default_flag(.A(1'b1),.B(2'b00),.S(si),.Y(h));
\$pmux #(.WIDTH(3),.S_WIDTH(1)) selected_gate(.A(3'b000),.B({si,h}),.S(so[0]),.Y(gated));
\$pmux #(.WIDTH(1),.S_WIDTH(3)) candidate_outer(.A(ao),.B({bi,ai}),.S({gated}),.Y(candidate_y));
endmodule

module tb;
integer samples=0,errors=0,control_code,data_code,j,v,seed;
function symbol; input integer code; begin
 case(code%4) 0:symbol=1'b0; 1:symbol=1'b1; 2:symbol=1'bx; 3:symbol=1'bz; endcase
end endfunction
function patterned; input integer code,position; integer x; begin
 if(code<4) patterned=symbol(code);
 else if(code<8) patterned=symbol(code+position);
 else begin x=(position*1103515245+code*12345+69004); patterned=symbol((x>>16)&3); end
end endfunction
reg [2:0] ao0,ai0; reg [2:0] bi0; reg [2:0] bo0; reg [0:0] si0; reg [0:0] so0; wire [2:0] ref0,cand0; k1_o1_arm0 d0(ao0,ai0,bi0,bo0,si0,so0,ref0,cand0);
reg [2:0] ao1,ai1; reg [2:0] bi1; reg [5:0] bo1; reg [0:0] si1; reg [1:0] so1; wire [2:0] ref1,cand1; k1_o2_arm0 d1(ao1,ai1,bi1,bo1,si1,so1,ref1,cand1);
reg [2:0] ao2,ai2; reg [2:0] bi2; reg [5:0] bo2; reg [0:0] si2; reg [1:0] so2; wire [2:0] ref2,cand2; k1_o2_arm1 d2(ao2,ai2,bi2,bo2,si2,so2,ref2,cand2);
reg [2:0] ao3,ai3; reg [2:0] bi3; reg [8:0] bo3; reg [0:0] si3; reg [2:0] so3; wire [2:0] ref3,cand3; k1_o3_arm0 d3(ao3,ai3,bi3,bo3,si3,so3,ref3,cand3);
reg [2:0] ao4,ai4; reg [2:0] bi4; reg [8:0] bo4; reg [0:0] si4; reg [2:0] so4; wire [2:0] ref4,cand4; k1_o3_arm1 d4(ao4,ai4,bi4,bo4,si4,so4,ref4,cand4);
reg [2:0] ao5,ai5; reg [2:0] bi5; reg [8:0] bo5; reg [0:0] si5; reg [2:0] so5; wire [2:0] ref5,cand5; k1_o3_arm2 d5(ao5,ai5,bi5,bo5,si5,so5,ref5,cand5);
reg [3:0] ao6,ai6; reg [7:0] bi6; reg [3:0] bo6; reg [1:0] si6; reg [0:0] so6; wire [3:0] ref6,cand6; k2_o1_arm0 d6(ao6,ai6,bi6,bo6,si6,so6,ref6,cand6);
reg [3:0] ao7,ai7; reg [7:0] bi7; reg [7:0] bo7; reg [1:0] si7; reg [1:0] so7; wire [3:0] ref7,cand7; k2_o2_arm0 d7(ao7,ai7,bi7,bo7,si7,so7,ref7,cand7);
reg [3:0] ao8,ai8; reg [7:0] bi8; reg [7:0] bo8; reg [1:0] si8; reg [1:0] so8; wire [3:0] ref8,cand8; k2_o2_arm1 d8(ao8,ai8,bi8,bo8,si8,so8,ref8,cand8);
reg [3:0] ao9,ai9; reg [7:0] bi9; reg [11:0] bo9; reg [1:0] si9; reg [2:0] so9; wire [3:0] ref9,cand9; k2_o3_arm0 d9(ao9,ai9,bi9,bo9,si9,so9,ref9,cand9);
reg [3:0] ao10,ai10; reg [7:0] bi10; reg [11:0] bo10; reg [1:0] si10; reg [2:0] so10; wire [3:0] ref10,cand10; k2_o3_arm1 d10(ao10,ai10,bi10,bo10,si10,so10,ref10,cand10);
reg [3:0] ao11,ai11; reg [7:0] bi11; reg [11:0] bo11; reg [1:0] si11; reg [2:0] so11; wire [3:0] ref11,cand11; k2_o3_arm2 d11(ao11,ai11,bi11,bo11,si11,so11,ref11,cand11);
reg [4:0] ao12,ai12; reg [14:0] bi12; reg [4:0] bo12; reg [2:0] si12; reg [0:0] so12; wire [4:0] ref12,cand12; k3_o1_arm0 d12(ao12,ai12,bi12,bo12,si12,so12,ref12,cand12);
reg [4:0] ao13,ai13; reg [14:0] bi13; reg [9:0] bo13; reg [2:0] si13; reg [1:0] so13; wire [4:0] ref13,cand13; k3_o2_arm0 d13(ao13,ai13,bi13,bo13,si13,so13,ref13,cand13);
reg [4:0] ao14,ai14; reg [14:0] bi14; reg [9:0] bo14; reg [2:0] si14; reg [1:0] so14; wire [4:0] ref14,cand14; k3_o2_arm1 d14(ao14,ai14,bi14,bo14,si14,so14,ref14,cand14);
reg [4:0] ao15,ai15; reg [14:0] bi15; reg [14:0] bo15; reg [2:0] si15; reg [2:0] so15; wire [4:0] ref15,cand15; k3_o3_arm0 d15(ao15,ai15,bi15,bo15,si15,so15,ref15,cand15);
reg [4:0] ao16,ai16; reg [14:0] bi16; reg [14:0] bo16; reg [2:0] si16; reg [2:0] so16; wire [4:0] ref16,cand16; k3_o3_arm1 d16(ao16,ai16,bi16,bo16,si16,so16,ref16,cand16);
reg [4:0] ao17,ai17; reg [14:0] bi17; reg [14:0] bo17; reg [2:0] si17; reg [2:0] so17; wire [4:0] ref17,cand17; k3_o3_arm2 d17(ao17,ai17,bi17,bo17,si17,so17,ref17,cand17);
reg [0:0] ao18,ai18; reg [0:0] bi18; reg [0:0] bo18; reg [0:0] si18; reg [0:0] so18; wire [0:0] ref18,cand18; exhaustive_scalar_k1 d18(ao18,ai18,bi18,bo18,si18,so18,ref18,cand18);
reg [0:0] ao19,ai19; reg [1:0] bi19; reg [0:0] bo19; reg [1:0] si19; reg [0:0] so19; wire [0:0] ref19,cand19; exhaustive_scalar_k2 d19(ao19,ai19,bi19,bo19,si19,so19,ref19,cand19);
initial begin
for(control_code=0;control_code<16;control_code=control_code+1) begin
v=control_code;
for(j=0;j<1;j=j+1) begin si0[j]=symbol(v%4);v=v/4;end
for(j=0;j<1;j=j+1) begin so0[j]=symbol(v%4);v=v/4;end
for(data_code=0;data_code<16;data_code=data_code+1) begin
for(j=0;j<3;j=j+1) begin ao0[j]=patterned(data_code,j);ai0[j]=patterned(data_code,j+3);end
for(j=0;j<3;j=j+1) bi0[j]=patterned(data_code,j+6);
for(j=0;j<3;j=j+1) bo0[j]=patterned(data_code,j+9);
#1; samples=samples+1; if(ref0 !== cand0) begin errors=errors+1;if(errors<10)$display("DIFF k1_o1_arm0 si=%b so=%b ao=%b ai=%b bi=%b bo=%b ref=%b cand=%b",si0,so0,ao0,ai0,bi0,bo0,ref0,cand0);end
end
end
for(control_code=0;control_code<64;control_code=control_code+1) begin
v=control_code;
for(j=0;j<1;j=j+1) begin si1[j]=symbol(v%4);v=v/4;end
for(j=0;j<2;j=j+1) begin so1[j]=symbol(v%4);v=v/4;end
for(data_code=0;data_code<16;data_code=data_code+1) begin
for(j=0;j<3;j=j+1) begin ao1[j]=patterned(data_code,j);ai1[j]=patterned(data_code,j+3);end
for(j=0;j<3;j=j+1) bi1[j]=patterned(data_code,j+6);
for(j=0;j<6;j=j+1) bo1[j]=patterned(data_code,j+9);
#1; samples=samples+1; if(ref1 !== cand1) begin errors=errors+1;if(errors<10)$display("DIFF k1_o2_arm0 si=%b so=%b ao=%b ai=%b bi=%b bo=%b ref=%b cand=%b",si1,so1,ao1,ai1,bi1,bo1,ref1,cand1);end
end
end
for(control_code=0;control_code<64;control_code=control_code+1) begin
v=control_code;
for(j=0;j<1;j=j+1) begin si2[j]=symbol(v%4);v=v/4;end
for(j=0;j<2;j=j+1) begin so2[j]=symbol(v%4);v=v/4;end
for(data_code=0;data_code<16;data_code=data_code+1) begin
for(j=0;j<3;j=j+1) begin ao2[j]=patterned(data_code,j);ai2[j]=patterned(data_code,j+3);end
for(j=0;j<3;j=j+1) bi2[j]=patterned(data_code,j+6);
for(j=0;j<6;j=j+1) bo2[j]=patterned(data_code,j+9);
#1; samples=samples+1; if(ref2 !== cand2) begin errors=errors+1;if(errors<10)$display("DIFF k1_o2_arm1 si=%b so=%b ao=%b ai=%b bi=%b bo=%b ref=%b cand=%b",si2,so2,ao2,ai2,bi2,bo2,ref2,cand2);end
end
end
for(control_code=0;control_code<256;control_code=control_code+1) begin
v=control_code;
for(j=0;j<1;j=j+1) begin si3[j]=symbol(v%4);v=v/4;end
for(j=0;j<3;j=j+1) begin so3[j]=symbol(v%4);v=v/4;end
for(data_code=0;data_code<16;data_code=data_code+1) begin
for(j=0;j<3;j=j+1) begin ao3[j]=patterned(data_code,j);ai3[j]=patterned(data_code,j+3);end
for(j=0;j<3;j=j+1) bi3[j]=patterned(data_code,j+6);
for(j=0;j<9;j=j+1) bo3[j]=patterned(data_code,j+9);
#1; samples=samples+1; if(ref3 !== cand3) begin errors=errors+1;if(errors<10)$display("DIFF k1_o3_arm0 si=%b so=%b ao=%b ai=%b bi=%b bo=%b ref=%b cand=%b",si3,so3,ao3,ai3,bi3,bo3,ref3,cand3);end
end
end
for(control_code=0;control_code<256;control_code=control_code+1) begin
v=control_code;
for(j=0;j<1;j=j+1) begin si4[j]=symbol(v%4);v=v/4;end
for(j=0;j<3;j=j+1) begin so4[j]=symbol(v%4);v=v/4;end
for(data_code=0;data_code<16;data_code=data_code+1) begin
for(j=0;j<3;j=j+1) begin ao4[j]=patterned(data_code,j);ai4[j]=patterned(data_code,j+3);end
for(j=0;j<3;j=j+1) bi4[j]=patterned(data_code,j+6);
for(j=0;j<9;j=j+1) bo4[j]=patterned(data_code,j+9);
#1; samples=samples+1; if(ref4 !== cand4) begin errors=errors+1;if(errors<10)$display("DIFF k1_o3_arm1 si=%b so=%b ao=%b ai=%b bi=%b bo=%b ref=%b cand=%b",si4,so4,ao4,ai4,bi4,bo4,ref4,cand4);end
end
end
for(control_code=0;control_code<256;control_code=control_code+1) begin
v=control_code;
for(j=0;j<1;j=j+1) begin si5[j]=symbol(v%4);v=v/4;end
for(j=0;j<3;j=j+1) begin so5[j]=symbol(v%4);v=v/4;end
for(data_code=0;data_code<16;data_code=data_code+1) begin
for(j=0;j<3;j=j+1) begin ao5[j]=patterned(data_code,j);ai5[j]=patterned(data_code,j+3);end
for(j=0;j<3;j=j+1) bi5[j]=patterned(data_code,j+6);
for(j=0;j<9;j=j+1) bo5[j]=patterned(data_code,j+9);
#1; samples=samples+1; if(ref5 !== cand5) begin errors=errors+1;if(errors<10)$display("DIFF k1_o3_arm2 si=%b so=%b ao=%b ai=%b bi=%b bo=%b ref=%b cand=%b",si5,so5,ao5,ai5,bi5,bo5,ref5,cand5);end
end
end
for(control_code=0;control_code<64;control_code=control_code+1) begin
v=control_code;
for(j=0;j<2;j=j+1) begin si6[j]=symbol(v%4);v=v/4;end
for(j=0;j<1;j=j+1) begin so6[j]=symbol(v%4);v=v/4;end
for(data_code=0;data_code<16;data_code=data_code+1) begin
for(j=0;j<4;j=j+1) begin ao6[j]=patterned(data_code,j);ai6[j]=patterned(data_code,j+4);end
for(j=0;j<8;j=j+1) bi6[j]=patterned(data_code,j+8);
for(j=0;j<4;j=j+1) bo6[j]=patterned(data_code,j+16);
#1; samples=samples+1; if(ref6 !== cand6) begin errors=errors+1;if(errors<10)$display("DIFF k2_o1_arm0 si=%b so=%b ao=%b ai=%b bi=%b bo=%b ref=%b cand=%b",si6,so6,ao6,ai6,bi6,bo6,ref6,cand6);end
end
end
for(control_code=0;control_code<256;control_code=control_code+1) begin
v=control_code;
for(j=0;j<2;j=j+1) begin si7[j]=symbol(v%4);v=v/4;end
for(j=0;j<2;j=j+1) begin so7[j]=symbol(v%4);v=v/4;end
for(data_code=0;data_code<16;data_code=data_code+1) begin
for(j=0;j<4;j=j+1) begin ao7[j]=patterned(data_code,j);ai7[j]=patterned(data_code,j+4);end
for(j=0;j<8;j=j+1) bi7[j]=patterned(data_code,j+8);
for(j=0;j<8;j=j+1) bo7[j]=patterned(data_code,j+16);
#1; samples=samples+1; if(ref7 !== cand7) begin errors=errors+1;if(errors<10)$display("DIFF k2_o2_arm0 si=%b so=%b ao=%b ai=%b bi=%b bo=%b ref=%b cand=%b",si7,so7,ao7,ai7,bi7,bo7,ref7,cand7);end
end
end
for(control_code=0;control_code<256;control_code=control_code+1) begin
v=control_code;
for(j=0;j<2;j=j+1) begin si8[j]=symbol(v%4);v=v/4;end
for(j=0;j<2;j=j+1) begin so8[j]=symbol(v%4);v=v/4;end
for(data_code=0;data_code<16;data_code=data_code+1) begin
for(j=0;j<4;j=j+1) begin ao8[j]=patterned(data_code,j);ai8[j]=patterned(data_code,j+4);end
for(j=0;j<8;j=j+1) bi8[j]=patterned(data_code,j+8);
for(j=0;j<8;j=j+1) bo8[j]=patterned(data_code,j+16);
#1; samples=samples+1; if(ref8 !== cand8) begin errors=errors+1;if(errors<10)$display("DIFF k2_o2_arm1 si=%b so=%b ao=%b ai=%b bi=%b bo=%b ref=%b cand=%b",si8,so8,ao8,ai8,bi8,bo8,ref8,cand8);end
end
end
for(control_code=0;control_code<1024;control_code=control_code+1) begin
v=control_code;
for(j=0;j<2;j=j+1) begin si9[j]=symbol(v%4);v=v/4;end
for(j=0;j<3;j=j+1) begin so9[j]=symbol(v%4);v=v/4;end
for(data_code=0;data_code<16;data_code=data_code+1) begin
for(j=0;j<4;j=j+1) begin ao9[j]=patterned(data_code,j);ai9[j]=patterned(data_code,j+4);end
for(j=0;j<8;j=j+1) bi9[j]=patterned(data_code,j+8);
for(j=0;j<12;j=j+1) bo9[j]=patterned(data_code,j+16);
#1; samples=samples+1; if(ref9 !== cand9) begin errors=errors+1;if(errors<10)$display("DIFF k2_o3_arm0 si=%b so=%b ao=%b ai=%b bi=%b bo=%b ref=%b cand=%b",si9,so9,ao9,ai9,bi9,bo9,ref9,cand9);end
end
end
for(control_code=0;control_code<1024;control_code=control_code+1) begin
v=control_code;
for(j=0;j<2;j=j+1) begin si10[j]=symbol(v%4);v=v/4;end
for(j=0;j<3;j=j+1) begin so10[j]=symbol(v%4);v=v/4;end
for(data_code=0;data_code<16;data_code=data_code+1) begin
for(j=0;j<4;j=j+1) begin ao10[j]=patterned(data_code,j);ai10[j]=patterned(data_code,j+4);end
for(j=0;j<8;j=j+1) bi10[j]=patterned(data_code,j+8);
for(j=0;j<12;j=j+1) bo10[j]=patterned(data_code,j+16);
#1; samples=samples+1; if(ref10 !== cand10) begin errors=errors+1;if(errors<10)$display("DIFF k2_o3_arm1 si=%b so=%b ao=%b ai=%b bi=%b bo=%b ref=%b cand=%b",si10,so10,ao10,ai10,bi10,bo10,ref10,cand10);end
end
end
for(control_code=0;control_code<1024;control_code=control_code+1) begin
v=control_code;
for(j=0;j<2;j=j+1) begin si11[j]=symbol(v%4);v=v/4;end
for(j=0;j<3;j=j+1) begin so11[j]=symbol(v%4);v=v/4;end
for(data_code=0;data_code<16;data_code=data_code+1) begin
for(j=0;j<4;j=j+1) begin ao11[j]=patterned(data_code,j);ai11[j]=patterned(data_code,j+4);end
for(j=0;j<8;j=j+1) bi11[j]=patterned(data_code,j+8);
for(j=0;j<12;j=j+1) bo11[j]=patterned(data_code,j+16);
#1; samples=samples+1; if(ref11 !== cand11) begin errors=errors+1;if(errors<10)$display("DIFF k2_o3_arm2 si=%b so=%b ao=%b ai=%b bi=%b bo=%b ref=%b cand=%b",si11,so11,ao11,ai11,bi11,bo11,ref11,cand11);end
end
end
for(control_code=0;control_code<256;control_code=control_code+1) begin
v=control_code;
for(j=0;j<3;j=j+1) begin si12[j]=symbol(v%4);v=v/4;end
for(j=0;j<1;j=j+1) begin so12[j]=symbol(v%4);v=v/4;end
for(data_code=0;data_code<16;data_code=data_code+1) begin
for(j=0;j<5;j=j+1) begin ao12[j]=patterned(data_code,j);ai12[j]=patterned(data_code,j+5);end
for(j=0;j<15;j=j+1) bi12[j]=patterned(data_code,j+10);
for(j=0;j<5;j=j+1) bo12[j]=patterned(data_code,j+25);
#1; samples=samples+1; if(ref12 !== cand12) begin errors=errors+1;if(errors<10)$display("DIFF k3_o1_arm0 si=%b so=%b ao=%b ai=%b bi=%b bo=%b ref=%b cand=%b",si12,so12,ao12,ai12,bi12,bo12,ref12,cand12);end
end
end
for(control_code=0;control_code<1024;control_code=control_code+1) begin
v=control_code;
for(j=0;j<3;j=j+1) begin si13[j]=symbol(v%4);v=v/4;end
for(j=0;j<2;j=j+1) begin so13[j]=symbol(v%4);v=v/4;end
for(data_code=0;data_code<16;data_code=data_code+1) begin
for(j=0;j<5;j=j+1) begin ao13[j]=patterned(data_code,j);ai13[j]=patterned(data_code,j+5);end
for(j=0;j<15;j=j+1) bi13[j]=patterned(data_code,j+10);
for(j=0;j<10;j=j+1) bo13[j]=patterned(data_code,j+25);
#1; samples=samples+1; if(ref13 !== cand13) begin errors=errors+1;if(errors<10)$display("DIFF k3_o2_arm0 si=%b so=%b ao=%b ai=%b bi=%b bo=%b ref=%b cand=%b",si13,so13,ao13,ai13,bi13,bo13,ref13,cand13);end
end
end
for(control_code=0;control_code<1024;control_code=control_code+1) begin
v=control_code;
for(j=0;j<3;j=j+1) begin si14[j]=symbol(v%4);v=v/4;end
for(j=0;j<2;j=j+1) begin so14[j]=symbol(v%4);v=v/4;end
for(data_code=0;data_code<16;data_code=data_code+1) begin
for(j=0;j<5;j=j+1) begin ao14[j]=patterned(data_code,j);ai14[j]=patterned(data_code,j+5);end
for(j=0;j<15;j=j+1) bi14[j]=patterned(data_code,j+10);
for(j=0;j<10;j=j+1) bo14[j]=patterned(data_code,j+25);
#1; samples=samples+1; if(ref14 !== cand14) begin errors=errors+1;if(errors<10)$display("DIFF k3_o2_arm1 si=%b so=%b ao=%b ai=%b bi=%b bo=%b ref=%b cand=%b",si14,so14,ao14,ai14,bi14,bo14,ref14,cand14);end
end
end
for(control_code=0;control_code<4096;control_code=control_code+1) begin
v=control_code;
for(j=0;j<3;j=j+1) begin si15[j]=symbol(v%4);v=v/4;end
for(j=0;j<3;j=j+1) begin so15[j]=symbol(v%4);v=v/4;end
for(data_code=0;data_code<16;data_code=data_code+1) begin
for(j=0;j<5;j=j+1) begin ao15[j]=patterned(data_code,j);ai15[j]=patterned(data_code,j+5);end
for(j=0;j<15;j=j+1) bi15[j]=patterned(data_code,j+10);
for(j=0;j<15;j=j+1) bo15[j]=patterned(data_code,j+25);
#1; samples=samples+1; if(ref15 !== cand15) begin errors=errors+1;if(errors<10)$display("DIFF k3_o3_arm0 si=%b so=%b ao=%b ai=%b bi=%b bo=%b ref=%b cand=%b",si15,so15,ao15,ai15,bi15,bo15,ref15,cand15);end
end
end
for(control_code=0;control_code<4096;control_code=control_code+1) begin
v=control_code;
for(j=0;j<3;j=j+1) begin si16[j]=symbol(v%4);v=v/4;end
for(j=0;j<3;j=j+1) begin so16[j]=symbol(v%4);v=v/4;end
for(data_code=0;data_code<16;data_code=data_code+1) begin
for(j=0;j<5;j=j+1) begin ao16[j]=patterned(data_code,j);ai16[j]=patterned(data_code,j+5);end
for(j=0;j<15;j=j+1) bi16[j]=patterned(data_code,j+10);
for(j=0;j<15;j=j+1) bo16[j]=patterned(data_code,j+25);
#1; samples=samples+1; if(ref16 !== cand16) begin errors=errors+1;if(errors<10)$display("DIFF k3_o3_arm1 si=%b so=%b ao=%b ai=%b bi=%b bo=%b ref=%b cand=%b",si16,so16,ao16,ai16,bi16,bo16,ref16,cand16);end
end
end
for(control_code=0;control_code<4096;control_code=control_code+1) begin
v=control_code;
for(j=0;j<3;j=j+1) begin si17[j]=symbol(v%4);v=v/4;end
for(j=0;j<3;j=j+1) begin so17[j]=symbol(v%4);v=v/4;end
for(data_code=0;data_code<16;data_code=data_code+1) begin
for(j=0;j<5;j=j+1) begin ao17[j]=patterned(data_code,j);ai17[j]=patterned(data_code,j+5);end
for(j=0;j<15;j=j+1) bi17[j]=patterned(data_code,j+10);
for(j=0;j<15;j=j+1) bo17[j]=patterned(data_code,j+25);
#1; samples=samples+1; if(ref17 !== cand17) begin errors=errors+1;if(errors<10)$display("DIFF k3_o3_arm2 si=%b so=%b ao=%b ai=%b bi=%b bo=%b ref=%b cand=%b",si17,so17,ao17,ai17,bi17,bo17,ref17,cand17);end
end
end
for(control_code=0;control_code<16;control_code=control_code+1) begin
v=control_code;
for(j=0;j<1;j=j+1) begin si18[j]=symbol(v%4);v=v/4;end
for(j=0;j<1;j=j+1) begin so18[j]=symbol(v%4);v=v/4;end
for(data_code=0;data_code<64;data_code=data_code+1) begin
v=data_code;ao18=symbol(v%4);v=v/4;ai18=symbol(v%4);v=v/4;bo18=0;
for(j=0;j<1;j=j+1) begin bi18[j]=symbol(v%4);v=v/4;end
#1; samples=samples+1; if(ref18 !== cand18) begin errors=errors+1;if(errors<10)$display("DIFF exhaustive_scalar_k1 si=%b so=%b ao=%b ai=%b bi=%b bo=%b ref=%b cand=%b",si18,so18,ao18,ai18,bi18,bo18,ref18,cand18);end
end
end
for(control_code=0;control_code<64;control_code=control_code+1) begin
v=control_code;
for(j=0;j<2;j=j+1) begin si19[j]=symbol(v%4);v=v/4;end
for(j=0;j<1;j=j+1) begin so19[j]=symbol(v%4);v=v/4;end
for(data_code=0;data_code<256;data_code=data_code+1) begin
v=data_code;ao19=symbol(v%4);v=v/4;ai19=symbol(v%4);v=v/4;bo19=0;
for(j=0;j<2;j=j+1) begin bi19[j]=symbol(v%4);v=v/4;end
#1; samples=samples+1; if(ref19 !== cand19) begin errors=errors+1;if(errors<10)$display("DIFF exhaustive_scalar_k2 si=%b so=%b ao=%b ai=%b bi=%b bo=%b ref=%b cand=%b",si19,so19,ao19,ai19,bi19,bo19,ref19,cand19);end
end
end
$display("RESULT samples=%0d errors=%0d",samples,errors);if(errors)$fatal(1,"Mismatch");$finish;end endmodule
