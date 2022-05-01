/***********************************************************/
/* Description: Slave SPI - parametrizable                */
/* 		WIDTH - length data                                */
/* 		FIRST_BIT - "MSB" or "LSB"                         */
/*      CPOL, CPHA - mode                                  */
/* Author: Dmitriy Dayneko (Digital Rabbit)                */
/* Version: 1.1                                            */
/* Date: 27.03.2022                                        */
/***********************************************************/
module SingleSPIslave
#(
	parameter WIDTH = 4,
	parameter FIRST_BIT = "MSB",
	parameter CPOL = 0,
	parameter CPHA = 0
)
(
	input mosi,
	input sck,
	input cs,
	output miso,
	output [WIDTH-1:0] rx_data,
	input [WIDTH-1:0] tx_data	
);

function automatic int clogb2 (input int number);
    int calc;
    begin
      for (int i = 0; 2**i < number; i++)
        calc = i + 1;
        clogb2 = (number == 0) ? 0 :
                  (number == 1) ? 1 : calc;
    end
endfunction

function automatic [WIDTH-1:0] funcReverse (input [WIDTH-1:0] in_word);
  int i;
  begin
    for (i=0; i<WIDTH; i=i+1)
      funcReverse[i] = in_word[(WIDTH-1)-i];
  end
endfunction

logic [WIDTH-1:0] tx_shift_reg = '0;
logic [WIDTH-1:0] rx_shift_reg = '0;
wire [WIDTH-1:0] tx_data_;
wire [WIDTH:0] tx_data__;
logic [WIDTH-1:0] rx_data_ = '0;
logic [clogb2(WIDTH):0] cnt = '0;

generate

if (((CPOL == 0)&&(CPHA == 0))|((CPOL == 1)&&(CPHA == 1)))
  begin
    always_ff @ (posedge sck, posedge cs)
	   if (cs) rx_data_ <= rx_shift_reg;
	   else rx_shift_reg <= {rx_shift_reg[WIDTH-2:0],mosi};

	always_ff @ (negedge sck, posedge cs)
		if (cs) cnt <= '0;
		else cnt <= cnt + 1'b1;
  end

if (((CPOL == 1)&&(CPHA == 0))|((CPOL == 0)&&(CPHA == 1)))  
  begin
    always_ff @ (negedge sck, posedge cs)
	   if (cs) rx_data_ <= rx_shift_reg;
	   else rx_shift_reg <= {rx_shift_reg[WIDTH-2:0],mosi};    

	always_ff @ (posedge sck, posedge cs)
		if (cs) cnt <= '0;
		else cnt <= cnt + 1'b1;
  end

endgenerate

generate
  if (FIRST_BIT == "MSB") begin
    assign tx_data_ = funcReverse(tx_data);;
    assign rx_data = rx_data_; end
  if (FIRST_BIT == "LSB") begin
    assign tx_data_ = tx_data;
    assign rx_data = funcReverse(rx_data_); end
endgenerate

generate
	if (CPHA == 0) assign tx_data__ = {1'b0,tx_data_};
	if (CPHA == 1) assign tx_data__ = {tx_data_,1'b0};
endgenerate

assign miso = (cs) ? 1'bz : tx_data__[cnt];

endmodule