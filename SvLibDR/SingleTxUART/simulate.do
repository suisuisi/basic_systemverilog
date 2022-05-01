puts ""
puts "Compiling modules:"
puts ""

vlog -sv $dir_prj/SingleTxUART/SingleTxUART.sv
vlog -sv $dir_prj/SingleTxUART/tb.sv

puts ""
puts "Compile is completed"
puts ""

puts ""
puts "Start simulator"
puts ""

vsim -novopt work.tb

add wave -noupdate -divider {Ports}

add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label clk /tb/SingleTxUART/clk
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label reset /tb/SingleTxUART/reset
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label start /tb/SingleTxUART/start
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label tx_data /tb/SingleTxUART/tx_data
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label txd /tb/SingleTxUART/txd
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label busy /tb/SingleTxUART/busy

add wave -noupdate -divider {Signals}

add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label parity_bit /tb/SingleTxUART/parity_bit
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label tx_data_ /tb/SingleTxUART/tx_data_
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label data_wire /tb/SingleTxUART/data_wire
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label data_buf /tb/SingleTxUART/data_buf
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label len_bit /tb/SingleTxUART/len_bit
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label clr_len_bit /tb/SingleTxUART/clr_len_bit
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label cnt_bit /tb/SingleTxUART/cnt_bit
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label width_word /tb/SingleTxUART/width_word

run -all
wave zoom full