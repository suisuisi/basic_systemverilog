puts ""
puts "Compiling modules:"
puts ""

vlog -sv $dir_prj/SingleRxUART/SingleRxUART.sv
vlog -sv $dir_prj/SingleRxUART/tb.sv

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
		-label clk /tb/SingleRxUART/clk
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label reset /tb/SingleRxUART/reset
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label rxd /tb/SingleRxUART/rxd
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label rx_data /tb/SingleRxUART/rx_data
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label parity_err /tb/SingleRxUART/parity_err
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label done /tb/SingleRxUART/done
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label busy /tb/SingleRxUART/busy		

add wave -noupdate -divider {Signals}

add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label sync_reg /tb/SingleRxUART/sync_reg
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label rxd_ /tb/SingleRxUART/rxd_
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label len_bit /tb/SingleRxUART/len_bit
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label bit_mid /tb/SingleRxUART/bit_mid
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label bit_full /tb/SingleRxUART/bit_full
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label len_bit_inc /tb/SingleRxUART/len_bit_inc
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label cnt_bit /tb/SingleRxUART/cnt_bit
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label len_word /tb/SingleRxUART/len_word
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label end_word /tb/SingleRxUART/end_word
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label data_buf /tb/SingleRxUART/data_buf
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label data /tb/SingleRxUART/data
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label parity_calc /tb/SingleRxUART/parity_calc
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label rx_data_ /tb/SingleRxUART/rx_data_

run -all
wave zoom full		