autoidx 1
attribute \top 1
module \shared_child_top_output
  wire width 8 input 1 \a0
  wire width 16 input 2 \b0
  wire width 2 input 3 \s0
  wire width 8 \y0
  wire width 8 input 4 \a1
  wire width 16 input 5 \b1
  wire width 2 input 6 \s1
  wire width 8 \y1
  wire width 8 output 7 \out0
  wire width 8 output 8 \out1
  cell $pmux \p0
    parameter \WIDTH 8
    parameter \S_WIDTH 2
    connect \A \a0
    connect \B { \b0 [15:8] \b0 [7:0] }
    connect \S { \s0 [1] \s0 [0] }
    connect \Y \y0
  end
  cell $pmux \p1
    parameter \WIDTH 8
    parameter \S_WIDTH 2
    connect \A \a1
    connect \B { \b1 [15:8] \y0 }
    connect \S { \s1 [1] \s1 [0] }
    connect \Y \y1
  end
  connect \out0 \y0
  connect \out1 \y1
end
