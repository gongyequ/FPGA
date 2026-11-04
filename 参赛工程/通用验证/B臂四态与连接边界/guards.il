autoidx 1
module \reject_fanout_guard
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
  wire width 4 \extra
  cell $not \consumer
    parameter \A_SIGNED 0
    parameter \A_WIDTH 4
    parameter \Y_WIDTH 4
    connect \A \t
    connect \Y \extra
  end
end
module \reject_top_output_guard
  wire width 4 input 1 \ao
  wire width 4 input 2 \ai
  wire width 8 input 3 \bi
  wire width 8 input 4 \bo
  wire width 2 input 5 \si
  wire width 2 input 6 \so
  wire width 4 output 7 \y
  wire width 4 output 8 \t
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
module \reject_partial_guard
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
    connect \B { \bo [7:4] { \t [3:1] \ai [0] } }
    connect \S \so
    connect \Y \y
  end
end
module \reject_reordered_guard
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
    connect \B { \bo [7:4] { \t [0] \t [1] \t [2] \t [3] } }
    connect \S \so
    connect \Y \y
  end
end
module \reject_inner_unselected_guard
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
module \reject_outer_unselected_guard
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
module \reject_ambiguous_guard
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
  cell $pmux \second_driver
    parameter \WIDTH 4
    parameter \S_WIDTH 2
    connect \A \ai
    connect \B \bi
    connect \S \si
    connect \Y \t
  end
end
module \reject_self_loop_guard
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
    connect \B { \bo [7:4] \y }
    connect \S \so
    connect \Y \y
  end
end
module \reject_unknown_consumer_guard
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
  cell \unknown_user_cell \consumer
    connect \P \t
  end
end
module \reject_marked_inner_guard
  wire width 4 input 1 \ao
  wire width 4 input 2 \ai
  wire width 8 input 3 \bi
  wire width 8 input 4 \bo
  wire width 2 input 5 \si
  wire width 2 input 6 \so
  wire width 4 output 7 \y
  wire width 4 \t
  attribute \pmux_opt_data_gate 1
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
module \reject_marked_outer_guard
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
  attribute \pmux_opt_control_gate 1
  cell $pmux \outer
    parameter \WIDTH 4
    parameter \S_WIDTH 2
    connect \A \ao
    connect \B { \bo [7:4] \t }
    connect \S \so
    connect \Y \y
  end
end
module \reject_width_limit_guard
  wire width 3 input 1 \ao
  wire width 3 input 2 \ai
  wire width 6 input 3 \bi
  wire width 6 input 4 \bo
  wire width 2 input 5 \si
  wire width 2 input 6 \so
  wire width 3 output 7 \y
  wire width 3 \t
  cell $pmux \inner
    parameter \WIDTH 3
    parameter \S_WIDTH 2
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
module \reject_arm_limit_guard
  wire width 10 input 1 \ao
  wire width 10 input 2 \ai
  wire width 80 input 3 \bi
  wire width 90 input 4 \bo
  wire width 8 input 5 \si
  wire width 9 input 6 \so
  wire width 10 output 7 \y
  wire width 10 \t
  cell $pmux \inner
    parameter \WIDTH 10
    parameter \S_WIDTH 8
    connect \A \ai
    connect \B \bi
    connect \S \si
    connect \Y \t
  end
  cell $pmux \outer
    parameter \WIDTH 10
    parameter \S_WIDTH 9
    connect \A \ao
    connect \B { \bo [89:80] \bo [79:70] \bo [69:60] \bo [59:50] \bo [49:40] \bo [39:30] \bo [29:20] \bo [19:10] \t }
    connect \S \so
    connect \Y \y
  end
end
