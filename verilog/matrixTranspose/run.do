# run.do

vlib work
vlog +acc "src/*.v"
vsim -t 1ns -lib work afu_user_tb
# view objects
view wave
do {input_fifo_wave.do}
log -r *
run -all