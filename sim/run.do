vlib work
vmap work work

# Compile
vlog -sv ../dut/rr_arbiter.sv
vlog -sv ../tb/rr_if.sv
vlog -sv ../tb/rr_assertions.sv
vlog -sv +incdir+../tb ../tb/tb_pkg.sv
vlog -sv +incdir+../tb ../tb/tb_top.sv

# Sim
vsim -voptargs=+acc tb_top

# Waves
delete wave *

add wave -divider "TOP / IF"
add wave sim:/tb_top/clk
add wave sim:/tb_top/rif/rst_n
add wave sim:/tb_top/rif/enable
add wave -radix hex sim:/tb_top/rif/req
add wave -radix hex sim:/tb_top/rif/gnt

add wave -divider "DUT INTERNALS"
add wave sim:/tb_top/dut/ptr_q
add wave sim:/tb_top/dut/ptr_d
add wave -radix hex sim:/tb_top/dut/gnt_d

run -all

