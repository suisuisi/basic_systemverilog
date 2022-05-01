// Copyright 2009 Altera Corporation. All rights reserved.  
// Altera products are protected under numerous U.S. and foreign patents, 
// maskwork rights, copyrights and other intellectual property laws.  
//
// This reference design file, and your use thereof, is subject to and governed
// by the terms and conditions of the applicable Altera Reference Design 
// License Agreement (either as signed by you or found at www.altera.com).  By
// using this reference design file, you indicate your acceptance of such terms
// and conditions between you and Altera Corporation.  In the event that you do
// not agree with such terms and conditions, you may not use the reference 
// design file and please promptly destroy any copies you have made.
//
// This reference design file is being provided on an "as-is" basis and as an 
// accommodation and therefore all warranties, representations or guarantees of 
// any kind (whether express, implied or statutory) including, without 
// limitation, warranties of merchantability, non-infringement, or fitness for
// a particular purpose, are specifically disclaimed.  By making this reference
// design file available, Altera expressly does not recommend, suggest or 
// require that this reference design file be used in combination with any 
// other product not provided by Altera.
/////////////////////////////////////////////////////////////////////////////

// baeckler - 03-28-2008

module gearbox_40_67 (
	input clk,arst,
	input slip_to_frame,
	input [39:0] din,
	output reg [66:0] dout,
	output reg dout_valid
);

// input reg
reg [39:0] din_r;
always @(posedge clk or posedge arst) begin
	if (arst) din_r <= 0;
	else din_r <= din;
end

// decide when to use the slip permission
// when the framing is wrong, and I haven't slipped in a few cycles
reg [2:0] prev_slip;
wire slip_now = prev_slip[0];

