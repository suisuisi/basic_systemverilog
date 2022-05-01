puts ""
puts "Compiling modules:"
puts ""

vlog -sv $dir_prj/ReceiverUART/ReceiverUART.sv
vlog -sv $dir_prj/ReceiverUART/SingleRxUART.sv
vlog -sv $dir_prj/ReceiverUART/RxUART_logic.sv
vlog -sv $dir_prj/ReceiverUART/RxUART_timeout.sv
vlog -sv $dir_prj/ReceiverUART/tb.sv

puts ""
puts "Compile is completed"
puts ""

puts ""
puts "Start simulator"
puts ""

vsim -novopt work.tb

add wave -noupdate -divider {ReceiverUART}

add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label clk /tb/ReceiverUART/clk
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label reset /tb/ReceiverUART/reset
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label rxd /tb/ReceiverUART/rxd
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label rx_done /tb/ReceiverUART/rx_done
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label cmd_rx /tb/ReceiverUART/cmd_rx
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label len_rx /tb/ReceiverUART/len_rx
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label wr_data /tb/ReceiverUART/wr_data
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label wr_addr /tb/ReceiverUART/wr_addr
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label wr_clock /tb/ReceiverUART/wr_clock
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label we /tb/ReceiverUART/we		

add wave -noupdate -divider {SingleRxUART}

add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label clk /tb/ReceiverUART/SingleRxUART/clk
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label reset /tb/ReceiverUART/SingleRxUART/reset
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label rxd /tb/ReceiverUART/SingleRxUART/rxd
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label rx_data /tb/ReceiverUART/SingleRxUART/rx_data
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label parity_err /tb/ReceiverUART/SingleRxUART/parity_err
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label done /tb/ReceiverUART/SingleRxUART/done
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label busy /tb/ReceiverUART/SingleRxUART/busy
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label rx_data_ /tb/ReceiverUART/SingleRxUART/rx_data_
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label sync_reg /tb/ReceiverUART/SingleRxUART/sync_reg
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label rxd_ /tb/ReceiverUART/SingleRxUART/rxd_
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label len_bit /tb/ReceiverUART/SingleRxUART/len_bit
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label bit_mid /tb/ReceiverUART/SingleRxUART/bit_mid
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label bit_full /tb/ReceiverUART/SingleRxUART/bit_full
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label len_bit_inc /tb/ReceiverUART/SingleRxUART/len_bit_inc
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label cnt_bit /tb/ReceiverUART/SingleRxUART/cnt_bit
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label len_word /tb/ReceiverUART/SingleRxUART/len_word
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label end_word /tb/ReceiverUART/SingleRxUART/end_word
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label data_buf /tb/ReceiverUART/SingleRxUART/data_buf
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label data /tb/ReceiverUART/SingleRxUART/data
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label parity_calc /tb/ReceiverUART/SingleRxUART/parity_calc

add wave -noupdate -divider {RxUART_logic}

add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label clk /tb/ReceiverUART/RxUART_logic/clk
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label reset /tb/ReceiverUART/RxUART_logic/reset
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label rx_data /tb/ReceiverUART/RxUART_logic/rx_data
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label rx_done /tb/ReceiverUART/RxUART_logic/rx_done
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label timeout /tb/ReceiverUART/RxUART_logic/timeout
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label pck_done /tb/ReceiverUART/RxUART_logic/pck_done
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label cmd_rx /tb/ReceiverUART/RxUART_logic/cmd_rx
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label len_rx /tb/ReceiverUART/RxUART_logic/len_rx
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label wr_data /tb/ReceiverUART/RxUART_logic/wr_data
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label wr_addr /tb/ReceiverUART/RxUART_logic/wr_addr
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label wr_clock /tb/ReceiverUART/RxUART_logic/wr_clock
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label we /tb/ReceiverUART/RxUART_logic/we

run -all
wave zoom full