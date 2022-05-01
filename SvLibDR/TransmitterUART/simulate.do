puts ""
puts "Compiling modules:"
puts ""

vlog -sv $dir_prj/TransmitterUART/TransmitterUART.sv
vlog -sv $dir_prj/TransmitterUART/SingleTxUART.sv
vlog -sv $dir_prj/TransmitterUART/TxUART_logic.sv
vlog -sv $dir_prj/TransmitterUART/tb.sv

puts ""
puts "Compile is completed"
puts ""

puts ""
puts "Start simulator"
puts ""

vsim -novopt work.tb

add wave -noupdate -divider {TransmitterUART}

add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label clk /tb/TransmitterUART/clk
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label reset /tb/TransmitterUART/reset
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label txd /tb/TransmitterUART/txd
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label start /tb/TransmitterUART/start
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label cmd_tx /tb/TransmitterUART/cmd_tx
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label len_tx /tb/TransmitterUART/len_tx
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label rd_data /tb/TransmitterUART/rd_data
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label rd_addr /tb/TransmitterUART/rd_addr
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label rd_clock /tb/TransmitterUART/rd_clock

add wave -noupdate -divider {SingleTxUART}

add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label clk /tb/TransmitterUART/SingleTxUART/clk
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label reset /tb/TransmitterUART/SingleTxUART/reset
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label start /tb/TransmitterUART/SingleTxUART/start
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label tx_data /tb/TransmitterUART/SingleTxUART/tx_data
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label txd /tb/TransmitterUART/SingleTxUART/txd
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label busy /tb/TransmitterUART/SingleTxUART/busy
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label parity_bit /tb/TransmitterUART/SingleTxUART/parity_bit
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label tx_data_ /tb/TransmitterUART/SingleTxUART/tx_data_
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label data_wire /tb/TransmitterUART/SingleTxUART/data_wire
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label data_buf /tb/TransmitterUART/SingleTxUART/data_buf
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label len_bit /tb/TransmitterUART/SingleTxUART/len_bit
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label clr_len_bit /tb/TransmitterUART/SingleTxUART/clr_len_bit
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label cnt_bit /tb/TransmitterUART/SingleTxUART/cnt_bit
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label width_word /tb/TransmitterUART/SingleTxUART/width_word		

add wave -noupdate -divider {TxUART_logic}

add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label clk /tb/TransmitterUART/TxUART_logic/clk
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label reset /tb/TransmitterUART/TxUART_logic/reset
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label tx_data /tb/TransmitterUART/TxUART_logic/tx_data
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label tx_start /tb/TransmitterUART/TxUART_logic/tx_start
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label start_pckt /tb/TransmitterUART/TxUART_logic/start_pckt
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label cmd_tx /tb/TransmitterUART/TxUART_logic/cmd_tx
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label len_tx /tb/TransmitterUART/TxUART_logic/len_tx
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label rd_data /tb/TransmitterUART/TxUART_logic/rd_data
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label rd_addr /tb/TransmitterUART/TxUART_logic/rd_addr
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label rd_clock /tb/TransmitterUART/TxUART_logic/rd_clock
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label delay_reg /tb/TransmitterUART/TxUART_logic/delay_reg
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label next_byte /tb/TransmitterUART/TxUART_logic/next_byte
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label incr_byte /tb/TransmitterUART/TxUART_logic/incr_byte
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label load_byte /tb/TransmitterUART/TxUART_logic/load_byte
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label start_byte /tb/TransmitterUART/TxUART_logic/start_byte
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label sum_and_read /tb/TransmitterUART/TxUART_logic/sum_and_read
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label cnt_byte /tb/TransmitterUART/TxUART_logic/cnt_byte
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label sum_calc /tb/TransmitterUART/TxUART_logic/sum_calc
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label num_byte /tb/TransmitterUART/TxUART_logic/num_byte
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label len_bit /tb/TransmitterUART/TxUART_logic/len_bit
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label cnt_bit_incr /tb/TransmitterUART/TxUART_logic/cnt_bit_incr
add wave -noupdate -radix hexadecimal -format Logic \
		-color Cyan -itemcolor Cyan \
		-label num_pause /tb/TransmitterUART/TxUART_logic/num_pause
add wave -noupdate -radix hexadecimal -format Logic \
		-color Green -itemcolor Green \
		-label cnt_bit /tb/TransmitterUART/TxUART_logic/cnt_bit

run -all
wave zoom full