autoidx 1
module \protected_fanout
  wire width 4 input 1 \a
  wire width 8 input 2 \bi
  wire width 8 input 3 \bo
  wire width 2 input 4 \si
  wire width 2 input 5 \so
  wire width 4 output 6 \y
  wire width 4 \inner
  wire width 4 output 7 \tap
  connect \tap \inner
  cell $pmux \inner_p
    parameter \WIDTH 4
    parameter \S_WIDTH 2
    connect \A \a
    connect \B \bi
    connect \S \si
    connect \Y \inner
  end
  cell $pmux \outer_p
    parameter \WIDTH 4
    parameter \S_WIDTH 2
    connect \A \inner
    connect \B \bo
    connect \S \so
    connect \Y \y
  end
end
module \protected_partial
  wire width 8 input 1 \a
  wire width 16 input 2 \bi
  wire width 8 input 3 \bo
  wire width 2 input 4 \si
  wire width 2 input 5 \so
  wire width 4 output 6 \y
  wire width 8 \inner
  cell $pmux \inner_p
    parameter \WIDTH 8
    parameter \S_WIDTH 2
    connect \A \a
    connect \B \bi
    connect \S \si
    connect \Y \inner
  end
  cell $pmux \outer_p
    parameter \WIDTH 4
    parameter \S_WIDTH 2
    connect \A \inner [3:0]
    connect \B \bo
    connect \S \so
    connect \Y \y
  end
end
module \protected_permuted
  wire width 4 input 1 \a
  wire width 8 input 2 \bi
  wire width 8 input 3 \bo
  wire width 2 input 4 \si
  wire width 2 input 5 \so
  wire width 4 output 6 \y
  wire width 4 \inner
  cell $pmux \inner_p
    parameter \WIDTH 4
    parameter \S_WIDTH 2
    connect \A \a
    connect \B \bi
    connect \S \si
    connect \Y \inner
  end
  cell $pmux \outer_p
    parameter \WIDTH 4
    parameter \S_WIDTH 2
    connect \A { \inner [0] \inner [1] \inner [2] \inner [3] }
    connect \B \bo
    connect \S \so
    connect \Y \y
  end
end
module \protected_second_consumer
  wire width 4 input 1 \a
  wire width 8 input 2 \bi
  wire width 8 input 3 \bo
  wire width 2 input 4 \si
  wire width 2 input 5 \so
  wire width 4 output 6 \y
  wire width 4 \inner
  cell $pmux \inner_p
    parameter \WIDTH 4
    parameter \S_WIDTH 2
    connect \A \a
    connect \B \bi
    connect \S \si
    connect \Y \inner
  end
  cell $pmux \outer_p
    parameter \WIDTH 4
    parameter \S_WIDTH 2
    connect \A \inner
    connect \B { \bo [7:4] \inner }
    connect \S \so
    connect \Y \y
  end
end
module \protected_cost
  wire width 2 input 1 \a
  wire width 4 input 2 \bi
  wire width 2 input 3 \bo
  wire width 2 input 4 \si
  wire width 1 input 5 \so
  wire width 2 output 6 \y
  wire width 2 \inner
  cell $pmux \inner_p
    parameter \WIDTH 2
    parameter \S_WIDTH 2
    connect \A \a
    connect \B \bi
    connect \S \si
    connect \Y \inner
  end
  cell $pmux \outer_p
    parameter \WIDTH 2
    parameter \S_WIDTH 1
    connect \A \inner
    connect \B \bo
    connect \S \so
    connect \Y \y
  end
end
module \protected_branch_limit
  wire width 10 input 1 \a
  wire width 80 input 2 \bi
  wire width 90 input 3 \bo
  wire width 8 input 4 \si
  wire width 9 input 5 \so
  wire width 10 output 6 \y
  wire width 10 \inner
  cell $pmux \inner_p
    parameter \WIDTH 10
    parameter \S_WIDTH 8
    connect \A \a
    connect \B \bi
    connect \S \si
    connect \Y \inner
  end
  cell $pmux \outer_p
    parameter \WIDTH 10
    parameter \S_WIDTH 9
    connect \A \inner
    connect \B \bo
    connect \S \so
    connect \Y \y
  end
end
module \protected_gate
  wire width 4 input 1 \a
  wire width 8 input 2 \bi
  wire width 8 input 3 \bo
  wire width 2 input 4 \si
  wire width 2 input 5 \so
  wire width 4 output 6 \y
  wire width 4 \inner
  attribute \pmux_opt_control_gate 1
  cell $pmux \inner_p
    parameter \WIDTH 4
    parameter \S_WIDTH 2
    connect \A \a
    connect \B \bi
    connect \S \si
    connect \Y \inner
  end
  cell $pmux \outer_p
    parameter \WIDTH 4
    parameter \S_WIDTH 2
    connect \A \inner
    connect \B \bo
    connect \S \so
    connect \Y \y
  end
end
module \positive
  wire width 4 input 1 \a
  wire width 8 input 2 \bi
  wire width 8 input 3 \bo
  wire width 2 input 4 \si
  wire width 2 input 5 \so
  wire width 4 output 6 \y
  wire width 4 \inner
  cell $pmux \inner_p
    parameter \WIDTH 4
    parameter \S_WIDTH 2
    connect \A \a
    connect \B \bi
    connect \S \si
    connect \Y \inner
  end
  cell $pmux \outer_p
    parameter \WIDTH 4
    parameter \S_WIDTH 2
    connect \A \inner
    connect \B \bo
    connect \S \so
    connect \Y \y
  end
end
module \positive_chain
  wire width 4 input 1 \a
  wire width 12 input 2 \b
  wire width 3 input 3 \s
  wire width 4 output 4 \y
  wire width 4 \t0
  wire width 4 \t1
  cell $pmux \p0
    parameter \WIDTH 4
    parameter \S_WIDTH 1
    connect \A \a
    connect \B \b [3:0]
    connect \S \s [0]
    connect \Y \t0
  end
  cell $pmux \p1
    parameter \WIDTH 4
    parameter \S_WIDTH 1
    connect \A \t0
    connect \B \b [7:4]
    connect \S \s [1]
    connect \Y \t1
  end
  cell $pmux \p2
    parameter \WIDTH 4
    parameter \S_WIDTH 1
    connect \A \t1
    connect \B \b [11:8]
    connect \S \s [2]
    connect \Y \y
  end
end
module \protected_selection
  wire width 4 input 1 \a
  wire width 8 input 2 \bi
  wire width 8 input 3 \bo
  wire width 2 input 4 \si
  wire width 2 input 5 \so
  wire width 4 output 6 \y
  wire width 4 \inner
  cell $pmux \inner_p
    parameter \WIDTH 4
    parameter \S_WIDTH 2
    connect \A \a
    connect \B \bi
    connect \S \si
    connect \Y \inner
  end
  cell $pmux \outer_p
    parameter \WIDTH 4
    parameter \S_WIDTH 2
    connect \A \inner
    connect \B \bo
    connect \S \so
    connect \Y \y
  end
end
