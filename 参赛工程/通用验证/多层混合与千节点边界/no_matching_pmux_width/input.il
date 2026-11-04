autoidx 1
attribute \top 1
module \no_matching_pmux_width
  wire width 2 input 1 \a0
  wire width 6 input 2 \b0
  wire width 3 input 3 \s0
  wire width 2 \y0
  wire width 6 input 4 \b1
  wire width 3 input 5 \s1
  wire width 2 \y1
  wire width 2 output 6 \out0
  cell $pmux \p0
    parameter \WIDTH 2
    parameter \S_WIDTH 3
    connect \A \a0
    connect \B { \b0 [5:4] \b0 [3:2] \b0 [1:0] }
    connect \S { \s0 [2] \s0 [1] \s0 [0] }
    connect \Y \y0
  end
  cell $pmux \p1
    parameter \WIDTH 2
    parameter \S_WIDTH 3
    connect \A \y0
    connect \B { \b1 [5:4] \b1 [3:2] \b1 [1:0] }
    connect \S { \s1 [2] \s1 [1] \s1 [0] }
    connect \Y \y1
  end
  connect \out0 \y1
end
