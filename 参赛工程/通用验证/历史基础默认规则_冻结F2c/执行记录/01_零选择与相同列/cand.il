autoidx 1
module \zero_mid_cand
  wire width 2 input 1 \a
  wire width 2 input 2 \b
  wire width 2 input 3 \c
  wire width 2 input 4 \s
  wire width 2 output 5 \y
  cell $pmux \p
    parameter \WIDTH 2
    parameter \S_WIDTH 3
    connect \A \a
    connect \B { \c \a \b }
    connect \S { \s [1] 1'0 \s [0] }
    connect \Y \y
  end
end
module \zero_one_cand
  wire width 2 input 1 \a
  wire width 2 input 2 \b
  wire width 2 input 3 \c
  wire width 2 input 4 \s
  wire width 2 output 5 \y
  cell $pmux \p
    parameter \WIDTH 2
    parameter \S_WIDTH 2
    connect \A \a
    connect \B { \c \b }
    connect \S { 1'0 \s [0] }
    connect \Y \y
  end
end
module \zero_all_cand
  wire width 2 input 1 \a
  wire width 2 input 2 \b
  wire width 2 input 3 \c
  wire width 2 input 4 \s
  wire width 2 output 5 \y
  cell $pmux \p
    parameter \WIDTH 2
    parameter \S_WIDTH 2
    connect \A \a
    connect \B { \c \b }
    connect \S 2'00
    connect \Y \y
  end
end
module \same_default_cand
  wire width 2 input 1 \a
  wire width 2 input 2 \b
  wire width 2 input 3 \c
  wire width 2 input 4 \s
  wire width 2 output 5 \y
  cell $pmux \p
    parameter \WIDTH 2
    parameter \S_WIDTH 2
    connect \A \a
    connect \B { \b \a }
    connect \S \s
    connect \Y \y
  end
end
module \columns_cand
  wire width 2 input 1 \a
  wire width 2 input 2 \b
  wire width 2 input 3 \c
  wire width 2 input 4 \s
  wire width 4 output 5 \y
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 2
    connect \A { \a \a }
    connect \B { \c \c \b \b }
    connect \S \s
    connect \Y \y
  end
end
module \wide_cand
  wire width 257 input 1 \a
  wire input 2 \s
  wire width 259 output 3 \y
  cell $pmux \p
    parameter \WIDTH 259
    parameter \S_WIDTH 1
    connect \A { \a [0] \a [256] \a }
    connect \B { \a [0] \a [256] \a }
    connect \S \s
    connect \Y \y
  end
end
