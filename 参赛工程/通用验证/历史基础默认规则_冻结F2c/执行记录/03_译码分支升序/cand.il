autoidx 1
module \c0_cand
  wire width 2 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 12 input 3 \b
  wire width 4 output 4 \y
  wire width 3 \decoded
  cell $eq \e0
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 2'10
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 2
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 1'0
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 2
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 1'1
    connect \Y \decoded [2]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 3
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c1_cand
  wire width 2 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 12 input 3 \b
  wire width 4 output 4 \y
  wire width 3 \decoded
  cell $eq \e0
    parameter \A_WIDTH 1
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 1'0
    connect \B \ctrl
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 2'10
    connect \B \ctrl
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 1
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 1'1
    connect \B \ctrl
    connect \Y \decoded [2]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 3
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c2_cand
  wire width 2 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 12 input 3 \b
  wire width 4 output 4 \y
  wire width 3 \decoded
  cell $eq \e0
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 2'10
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 2'01
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 2
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 1'0
    connect \Y \decoded [2]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 3
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c3_cand
  wire width 2 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 12 input 3 \b
  wire width 4 output 4 \y
  wire width 3 \decoded
  cell $eq \e0
    parameter \A_WIDTH 1
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 1'0
    connect \B \ctrl
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 2'01
    connect \B \ctrl
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 2'10
    connect \B \ctrl
    connect \Y \decoded [2]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 3
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c4_cand
  wire width 2 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 12 input 3 \b
  wire width 4 output 4 \y
  wire width 3 \decoded
  cell $eq \e0
    parameter \A_WIDTH 2
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 1'1
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 2
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 1'0
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 2'11
    connect \Y \decoded [2]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 3
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c5_cand
  wire width 2 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 12 input 3 \b
  wire width 4 output 4 \y
  wire width 3 \decoded
  cell $eq \e0
    parameter \A_WIDTH 1
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 1'1
    connect \B \ctrl
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 1
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 1'0
    connect \B \ctrl
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 2'11
    connect \B \ctrl
    connect \Y \decoded [2]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 3
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c6_cand
  wire width 2 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 12 input 3 \b
  wire width 4 output 4 \y
  wire width 3 \decoded
  cell $eq \e0
    parameter \A_WIDTH 2
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 1'0
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 2'01
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 2
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 1'1
    connect \Y \decoded [2]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 3
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c7_cand
  wire width 2 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 12 input 3 \b
  wire width 4 output 4 \y
  wire width 3 \decoded
  cell $eq \e0
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 2'01
    connect \B \ctrl
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 1
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 1'0
    connect \B \ctrl
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 1
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 1'1
    connect \B \ctrl
    connect \Y \decoded [2]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 3
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c8_cand
  wire width 2 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 12 input 3 \b
  wire width 4 output 4 \y
  wire width 3 \decoded
  cell $eq \e0
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 2'10
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 2
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 1'0
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 2'11
    connect \Y \decoded [2]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 3
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c9_cand
  wire width 2 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 12 input 3 \b
  wire width 4 output 4 \y
  wire width 3 \decoded
  cell $eq \e0
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 2'11
    connect \B \ctrl
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 2'10
    connect \B \ctrl
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 1
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 1'0
    connect \B \ctrl
    connect \Y \decoded [2]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 3
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c10_cand
  wire width 2 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 12 input 3 \b
  wire width 4 output 4 \y
  wire width 3 \decoded
  cell $eq \e0
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 2'10
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 2
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 1'0
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 2
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 1'1
    connect \Y \decoded [2]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 3
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c11_cand
  wire width 2 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 12 input 3 \b
  wire width 4 output 4 \y
  wire width 3 \decoded
  cell $eq \e0
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 2'10
    connect \B \ctrl
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 1
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 1'1
    connect \B \ctrl
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 1
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 1'0
    connect \B \ctrl
    connect \Y \decoded [2]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 3
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c12_cand
  wire width 2 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 12 input 3 \b
  wire width 4 output 4 \y
  wire width 3 \decoded
  cell $eq \e0
    parameter \A_WIDTH 2
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 1'1
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 2'10
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 2'11
    connect \Y \decoded [2]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 3
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c13_cand
  wire width 2 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 12 input 3 \b
  wire width 4 output 4 \y
  wire width 3 \decoded
  cell $eq \e0
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 2'11
    connect \B \ctrl
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 2'10
    connect \B \ctrl
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 1
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 1'1
    connect \B \ctrl
    connect \Y \decoded [2]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 3
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c14_cand
  wire width 2 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 12 input 3 \b
  wire width 4 output 4 \y
  wire width 3 \decoded
  cell $eq \e0
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 2'01
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 2
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 1'1
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 2'10
    connect \Y \decoded [2]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 3
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c15_cand
  wire width 2 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 12 input 3 \b
  wire width 4 output 4 \y
  wire width 3 \decoded
  cell $eq \e0
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 2'10
    connect \B \ctrl
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 2'01
    connect \B \ctrl
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 1
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 1'1
    connect \B \ctrl
    connect \Y \decoded [2]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 3
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c16_cand
  wire width 2 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 16 input 3 \b
  wire width 4 output 4 \y
  wire width 4 \decoded
  cell $eq \e0
    parameter \A_WIDTH 2
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 1'1
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 2
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 1'0
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 2'10
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 2'11
    connect \Y \decoded [3]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 4
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c17_cand
  wire width 2 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 16 input 3 \b
  wire width 4 output 4 \y
  wire width 4 \decoded
  cell $eq \e0
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 2'10
    connect \B \ctrl
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 1
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 1'0
    connect \B \ctrl
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 1
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 1'1
    connect \B \ctrl
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 2'11
    connect \B \ctrl
    connect \Y \decoded [3]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 4
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c18_cand
  wire width 2 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 16 input 3 \b
  wire width 4 output 4 \y
  wire width 4 \decoded
  cell $eq \e0
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 2'01
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 2
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 1'1
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 2'10
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 2
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 1'0
    connect \Y \decoded [3]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 4
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c19_cand
  wire width 2 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 16 input 3 \b
  wire width 4 output 4 \y
  wire width 4 \decoded
  cell $eq \e0
    parameter \A_WIDTH 1
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 1'0
    connect \B \ctrl
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 2'01
    connect \B \ctrl
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 1
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 1'1
    connect \B \ctrl
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 2'10
    connect \B \ctrl
    connect \Y \decoded [3]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 4
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c20_cand
  wire width 3 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 28 input 3 \b
  wire width 4 output 4 \y
  wire width 7 \decoded
  cell $eq \e0
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 3'100
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 3'110
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 3
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 2'10
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 3
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 1'0
    connect \Y \decoded [3]
  end
  cell $eq \e4
    parameter \A_WIDTH 3
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 1'1
    connect \Y \decoded [4]
  end
  cell $eq \e5
    parameter \A_WIDTH 3
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 2'11
    connect \Y \decoded [5]
  end
  cell $eq \e6
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 3'101
    connect \Y \decoded [6]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 7
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c21_cand
  wire width 3 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 28 input 3 \b
  wire width 4 output 4 \y
  wire width 7 \decoded
  cell $eq \e0
    parameter \A_WIDTH 2
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 2'11
    connect \B \ctrl
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 3'101
    connect \B \ctrl
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 1
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 1'1
    connect \B \ctrl
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 3'100
    connect \B \ctrl
    connect \Y \decoded [3]
  end
  cell $eq \e4
    parameter \A_WIDTH 2
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 2'10
    connect \B \ctrl
    connect \Y \decoded [4]
  end
  cell $eq \e5
    parameter \A_WIDTH 1
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 1'0
    connect \B \ctrl
    connect \Y \decoded [5]
  end
  cell $eq \e6
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 3'110
    connect \B \ctrl
    connect \Y \decoded [6]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 7
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c22_cand
  wire width 3 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 28 input 3 \b
  wire width 4 output 4 \y
  wire width 7 \decoded
  cell $eq \e0
    parameter \A_WIDTH 3
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 2'10
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 3'011
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 3'101
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 3
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 1'0
    connect \Y \decoded [3]
  end
  cell $eq \e4
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 3'100
    connect \Y \decoded [4]
  end
  cell $eq \e5
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 3'010
    connect \Y \decoded [5]
  end
  cell $eq \e6
    parameter \A_WIDTH 3
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 2'01
    connect \Y \decoded [6]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 7
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c23_cand
  wire width 3 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 28 input 3 \b
  wire width 4 output 4 \y
  wire width 7 \decoded
  cell $eq \e0
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 3'101
    connect \B \ctrl
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 1
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 1'0
    connect \B \ctrl
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 3'100
    connect \B \ctrl
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 3'010
    connect \B \ctrl
    connect \Y \decoded [3]
  end
  cell $eq \e4
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 3'011
    connect \B \ctrl
    connect \Y \decoded [4]
  end
  cell $eq \e5
    parameter \A_WIDTH 2
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 2'01
    connect \B \ctrl
    connect \Y \decoded [5]
  end
  cell $eq \e6
    parameter \A_WIDTH 2
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 2'10
    connect \B \ctrl
    connect \Y \decoded [6]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 7
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c24_cand
  wire width 3 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 28 input 3 \b
  wire width 4 output 4 \y
  wire width 7 \decoded
  cell $eq \e0
    parameter \A_WIDTH 3
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 1'0
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 3
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 1'1
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 3
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 2'10
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 3'101
    connect \Y \decoded [3]
  end
  cell $eq \e4
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 3'100
    connect \Y \decoded [4]
  end
  cell $eq \e5
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 3'111
    connect \Y \decoded [5]
  end
  cell $eq \e6
    parameter \A_WIDTH 3
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 2'11
    connect \Y \decoded [6]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 7
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c25_cand
  wire width 3 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 28 input 3 \b
  wire width 4 output 4 \y
  wire width 7 \decoded
  cell $eq \e0
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 3'100
    connect \B \ctrl
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 1
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 1'0
    connect \B \ctrl
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 1
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 1'1
    connect \B \ctrl
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 3'101
    connect \B \ctrl
    connect \Y \decoded [3]
  end
  cell $eq \e4
    parameter \A_WIDTH 2
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 2'11
    connect \B \ctrl
    connect \Y \decoded [4]
  end
  cell $eq \e5
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 3'111
    connect \B \ctrl
    connect \Y \decoded [5]
  end
  cell $eq \e6
    parameter \A_WIDTH 2
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 2'10
    connect \B \ctrl
    connect \Y \decoded [6]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 7
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c26_cand
  wire width 3 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 28 input 3 \b
  wire width 4 output 4 \y
  wire width 7 \decoded
  cell $eq \e0
    parameter \A_WIDTH 3
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 1'1
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 3
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 1'0
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 3'101
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 3'010
    connect \Y \decoded [3]
  end
  cell $eq \e4
    parameter \A_WIDTH 3
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 2'01
    connect \Y \decoded [4]
  end
  cell $eq \e5
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 3'100
    connect \Y \decoded [5]
  end
  cell $eq \e6
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 3'011
    connect \Y \decoded [6]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 7
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c27_cand
  wire width 3 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 28 input 3 \b
  wire width 4 output 4 \y
  wire width 7 \decoded
  cell $eq \e0
    parameter \A_WIDTH 1
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 1'0
    connect \B \ctrl
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 3'101
    connect \B \ctrl
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 3'011
    connect \B \ctrl
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 3'010
    connect \B \ctrl
    connect \Y \decoded [3]
  end
  cell $eq \e4
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 3'100
    connect \B \ctrl
    connect \Y \decoded [4]
  end
  cell $eq \e5
    parameter \A_WIDTH 1
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 1'1
    connect \B \ctrl
    connect \Y \decoded [5]
  end
  cell $eq \e6
    parameter \A_WIDTH 2
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 2'01
    connect \B \ctrl
    connect \Y \decoded [6]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 7
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c28_cand
  wire width 3 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 28 input 3 \b
  wire width 4 output 4 \y
  wire width 7 \decoded
  cell $eq \e0
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 3'111
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 3
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 1'1
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 3
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 2'10
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 3
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 1'0
    connect \Y \decoded [3]
  end
  cell $eq \e4
    parameter \A_WIDTH 3
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 2'11
    connect \Y \decoded [4]
  end
  cell $eq \e5
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 3'110
    connect \Y \decoded [5]
  end
  cell $eq \e6
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 3'100
    connect \Y \decoded [6]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 7
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c29_cand
  wire width 3 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 28 input 3 \b
  wire width 4 output 4 \y
  wire width 7 \decoded
  cell $eq \e0
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 3'100
    connect \B \ctrl
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 1
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 1'1
    connect \B \ctrl
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 2
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 2'11
    connect \B \ctrl
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 2
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 2'10
    connect \B \ctrl
    connect \Y \decoded [3]
  end
  cell $eq \e4
    parameter \A_WIDTH 1
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 1'0
    connect \B \ctrl
    connect \Y \decoded [4]
  end
  cell $eq \e5
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 3'110
    connect \B \ctrl
    connect \Y \decoded [5]
  end
  cell $eq \e6
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 3'111
    connect \B \ctrl
    connect \Y \decoded [6]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 7
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c30_cand
  wire width 3 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 28 input 3 \b
  wire width 4 output 4 \y
  wire width 7 \decoded
  cell $eq \e0
    parameter \A_WIDTH 3
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 1'1
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 3'100
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 3'011
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 3
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 2'01
    connect \Y \decoded [3]
  end
  cell $eq \e4
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 3'010
    connect \Y \decoded [4]
  end
  cell $eq \e5
    parameter \A_WIDTH 3
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 1'0
    connect \Y \decoded [5]
  end
  cell $eq \e6
    parameter \A_WIDTH 3
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 2'10
    connect \Y \decoded [6]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 7
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c31_cand
  wire width 3 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 28 input 3 \b
  wire width 4 output 4 \y
  wire width 7 \decoded
  cell $eq \e0
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 3'011
    connect \B \ctrl
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 1
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 1'1
    connect \B \ctrl
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 2
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 2'01
    connect \B \ctrl
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 2
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 2'10
    connect \B \ctrl
    connect \Y \decoded [3]
  end
  cell $eq \e4
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 3'010
    connect \B \ctrl
    connect \Y \decoded [4]
  end
  cell $eq \e5
    parameter \A_WIDTH 1
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 1'0
    connect \B \ctrl
    connect \Y \decoded [5]
  end
  cell $eq \e6
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 3'100
    connect \B \ctrl
    connect \Y \decoded [6]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 7
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c32_cand
  wire width 3 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 28 input 3 \b
  wire width 4 output 4 \y
  wire width 7 \decoded
  cell $eq \e0
    parameter \A_WIDTH 3
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 2'11
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 3'110
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 3'111
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 3
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 1'1
    connect \Y \decoded [3]
  end
  cell $eq \e4
    parameter \A_WIDTH 3
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 1'0
    connect \Y \decoded [4]
  end
  cell $eq \e5
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 3'101
    connect \Y \decoded [5]
  end
  cell $eq \e6
    parameter \A_WIDTH 3
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 2'10
    connect \Y \decoded [6]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 7
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c33_cand
  wire width 3 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 28 input 3 \b
  wire width 4 output 4 \y
  wire width 7 \decoded
  cell $eq \e0
    parameter \A_WIDTH 2
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 2'10
    connect \B \ctrl
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 1
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 1'1
    connect \B \ctrl
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 2
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 2'11
    connect \B \ctrl
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 3'101
    connect \B \ctrl
    connect \Y \decoded [3]
  end
  cell $eq \e4
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 3'110
    connect \B \ctrl
    connect \Y \decoded [4]
  end
  cell $eq \e5
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 3'111
    connect \B \ctrl
    connect \Y \decoded [5]
  end
  cell $eq \e6
    parameter \A_WIDTH 1
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 1'0
    connect \B \ctrl
    connect \Y \decoded [6]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 7
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c34_cand
  wire width 3 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 28 input 3 \b
  wire width 4 output 4 \y
  wire width 7 \decoded
  cell $eq \e0
    parameter \A_WIDTH 3
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 2'10
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 3'101
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 3
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 1'1
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 3
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 1'0
    connect \Y \decoded [3]
  end
  cell $eq \e4
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 3'011
    connect \Y \decoded [4]
  end
  cell $eq \e5
    parameter \A_WIDTH 3
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 2'01
    connect \Y \decoded [5]
  end
  cell $eq \e6
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 3'010
    connect \Y \decoded [6]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 7
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c35_cand
  wire width 3 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 28 input 3 \b
  wire width 4 output 4 \y
  wire width 7 \decoded
  cell $eq \e0
    parameter \A_WIDTH 1
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 1'0
    connect \B \ctrl
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 1
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 1'1
    connect \B \ctrl
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 2
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 2'10
    connect \B \ctrl
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 3'011
    connect \B \ctrl
    connect \Y \decoded [3]
  end
  cell $eq \e4
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 3'010
    connect \B \ctrl
    connect \Y \decoded [4]
  end
  cell $eq \e5
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 3'101
    connect \B \ctrl
    connect \Y \decoded [5]
  end
  cell $eq \e6
    parameter \A_WIDTH 2
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 2'01
    connect \B \ctrl
    connect \Y \decoded [6]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 7
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c36_cand
  wire width 3 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 28 input 3 \b
  wire width 4 output 4 \y
  wire width 7 \decoded
  cell $eq \e0
    parameter \A_WIDTH 3
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 1'0
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 3
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 2'10
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 3'110
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 3'100
    connect \Y \decoded [3]
  end
  cell $eq \e4
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 3'101
    connect \Y \decoded [4]
  end
  cell $eq \e5
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 3'111
    connect \Y \decoded [5]
  end
  cell $eq \e6
    parameter \A_WIDTH 3
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 1'1
    connect \Y \decoded [6]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 7
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c37_cand
  wire width 3 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 28 input 3 \b
  wire width 4 output 4 \y
  wire width 7 \decoded
  cell $eq \e0
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 3'110
    connect \B \ctrl
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 3'101
    connect \B \ctrl
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 3'100
    connect \B \ctrl
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 1
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 1'0
    connect \B \ctrl
    connect \Y \decoded [3]
  end
  cell $eq \e4
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 3'111
    connect \B \ctrl
    connect \Y \decoded [4]
  end
  cell $eq \e5
    parameter \A_WIDTH 1
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 1'1
    connect \B \ctrl
    connect \Y \decoded [5]
  end
  cell $eq \e6
    parameter \A_WIDTH 2
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 2'10
    connect \B \ctrl
    connect \Y \decoded [6]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 7
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c38_cand
  wire width 3 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 28 input 3 \b
  wire width 4 output 4 \y
  wire width 7 \decoded
  cell $eq \e0
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 3'101
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 3'010
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 3
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 1'0
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 3
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 2'10
    connect \Y \decoded [3]
  end
  cell $eq \e4
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 3'100
    connect \Y \decoded [4]
  end
  cell $eq \e5
    parameter \A_WIDTH 3
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 2'01
    connect \Y \decoded [5]
  end
  cell $eq \e6
    parameter \A_WIDTH 3
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 1'1
    connect \Y \decoded [6]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 7
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c39_cand
  wire width 3 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 28 input 3 \b
  wire width 4 output 4 \y
  wire width 7 \decoded
  cell $eq \e0
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 3'101
    connect \B \ctrl
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 3'010
    connect \B \ctrl
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 1
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 1'1
    connect \B \ctrl
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 3'100
    connect \B \ctrl
    connect \Y \decoded [3]
  end
  cell $eq \e4
    parameter \A_WIDTH 2
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 2'01
    connect \B \ctrl
    connect \Y \decoded [4]
  end
  cell $eq \e5
    parameter \A_WIDTH 1
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 1'0
    connect \B \ctrl
    connect \Y \decoded [5]
  end
  cell $eq \e6
    parameter \A_WIDTH 2
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 2'10
    connect \B \ctrl
    connect \Y \decoded [6]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 7
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c40_cand
  wire width 3 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 28 input 3 \b
  wire width 4 output 4 \y
  wire width 7 \decoded
  cell $eq \e0
    parameter \A_WIDTH 3
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 1'1
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 3'110
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 3'100
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 3'111
    connect \Y \decoded [3]
  end
  cell $eq \e4
    parameter \A_WIDTH 3
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 2'11
    connect \Y \decoded [4]
  end
  cell $eq \e5
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 3'101
    connect \Y \decoded [5]
  end
  cell $eq \e6
    parameter \A_WIDTH 3
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 1'0
    connect \Y \decoded [6]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 7
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c41_cand
  wire width 3 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 28 input 3 \b
  wire width 4 output 4 \y
  wire width 7 \decoded
  cell $eq \e0
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 3'111
    connect \B \ctrl
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 1
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 1'1
    connect \B \ctrl
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 3'100
    connect \B \ctrl
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 3'101
    connect \B \ctrl
    connect \Y \decoded [3]
  end
  cell $eq \e4
    parameter \A_WIDTH 1
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 1'0
    connect \B \ctrl
    connect \Y \decoded [4]
  end
  cell $eq \e5
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 3'110
    connect \B \ctrl
    connect \Y \decoded [5]
  end
  cell $eq \e6
    parameter \A_WIDTH 2
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 2'11
    connect \B \ctrl
    connect \Y \decoded [6]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 7
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c42_cand
  wire width 3 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 28 input 3 \b
  wire width 4 output 4 \y
  wire width 7 \decoded
  cell $eq \e0
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 3'011
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 3'100
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 3
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 2'10
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 3
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 1'0
    connect \Y \decoded [3]
  end
  cell $eq \e4
    parameter \A_WIDTH 3
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 2'01
    connect \Y \decoded [4]
  end
  cell $eq \e5
    parameter \A_WIDTH 3
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 1'1
    connect \Y \decoded [5]
  end
  cell $eq \e6
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 3'101
    connect \Y \decoded [6]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 7
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c43_cand
  wire width 3 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 28 input 3 \b
  wire width 4 output 4 \y
  wire width 7 \decoded
  cell $eq \e0
    parameter \A_WIDTH 2
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 2'01
    connect \B \ctrl
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 3'011
    connect \B \ctrl
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 2
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 2'10
    connect \B \ctrl
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 1
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 1'0
    connect \B \ctrl
    connect \Y \decoded [3]
  end
  cell $eq \e4
    parameter \A_WIDTH 1
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 1'1
    connect \B \ctrl
    connect \Y \decoded [4]
  end
  cell $eq \e5
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 3'100
    connect \B \ctrl
    connect \Y \decoded [5]
  end
  cell $eq \e6
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 3'101
    connect \B \ctrl
    connect \Y \decoded [6]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 7
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c44_cand
  wire width 3 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 28 input 3 \b
  wire width 4 output 4 \y
  wire width 7 \decoded
  cell $eq \e0
    parameter \A_WIDTH 3
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 2'11
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 3
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 1'0
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 3'101
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 3'110
    connect \Y \decoded [3]
  end
  cell $eq \e4
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 3'111
    connect \Y \decoded [4]
  end
  cell $eq \e5
    parameter \A_WIDTH 3
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 2'10
    connect \Y \decoded [5]
  end
  cell $eq \e6
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 3'100
    connect \Y \decoded [6]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 7
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c45_cand
  wire width 3 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 28 input 3 \b
  wire width 4 output 4 \y
  wire width 7 \decoded
  cell $eq \e0
    parameter \A_WIDTH 2
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 2'10
    connect \B \ctrl
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 3'110
    connect \B \ctrl
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 3'111
    connect \B \ctrl
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 2
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 2'11
    connect \B \ctrl
    connect \Y \decoded [3]
  end
  cell $eq \e4
    parameter \A_WIDTH 1
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 1'0
    connect \B \ctrl
    connect \Y \decoded [4]
  end
  cell $eq \e5
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 3'100
    connect \B \ctrl
    connect \Y \decoded [5]
  end
  cell $eq \e6
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 3'101
    connect \B \ctrl
    connect \Y \decoded [6]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 7
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c46_cand
  wire width 3 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 28 input 3 \b
  wire width 4 output 4 \y
  wire width 7 \decoded
  cell $eq \e0
    parameter \A_WIDTH 3
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 1'0
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 3'010
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 3
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 1'1
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 3'011
    connect \Y \decoded [3]
  end
  cell $eq \e4
    parameter \A_WIDTH 3
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 2'10
    connect \Y \decoded [4]
  end
  cell $eq \e5
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 3'100
    connect \Y \decoded [5]
  end
  cell $eq \e6
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 3'101
    connect \Y \decoded [6]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 7
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c47_cand
  wire width 3 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 28 input 3 \b
  wire width 4 output 4 \y
  wire width 7 \decoded
  cell $eq \e0
    parameter \A_WIDTH 1
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 1'1
    connect \B \ctrl
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 2
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 2'10
    connect \B \ctrl
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 3'100
    connect \B \ctrl
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 3'101
    connect \B \ctrl
    connect \Y \decoded [3]
  end
  cell $eq \e4
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 3'010
    connect \B \ctrl
    connect \Y \decoded [4]
  end
  cell $eq \e5
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 3'011
    connect \B \ctrl
    connect \Y \decoded [5]
  end
  cell $eq \e6
    parameter \A_WIDTH 1
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 1'0
    connect \B \ctrl
    connect \Y \decoded [6]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 7
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c48_cand
  wire width 3 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 28 input 3 \b
  wire width 4 output 4 \y
  wire width 7 \decoded
  cell $eq \e0
    parameter \A_WIDTH 3
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 1'1
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 3'100
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 3'110
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 3
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 2'11
    connect \Y \decoded [3]
  end
  cell $eq \e4
    parameter \A_WIDTH 3
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 2'10
    connect \Y \decoded [4]
  end
  cell $eq \e5
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 3'101
    connect \Y \decoded [5]
  end
  cell $eq \e6
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 3'111
    connect \Y \decoded [6]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 7
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c49_cand
  wire width 3 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 28 input 3 \b
  wire width 4 output 4 \y
  wire width 7 \decoded
  cell $eq \e0
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 3'101
    connect \B \ctrl
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 2
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 2'10
    connect \B \ctrl
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 1
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 1'1
    connect \B \ctrl
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 3'111
    connect \B \ctrl
    connect \Y \decoded [3]
  end
  cell $eq \e4
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 3'110
    connect \B \ctrl
    connect \Y \decoded [4]
  end
  cell $eq \e5
    parameter \A_WIDTH 2
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 2'11
    connect \B \ctrl
    connect \Y \decoded [5]
  end
  cell $eq \e6
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 3'100
    connect \B \ctrl
    connect \Y \decoded [6]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 7
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c50_cand
  wire width 3 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 28 input 3 \b
  wire width 4 output 4 \y
  wire width 7 \decoded
  cell $eq \e0
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 3'100
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 3
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 2'10
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 3
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 1'1
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 3'010
    connect \Y \decoded [3]
  end
  cell $eq \e4
    parameter \A_WIDTH 3
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 2'01
    connect \Y \decoded [4]
  end
  cell $eq \e5
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 3'011
    connect \Y \decoded [5]
  end
  cell $eq \e6
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 3'101
    connect \Y \decoded [6]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 7
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c51_cand
  wire width 3 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 28 input 3 \b
  wire width 4 output 4 \y
  wire width 7 \decoded
  cell $eq \e0
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 3'101
    connect \B \ctrl
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 2
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 2'10
    connect \B \ctrl
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 1
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 1'1
    connect \B \ctrl
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 3'100
    connect \B \ctrl
    connect \Y \decoded [3]
  end
  cell $eq \e4
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 3'011
    connect \B \ctrl
    connect \Y \decoded [4]
  end
  cell $eq \e5
    parameter \A_WIDTH 3
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 3'010
    connect \B \ctrl
    connect \Y \decoded [5]
  end
  cell $eq \e6
    parameter \A_WIDTH 2
    parameter \B_WIDTH 3
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 2'01
    connect \B \ctrl
    connect \Y \decoded [6]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 7
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c52_cand
  wire width 2 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 16 input 3 \b
  wire width 4 output 4 \y
  wire width 4 \decoded
  cell $eq \e0
    parameter \A_WIDTH 2
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 1'1
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 2
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 1'1
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 2'10
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 2
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A \ctrl
    connect \B 1'0
    connect \Y \decoded [3]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 4
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c53_cand
  wire width 2 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 16 input 3 \b
  wire width 4 output 4 \y
  wire width 4 \decoded
  cell $eq \e0
    parameter \A_WIDTH 1
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 1'1
    connect \B \ctrl
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 2'10
    connect \B \ctrl
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 1
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 1'0
    connect \B \ctrl
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 1
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 0
    parameter \B_SIGNED 0
    connect \A 1'1
    connect \B \ctrl
    connect \Y \decoded [3]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 4
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c54_cand
  wire width 2 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 16 input 3 \b
  wire width 4 output 4 \y
  wire width 4 \decoded
  cell $eq \e0
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 2'01
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 2'10
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 2'01
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 2
    parameter \B_WIDTH 1
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A \ctrl
    connect \B 1'0
    connect \Y \decoded [3]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 4
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
module \c55_cand
  wire width 2 input 1 \ctrl
  wire width 4 input 2 \a
  wire width 16 input 3 \b
  wire width 4 output 4 \y
  wire width 4 \decoded
  cell $eq \e0
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 2'01
    connect \B \ctrl
    connect \Y \decoded [0]
  end
  cell $eq \e1
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 2'10
    connect \B \ctrl
    connect \Y \decoded [1]
  end
  cell $eq \e2
    parameter \A_WIDTH 1
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 1'0
    connect \B \ctrl
    connect \Y \decoded [2]
  end
  cell $eq \e3
    parameter \A_WIDTH 2
    parameter \B_WIDTH 2
    parameter \Y_WIDTH 1
    parameter \A_SIGNED 1
    parameter \B_SIGNED 1
    connect \A 2'01
    connect \B \ctrl
    connect \Y \decoded [3]
  end
  cell $pmux \p
    parameter \WIDTH 4
    parameter \S_WIDTH 4
    connect \A \a
    connect \B \b
    connect \S \decoded
    connect \Y \y
  end
end
