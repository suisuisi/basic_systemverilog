/***********************************************************/
/* Description: Transmitter protocol to UART               */
/* 		cmd, len, data0, ... datax, sum                    */
/*      {sum = ~(cmd + len + data0 + ... + datax)}         */
/* Author: Dmitriy Dayneko (Digital Rabbit)                */
/* Version: 1.1                                            */
/* Date: 20.02.2022                                        */
/***********************************************************/

function automatic int clogb2 (input int number);
    int calc;
    begin
      for (int i = 0; 2**i < number; i++)
        calc = i + 1;
        clogb2 = (number == 0) ? 0 :
                  (number == 1) ? 1 : calc;
    end
endfunction

module TransmitterUART
#(
	parameter int CLOCK = 10_000_000,
	parameter int BAUD = 1_000_000,
	parameter PARITY = "NO",
	parameter FIRST_BIT = "LSB",
	parameter NUMBER = 256,
	parameter PAUSE = 0
)
(
input clk,
input reset,
output txd,
input start,
input [7:0] cmd_tx,
input [clogb2(NUMBER)-1:0] len_tx,
input [7:0] rd_data,
output [clogb2(NUMBER)-1:0] rd_addr,
output rd_clock
);

///// SIGNALS /////

wire single_start;
wire [7:0] tx_data;

///// TRANSMIT SINGLE BYTE /////

defparam SingleTxUART.CLOCK = CLOCK;
defparam SingleTxUART.BAUD = BAUD;
defparam SingleTxUART.PARITY = PARITY;
defparam SingleTxUART.FIRST_BIT = FIRST_BIT;
SingleTxUART SingleTxUART
(
	.clk (clk), .reset (reset),
	.start (single_start), .tx_data (tx_data),
	.busy (),
	.txd (txd)
);

///// TRANSMIT PACKET /////

defparam TxUART_logic.CLOCK = CLOCK;
defparam TxUART_logic.BAUD = BAUD;
defparam TxUART_logic.PARITY = PARITY;
defparam TxUART_logic.NUMBER = NUMBER;
defparam TxUART_logic.PAUSE = PAUSE;
TxUART_logic TxUART_logic
(
	.clk (clk), .reset (reset),
	.tx_data (tx_data), .tx_start (single_start),
	.start_pckt (start),
	.cmd_tx (cmd_tx), .len_tx (len_tx),
	.rd_data (rd_data),
	.rd_addr (rd_addr),
	.rd_clock (rd_clock)
);

endmodule