/***********************************************************/
/* Description: Logic control for                          */
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

module RxUART_logic 
#( parameter NUMBER = 256 )
(
input clk,
input reset,

input [7:0] rx_data,
input rx_done,
input timeout,

output pck_done,
output logic [7:0] cmd_rx,
output logic [clogb2(NUMBER)-1:0] len_rx,

output [7:0] wr_data,
output [clogb2(NUMBER)-1:0] wr_addr,
output logic wr_clock,
output logic we
);

logic [1:0] shift;
wire clr_addr;
logic [clogb2(NUMBER):0] cnt_byte;

always_ff @ (posedge clk, posedge reset)
  if (reset) shift <= '0;
  else shift <= {shift[0],rx_done};

always_ff @ (posedge clk, posedge reset)
  if (reset) cnt_byte <= '1;
  else if (clr_addr) cnt_byte <= '1;
  else if (rx_done) cnt_byte <= cnt_byte + 1'b1;

logic [7:0] crc_calc;  
wire [clogb2(NUMBER):0] len_buf;
  
always_ff @ (posedge clk, posedge reset)
   if (reset) begin 
    cmd_rx <= '0;
    len_rx <= '0; end
   else begin
    if ((shift[0])&(cnt_byte == 0)) cmd_rx <= rx_data;
    if ((shift[0])&(cnt_byte == 1)) len_rx <= rx_data;
   end

assign len_buf = (|len_rx) ? len_rx : 9'd256;
   
always_ff @ (posedge clk, posedge reset)
  if (reset) crc_calc <= '0;
  else if ((shift[1])&(cnt_byte == 0)) crc_calc <= rx_data;
  else if ((shift[1])&(cnt_byte != 0)) crc_calc <= crc_calc + rx_data;  

assign wr_data = rx_data;
assign wr_addr = cnt_byte - 2;

always_ff @ (posedge clk, posedge reset)
  if (reset) we <= 1'b0;
  else if ((cnt_byte > 1)&(cnt_byte < len_buf + 2)) we <= |shift;
    
always_ff @ (posedge clk, posedge reset)
  if (reset) wr_clock <= 1'b0;
  else wr_clock <= shift[1];
  
assign pck_done = (cnt_byte == len_buf + 2)&(crc_calc == ~rx_data);
assign clr_addr = pck_done | timeout;  
  
endmodule