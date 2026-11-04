autoidx 1
attribute \top 1
module \mixed_chain_d7_w12_k2
  wire width 12 input 1 \a0
  wire width 24 input 2 \b0
  wire width 2 input 3 \s0
  wire width 12 \y0
  wire width 24 input 4 \b1
  wire width 2 input 5 \s1
  wire width 12 \y1
  wire width 12 input 6 \a2
  wire width 24 input 7 \b2
  wire width 2 input 8 \s2
  wire width 12 \y2
  wire width 24 input 9 \b3
  wire width 2 input 10 \s3
  wire width 12 \y3
  wire width 12 input 11 \a4
  wire width 24 input 12 \b4
  wire width 2 input 13 \s4
  wire width 12 \y4
  wire width 24 input 14 \b5
  wire width 2 input 15 \s5
  wire width 12 \y5
  wire width 12 input 16 \a6
  wire width 24 input 17 \b6
  wire width 2 input 18 \s6
  wire width 12 \y6
  wire width 12 output 19 \out0
  cell $pmux \p0
    parameter \WIDTH 12
    parameter \S_WIDTH 2
    connect \A \a0
    connect \B { \b0 [23:12] \b0 [11:0] }
    connect \S { \s0 [1] \s0 [0] }
    connect \Y \y0
  end
  cell $pmux \p1
    parameter \WIDTH 12
    parameter \S_WIDTH 2
    connect \A \y0
    connect \B { \b1 [23:12] \b1 [11:0] }
    connect \S { \s1 [1] \s1 [0] }
    connect \Y \y1
  end
  cell $pmux \p2
    parameter \WIDTH 12
    parameter \S_WIDTH 2
    connect \A \a2
    connect \B { \y1 \b2 [23:12] }
    connect \S { \s2 [0] \s2 [1] }
    connect \Y \y2
  end
  cell $pmux \p3
    parameter \WIDTH 12
    parameter \S_WIDTH 2
    connect \A \y2
    connect \B { \b3 [23:12] \b3 [11:0] }
    connect \S { \s3 [1] \s3 [0] }
    connect \Y \y3
  end
  cell $pmux \p4
    parameter \WIDTH 12
    parameter \S_WIDTH 2
    connect \A \a4
    connect \B { \y3 \b4 [23:12] }
    connect \S { \s4 [0] \s4 [1] }
    connect \Y \y4
  end
  cell $pmux \p5
    parameter \WIDTH 12
    parameter \S_WIDTH 2
    connect \A \y4
    connect \B { \b5 [23:12] \b5 [11:0] }
    connect \S { \s5 [1] \s5 [0] }
    connect \Y \y5
  end
  cell $pmux \p6
    parameter \WIDTH 12
    parameter \S_WIDTH 2
    connect \A \a6
    connect \B { \y5 \b6 [23:12] }
    connect \S { \s6 [0] \s6 [1] }
    connect \Y \y6
  end
  connect \out0 \y6
end
