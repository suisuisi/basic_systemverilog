`include "/binary_counter/binary_counter.sv"
`include "/binary_to_gray/binary_to_gray.sv"

module gray_ctr
  #(parameter WIDTH=5)
  (input logic clk,                
   input logic reset,
   output logic [WIDTH-1:0] q);    
   
  logic [WIDTH-1:0] counter;
   
  binary_counter #(WIDTH) u_binary_counter (.q(counter), .*);  
   
  binary_to_gray #(WIDTH) u_binary_to_gray (.b_in(counter), .g_out(q));
  
endmodule
