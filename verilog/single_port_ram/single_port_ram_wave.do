onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /single_port_ram_tb/clk
add wave -noupdate /single_port_ram_tb/data
add wave -noupdate /single_port_ram_tb/addr
add wave -noupdate /single_port_ram_tb/we
add wave -noupdate /single_port_ram_tb/q
add wave -noupdate /single_port_ram_tb/file
add wave -noupdate /single_port_ram_tb/uut/data
add wave -noupdate /single_port_ram_tb/uut/addr
add wave -noupdate /single_port_ram_tb/uut/we
add wave -noupdate /single_port_ram_tb/uut/clk
add wave -noupdate /single_port_ram_tb/uut/q
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 205
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
WaveRestoreZoom {0 ns} {910 ns}
