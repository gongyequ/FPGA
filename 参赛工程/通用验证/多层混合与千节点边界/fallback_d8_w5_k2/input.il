autoidx 1
attribute \top 1
module \fallback_d8_w5_k2
  wire width 5 input 1 \a0
  wire width 10 input 2 \b0
  wire width 2 input 3 \s0
  wire width 5 \y0
  wire width 10 input 4 \b1
  wire width 2 input 5 \s1
  wire width 5 \y1
  wire width 10 input 6 \b2
  wire width 2 input 7 \s2
  wire width 5 \y2
  wire width 10 input 8 \b3
  wire width 2 input 9 \s3
  wire width 5 \y3
  wire width 10 input 10 \b4
  wire width 2 input 11 \s4
  wire width 5 \y4
  wire width 10 input 12 \b5
  wire width 2 input 13 \s5
  wire width 5 \y5
  wire width 10 input 14 \b6
  wire width 2 input 15 \s6
  wire width 5 \y6
  wire width 10 input 16 \b7
  wire width 2 input 17 \s7
  wire width 5 \y7
  wire width 5 output 18 \out0
  cell $pmux \p0
    parameter \WIDTH 5
    parameter \S_WIDTH 2
    connect \A \a0
    connect \B { \b0 [9:5] \b0 [4:0] }
    connect \S { \s0 [1] \s0 [0] }
    connect \Y \y0
  end
  cell $pmux \p1
    parameter \WIDTH 5
    parameter \S_WIDTH 2
    connect \A \y0
    connect \B { \b1 [9:5] \b1 [4:0] }
    connect \S { \s1 [1] \s1 [0] }
    connect \Y \y1
  end
  cell $pmux \p2
    parameter \WIDTH 5
    parameter \S_WIDTH 2
    connect \A \y1
    connect \B { \b2 [9:5] \b2 [4:0] }
    connect \S { \s2 [1] \s2 [0] }
    connect \Y \y2
  end
  cell $pmux \p3
    parameter \WIDTH 5
    parameter \S_WIDTH 2
    connect \A \y2
    connect \B { \b3 [9:5] \b3 [4:0] }
    connect \S { \s3 [1] \s3 [0] }
    connect \Y \y3
  end
  cell $pmux \p4
    parameter \WIDTH 5
    parameter \S_WIDTH 2
    connect \A \y3
    connect \B { \b4 [9:5] \b4 [4:0] }
    connect \S { \s4 [1] \s4 [0] }
    connect \Y \y4
  end
  cell $pmux \p5
    parameter \WIDTH 5
    parameter \S_WIDTH 2
    connect \A \y4
    connect \B { \b5 [9:5] \b5 [4:0] }
    connect \S { \s5 [1] \s5 [0] }
    connect \Y \y5
  end
  cell $pmux \p6
    parameter \WIDTH 5
    parameter \S_WIDTH 2
    connect \A \y5
    connect \B { \b6 [9:5] \b6 [4:0] }
    connect \S { \s6 [1] \s6 [0] }
    connect \Y \y6
  end
  cell $pmux \p7
    parameter \WIDTH 5
    parameter \S_WIDTH 2
    connect \A \y6
    connect \B { \b7 [9:5] \b7 [4:0] }
    connect \S { \s7 [1] \s7 [0] }
    connect \Y \y7
  end
  connect \out0 \y7
end
