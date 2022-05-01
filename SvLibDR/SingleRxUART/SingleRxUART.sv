/***********************************************************/
/* Description: Receiving 1 byte from UART                 */
/* Author: Dmitriy Dayneko (Digital Rabbit)                */
/* Version: 1.1                                            */
/* Date: 20.02.2022                                        */
/***********************************************************/
module SingleRxUART
#(
	parameter int CLOCK = 10_000_000,
	parameter int BAUD = 1_000_000,
	parameter PARITY = "NO",
	parameter FIRST_BIT = "LSB"
)	  
(
  input clk, reset,
  input rxd,
  output [7:0] rx_data, 
  output logic parity_err, done, busy  
);

///// FUNCTIONS /////

function automatic int clogb2 (input int number);
    int calc;
    begin
      for (int i = 0; 2**i < number; i++)
        calc = i + 1;
        clogb2 = (number == 0) ? 0 :
                  (number == 1) ? 1 : calc;
    end
endfunction

function automatic [7:0] funcReverse8bit (input [7:0] in_word);
  int i;
  begin
    for (i=0; i<8; i=i+1)
      funcReverse8bit[i] = in_word[7-i];
  end
endfunction

///// PARAMETERS /////

localparam real factor_real = CLOCK/BAUD;
localparam int factor_int = factor_real;

///// META /////

reg [2:0] sync_reg;
wire rxd_;

always_ff @ (posedge clk, posedge reset)  
  if (reset) sync_reg[2:0] <= '1;
  else sync_reg[2:0] <= {sync_reg[1:0],rxd};

assign rxd_ = sync_reg[2];

///// LENGTH BIT COUNTER /////

reg [clogb2(factor_int)-1:0] len_bit;
wire bit_mid, bit_full;
wire len_bit_inc;

always_ff @ (posedge clk, posedge reset)
  if (reset) len_bit <= '0;
  else if (bit_full) len_bit <= '0;
  else	if (len_bit_inc) len_bit <= len_bit + 1'b1;
  else len_bit <= '0;

assign len_bit_inc = (busy) | (rxd_ == 1'b0);
assign bit_full = (len_bit == factor_int-1);
assign bit_mid = (len_bit == factor_int/2-1);

///// NUMBER BIT COUNTER /////

reg [3:0] cnt_bit;
wire [3:0] len_word;
wire end_word = (cnt_bit == len_word-1) & (bit_full);

generate
  if (PARITY == "NO")
	assign len_word = 4'd10;
  if ((PARITY == "ODD")|(PARITY == "EVEN"))
	assign len_word = 4'd11;
endgenerate

always_ff @ (posedge clk, posedge reset)
	if (reset) busy <= 1'b0;
	else if (~busy & bit_mid) busy <= 1'b1;
	else if (busy & end_word) busy <= 1'b0;

always_ff @ (posedge clk, posedge reset)
	if (reset) cnt_bit <= '0;
	else if (~busy) cnt_bit <= '0;
	else if (busy & bit_mid) cnt_bit <= cnt_bit + 4'h1;

///// SHIFT DATA /////

reg [9:0] data_buf;
wire [7:0] data;

always_ff @ (posedge clk, posedge reset)
	if (reset) data_buf <= '0;
	else if (busy & bit_mid) data_buf <= {data_buf[8:0],rxd_};	

generate
  if (PARITY == "NO") 
	assign data = data_buf[8:1];
  if ((PARITY == "ODD")|(PARITY == "EVEN")) 
	assign data = data_buf[9:2];
endgenerate	
	
///// DONE DATA /////

wire parity_calc;
reg [7:0] rx_data_;

generate
  if (PARITY == "NO") 
	assign parity_calc = 1'b0;
  if (PARITY == "EVEN") 
	assign parity_calc = (^data_buf[8:0]);
  if (PARITY == "ODD") 
	assign parity_calc = ~(^data_buf[8:0]);
endgenerate

always_ff @ (posedge clk, posedge reset)
  if (reset) begin 
	rx_data_ <= '0;
	done <= 1'b0;
	parity_err <= 1'b0; end 
  else if (busy & end_word) begin 
	rx_data_ <= data;
	parity_err <= parity_calc;
	done <= 1'b1;	end 
  else done <= 1'b0;	

generate
  if (FIRST_BIT == "MSB")
	assign rx_data = rx_data_;
  if (FIRST_BIT == "LSB") 
	assign rx_data = funcReverse8bit(rx_data_);
endgenerate
  
endmodule


