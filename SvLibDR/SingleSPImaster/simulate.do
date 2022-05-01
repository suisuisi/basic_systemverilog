puts ""
puts "Compiling modules:"
puts ""

vlog -sv $dir_prj/SingleSPImaster/SingleSPImaster.sv
vlog -sv $dir_prj/SingleSPImaster/tb.sv

puts ""
puts "Compile is completed"
puts ""

puts ""
puts "Start simulator"
puts ""

vsim -novopt work.tb

add wave -noupdate -divider {Ports}

add wave -noupdate -group {SingleSPImaster MODE 0 - Ports} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label clk /tb/SingleSPImaster_mode0/clk
add wave -noupdate -group {SingleSPImaster MODE 0 - Ports} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label reset /tb/SingleSPImaster_mode0/reset
add wave -noupdate -group {SingleSPImaster MODE 0 - Ports} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label start /tb/SingleSPImaster_mode0/start
add wave -noupdate -group {SingleSPImaster MODE 0 - Ports} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label tx_data /tb/SingleSPImaster_mode0/tx_data
add wave -noupdate -group {SingleSPImaster MODE 0 - Ports} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label rx_data /tb/SingleSPImaster_mode0/rx_data
add wave -noupdate -group {SingleSPImaster MODE 0 - Ports} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label mosi /tb/SingleSPImaster_mode0/mosi
add wave -noupdate -group {SingleSPImaster MODE 0 - Ports} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label sck /tb/SingleSPImaster_mode0/sck
add wave -noupdate -group {SingleSPImaster MODE 0 - Ports} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label cs /tb/SingleSPImaster_mode0/cs
add wave -noupdate -group {SingleSPImaster MODE 0 - Ports} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label miso /tb/SingleSPImaster_mode0/miso
add wave -noupdate -group {SingleSPImaster MODE 0 - Ports} \
		-radix hexadecimal -format Logic \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label done /tb/SingleSPImaster_mode0/done

add wave -noupdate -group {SingleSPImaster MODE 1 - Ports} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label clk /tb/SingleSPImaster_mode1/clk
add wave -noupdate -group {SingleSPImaster MODE 1 - Ports} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label reset /tb/SingleSPImaster_mode1/reset
add wave -noupdate -group {SingleSPImaster MODE 1 - Ports} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label start /tb/SingleSPImaster_mode1/start
add wave -noupdate -group {SingleSPImaster MODE 1 - Ports} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label tx_data /tb/SingleSPImaster_mode1/tx_data
add wave -noupdate -group {SingleSPImaster MODE 1 - Ports} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label rx_data /tb/SingleSPImaster_mode1/rx_data
add wave -noupdate -group {SingleSPImaster MODE 1 - Ports} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label mosi /tb/SingleSPImaster_mode1/mosi
add wave -noupdate -group {SingleSPImaster MODE 1 - Ports} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label sck /tb/SingleSPImaster_mode1/sck
add wave -noupdate -group {SingleSPImaster MODE 1 - Ports} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label cs /tb/SingleSPImaster_mode1/cs
add wave -noupdate -group {SingleSPImaster MODE 1 - Ports} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label miso /tb/SingleSPImaster_mode1/miso
add wave -noupdate -group {SingleSPImaster MODE 1 - Ports} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label done /tb/SingleSPImaster_mode1/done

add wave -noupdate -group {SingleSPImaster MODE 2 - Ports} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label clk /tb/SingleSPImaster_mode2/clk
add wave -noupdate -group {SingleSPImaster MODE 2 - Ports} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label reset /tb/SingleSPImaster_mode2/reset
add wave -noupdate -group {SingleSPImaster MODE 2 - Ports} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label start /tb/SingleSPImaster_mode2/start
add wave -noupdate -group {SingleSPImaster MODE 2 - Ports} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label tx_data /tb/SingleSPImaster_mode2/tx_data
add wave -noupdate -group {SingleSPImaster MODE 2 - Ports} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label rx_data /tb/SingleSPImaster_mode2/rx_data
add wave -noupdate -group {SingleSPImaster MODE 2 - Ports} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label mosi /tb/SingleSPImaster_mode2/mosi
add wave -noupdate -group {SingleSPImaster MODE 2 - Ports} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label sck /tb/SingleSPImaster_mode2/sck
add wave -noupdate -group {SingleSPImaster MODE 2 - Ports} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label cs /tb/SingleSPImaster_mode2/cs
add wave -noupdate -group {SingleSPImaster MODE 2 - Ports} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label miso /tb/SingleSPImaster_mode2/miso
add wave -noupdate -group {SingleSPImaster MODE 2 - Ports} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label done /tb/SingleSPImaster_mode2/done

