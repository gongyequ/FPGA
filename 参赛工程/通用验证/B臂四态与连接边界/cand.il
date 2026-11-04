autoidx 1
module \k1_o1_arm0_cand
  wire width 3 input 1 \ao
  wire width 3 input 2 \ai
  wire width 3 input 3 \bi
  wire width 3 input 4 \bo
  wire width 1 input 5 \si
  wire width 1 input 6 \so
  wire width 3 output 7 \y
  wire width 3 \t
  cell $pmux \inner
    parameter \WIDTH 3
    parameter \S_WIDTH 1
    connect \A \ai
    connect \B \bi
    connect \S \si
    connect \Y \t
  end
  cell $pmux \outer
    parameter \WIDTH 3
    parameter \S_WIDTH 1
    connect \A \ao
    connect \B { \t }
    connect \S \so
    connect \Y \y
  end
end
module \k1_o2_arm0_cand
  wire width 3 input 1 \ao
  wire width 3 input 2 \ai
  wire width 3 input 3 \bi
  wire width 6 input 4 \bo
  wire width 1 input 5 \si
  wire width 2 input 6 \so
  wire width 3 output 7 \y
  wire width 3 \t
  cell $pmux \inner
    parameter \WIDTH 3
    parameter \S_WIDTH 1
    connect \A \ai
    connect \B \bi
    connect \S \si
    connect \Y \t
  end
  cell $pmux \outer
    parameter \WIDTH 3
    parameter \S_WIDTH 2
    connect \A \ao
    connect \B { \bo [5:3] \t }
    connect \S \so
    connect \Y \y
  end
end
module \k1_o2_arm1_cand
  wire width 3 input 1 \ao
  wire width 3 input 2 \ai
  wire width 3 input 3 \bi
  wire width 6 input 4 \bo
  wire width 1 input 5 \si
  wire width 2 input 6 \so
  wire width 3 output 7 \y
  wire width 3 \t
  cell $pmux \inner
    parameter \WIDTH 3
    parameter \S_WIDTH 1
    connect \A \ai
    connect \B \bi
    connect \S \si
    connect \Y \t
  end
  cell $pmux \outer
    parameter \WIDTH 3
    parameter \S_WIDTH 2
    connect \A \ao
    connect \B { \t \bo [2:0] }
    connect \S \so
    connect \Y \y
  end
end
module \k1_o3_arm0_cand
  wire width 3 input 1 \ao
  wire width 3 input 2 \ai
  wire width 3 input 3 \bi
  wire width 9 input 4 \bo
  wire width 1 input 5 \si
  wire width 3 input 6 \so
  wire width 3 output 7 \y
  wire width 3 \t
  cell $pmux \inner
    parameter \WIDTH 3
    parameter \S_WIDTH 1
    connect \A \ai
    connect \B \bi
    connect \S \si
    connect \Y \t
  end
  cell $pmux \outer
    parameter \WIDTH 3
    parameter \S_WIDTH 3
    connect \A \ao
    connect \B { \bo [8:6] \bo [5:3] \t }
    connect \S \so
    connect \Y \y
  end
end
module \k1_o3_arm1_cand
  wire width 3 input 1 \ao
  wire width 3 input 2 \ai
  wire width 3 input 3 \bi
  wire width 9 input 4 \bo
  wire width 1 input 5 \si
  wire width 3 input 6 \so
  wire width 3 output 7 \y
  wire width 3 \t
  cell $pmux \inner
    parameter \WIDTH 3
    parameter \S_WIDTH 1
    connect \A \ai
    connect \B \bi
    connect \S \si
    connect \Y \t
  end
  cell $pmux \outer
    parameter \WIDTH 3
    parameter \S_WIDTH 3
    connect \A \ao
    connect \B { \bo [8:6] \t \bo [2:0] }
    connect \S \so
    connect \Y \y
  end
end
module \k1_o3_arm2_cand
  wire width 3 input 1 \ao
  wire width 3 input 2 \ai
  wire width 3 input 3 \bi
  wire width 9 input 4 \bo
  wire width 1 input 5 \si
  wire width 3 input 6 \so
  wire width 3 output 7 \y
  wire width 3 \t
  cell $pmux \inner
    parameter \WIDTH 3
    parameter \S_WIDTH 1
    connect \A \ai
    connect \B \bi
    connect \S \si
    connect \Y \t
  end
  cell $pmux \outer
    parameter \WIDTH 3
    parameter \S_WIDTH 3
    connect \A \ao
    connect \B { \t \bo [5:3] \bo [2:0] }
    connect \S \so
    connect \Y \y
  end
end
module \k2_o1_arm0_cand
  wire width 4 input 1 \ao
  wire width 4 input 2 \ai
  wire width 8 input 3 \bi
  wire width 4 input 4 \bo
  wire width 2 input 5 \si
  wire width 1 input 6 \so
  wire width 4 output 7 \y
  wire width 4 \t
  cell $pmux \inner
    parameter \WIDTH 4
    parameter \S_WIDTH 2
    connect \A \ai
    connect \B \bi
    connect \S \si
    connect \Y \t
  end
  cell $pmux \outer
    parameter \WIDTH 4
    parameter \S_WIDTH 1
    connect \A \ao
    connect \B { \t }
    connect \S \so
    connect \Y \y
  end
