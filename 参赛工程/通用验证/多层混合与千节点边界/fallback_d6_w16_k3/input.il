autoidx 1
attribute \top 1
module \fallback_d6_w16_k3
  wire width 16 input 1 \a0
  wire width 48 input 2 \b0
  wire width 3 input 3 \s0
  wire width 16 \y0
  wire width 48 input 4 \b1
  wire width 3 input 5 \s1
  wire width 16 \y1
  wire width 48 input 6 \b2
  wire width 3 input 7 \s2
  wire width 16 \y2
  wire width 48 input 8 \b3
  wire width 3 input 9 \s3
  wire width 16 \y3
  wire width 48 input 10 \b4
  wire width 3 input 11 \s4
  wire width 16 \y4
  wire width 48 input 12 \b5
  wire width 3 input 13 \s5
  wire width 16 \y5
  wire width 16 output 14 \out0
  cell $pmux \p0
    parameter \WIDTH 16
    parameter \S_WIDTH 3
    connect \A \a0
    connect \B { \b0 [47:32] \b0 [31:16] \b0 [15:0] }
    connect \S { \s0 [2] \s0 [1] \s0 [0] }
    connect \Y \y0
  end
  cell $pmux \p1
    parameter \WIDTH 16
    parameter \S_WIDTH 3
    connect \A \y0
    connect \B { \b1 [47:32] \b1 [31:16] \b1 [15:0] }
    connect \S { \s1 [2] \s1 [1] \s1 [0] }
    connect \Y \y1
  end
  cell $pmux \p2
    parameter \WIDTH 16
    parameter \S_WIDTH 3
    connect \A \y1
    connect \B { \b2 [47:32] \b2 [31:16] \b2 [15:0] }
    connect \S { \s2 [2] \s2 [1] \s2 [0] }
    connect \Y \y2
  end
  cell $pmux \p3
    parameter \WIDTH 16
    parameter \S_WIDTH 3
    connect \A \y2
    connect \B { \b3 [47:32] \b3 [31:16] \b3 [15:0] }
    connect \S { \s3 [2] \s3 [1] \s3 [0] }
    connect \Y \y3
  end
  cell $pmux \p4
    parameter \WIDTH 16
    parameter \S_WIDTH 3
    connect \A \y3
    connect \B { \b4 [47:32] \b4 [31:16] \b4 [15:0] }
    connect \S { \s4 [2] \s4 [1] \s4 [0] }
    connect \Y \y4
  end
  cell $pmux \p5
    parameter \WIDTH 16
    parameter \S_WIDTH 3
    connect \A \y4
    connect \B { \b5 [47:32] \b5 [31:16] \b5 [15:0] }
    connect \S { \s5 [2] \s5 [1] \s5 [0] }
    connect \Y \y5
  end
  connect \out0 \y5
end
