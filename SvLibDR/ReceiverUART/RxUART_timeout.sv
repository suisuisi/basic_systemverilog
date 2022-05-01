/***********************************************************/
/* Description: Timeout control for                        */
/*              protocol receiving from UART               */
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

module RxUART_timeout 
#(
	parameter int CLOCK = 10_000_000,
	parameter int BAUD = 1_000_000,
	parameter PARITY = "NO",
	parameter TIMEOUT = 10
)
(

input clk,
input reset,

input rx_done,
input rx_busy,

output logic timeout

);

localparam real factor_real = CLOCK/BAUD;
localparam int factor_int = factor_real;

logic [4:0] rx_done_buf;
wire start_timeout;

always_ff @ (posedge clk, posedge reset)
	if (reset) rx_done_buf <= '0;
	else rx_done_buf <= {rx_done_buf[3:0],rx_done};
assign start_timeout = (!rx_done_buf[4])&(rx_done_buf[3]);

//

logic [clogb2(factor_int)-1:0] len_bit;

wire clr_len_bit = (len_bit == factor_int-1);

always_ff @ (posedge clk, posedge reset)
  if (reset) len_bit <= '1;
  else if (start_timeout | clr_len_bit | rx_busy) len_bit <= '0;
  else len_bit <= len_bit + 1'b1;
  
//  

wire [3:0] num_bit;
logic [3:0] len_byte;

generate
  if (PARITY == "NO") 
	assign num_bit = 4'd10;
  else if ((PARITY == "ODD")|(PARITY == "EVEN")) 
	assign num_bit = 4'd11;
endgenerate
 
wire clr_len_byte = (len_byte == num_bit-1)& (clr_len_bit);

always_ff @ (posedge clk, posedge reset)
  if (reset) len_byte <= '1;
  else if (rx_busy | clr_len_byte) len_byte <= '0;
  else if (clr_len_bit) len_byte <= len_byte + 1'b1;
  
//  

logic [clogb2(TIMEOUT):0] cnt_byte;  

always_ff @ (posedge clk, posedge reset)    
  if (reset) cnt_byte <= '1;
  else if (rx_busy) cnt_byte <= '0;
  else if (clr_len_byte) cnt_byte <= cnt_byte + 1'b1;

//  
  
always_ff @ (posedge clk, posedge reset)
	if (reset) timeout <= 1'b1;
	else if (rx_busy) timeout <= 1'b0;
	else if ((cnt_byte == TIMEOUT-1)&(clr_len_byte)) timeout <= 1'b1;

endmodule