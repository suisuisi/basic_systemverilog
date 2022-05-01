module binary_counter
  #(parameter WIDTH=4)
  (input  logic clk, 
                reset, 
   output logic [WIDTH-1:0] q);    
  
  always_ff @ (posedge clk or posedge reset) 
    if (reset == 1) q <= 'b0;
    else            q <= q + 1; 
  
endmodule
