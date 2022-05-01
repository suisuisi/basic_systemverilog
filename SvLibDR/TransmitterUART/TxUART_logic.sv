/***********************************************************/
/* Description: Logic control for                          */
/*              protocol transmitting to UART              */
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

module TxUART_logic
#(
  parameter int CLOCK = 10_000_000,
  parameter int BAUD = 1_000_000,
  parameter PARITY = "NO",
  parameter NUMBER = 256,
  parameter PAUSE = 0
)
(
input clk,
input reset,

output logic [7:0] tx_data,
output logic tx_start,

input start_pckt,
input [7:0] cmd_tx,
input [clogb2(NUMBER)-1:0] len_tx,

input [7:0] rd_data,
output [clogb2(NUMBER)-1:0] rd_addr,
output logic rd_clock
);

localparam real factor_real = CLOCK/BAUD;
localparam int factor_int = factor_real;

///// STROBs and COUNTER /////

logic [2:0] delay_reg;
wire next_byte;
wire incr_byte, load_byte, start_byte, sum_and_read;
logic [clogb2(NUMBER):0] cnt_byte;

always_ff @ (posedge clk, posedge reset)
  if (reset) delay_reg <= '0;
  else delay_reg <= {delay_reg[1:0],start_pckt | next_byte};
assign incr_byte = delay_reg[2];
assign load_byte = delay_reg[0];
assign start_byte = delay_reg[1];
assign sum_and_read = delay_reg[1];
    
always_ff @ (posedge clk, posedge reset)
	if (reset) cnt_byte <= '1;
	else if (start_pckt) cnt_byte <= '0;
	else if (incr_byte) cnt_byte <= cnt_byte + 1'b1;    

///// BYTEs TRANSMIT /////

logic [7:0] sum_calc;
wire [clogb2(NUMBER):0] num_byte;

assign num_byte = (len_tx == '0) ? NUMBER+2 : len_tx + 2;

always_ff @ (posedge clk, posedge reset)
	if (reset) tx_data <= '0;
	else if ((load_byte)&(cnt_byte == 0)) tx_data <= cmd_tx;
	else if ((load_byte)&(cnt_byte == 1)) tx_data <= len_tx;
	else if ((load_byte)&(cnt_byte < num_byte)) tx_data <= rd_data;
	else if ((load_byte)&(cnt_byte == num_byte)) tx_data <= ~sum_calc;
	
always_ff @ (posedge clk, posedge reset)
	if (reset) tx_start <= 1'b0;
	else if (start_byte) tx_start <= 1'b1;
	else tx_start <= 1'b0;

///// SUM and READ /////

always_ff @ (posedge clk, posedge reset)
	if (reset) sum_calc <= '0;
	else if ((sum_and_read)&(cnt_byte == 0)) sum_calc <= cmd_tx;
	else if ((sum_and_read)&(cnt_byte != 0)) sum_calc <= sum_calc + tx_data;
	  
assign rd_addr = (cnt_byte - 1);
always_ff @ (posedge clk, posedge reset)
	if (reset) rd_clock <= 1'b0;
	else if (sum_and_read) rd_clock <= 1'b1;
	else rd_clock <= 1'b0;	  

///// PAUSE between BYTEs /////

logic [clogb2(factor_int)-1:0] len_bit;
wire cnt_bit_incr;
wire [clogb2(PAUSE)+3:0] num_pause;
logic [clogb2(PAUSE)+3:0] cnt_bit;

always_ff @ (posedge clk, posedge reset)
	if (reset) len_bit <= '0;
	else if (start_pckt | cnt_bit_incr | next_byte) len_bit <= '0;
	else len_bit <= len_bit + 1'b1;
	
assign cnt_bit_incr = (len_bit == factor_int-1);

always_ff @ (posedge clk, posedge reset)
	if (reset) cnt_bit <= '1;
	else if (start_pckt | next_byte) cnt_bit <= '0;
	else if (cnt_bit_incr) cnt_bit <= cnt_bit + 1'b1;

generate
	if (PARITY == "NO") assign num_pause = PAUSE + 9;
	if ((PARITY == "ODD")|(PARITY == "EVEN")) assign num_pause = PAUSE + 10;
endgenerate
	
assign next_byte = (cnt_bit == num_pause)&(cnt_byte <= num_byte)&(cnt_bit_incr);

	endmodule