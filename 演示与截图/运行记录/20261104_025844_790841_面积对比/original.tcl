yosys -import
read_verilog -sv zip_case04.v
hierarchy -check -top pmux_case04_feedback
synth_intel -family cycloneiv -top pmux_case04_feedback -run begin:map_cells
stat
write_rtlil original.il
write_json original.json
