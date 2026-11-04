autoidx 1
module \c0_ref
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
module \c1_ref
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
module \c2_ref
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
module \c3_ref
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
module \c4_ref
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
module \c5_ref
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
module \c6_ref
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
module \c7_ref
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
module \c8_ref
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
module \c9_ref
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
module \c10_ref
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
module \c11_ref
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
module \c12_ref
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
module \c13_ref
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
module \c14_ref
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
module \c15_ref
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
module \c16_ref
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
module \c17_ref
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
module \c18_ref
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
module \c19_ref
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
module \c20_ref
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
module \c21_ref
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
module \c22_ref
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
module \c23_ref
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
module \c24_ref
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
module \c25_ref
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
module \c26_ref
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
module \c27_ref
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
module \c28_ref
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
module \c29_ref
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
module \c30_ref
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
module \c31_ref
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
module \c32_ref
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
module \c33_ref
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
module \c34_ref
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
module \c35_ref
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
module \c36_ref
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
module \c37_ref
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
module \c38_ref
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
module \c39_ref
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
module \c40_ref
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
module \c41_ref
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
module \c42_ref
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
module \c43_ref
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
module \c44_ref
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
module \c45_ref
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
module \c46_ref
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
module \c47_ref
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
module \c48_ref
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
module \c49_ref
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
module \c50_ref
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
module \c51_ref
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
module \c52_ref
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
module \c53_ref
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
module \c54_ref
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
module \c55_ref
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
