/***********************************************************/
/* Description: TestBench for SingleSPImaster.sv           */
/* Author: Dmitriy Dayneko (Digital Rabbit)                */
/* Date: 27.02.2022                                        */
/***********************************************************/
`timescale 1ns/1ns;
module tb;

//tb
parameter real parClock = 10_000_000; // Hz 
localparam realtime parPeriod = 1/parClock * 1_000_000_000;
logic clk, reset;

//mode 0
defparam SingleSPImaster_mode0.WIDTH = 8;
defparam SingleSPImaster_mode0.FIRST_BIT = "MSB";
defparam SingleSPImaster_mode0.CPOL = 0;
defparam SingleSPImaster_mode0.CPHA = 0;
logic start_mode0 = 0;
logic [SingleSPImaster_mode0.WIDTH-1:0] tx_data_mode0;
wire [SingleSPImaster_mode0.WIDTH-1:0] rx_data_mode0;
wire mosi_mode0, sck_mode0, cs_mode0;
wire miso_mode0;
logic tb_miso_mode0;
wire done_mode0;
SingleSPImaster SingleSPImaster_mode0
(
	.clk (clk), .reset (reset),
	.start (start_mode0),
	.tx_data (tx_data_mode0), .rx_data (rx_data_mode0),
	.mosi (mosi_mode0), .sck (sck_mode0), .cs (cs_mode0), .miso (miso_mode0),
	.done (done_mode0)
);
logic [SingleSPImaster_mode0.WIDTH-1:0] tb_rx_data_mode0;
initial begin : miso_mode0_process
	tb_rx_data_mode0 = {$random} % (2**(SingleSPImaster_mode0.WIDTH));
	tb_miso_mode0 = 0;
	@(negedge cs_mode0)
	forever begin
		tb_miso_mode0 = tb_rx_data_mode0[SingleSPImaster_mode0.WIDTH-1];
		@(negedge sck_mode0) tb_rx_data_mode0 <= {tb_rx_data_mode0[SingleSPImaster_mode0.WIDTH-2:0],1'b0};
	end
end
assign miso_mode0 = (cs_mode0) ? 1'bz : tb_miso_mode0;


//mode 1
defparam SingleSPImaster_mode1.WIDTH = 12;
defparam SingleSPImaster_mode1.FIRST_BIT = "LSB";
defparam SingleSPImaster_mode1.CPOL = 0;
defparam SingleSPImaster_mode1.CPHA = 1;
logic start_mode1 = 0;
logic [SingleSPImaster_mode1.WIDTH-1:0] tx_data_mode1;
wire [SingleSPImaster_mode1.WIDTH-1:0] rx_data_mode1;
wire mosi_mode1, sck_mode1, cs_mode1;
wire miso_mode1;
logic tb_miso_mode1;
wire done_mode1;
SingleSPImaster SingleSPImaster_mode1
(
	.clk (clk), .reset (reset),
	.start (start_mode1),
	.tx_data (tx_data_mode1), .rx_data (rx_data_mode1),
	.mosi (mosi_mode1), .sck (sck_mode1), .cs (cs_mode1), .miso (miso_mode1),
	.done (done_mode1)
);
logic [SingleSPImaster_mode1.WIDTH-1:0] tb_rx_data_mode1;
initial begin : miso_mode1_process
	tb_rx_data_mode1 = {$random} % (2**(SingleSPImaster_mode1.WIDTH));
	tb_miso_mode1 = 0;
	@(negedge cs_mode1)
	forever begin		
		@(posedge sck_mode1) tb_miso_mode1 = tb_rx_data_mode1[0];
		tb_rx_data_mode1 <= {1'b0,tb_rx_data_mode1[SingleSPImaster_mode1.WIDTH-1:1]};
	end
end
assign miso_mode1 = (cs_mode1) ? 1'bz : tb_miso_mode1;

//mode 2
defparam SingleSPImaster_mode2.WIDTH = 16;
defparam SingleSPImaster_mode2.FIRST_BIT = "MSB";
defparam SingleSPImaster_mode2.CPOL = 1;
defparam SingleSPImaster_mode2.CPHA = 0;
logic start_mode2 = 0;
logic [SingleSPImaster_mode2.WIDTH-1:0] tx_data_mode2;
wire [SingleSPImaster_mode2.WIDTH-1:0] rx_data_mode2;
wire mosi_mode2, sck_mode2, cs_mode2;
wire miso_mode2;
logic tb_miso_mode2;
wire done_mode2;
SingleSPImaster SingleSPImaster_mode2
(
	.clk (clk), .reset (reset),
	.start (start_mode2),
	.tx_data (tx_data_mode2), .rx_data (rx_data_mode2),
	.mosi (mosi_mode2), .sck (sck_mode2), .cs (cs_mode2), .miso (miso_mode2),
	.done (done_mode2)
);
logic [SingleSPImaster_mode2.WIDTH-1:0] tb_rx_data_mode2;
initial begin : miso_mode2_process
	tb_rx_data_mode2 = {$random} % (2**(SingleSPImaster_mode2.WIDTH));
	tb_miso_mode2 = 0;
	@(negedge cs_mode2)
	forever begin
		tb_miso_mode2 = tb_rx_data_mode2[SingleSPImaster_mode2.WIDTH-1];
		@(posedge sck_mode2) tb_rx_data_mode2 <= {tb_rx_data_mode2[SingleSPImaster_mode2.WIDTH-2:0],1'b0};
	end
end
assign miso_mode2 = (cs_mode2) ? 1'bz : tb_miso_mode2;

//mode 3
defparam SingleSPImaster_mode3.WIDTH = 32;
defparam SingleSPImaster_mode3.FIRST_BIT = "LSB";
defparam SingleSPImaster_mode3.CPOL = 1;
defparam SingleSPImaster_mode3.CPHA = 1;
logic start_mode3 = 0;
logic [SingleSPImaster_mode3.WIDTH-1:0] tx_data_mode3;
wire [SingleSPImaster_mode3.WIDTH-1:0] rx_data_mode3;
wire mosi_mode3, sck_mode3, cs_mode3;
wire miso_mode3;
logic tb_miso_mode3;
wire done_mode3;
SingleSPImaster SingleSPImaster_mode3
(
	.clk (clk), .reset (reset),
	.start (start_mode3),
	.tx_data (tx_data_mode3), .rx_data (rx_data_mode3),
	.mosi (mosi_mode3), .sck (sck_mode3), .cs (cs_mode3), .miso (miso_mode3),
	.done (done_mode3)
);
logic [SingleSPImaster_mode3.WIDTH-1:0] tb_rx_data_mode3;
initial begin : miso_mode3_process
	//tb_rx_data_mode3 = {$random} % (2**(SingleSPImaster_mode3.WIDTH));
	tb_rx_data_mode3[15:0] = {$random} % (2**16);
	tb_rx_data_mode3[31:16] = {$random} % (2**16);
	tb_miso_mode3 = 0;
	@(negedge cs_mode3)
	forever begin		
		@(negedge sck_mode3) tb_miso_mode3 = tb_rx_data_mode3[0];
		tb_rx_data_mode3 <= {1'b0,tb_rx_data_mode3[SingleSPImaster_mode3.WIDTH-1:1]};
	end
end
assign miso_mode3 = (cs_mode3) ? 1'bz : tb_miso_mode3;

initial begin : clock_init
	clk = 0;
	forever #(parPeriod/2) clk = !clk;
end

initial begin : reset_init
	tx_data_mode0 = '0;
	tx_data_mode1 = '0;
	tx_data_mode2 = '0;
	tx_data_mode3 = '0;
	reset = 1;
	repeat (2) @(posedge clk);
	reset = 0;
	//
	tx_data_mode0 = {$random} % (2**(SingleSPImaster_mode0.WIDTH));
	repeat (1) @(posedge clk); start_mode0 = 1;
	repeat (1) @(posedge clk); start_mode0 = 0;
	repeat ((SingleSPImaster_mode0.WIDTH)+5) @(posedge clk);
	//
	tx_data_mode1 = {$random} % (2**(SingleSPImaster_mode1.WIDTH));
	repeat (1) @(posedge clk); start_mode1 = 1;
	repeat (1) @(posedge clk); start_mode1 = 0;
	repeat ((SingleSPImaster_mode1.WIDTH)+5) @(posedge clk);
	//
	//
	tx_data_mode2 = {$random} % (2**(SingleSPImaster_mode2.WIDTH));
	repeat (1) @(posedge clk); start_mode2 = 1;
	repeat (1) @(posedge clk); start_mode2 = 0;
	repeat ((SingleSPImaster_mode2.WIDTH)+5) @(posedge clk);
	//
	//tx_data_mode3 = {$random} % (2**(SingleSPImaster_mode3.WIDTH));
	tx_data_mode3[15:0] = {$random} % (2**16);
	tx_data_mode3[31:16] = {$random} % (2**16);
	repeat (1) @(posedge clk); start_mode3 = 1;
	repeat (1) @(posedge clk); start_mode3 = 0;
	repeat ((SingleSPImaster_mode3.WIDTH)+5) @(posedge clk);
	$stop;$stop;$stop;
end

initial begin : process

end

endmodule