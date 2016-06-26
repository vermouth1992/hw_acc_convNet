onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /afu_user_tb/clk
add wave -noupdate /afu_user_tb/reset
add wave -noupdate /afu_user_tb/input_fifo_din
add wave -noupdate /afu_user_tb/input_fifo_we
add wave -noupdate /afu_user_tb/output_fifo_dout
add wave -noupdate /afu_user_tb/output_fifo_re
add wave -noupdate /afu_user_tb/output_fifo_empty
add wave -noupdate /afu_user_tb/ctx_length
add wave -noupdate /afu_user_tb/input_file
add wave -noupdate /afu_user_tb/output_file
add wave -noupdate /afu_user_tb/status
add wave -noupdate /afu_user_tb/ctx_length_count
add wave -noupdate /afu_user_tb/output_fifo_re_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1001 ns}
