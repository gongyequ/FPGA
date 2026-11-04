autoidx 1
attribute \top 1
module \data_arm_d4_w8_k2
  wire width 8 input 1 \a0
  wire width 16 input 2 \b0
  wire width 2 input 3 \s0
  wire width 8 \y0
  wire width 8 input 4 \a1
  wire width 16 input 5 \b1
  wire width 2 input 6 \s1
  wire width 8 \y1
  wire width 8 input 7 \a2
  wire width 16 input 8 \b2
  wire width 2 input 9 \s2
  wire width 8 \y2
  wire width 8 input 10 \a3
  wire width 16 input 11 \b3
  wire width 2 input 12 \s3
  wire width 8 \y3
  wire width 8 output 13 \out0
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
    connect \B { \b1 [7:0] \y0 }
    connect \S { \s1 [0] \s1 [1] }
    connect \Y \y1
  end
  cell $pmux \p2
    parameter \WIDTH 8
    parameter \S_WIDTH 2
    connect \A \a2
    connect \B { \y1 \b2 [15:8] }
    connect \S { \s2 [0] \s2 [1] }
    connect \Y \y2
  end
  cell $pmux \p3
    parameter \WIDTH 8
    parameter \S_WIDTH 2
    connect \A \a3
    connect \B { \b3 [7:0] \y2 }
    connect \S { \s3 [0] \s3 [1] }
    connect \Y \y3
  end
  connect \out0 \y3
end
