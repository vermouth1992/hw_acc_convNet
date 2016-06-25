onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /afu_user_tb/afu_user_uut/input_fifo/clk
add wave -noupdate /afu_user_tb/afu_user_uut/input_fifo/reset
add wave -noupdate /afu_user_tb/afu_user_uut/input_fifo/we
add wave -noupdate /afu_user_tb/afu_user_uut/input_fifo/din
add wave -noupdate /afu_user_tb/afu_user_uut/input_fifo/re
add wave -noupdate /afu_user_tb/afu_user_uut/input_fifo/dout
add wave -noupdate /afu_user_tb/afu_user_uut/input_fifo/count
add wave -noupdate /afu_user_tb/afu_user_uut/input_fifo/empty
add wave -noupdate /afu_user_tb/afu_user_uut/input_fifo/almostempty
add wave -noupdate /afu_user_tb/afu_user_uut/input_fifo/full
add wave -noupdate /afu_user_tb/afu_user_uut/input_fifo/almostfull
add wave -noupdate /afu_user_tb/afu_user_uut/input_fifo/valid
add wave -noupdate /afu_user_tb/afu_user_uut/input_fifo/overflow
add wave -noupdate /afu_user_tb/afu_user_uut/input_fifo/underflow
add wave -noupdate /afu_user_tb/afu_user_uut/input_fifo/rp
add wave -noupdate /afu_user_tb/afu_user_uut/input_fifo/wp
add wave -noupdate /afu_user_tb/afu_user_uut/input_fifo/mem
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
WaveRestoreZoom {0 ns} {1002 ns}
