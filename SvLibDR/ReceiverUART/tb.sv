/***********************************************************/
/* Description: TestBench for ReceiverUART.sv              */
/* Author: Dmitriy Dayneko (Digital Rabbit)                */
/* Date: 21.02.2022                                        */
/***********************************************************/
`timescale 1ns/1ns;
module tb;

//tb
parameter real parClock = 10_000_000; // Hz 
localparam realtime parPeriod = 1/parClock * 1_000_000_000;
int length_bit = ReceiverUART.SingleRxUART.factor_int;
int num_to_rxd;
logic [7:0] mem [0:7];

//ReceiverUART
parameter int CLOCK = 10_000_000;	// Hz
parameter int BAUD = 1_000_000;		// Baud
parameter PARITY = "NO";			// "ODD","EVEN","NO"
parameter FIRST_BIT = "LSB";		// "LSB","MSB"
parameter NUMBER = 8;				// 1 ... 256
parameter TIMEOUT = 2;				// words (delay between bytes)
logic clk, reset;
logic rxd;
wire rx_done;
wire [7:0] cmd_rx, len_rx;
wire [7:0] wr_data;
wire [$clog2(NUMBER)-1:0] wr_addr;
wire wr_clock, we;

defparam ReceiverUART.CLOCK = CLOCK;
defparam ReceiverUART.BAUD = BAUD;
defparam ReceiverUART.PARITY = PARITY;
defparam ReceiverUART.FIRST_BIT = FIRST_BIT;
defparam ReceiverUART.NUMBER = NUMBER;
defparam ReceiverUART.TIMEOUT = TIMEOUT;
ReceiverUART ReceiverUART
(
	.clk (clk), .reset (reset),
	.rxd (rxd), .rx_done (rx_done),
	.cmd_rx (cmd_rx), .len_rx (len_rx),
	.wr_data (wr_data), .wr_addr (wr_addr),
	.wr_clock (wr_clock), .we (we)
);

task SendUartByte(input logic [7:0] data, input string first, input real baud, input string parity);
	logic [7:0] shift;  
	realtime takt;
	int num = 8;
	begin
    	$display("Send data = %h",data);
    
    	takt = (1/baud) * 1_000_000_000;
    	shift = data;    
      
    	rxd = 0;
    	#takt;
    
    	if (first == "MSB") for(int i=num; i>0; i--) begin
      		rxd = shift[num-1];
      		#takt;
      		shift = {shift[6:0],1'b1}; end
    	if (first == "LSB") for(int i=0; i<num; i++) begin
      		rxd = shift[0];
      		#takt;
      		shift = {1'b1,shift[7:1]}; end
      
    	if (parity == "ODD") begin rxd = ~(^data); #takt; end
    	else if (parity == "EVEN") begin rxd = (^data); #takt; end  
    
    	rxd = 1;
    	#takt;
        
  	end
endtask

task SendPacket(input [7:0] cmd, len, input int num);
	logic [7:0] temp, sum;
	begin	
		SendUartByte(cmd,"LSB",1_000_000,"NO"); sum = cmd;
		SendUartByte(len,"LSB",1_000_000,"NO"); sum += len;
		for(int i=0; i<num; i++) begin
			temp = {$random} % (2**8);
			SendUartByte(temp,"LSB",1_000_000,"NO");
			sum += temp;
		end
		SendUartByte(~sum,"LSB",1_000_000,"NO");
	end
endtask

always_ff @ (posedge wr_clock)
	if (we) mem[wr_addr] = wr_data;

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
	repeat (4) @(posedge clk);
	SendPacket(8'h53,8'h05,5);
	repeat (length_bit*12) @(posedge clk);
	$stop;$stop;$stop;
end

endmodule