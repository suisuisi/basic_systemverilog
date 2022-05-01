/***********************************************************/
/* Description: Master SPI - parametrizable                */
/* 		WIDTH - length data                                */
/* 		FIRST_BIT - "MSB" or "LSB"                         */
/*      CPOL, CPHA - mode                                  */
/* Author: Dmitriy Dayneko (Digital Rabbit)                */
/* Version: 1.1                                            */
/* Date: 27.02.2022                                        */
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

module SingleSPImaster
#(
	parameter WIDTH = 4,
	parameter FIRST_BIT = "MSB",
	parameter CPOL = 0,
	parameter CPHA = 0
)
(
	input clk,
	input reset,
	input start,
	input [WIDTH-1:0] tx_data,
	output [WIDTH-1:0] rx_data,
	output mosi,
	output sck,
	output cs,
	input miso,
	output done
);

function automatic [WIDTH-1:0] funcReverse (input [WIDTH-1:0] in_word);
  int i;
  begin
    for (i=0; i<WIDTH; i=i+1)
      funcReverse[i] = in_word[(WIDTH-1)-i];
  end
endfunction

//////////////// DESCRIPTION SIGNALS ////////////////////////

logic [clogb2(WIDTH):0] cnt = '0;
logic cs_pos, cs_neg;
logic [WIDTH-1:0] tx_shift_reg = '0;
logic [WIDTH-1:0] rx_shift_reg = '0;
wire [WIDTH-1:0] tx_data_;
logic [WIDTH-1:0] rx_data_ = '0;

//////////////////////// BODY ///////////////////////////////

assign cs = !((!cs_pos)|(!cs_neg));
assign mosi = (!cs)&(tx_shift_reg[WIDTH-1]);

always_ff @ (posedge clk, posedge reset)
  if (reset) cnt <= '1;
  else if (start) cnt <= '0;
  else if (cnt != '1) cnt <= cnt + 1'b1;

always_ff @ (posedge clk, posedge reset)
  if (reset) cs_pos <= 1'b1;
  else if (start) cs_pos <= 1'b0;
	else if (cnt < WIDTH-1) cs_pos <= 1'b0;
	else cs_pos <= 1'b1;
	   
always @ (negedge clk, posedge reset)	   
  if (reset) cs_neg <= 1'b1;
  else cs_neg <= cs_pos;

generate
  if (FIRST_BIT == "MSB") begin
    assign tx_data_ = tx_data;
    assign rx_data = rx_data_; end
  if (FIRST_BIT == "LSB") begin
    assign tx_data_ = funcReverse(tx_data);
    assign rx_data = funcReverse(rx_data_); end
endgenerate

generate
  
if (CPOL == 0) 
  assign sck = (!clk)&(!cs_pos);
  
if (CPOL == 1)
  assign sck = !((!clk)&(!cs_pos));

if (CPHA == 0) 
  begin
    always_ff @ (posedge clk, posedge reset)
	   if (reset) tx_shift_reg <= '0;
	   else if (start) tx_shift_reg <= tx_data_;
	   else tx_shift_reg <= {tx_shift_reg[WIDTH-2:0],1'b0};
	end
	
if (CPHA == 1)
  begin
    logic start_;
    always_ff @ (posedge clk, posedge reset)	   
      if (reset) start_ <= 1'b0;
      else start_ <= start;
      
    always_ff @ (posedge sck, posedge reset)
	   if (reset) tx_shift_reg <= '0;
	   else if (start_) tx_shift_reg <= tx_data_;
	   else tx_shift_reg <= {tx_shift_reg[WIDTH-2:0],1'b0};
  end

if (((CPOL == 0)&&(CPHA == 0))|((CPOL == 1)&&(CPHA == 1)))
  begin
    always_ff @ (posedge sck, posedge cs)
	   if (cs) rx_data_ <= rx_shift_reg;
	   else rx_shift_reg <= {rx_shift_reg[WIDTH-2:0],miso};
  end

if (((CPOL == 1)&&(CPHA == 0))|((CPOL == 0)&&(CPHA == 1)))  
  begin
    always_ff @ (negedge sck, posedge cs)
	   if (cs) rx_data_ <= rx_shift_reg;
	   else rx_shift_reg <= {rx_shift_reg[WIDTH-2:0],miso};    
  end

endgenerate

assign done = (cnt == WIDTH+1);

endmodule