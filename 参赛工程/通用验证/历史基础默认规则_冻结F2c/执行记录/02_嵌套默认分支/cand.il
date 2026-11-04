autoidx 1
module \case0_ref
  wire width 4 input 1 \a
  wire width 4 input 2 \bi
  wire width 4 input 3 \bo
  wire width 1 input 4 \si
  wire width 1 input 5 \so
  wire width 4 output 6 \y
  wire width 4 \inner
  cell $pmux \inner_p
    parameter \WIDTH 4
    parameter \S_WIDTH 1
    connect \A \a
    connect \B \bi
    connect \S \si
    connect \Y \inner
  end
  cell $pmux \outer_p
    parameter \WIDTH 4
    parameter \S_WIDTH 1
    connect \A \inner
    connect \B \bo
    connect \S \so
    connect \Y \y
  end
end
module \case1_ref
  wire width 4 input 1 \a
  wire width 4 input 2 \bi
  wire width 8 input 3 \bo
  wire width 1 input 4 \si
  wire width 2 input 5 \so
  wire width 4 output 6 \y
  wire width 4 \inner
  cell $pmux \inner_p
    parameter \WIDTH 4
    parameter \S_WIDTH 1
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
module \case2_ref
  wire width 4 input 1 \a
  wire width 4 input 2 \bi
  wire width 12 input 3 \bo
  wire width 1 input 4 \si
  wire width 3 input 5 \so
  wire width 4 output 6 \y
  wire width 4 \inner
  cell $pmux \inner_p
    parameter \WIDTH 4
    parameter \S_WIDTH 1
    connect \A \a
    connect \B \bi
    connect \S \si
    connect \Y \inner
  end
  cell $pmux \outer_p
    parameter \WIDTH 4
    parameter \S_WIDTH 3
    connect \A \inner
    connect \B \bo
    connect \S \so
    connect \Y \y
  end
end
module \case3_ref
  wire width 4 input 1 \a
  wire width 8 input 2 \bi
  wire width 4 input 3 \bo
  wire width 2 input 4 \si
  wire width 1 input 5 \so
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
    parameter \S_WIDTH 1
    connect \A \inner
    connect \B \bo
    connect \S \so
    connect \Y \y
  end
end
module \case4_ref
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
module \case5_ref
  wire width 4 input 1 \a
  wire width 8 input 2 \bi
  wire width 12 input 3 \bo
  wire width 2 input 4 \si
  wire width 3 input 5 \so
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
    parameter \S_WIDTH 3
    connect \A \inner
    connect \B \bo
    connect \S \so
    connect \Y \y
  end
end
module \case6_ref
  wire width 4 input 1 \a
  wire width 12 input 2 \bi
  wire width 4 input 3 \bo
  wire width 3 input 4 \si
  wire width 1 input 5 \so
  wire width 4 output 6 \y
  wire width 4 \inner
  cell $pmux \inner_p
    parameter \WIDTH 4
    parameter \S_WIDTH 3
    connect \A \a
    connect \B \bi
    connect \S \si
    connect \Y \inner
  end
  cell $pmux \outer_p
    parameter \WIDTH 4
    parameter \S_WIDTH 1
    connect \A \inner
    connect \B \bo
    connect \S \so
    connect \Y \y
  end
end
module \case7_ref
  wire width 4 input 1 \a
  wire width 12 input 2 \bi
  wire width 8 input 3 \bo
  wire width 3 input 4 \si
  wire width 2 input 5 \so
  wire width 4 output 6 \y
  wire width 4 \inner
  cell $pmux \inner_p
    parameter \WIDTH 4
    parameter \S_WIDTH 3
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
module \case8_ref
  wire width 4 input 1 \a
  wire width 12 input 2 \bi
  wire width 12 input 3 \bo
  wire width 3 input 4 \si
  wire width 3 input 5 \so
  wire width 4 output 6 \y
  wire width 4 \inner
  cell $pmux \inner_p
    parameter \WIDTH 4
    parameter \S_WIDTH 3
    connect \A \a
    connect \B \bi
    connect \S \si
    connect \Y \inner
  end
  cell $pmux \outer_p
    parameter \WIDTH 4
    parameter \S_WIDTH 3
    connect \A \inner
    connect \B \bo
    connect \S \so
    connect \Y \y
  end
end
