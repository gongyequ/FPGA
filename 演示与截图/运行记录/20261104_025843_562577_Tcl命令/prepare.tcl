yosys -import
read_verilog -sv zip_case04.v
hierarchy -check -top pmux_case04_feedback
synth_intel -family cycloneiv -top pmux_case04_feedback -run begin:coarse
yosys proc
flatten
tribuf -logic
deminout
opt_expr
check
opt_clean
opt -nodffe -nosdff
fsm
opt
wreduce
peepopt
opt_clean
write_rtlil pre_pmux.il
