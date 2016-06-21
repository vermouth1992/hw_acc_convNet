# run.do

vlib work
vlog +acc "src/*.v"
vsim -t 1ns -lib work single_port_ram_tb
# view objects
view wave
do {single_port_ram_wave.do}
log -r *
run -all