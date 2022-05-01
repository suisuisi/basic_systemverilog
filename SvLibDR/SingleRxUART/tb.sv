/***********************************************************/
/* Description: TestBench for SingleRxUART.sv              */
/* Author: Dmitriy Dayneko (Digital Rabbit)                */
/* Date: 20.02.2022                                        */
/***********************************************************/
`timescale 1ns/1ns;
module tb;

//tb
parameter real parClock = 10_000_000; // Hz 
localparam realtime parPeriod = 1/parClock * 1_000_000_000;
parameter real parUartSpeed = 1_000_000; // bit/s
localparam realtime length_bit = (1/parUartSpeed) * 1_000_000_000;
logic [7:0] data;

//SingleRxUART
parameter int CLOCK = 10_000_000;	// Hz
parameter int BAUD = 1_000_000;		// Baud
parameter PARITY = "NO";			// "ODD","EVEN","NO"
parameter FIRST_BIT = "LSB";		// "LSB","MSB"
logic clk, reset;
logic rxd;
wire [7:0] rx_data;
wire parity_err, done, busy;

defparam SingleRxUART.CLOCK = CLOCK;
defparam SingleRxUART.BAUD = BAUD;
defparam SingleRxUART.PARITY = PARITY;
defparam SingleRxUART.FIRST_BIT = FIRST_BIT;
SingleRxUART SingleRxUART
(
	.clk (clk), .reset (reset),
	.rxd (rxd),
	.rx_data (rx_data), 
	.parity_err (parity_err), .done (done), .busy (busy)
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
	rxd = 1;
	data = {$random} % (2**8);
	repeat (4) @(posedge clk);
	SendUartByte(data,"LSB",parUartSpeed,"NO");
	repeat (1) #length_bit;
	$stop;$stop;$stop;
end

endmodule