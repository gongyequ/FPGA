autoidx 1
attribute \top 1
module \shared_child_a_and_b
  wire width 8 input 1 \a0
  wire width 16 input 2 \b0
  wire width 2 input 3 \s0
  wire width 8 \y0
  wire width 16 input 4 \b1
  wire width 2 input 5 \s1
  wire width 8 \y1
  wire width 8 input 6 \a2
  wire width 16 input 7 \b2
  wire width 2 input 8 \s2
  wire width 8 \y2
  wire width 8 output 9 \out0
  wire width 8 output 10 \out1
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
    connect \A \y0
    connect \B { \b1 [15:8] \b1 [7:0] }
    connect \S { \s1 [1] \s1 [0] }
    connect \Y \y1
  end
  cell $pmux \p2
    parameter \WIDTH 8
    parameter \S_WIDTH 2
    connect \A \a2
    connect \B { \y0 \b2 [7:0] }
    connect \S { \s2 [1] \s2 [0] }
    connect \Y \y2
  end
  connect \out0 \y1
  connect \out1 \y2
end
