onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/clk
add wave -noupdate /testbench/reset
add wave -noupdate /testbench/PC
add wave -noupdate /testbench/Instr
add wave -noupdate /testbench/DataAdr
add wave -noupdate /testbench/ReadData
add wave -noupdate /testbench/MemReadData
add wave -noupdate /testbench/TestbenchRequestReadData
add wave -noupdate /testbench/WriteData
add wave -noupdate /testbench/IMEM_WriteData
add wave -noupdate /testbench/WriteEn
add wave -noupdate /testbench/MemEn
add wave -noupdate /testbench/WriteByteEn
add wave -noupdate /testbench/TestbenchRequest
add wave -noupdate /testbench/TO_HOST_ADR
add wave -noupdate /testbench/tohost_lo
add wave -noupdate /testbench/tohost_hi
add wave -noupdate /testbench/payload
add wave -noupdate /testbench/jump_to_self_count
add wave -noupdate /testbench/cycle_count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
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
configure wave -timelineunits ps
update
WaveRestoreZoom {1210050 ps} {1211050 ps}