always @(posedge clk or posedge arst) begin
	if (arst) begin
		prev_slip <= 0;
	end
	else begin
		prev_slip <= {prev_slip[1:0],1'b0};
		if (slip_to_frame) begin
			if (dout_valid & ~^dout[65:64]) begin
				// the framing is wrong, and I have a slip permit
				if (~|prev_slip) prev_slip[0] <= 1'b1;				
			end
		end
	end
end

// where are we in the schedule?
// to slip just fail to advance the phase once
reg [6:0] phase;
always @(posedge clk or posedge arst) begin
	if (arst) phase <= 0;
	else begin
		if (!slip_now) begin
			if (phase == 66) phase <= 0;
			else phase <= phase + 1'b1;
		end
	end
end

// shift the input word left 0..13 inclusive to enter storage
// at the right place
reg [52:0] positioned_data;
reg [3:0] dshift /* synthesis preserve */;
always @(posedge clk or posedge arst) begin
	if (arst) positioned_data <= 0;
	else positioned_data <= din_r << dshift;
end

// on every tick shift storage left by one of a couple of distance
// choices, and merge in the positioned data
reg [105:0] storage;
reg [1:0] sshift /* synthesis preserve */;
always @(posedge clk or posedge arst) begin
	if (arst) storage <= 0;
	else begin
		case (sshift) 
			2'b00 : storage <= (storage << 33) | positioned_data;
			2'b01 : storage <= (storage << 34) | positioned_data;
			2'b10 : storage <= (storage << 40) | positioned_data;
			2'b11 : storage <= (storage << 47) | positioned_data;
		endcase
	end
end

// extract an output word from one of a couple of choices
reg [1:0] epoint /* synthesis preserve */;
always @(posedge clk or posedge arst) begin
	if (arst) begin
		dout <= 0;
		dout_valid <= 0;
	end
	else begin
		case (epoint) 
			2'b00: begin
				dout_valid <= 1'b0;
				dout <= 0;
			end
			2'b01: begin
				dout_valid <= 1'b1;
				dout <= storage [78:78-66];
			end
			2'b10: begin
				dout_valid <= 1'b1;
				dout <= storage [92:92-66];
			end
			2'b11: begin
				dout_valid <= 1'b1;
				dout <= storage [105:105-66];
			end
		endcase
	end
end

// The schedule - expected to map into one 6LUT per output bit
// if it goes to ROM be sure to suppress
reg [3:0] ds /* synthesis preserve */;
reg [3:0] dsalt;
reg [1:0] ss,ep /* synthesis preserve */;
reg [1:0] ssalt,epalt;
always @(posedge clk or posedge arst) begin
	if (arst) begin
		ds <= 0;
		dsalt <= 0;
		ss <= 0;
		ssalt <= 0;
		ep <= 0;
		epalt <= 0;
	end
	else begin
		case (phase[5:0])
			6'h00 : begin  ds <= 4'hd; ss <= 2'h3;  ep <= 2'h1;  end
			6'h01 : begin  ds <= 4'hd; ss <= 2'h3;  ep <= 2'h0;  end
			6'h02 : begin  ds <= 4'hd; ss <= 2'h2;  ep <= 2'h2;  end
			6'h03 : begin  ds <= 4'h7; ss <= 2'h2;  ep <= 2'h0;  end
			6'h04 : begin  ds <= 4'h0; ss <= 2'h1;  ep <= 2'h3;  end
			6'h05 : begin  ds <= 4'h0; ss <= 2'h0;  ep <= 2'h0;  end
			6'h06 : begin  ds <= 4'h7; ss <= 2'h2;  ep <= 2'h3;  end
			6'h07 : begin  ds <= 4'h1; ss <= 2'h3;  ep <= 2'h1;  end
			6'h08 : begin  ds <= 4'h8; ss <= 2'h1;  ep <= 2'h0;  end
			6'h09 : begin  ds <= 4'h1; ss <= 2'h3;  ep <= 2'h2;  end
			6'h0a : begin  ds <= 4'h1; ss <= 2'h0;  ep <= 2'h0;  end
			6'h0b : begin  ds <= 4'h8; ss <= 2'h2;  ep <= 2'h3;  end
			6'h0c : begin  ds <= 4'h2; ss <= 2'h3;  ep <= 2'h1;  end
			6'h0d : begin  ds <= 4'h9; ss <= 2'h1;  ep <= 2'h0;  end
			6'h0e : begin  ds <= 4'h2; ss <= 2'h3;  ep <= 2'h2;  end
			6'h0f : begin  ds <= 4'h2; ss <= 2'h0;  ep <= 2'h0;  end
			6'h10 : begin  ds <= 4'h9; ss <= 2'h2;  ep <= 2'h3;  end
			6'h11 : begin  ds <= 4'h3; ss <= 2'h3;  ep <= 2'h1;  end
			6'h12 : begin  ds <= 4'ha; ss <= 2'h1;  ep <= 2'h0;  end
			6'h13 : begin  ds <= 4'h3; ss <= 2'h3;  ep <= 2'h2;  end
			6'h14 : begin  ds <= 4'h3; ss <= 2'h0;  ep <= 2'h0;  end
			6'h15 : begin  ds <= 4'ha; ss <= 2'h2;  ep <= 2'h3;  end
			6'h16 : begin  ds <= 4'h4; ss <= 2'h3;  ep <= 2'h1;  end
			6'h17 : begin  ds <= 4'hb; ss <= 2'h1;  ep <= 2'h0;  end
			6'h18 : begin  ds <= 4'h4; ss <= 2'h3;  ep <= 2'h2;  end
			6'h19 : begin  ds <= 4'h4; ss <= 2'h0;  ep <= 2'h0;  end
			6'h1a : begin  ds <= 4'hb; ss <= 2'h2;  ep <= 2'h3;  end
			6'h1b : begin  ds <= 4'h5; ss <= 2'h3;  ep <= 2'h1;  end
			6'h1c : begin  ds <= 4'hc; ss <= 2'h1;  ep <= 2'h0;  end
			6'h1d : begin  ds <= 4'h5; ss <= 2'h3;  ep <= 2'h2;  end
			6'h1e : begin  ds <= 4'h5; ss <= 2'h0;  ep <= 2'h0;  end
			6'h1f : begin  ds <= 4'hc; ss <= 2'h2;  ep <= 2'h3;  end
			6'h20 : begin  ds <= 4'h6; ss <= 2'h3;  ep <= 2'h1;  end
			6'h21 : begin  ds <= 4'hd; ss <= 2'h1;  ep <= 2'h0;  end
			6'h22 : begin  ds <= 4'h6; ss <= 2'h3;  ep <= 2'h2;  end
			6'h23 : begin  ds <= 4'h6; ss <= 2'h0;  ep <= 2'h0;  end
			6'h24 : begin  ds <= 4'hd; ss <= 2'h2;  ep <= 2'h3;  end
			6'h25 : begin  ds <= 4'h7; ss <= 2'h3;  ep <= 2'h1;  end
			6'h26 : begin  ds <= 4'h7; ss <= 2'h1;  ep <= 2'h0;  end
			6'h27 : begin  ds <= 4'h7; ss <= 2'h2;  ep <= 2'h2;  end
			6'h28 : begin  ds <= 4'h7; ss <= 2'h2;  ep <= 2'h0;  end
			6'h29 : begin  ds <= 4'h1; ss <= 2'h2;  ep <= 2'h3;  end
			6'h2a : begin  ds <= 4'h8; ss <= 2'h1;  ep <= 2'h1;  end
			6'h2b : begin  ds <= 4'h8; ss <= 2'h3;  ep <= 2'h0;  end
			6'h2c : begin  ds <= 4'h8; ss <= 2'h2;  ep <= 2'h2;  end
			6'h2d : begin  ds <= 4'h8; ss <= 2'h2;  ep <= 2'h0;  end
			6'h2e : begin  ds <= 4'h2; ss <= 2'h2;  ep <= 2'h3;  end
			6'h2f : begin  ds <= 4'h9; ss <= 2'h1;  ep <= 2'h1;  end
			6'h30 : begin  ds <= 4'h9; ss <= 2'h3;  ep <= 2'h0;  end
			6'h31 : begin  ds <= 4'h9; ss <= 2'h2;  ep <= 2'h2;  end
			6'h32 : begin  ds <= 4'h9; ss <= 2'h2;  ep <= 2'h0;  end
			6'h33 : begin  ds <= 4'h3; ss <= 2'h2;  ep <= 2'h3;  end
			6'h34 : begin  ds <= 4'ha; ss <= 2'h1;  ep <= 2'h1;  end
			6'h35 : begin  ds <= 4'ha; ss <= 2'h3;  ep <= 2'h0;  end
			6'h36 : begin  ds <= 4'ha; ss <= 2'h2;  ep <= 2'h2;  end
			6'h37 : begin  ds <= 4'ha; ss <= 2'h2;  ep <= 2'h0;  end
			6'h38 : begin  ds <= 4'h4; ss <= 2'h2;  ep <= 2'h3;  end
			6'h39 : begin  ds <= 4'hb; ss <= 2'h1;  ep <= 2'h1;  end
			6'h3a : begin  ds <= 4'hb; ss <= 2'h3;  ep <= 2'h0;  end
			6'h3b : begin  ds <= 4'hb; ss <= 2'h2;  ep <= 2'h2;  end
			6'h3c : begin  ds <= 4'hb; ss <= 2'h2;  ep <= 2'h0;  end
			6'h3d : begin  ds <= 4'h5; ss <= 2'h2;  ep <= 2'h3;  end
			6'h3e : begin  ds <= 4'hc; ss <= 2'h1;  ep <= 2'h1;  end
			6'h3f : begin  ds <= 4'hc; ss <= 2'h3;  ep <= 2'h0;  end
		endcase
		
		case (phase[1:0])
			2'h0 : begin  dsalt <= 4'hc; ssalt <= 2'h2;  epalt <= 2'h2;  end
			2'h1 : begin  dsalt <= 4'hc; ssalt <= 2'h2;  epalt <= 2'h0;  end
			2'h2 : begin  dsalt <= 4'h6; ssalt <= 2'h2;  epalt <= 2'h3;  end
			
			// this one is actually don't care
			// selected to minimize
			2'h3 : begin  dsalt <= 4'h6; ssalt <= 2'h2;  epalt <= 2'h3;  end			
		endcase
	end
end		

// phase 64,5,6 use the alternate schedule
reg use_alt;
always @(posedge clk or posedge arst) begin
	if (arst) begin
		sshift <= 0;
		dshift <= 0;
		epoint <= 0;
		use_alt <= 0;
	end
	else begin
		sshift <= use_alt ? ssalt : ss;
		dshift <= use_alt ? dsalt : ds;
		epoint <= use_alt ? epalt : ep;
		use_alt <= phase[6];		
	end
end

endmodule