/***********************************************************/
/* Description: TestBench for SingleTxUART.sv              */
/* Author: Dmitriy Dayneko (Digital Rabbit)                */
/* Date: 20.02.2022                                        */
/***********************************************************/
`timescale 1ns/1ns;
module tb;

//tb
parameter real parClock = 10_000_000; // Hz 
localparam realtime parPeriod = 1/parClock * 1_000_000_000;
int length_bit = SingleTxUART.factor_int;

//SingleTxUART
parameter int CLOCK = 10_000_000;	// Hz
parameter int BAUD = 1_000_000;		// Baud
parameter PARITY = "NO";			// "ODD","EVEN","NO"
parameter FIRST_BIT = "LSB";		// "LSB","MSB"
logic clk, reset;
wire txd, busy;
logic start;
logic [7:0] tx_data;

defparam SingleTxUART.CLOCK = CLOCK;
defparam SingleTxUART.BAUD = BAUD;
defparam SingleTxUART.PARITY = PARITY;
defparam SingleTxUART.FIRST_BIT = FIRST_BIT;
SingleTxUART SingleTxUART
(
	.clk (clk), .reset (reset),
	.txd (txd),
  	.start (start), .tx_data (tx_data),
  	.busy (busy)
);

initial begin : clock_init
	clk = 0;
	forever #(parPeriod/2) clk = !clk;
end

initial begin : reset_init
	reset = 1;
	repeat (2) @(posedge clk);
	reset = 0;
end

initial begin : process
	tx_data = 0; start = 0;
	repeat (4) @(posedge clk);
	tx_data = {$random} % (2**8);
	repeat (1) @(posedge clk);
	start = 1; @(posedge clk); start = 0;
	repeat (length_bit*12) @(posedge clk);
	$stop;$stop;$stop;
end

endmodule