add wave -noupdate -group {SingleSPImaster MODE 3 - Ports} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label clk /tb/SingleSPImaster_mode3/clk
add wave -noupdate -group {SingleSPImaster MODE 3 - Ports} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label reset /tb/SingleSPImaster_mode3/reset
add wave -noupdate -group {SingleSPImaster MODE 3 - Ports} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label start /tb/SingleSPImaster_mode3/start
add wave -noupdate -group {SingleSPImaster MODE 3 - Ports} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label tx_data /tb/SingleSPImaster_mode3/tx_data
add wave -noupdate -group {SingleSPImaster MODE 3 - Ports} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label rx_data /tb/SingleSPImaster_mode3/rx_data
add wave -noupdate -group {SingleSPImaster MODE 3 - Ports} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label mosi /tb/SingleSPImaster_mode3/mosi
add wave -noupdate -group {SingleSPImaster MODE 3 - Ports} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label sck /tb/SingleSPImaster_mode3/sck
add wave -noupdate -group {SingleSPImaster MODE 3 - Ports} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label cs /tb/SingleSPImaster_mode3/cs
add wave -noupdate -group {SingleSPImaster MODE 3 - Ports} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label miso /tb/SingleSPImaster_mode3/miso
add wave -noupdate -group {SingleSPImaster MODE 3 - Ports} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label done /tb/SingleSPImaster_mode3/done		

add wave -noupdate -divider {Signals}		

add wave -noupdate -group {SingleSPImaster MODE 0 - Signals} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label cnt /tb/SingleSPImaster_mode0/cnt
add wave -noupdate -group {SingleSPImaster MODE 0 - Signals} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label cs_pos /tb/SingleSPImaster_mode0/cs_pos
add wave -noupdate -group {SingleSPImaster MODE 0 - Signals} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label cs_neg /tb/SingleSPImaster_mode0/cs_neg
add wave -noupdate -group {SingleSPImaster MODE 0 - Signals} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label tx_shift_reg /tb/SingleSPImaster_mode0/tx_shift_reg
add wave -noupdate -group {SingleSPImaster MODE 0 - Signals} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label rx_shift_reg /tb/SingleSPImaster_mode0/rx_shift_reg
add wave -noupdate -group {SingleSPImaster MODE 0 - Signals} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label tx_data_ /tb/SingleSPImaster_mode0/tx_data_
add wave -noupdate -group {SingleSPImaster MODE 0 - Signals} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label rx_data_ /tb/SingleSPImaster_mode0/rx_data_

add wave -noupdate -group {SingleSPImaster MODE 1 - Signals} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label cnt /tb/SingleSPImaster_mode1/cnt
add wave -noupdate -group {SingleSPImaster MODE 1 - Signals} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label cs_pos /tb/SingleSPImaster_mode1/cs_pos
add wave -noupdate -group {SingleSPImaster MODE 1 - Signals} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label cs_neg /tb/SingleSPImaster_mode1/cs_neg
add wave -noupdate -group {SingleSPImaster MODE 1 - Signals} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label tx_shift_reg /tb/SingleSPImaster_mode1/tx_shift_reg
add wave -noupdate -group {SingleSPImaster MODE 1 - Signals} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label rx_shift_reg /tb/SingleSPImaster_mode1/rx_shift_reg
add wave -noupdate -group {SingleSPImaster MODE 1 - Signals} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label tx_data_ /tb/SingleSPImaster_mode1/tx_data_
add wave -noupdate -group {SingleSPImaster MODE 1 - Signals} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label rx_data_ /tb/SingleSPImaster_mode1/rx_data_		

add wave -noupdate -group {SingleSPImaster MODE 2 - Signals} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label cnt /tb/SingleSPImaster_mode2/cnt
add wave -noupdate -group {SingleSPImaster MODE 2 - Signals} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label cs_pos /tb/SingleSPImaster_mode2/cs_pos
add wave -noupdate -group {SingleSPImaster MODE 2 - Signals} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label cs_neg /tb/SingleSPImaster_mode2/cs_neg
add wave -noupdate -group {SingleSPImaster MODE 2 - Signals} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label tx_shift_reg /tb/SingleSPImaster_mode2/tx_shift_reg
add wave -noupdate -group {SingleSPImaster MODE 2 - Signals} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label rx_shift_reg /tb/SingleSPImaster_mode2/rx_shift_reg
add wave -noupdate -group {SingleSPImaster MODE 2 - Signals} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label tx_data_ /tb/SingleSPImaster_mode2/tx_data_
add wave -noupdate -group {SingleSPImaster MODE 2 - Signals} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label rx_data_ /tb/SingleSPImaster_mode2/rx_data_		

add wave -noupdate -group {SingleSPImaster MODE 3 - Signals} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label cnt /tb/SingleSPImaster_mode3/cnt
add wave -noupdate -group {SingleSPImaster MODE 3 - Signals} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label cs_pos /tb/SingleSPImaster_mode3/cs_pos
add wave -noupdate -group {SingleSPImaster MODE 3 - Signals} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label cs_neg /tb/SingleSPImaster_mode3/cs_neg
add wave -noupdate -group {SingleSPImaster MODE 3 - Signals} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label tx_shift_reg /tb/SingleSPImaster_mode3/tx_shift_reg
add wave -noupdate -group {SingleSPImaster MODE 3 - Signals} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label rx_shift_reg /tb/SingleSPImaster_mode3/rx_shift_reg
add wave -noupdate -group {SingleSPImaster MODE 3 - Signals} \
		-radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label tx_data_ /tb/SingleSPImaster_mode3/tx_data_
add wave -noupdate -group {SingleSPImaster MODE 3 - Signals} \
		-radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label rx_data_ /tb/SingleSPImaster_mode3/rx_data_

run -all
wave zoom full