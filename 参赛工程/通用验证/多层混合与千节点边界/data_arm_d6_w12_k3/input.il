autoidx 1
attribute \top 1
module \data_arm_d6_w12_k3
  wire width 12 input 1 \a0
  wire width 36 input 2 \b0
  wire width 3 input 3 \s0
  wire width 12 \y0
  wire width 12 input 4 \a1
  wire width 36 input 5 \b1
  wire width 3 input 6 \s1
  wire width 12 \y1
  wire width 12 input 7 \a2
  wire width 36 input 8 \b2
  wire width 3 input 9 \s2
  wire width 12 \y2
  wire width 12 input 10 \a3
  wire width 36 input 11 \b3
  wire width 3 input 12 \s3
  wire width 12 \y3
  wire width 12 input 13 \a4
  wire width 36 input 14 \b4
  wire width 3 input 15 \s4
  wire width 12 \y4
  wire width 12 input 16 \a5
  wire width 36 input 17 \b5
  wire width 3 input 18 \s5
  wire width 12 \y5
  wire width 12 output 19 \out0
  cell $pmux \p0
    parameter \WIDTH 12
    parameter \S_WIDTH 3
    connect \A \a0
    connect \B { \b0 [35:24] \b0 [23:12] \b0 [11:0] }
    connect \S { \s0 [2] \s0 [1] \s0 [0] }
    connect \Y \y0
  end
  cell $pmux \p1
    parameter \WIDTH 12
    parameter \S_WIDTH 3
    connect \A \a1
    connect \B { \b1 [11:0] \y0 \b1 [35:24] }
    connect \S { \s1 [0] \s1 [1] \s1 [2] }
    connect \Y \y1
  end
  cell $pmux \p2
    parameter \WIDTH 12
    parameter \S_WIDTH 3
    connect \A \a2
    connect \B { \b2 [11:0] \b2 [23:12] \y1 }
    connect \S { \s2 [0] \s2 [1] \s2 [2] }
    connect \Y \y2
  end
  cell $pmux \p3
    parameter \WIDTH 12
    parameter \S_WIDTH 3
    connect \A \a3
    connect \B { \y2 \b3 [23:12] \b3 [35:24] }
    connect \S { \s3 [0] \s3 [1] \s3 [2] }
    connect \Y \y3
  end
  cell $pmux \p4
    parameter \WIDTH 12
    parameter \S_WIDTH 3
    connect \A \a4
    connect \B { \b4 [11:0] \y3 \b4 [35:24] }
    connect \S { \s4 [0] \s4 [1] \s4 [2] }
    connect \Y \y4
  end
  cell $pmux \p5
    parameter \WIDTH 12
    parameter \S_WIDTH 3
    connect \A \a5
    connect \B { \b5 [11:0] \b5 [23:12] \y4 }
    connect \S { \s5 [0] \s5 [1] \s5 [2] }
    connect \Y \y5
  end
  connect \out0 \y5
end
