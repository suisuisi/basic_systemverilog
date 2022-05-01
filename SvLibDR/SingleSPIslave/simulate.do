puts ""
puts "Compiling modules:"
puts ""

vlog -sv $dir_prj/SingleSPIslave/SingleSPIslave.sv
vlog -sv $dir_prj/SingleSPIslave/tb.sv

puts ""
puts "Compile is completed"
puts ""

puts ""
puts "Start simulator"
puts ""

vsim -novopt work.tb

add wave -noupdate -divider {Ports}

add wave -noupdate -group {SingleSPIslave MODE 0 - Ports} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label mosi /tb/SingleSPIslave_mode0/mosi
add wave -noupdate -group {SingleSPIslave MODE 0 - Ports} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label sck /tb/SingleSPIslave_mode0/sck
add wave -noupdate -group {SingleSPIslave MODE 0 - Ports} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label cs /tb/SingleSPIslave_mode0/cs
add wave -noupdate -group {SingleSPIslave MODE 0 - Ports} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label miso /tb/SingleSPIslave_mode0/miso
add wave -noupdate -group {SingleSPIslave MODE 0 - Ports} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label rx_data /tb/SingleSPIslave_mode0/rx_data				
add wave -noupdate -group {SingleSPIslave MODE 0 - Ports} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label tx_data /tb/SingleSPIslave_mode0/tx_data

add wave -noupdate -group {SingleSPIslave MODE 1 - Ports} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label mosi /tb/SingleSPIslave_mode1/mosi
add wave -noupdate -group {SingleSPIslave MODE 1 - Ports} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label sck /tb/SingleSPIslave_mode1/sck
add wave -noupdate -group {SingleSPIslave MODE 1 - Ports} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label cs /tb/SingleSPIslave_mode1/cs
add wave -noupdate -group {SingleSPIslave MODE 1 - Ports} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label miso /tb/SingleSPIslave_mode1/miso
add wave -noupdate -group {SingleSPIslave MODE 1 - Ports} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label rx_data /tb/SingleSPIslave_mode1/rx_data				
add wave -noupdate -group {SingleSPIslave MODE 1 - Ports} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label tx_data /tb/SingleSPIslave_mode1/tx_data

add wave -noupdate -group {SingleSPIslave MODE 2 - Ports} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label mosi /tb/SingleSPIslave_mode2/mosi
add wave -noupdate -group {SingleSPIslave MODE 2 - Ports} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label sck /tb/SingleSPIslave_mode2/sck
add wave -noupdate -group {SingleSPIslave MODE 2 - Ports} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label cs /tb/SingleSPIslave_mode2/cs
add wave -noupdate -group {SingleSPIslave MODE 2 - Ports} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label miso /tb/SingleSPIslave_mode2/miso
add wave -noupdate -group {SingleSPIslave MODE 2 - Ports} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label rx_data /tb/SingleSPIslave_mode2/rx_data				
add wave -noupdate -group {SingleSPIslave MODE 2 - Ports} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label tx_data /tb/SingleSPIslave_mode2/tx_data

add wave -noupdate -group {SingleSPIslave MODE 3 - Ports} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label mosi /tb/SingleSPIslave_mode3/mosi
add wave -noupdate -group {SingleSPIslave MODE 3 - Ports} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label sck /tb/SingleSPIslave_mode3/sck
add wave -noupdate -group {SingleSPIslave MODE 3 - Ports} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label cs /tb/SingleSPIslave_mode3/cs
add wave -noupdate -group {SingleSPIslave MODE 3 - Ports} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label miso /tb/SingleSPIslave_mode3/miso
add wave -noupdate -group {SingleSPIslave MODE 3 - Ports} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label rx_data /tb/SingleSPIslave_mode3/rx_data				
add wave -noupdate -group {SingleSPIslave MODE 3 - Ports} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label tx_data /tb/SingleSPIslave_mode3/tx_data

add wave -noupdate -divider {Signals}

add wave -noupdate -group {SingleSPIslave MODE 0 - Signals} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label tx_shift_reg /tb/SingleSPIslave_mode0/tx_shift_reg
add wave -noupdate -group {SingleSPIslave MODE 0 - Signals} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label rx_shift_reg /tb/SingleSPIslave_mode0/rx_shift_reg
add wave -noupdate -group {SingleSPIslave MODE 0 - Signals} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label tx_data_ /tb/SingleSPIslave_mode0/tx_data_
add wave -noupdate -group {SingleSPIslave MODE 0 - Signals} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label tx_data__ /tb/SingleSPIslave_mode0/tx_data__
add wave -noupdate -group {SingleSPIslave MODE 0 - Signals} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label rx_data_ /tb/SingleSPIslave_mode0/rx_data_
add wave -noupdate -group {SingleSPIslave MODE 0 - Signals} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label cnt /tb/SingleSPIslave_mode0/cnt

add wave -noupdate -group {SingleSPIslave MODE 1 - Signals} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label tx_shift_reg /tb/SingleSPIslave_mode1/tx_shift_reg
add wave -noupdate -group {SingleSPIslave MODE 1 - Signals} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label rx_shift_reg /tb/SingleSPIslave_mode1/rx_shift_reg
add wave -noupdate -group {SingleSPIslave MODE 1 - Signals} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label tx_data_ /tb/SingleSPIslave_mode1/tx_data_
add wave -noupdate -group {SingleSPIslave MODE 1 - Signals} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label tx_data__ /tb/SingleSPIslave_mode1/tx_data__
add wave -noupdate -group {SingleSPIslave MODE 1 - Signals} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label rx_data_ /tb/SingleSPIslave_mode1/rx_data_
add wave -noupdate -group {SingleSPIslave MODE 1 - Signals} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label cnt /tb/SingleSPIslave_mode1/cnt

add wave -noupdate -group {SingleSPIslave MODE 2 - Signals} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label tx_shift_reg /tb/SingleSPIslave_mode2/tx_shift_reg
add wave -noupdate -group {SingleSPIslave MODE 2 - Signals} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label rx_shift_reg /tb/SingleSPIslave_mode2/rx_shift_reg
add wave -noupdate -group {SingleSPIslave MODE 2 - Signals} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label tx_data_ /tb/SingleSPIslave_mode2/tx_data_
add wave -noupdate -group {SingleSPIslave MODE 2 - Signals} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label tx_data__ /tb/SingleSPIslave_mode2/tx_data__
add wave -noupdate -group {SingleSPIslave MODE 2 - Signals} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label rx_data_ /tb/SingleSPIslave_mode2/rx_data_
add wave -noupdate -group {SingleSPIslave MODE 2 - Signals} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label cnt /tb/SingleSPIslave_mode2/cnt

add wave -noupdate -group {SingleSPIslave MODE 3 - Signals} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label tx_shift_reg /tb/SingleSPIslave_mode3/tx_shift_reg
add wave -noupdate -group {SingleSPIslave MODE 3 - Signals} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label rx_shift_reg /tb/SingleSPIslave_mode3/rx_shift_reg
add wave -noupdate -group {SingleSPIslave MODE 3 - Signals} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label tx_data_ /tb/SingleSPIslave_mode3/tx_data_
add wave -noupdate -group {SingleSPIslave MODE 3 - Signals} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label tx_data__ /tb/SingleSPIslave_mode3/tx_data__
add wave -noupdate -group {SingleSPIslave MODE 3 - Signals} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label rx_data_ /tb/SingleSPIslave_mode3/rx_data_
add wave -noupdate -group {SingleSPIslave MODE 3 - Signals} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label cnt /tb/SingleSPIslave_mode3/cnt

run -all
wave zoom full