end
module \k2_o2_arm0_cand
  wire width 4 input 1 \ao
  wire width 4 input 2 \ai
  wire width 8 input 3 \bi
  wire width 8 input 4 \bo
  wire width 2 input 5 \si
  wire width 2 input 6 \so
  wire width 4 output 7 \y
  wire width 4 \t
  cell $pmux \inner
    parameter \WIDTH 4
    parameter \S_WIDTH 2
    connect \A \ai
    connect \B \bi
    connect \S \si
    connect \Y \t
  end
  cell $pmux \outer
    parameter \WIDTH 4
    parameter \S_WIDTH 2
    connect \A \ao
    connect \B { \bo [7:4] \t }
    connect \S \so
    connect \Y \y
  end
end
module \k2_o2_arm1_cand
  wire width 4 input 1 \ao
  wire width 4 input 2 \ai
  wire width 8 input 3 \bi
  wire width 8 input 4 \bo
  wire width 2 input 5 \si
  wire width 2 input 6 \so
  wire width 4 output 7 \y
  wire width 4 \t
  cell $pmux \inner
    parameter \WIDTH 4
    parameter \S_WIDTH 2
    connect \A \ai
    connect \B \bi
    connect \S \si
    connect \Y \t
  end
  cell $pmux \outer
    parameter \WIDTH 4
    parameter \S_WIDTH 2
    connect \A \ao
    connect \B { \t \bo [3:0] }
    connect \S \so
    connect \Y \y
  end
end
module \k2_o3_arm0_cand
  wire width 4 input 1 \ao
  wire width 4 input 2 \ai
  wire width 8 input 3 \bi
  wire width 12 input 4 \bo
  wire width 2 input 5 \si
  wire width 3 input 6 \so
  wire width 4 output 7 \y
  wire width 4 \t
  cell $pmux \inner
    parameter \WIDTH 4
    parameter \S_WIDTH 2
    connect \A \ai
    connect \B \bi
    connect \S \si
    connect \Y \t
  end
  cell $pmux \outer
    parameter \WIDTH 4
    parameter \S_WIDTH 3
    connect \A \ao
    connect \B { \bo [11:8] \bo [7:4] \t }
    connect \S \so
    connect \Y \y
  end
end
module \k2_o3_arm1_cand
  wire width 4 input 1 \ao
  wire width 4 input 2 \ai
  wire width 8 input 3 \bi
  wire width 12 input 4 \bo
  wire width 2 input 5 \si
  wire width 3 input 6 \so
  wire width 4 output 7 \y
  wire width 4 \t
  cell $pmux \inner
    parameter \WIDTH 4
    parameter \S_WIDTH 2
    connect \A \ai
    connect \B \bi
    connect \S \si
    connect \Y \t
  end
  cell $pmux \outer
    parameter \WIDTH 4
    parameter \S_WIDTH 3
    connect \A \ao
    connect \B { \bo [11:8] \t \bo [3:0] }
    connect \S \so
    connect \Y \y
  end
end
module \k2_o3_arm2_cand
  wire width 4 input 1 \ao
  wire width 4 input 2 \ai
  wire width 8 input 3 \bi
  wire width 12 input 4 \bo
  wire width 2 input 5 \si
  wire width 3 input 6 \so
  wire width 4 output 7 \y
  wire width 4 \t
  cell $pmux \inner
    parameter \WIDTH 4
    parameter \S_WIDTH 2
    connect \A \ai
    connect \B \bi
    connect \S \si
    connect \Y \t
  end
  cell $pmux \outer
    parameter \WIDTH 4
    parameter \S_WIDTH 3
    connect \A \ao
    connect \B { \t \bo [7:4] \bo [3:0] }
    connect \S \so
    connect \Y \y
  end
end
module \k3_o1_arm0_cand
  wire width 5 input 1 \ao
  wire width 5 input 2 \ai
  wire width 15 input 3 \bi
  wire width 5 input 4 \bo
  wire width 3 input 5 \si
  wire width 1 input 6 \so
  wire width 5 output 7 \y
  wire width 5 \t
  cell $pmux \inner
    parameter \WIDTH 5
    parameter \S_WIDTH 3
    connect \A \ai
    connect \B \bi
    connect \S \si
    connect \Y \t
  end
  cell $pmux \outer
    parameter \WIDTH 5
    parameter \S_WIDTH 1
    connect \A \ao
    connect \B { \t }
    connect \S \so
    connect \Y \y
  end
