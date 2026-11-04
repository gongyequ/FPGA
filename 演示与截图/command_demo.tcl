# Real Tcl entry; Yosys exposes its registered commands to Tcl.
yosys -import
read_rtlil pre_pmux.il
puts {=== Custom Tcl command ===}
pmux_opt -order-decode -flatten-fallback -uniform-abc -flatten-data-arm
stat
write_rtlil after_pmux.il
