/***********************************************************/
/* Description: TestBench for TransmitterUART.sv           */
/* Author: Dmitriy Dayneko (Digital Rabbit)                */
/* Date: 21.02.2022                                        */
/***********************************************************/
`timescale 1ns/1ns;
module tb;

//tb
parameter real parClock = 10_000_000; // Hz 
localparam realtime parPeriod = 1/parClock * 1_000_000_000;
int length_bit = TransmitterUART.SingleTxUART.factor_int;
logic [7:0] mem [0:7];

//TransmitterUART
parameter int CLOCK = 10_000_000;	// Hz
parameter int BAUD = 1_000_000;		// Baud
parameter PARITY = "NO";			// "ODD","EVEN","NO"
parameter FIRST_BIT = "LSB";		// "LSB","MSB"
parameter NUMBER = 8;				// 1 ... 256
parameter PAUSE = 0;				// bits (delay between bytes)
logic clk, reset;
wire txd;
logic start;
logic [7:0] cmd_tx, len_tx;
logic [7:0] rd_data = '0;
wire [$clog2(NUMBER)-1:0] rd_addr;
wire rd_clock;

defparam TransmitterUART.CLOCK = CLOCK;
defparam TransmitterUART.BAUD = BAUD;
defparam TransmitterUART.PARITY = PARITY;
defparam TransmitterUART.FIRST_BIT = FIRST_BIT;
defparam TransmitterUART.NUMBER = NUMBER;
defparam TransmitterUART.PAUSE = PAUSE;
TransmitterUART TransmitterUART
(
	.clk (clk), .reset (reset),
	.txd (txd),
	.start (start), .cmd_tx (cmd_tx), .len_tx (len_tx),
	.rd_data (rd_data), .rd_addr (rd_addr), .rd_clock (rd_clock)
);

initial begin : mem_init
	for(int i=0; i<NUMBER; i++) mem[i] = {$random} % (2**8);
end

always_ff @ (posedge rd_clock)
	rd_data = mem[rd_addr];

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
	start = 0; cmd_tx = '0; len_tx = '0;
	repeat (4) @(posedge clk);
	cmd_tx = {$random} % (2**8);
	len_tx = 7;
	repeat (1) @(posedge clk);
	start = 1; @(posedge clk); start = 0;
	repeat ((length_bit*(11+PAUSE))*(len_tx+3)) @(posedge clk);
	$stop;$stop;$stop;
end

endmodule