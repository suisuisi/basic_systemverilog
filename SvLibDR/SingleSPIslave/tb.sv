/***********************************************************/
/* Description: TestBench for SingleSPIslave.sv           */
/* Author: Dmitriy Dayneko (Digital Rabbit)                */
/* Date: 27.03.2022                                        */
/***********************************************************/
`timescale 1ns/1ns;
module tb;

//mode 0
defparam SingleSPIslave_mode0.WIDTH = 8;
defparam SingleSPIslave_mode0.FIRST_BIT = "MSB";
defparam SingleSPIslave_mode0.CPOL = 0;
defparam SingleSPIslave_mode0.CPHA = 0;
logic [SingleSPIslave_mode0.WIDTH-1:0] tx_data_mode0;
wire [SingleSPIslave_mode0.WIDTH-1:0] rx_data_mode0;
logic mosi_mode0, sck_mode0, cs_mode0;
wire miso_mode0;
SingleSPIslave SingleSPIslave_mode0
(
	.mosi (mosi_mode0), .sck (sck_mode0), .cs (cs_mode0), .miso (miso_mode0),
	.rx_data (rx_data_mode0), .tx_data (tx_data_mode0)
);

//mode 1
defparam SingleSPIslave_mode1.WIDTH = 12;
defparam SingleSPIslave_mode1.FIRST_BIT = "LSB";
defparam SingleSPIslave_mode1.CPOL = 0;
defparam SingleSPIslave_mode1.CPHA = 1;
logic [SingleSPIslave_mode1.WIDTH-1:0] tx_data_mode1;
wire [SingleSPIslave_mode1.WIDTH-1:0] rx_data_mode1;
logic mosi_mode1, sck_mode1, cs_mode1;
wire miso_mode1;
SingleSPIslave SingleSPIslave_mode1
(
	.mosi (mosi_mode1), .sck (sck_mode1), .cs (cs_mode1), .miso (miso_mode1),
	.rx_data (rx_data_mode1), .tx_data (tx_data_mode1)
);

//mode 2
defparam SingleSPIslave_mode2.WIDTH = 16;
defparam SingleSPIslave_mode2.FIRST_BIT = "MSB";
defparam SingleSPIslave_mode2.CPOL = 1;
defparam SingleSPIslave_mode2.CPHA = 0;
logic [SingleSPIslave_mode2.WIDTH-1:0] tx_data_mode2;
wire [SingleSPIslave_mode2.WIDTH-1:0] rx_data_mode2;
logic mosi_mode2, sck_mode2, cs_mode2;
wire miso_mode2;
SingleSPIslave SingleSPIslave_mode2
(
	.mosi (mosi_mode2), .sck (sck_mode2), .cs (cs_mode2), .miso (miso_mode2),
	.rx_data (rx_data_mode2), .tx_data (tx_data_mode2)
);

//mode 3
defparam SingleSPIslave_mode3.WIDTH = 32;
defparam SingleSPIslave_mode3.FIRST_BIT = "LSB";
defparam SingleSPIslave_mode3.CPOL = 1;
defparam SingleSPIslave_mode3.CPHA = 1;
logic [SingleSPIslave_mode3.WIDTH-1:0] tx_data_mode3;
wire [SingleSPIslave_mode3.WIDTH-1:0] rx_data_mode3;
logic mosi_mode3, sck_mode3, cs_mode3;
wire miso_mode3;
SingleSPIslave SingleSPIslave_mode3
(
	.mosi (mosi_mode3), .sck (sck_mode3), .cs (cs_mode3), .miso (miso_mode3),
	.rx_data (rx_data_mode3), .tx_data (tx_data_mode3)
);

logic [SingleSPIslave_mode0.WIDTH-1:0] tb_data_mode0;
logic [SingleSPIslave_mode1.WIDTH-1:0] tb_data_mode1;
logic [SingleSPIslave_mode2.WIDTH-1:0] tb_data_mode2;
logic [SingleSPIslave_mode3.WIDTH-1:0] tb_data_mode3;

task tb_spi_mode0_msb (input [SingleSPIslave_mode0.WIDTH-1:0] data);
	begin
		cs_mode0 = 0;
		for(int i=0;i<SingleSPIslave_mode0.WIDTH;i++) begin
			mosi_mode0 = data[SingleSPIslave_mode0.WIDTH-1];
			#100;
			sck_mode0 = 1;			
			#100;
			sck_mode0 = 0;
			data = {data[SingleSPIslave_mode0.WIDTH-2:0],1'b0};
		end
		#100;
		cs_mode0 = 1;
	end
endtask

task tb_spi_mode1_lsb (input [SingleSPIslave_mode1.WIDTH-1:0] data);
	begin
		cs_mode1 = 0;
		for(int i=0;i<SingleSPIslave_mode1.WIDTH;i++) begin			
			#100;
			sck_mode1 = 1;
			mosi_mode1 = data[0];
			#100;
			sck_mode1 = 0;
			data = {1'b0,data[SingleSPIslave_mode1.WIDTH-1:1]};
		end
		#100;
		cs_mode1 = 1;
	end
endtask

task tb_spi_mode2_msb (input [SingleSPIslave_mode2.WIDTH-1:0] data);
	begin
		cs_mode2 = 0;
		for(int i=0;i<SingleSPIslave_mode2.WIDTH;i++) begin
			mosi_mode2 = data[SingleSPIslave_mode2.WIDTH-1];
			#100;
			sck_mode2 = 0;			
			#100;
			sck_mode2 = 1;
			data = {data[SingleSPIslave_mode2.WIDTH-2:0],1'b0};
		end
		#100;
		cs_mode2 = 1;
	end
endtask

task tb_spi_mode3_lsb (input [SingleSPIslave_mode3.WIDTH-1:0] data);
	begin
		cs_mode3 = 0;
		for(int i=0;i<SingleSPIslave_mode3.WIDTH;i++) begin			
			#100;
			sck_mode3 = 0;
			mosi_mode3 = data[0];
			#100;
			sck_mode3 = 1;
			data = {1'b0,data[SingleSPIslave_mode3.WIDTH-1:1]};
		end
		#100;
		cs_mode3 = 1;
	end
endtask

initial begin : process
	{tb_data_mode0,tb_data_mode1,tb_data_mode2,tb_data_mode3} = '0;
	{mosi_mode0,mosi_mode1,mosi_mode2,mosi_mode3} = '0;
	{cs_mode0,cs_mode1,cs_mode2,cs_mode3} = '1;
	{sck_mode0,sck_mode1,sck_mode2,sck_mode3} = 4'b0011;
	#5000;
	tb_data_mode0 = {$random} % (2**(SingleSPIslave_mode0.WIDTH));
	tx_data_mode0 = {$random} % (2**(SingleSPIslave_mode0.WIDTH));
	tb_spi_mode0_msb(tb_data_mode0);
	#5000;
	tb_data_mode1 = {$random} % (2**(SingleSPIslave_mode1.WIDTH));
	tx_data_mode1 = {$random} % (2**(SingleSPIslave_mode1.WIDTH));
	tb_spi_mode1_lsb(tb_data_mode1);
	#5000;
	tb_data_mode2 = {$random} % (2**(SingleSPIslave_mode2.WIDTH));
	tx_data_mode2 = {$random} % (2**(SingleSPIslave_mode2.WIDTH));
	tb_spi_mode2_msb(tb_data_mode2);
	#5000;
	//tb_data_mode3 = {$random} % (2**(SingleSPIslave_mode3.WIDTH));
	tb_data_mode3[15:0] = {$random} % (2**16);
	tb_data_mode3[31:16] = {$random} % (2**16);
	//tx_data_mode3 = {$random} % (2**(SingleSPIslave_mode3.WIDTH));
	tx_data_mode3[15:0] = {$random} % (2**16);
	tx_data_mode3[31:16] = {$random} % (2**16);
	tb_spi_mode3_lsb(tb_data_mode3);
	#5000;
	$stop;$stop;$stop;
end

endmodule