end
module \k3_o2_arm0_cand
  wire width 5 input 1 \ao
  wire width 5 input 2 \ai
  wire width 15 input 3 \bi
  wire width 10 input 4 \bo
  wire width 3 input 5 \si
  wire width 2 input 6 \so
  wire width 5 output 7 \y
  wire width 5 \t
  cell $pmux \inner
    parameter \WIDTH 5
    parameter \S_WIDTH 3
    connect \A \ai
    connect \B \bi
    connect \S \si
    connect \Y \t
  end
  cell $pmux \outer
    parameter \WIDTH 5
    parameter \S_WIDTH 2
    connect \A \ao
    connect \B { \bo [9:5] \t }
    connect \S \so
    connect \Y \y
  end
end
module \k3_o2_arm1_cand
  wire width 5 input 1 \ao
  wire width 5 input 2 \ai
  wire width 15 input 3 \bi
  wire width 10 input 4 \bo
  wire width 3 input 5 \si
  wire width 2 input 6 \so
  wire width 5 output 7 \y
  wire width 5 \t
  cell $pmux \inner
    parameter \WIDTH 5
    parameter \S_WIDTH 3
    connect \A \ai
    connect \B \bi
    connect \S \si
    connect \Y \t
  end
  cell $pmux \outer
    parameter \WIDTH 5
    parameter \S_WIDTH 2
    connect \A \ao
    connect \B { \t \bo [4:0] }
    connect \S \so
    connect \Y \y
  end
end
module \k3_o3_arm0_cand
  wire width 5 input 1 \ao
  wire width 5 input 2 \ai
  wire width 15 input 3 \bi
  wire width 15 input 4 \bo
  wire width 3 input 5 \si
  wire width 3 input 6 \so
  wire width 5 output 7 \y
  wire width 5 \t
  cell $pmux \inner
    parameter \WIDTH 5
    parameter \S_WIDTH 3
    connect \A \ai
    connect \B \bi
    connect \S \si
    connect \Y \t
  end
  cell $pmux \outer
    parameter \WIDTH 5
    parameter \S_WIDTH 3
    connect \A \ao
    connect \B { \bo [14:10] \bo [9:5] \t }
    connect \S \so
    connect \Y \y
  end
end
module \k3_o3_arm1_cand
  wire width 5 input 1 \ao
  wire width 5 input 2 \ai
  wire width 15 input 3 \bi
  wire width 15 input 4 \bo
  wire width 3 input 5 \si
  wire width 3 input 6 \so
  wire width 5 output 7 \y
  wire width 5 \t
  cell $pmux \inner
    parameter \WIDTH 5
    parameter \S_WIDTH 3
    connect \A \ai
    connect \B \bi
    connect \S \si
    connect \Y \t
  end
  cell $pmux \outer
    parameter \WIDTH 5
    parameter \S_WIDTH 3
    connect \A \ao
    connect \B { \bo [14:10] \t \bo [4:0] }
    connect \S \so
    connect \Y \y
  end
end
module \k3_o3_arm2_cand
  wire width 5 input 1 \ao
  wire width 5 input 2 \ai
  wire width 15 input 3 \bi
  wire width 15 input 4 \bo
  wire width 3 input 5 \si
  wire width 3 input 6 \so
  wire width 5 output 7 \y
  wire width 5 \t
  cell $pmux \inner
    parameter \WIDTH 5
    parameter \S_WIDTH 3
    connect \A \ai
    connect \B \bi
    connect \S \si
    connect \Y \t
  end
  cell $pmux \outer
    parameter \WIDTH 5
    parameter \S_WIDTH 3
    connect \A \ao
    connect \B { \t \bo [9:5] \bo [4:0] }
    connect \S \so
    connect \Y \y
  end
end
module \exhaustive_scalar_k1_cand
  wire width 1 input 1 \ao
  wire width 1 input 2 \ai
  wire width 1 input 3 \bi
  wire width 1 input 4 \bo
  wire width 1 input 5 \si
  wire width 1 input 6 \so
  wire width 1 output 7 \y
  wire width 1 \t
  cell $pmux \inner
    parameter \WIDTH 1
    parameter \S_WIDTH 1
    connect \A \ai
    connect \B \bi
    connect \S \si
    connect \Y \t
  end
  cell $pmux \outer
    parameter \WIDTH 1
    parameter \S_WIDTH 1
    connect \A \ao
    connect \B { \t }
    connect \S \so
    connect \Y \y
  end
end
module \exhaustive_scalar_k2_cand
  wire width 1 input 1 \ao
  wire width 1 input 2 \ai
  wire width 2 input 3 \bi
  wire width 1 input 4 \bo
  wire width 2 input 5 \si
  wire width 1 input 6 \so
  wire width 1 output 7 \y
  wire width 1 \t
  cell $pmux \inner
    parameter \WIDTH 1
    parameter \S_WIDTH 2
    connect \A \ai
    connect \B \bi
    connect \S \si
    connect \Y \t
  end
  cell $pmux \outer
    parameter \WIDTH 1
    parameter \S_WIDTH 1
    connect \A \ao
    connect \B { \t }
    connect \S \so
    connect \Y \y
  end
end
