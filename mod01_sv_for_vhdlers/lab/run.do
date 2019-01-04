# deletes library work
if [file exists work] {vdel -all}  

# creates library work
vlib work

# vlog compiles verilog source code and systemVerilog extensions into a specified working library
vlog ../lab_solution/clear_DUT.sv
vlog top.sv

# vsim invokes the simulator
# +acc enables visiblity into design 
vsim -voptargs="+acc" top



add wave sim:/top/*

run 500 ns

configure wave -signalnamewidth 1

