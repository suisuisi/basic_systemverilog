module binary_to_gray
  #(parameter WIDTH=4)
  (input  logic [WIDTH-1:0] b_in,
   output logic [WIDTH-1:0] g_out);
  
  always_comb begin
    g_out[WIDTH-1] = b_in[WIDTH-1];
    foreach (g_out[i]) 
      g_out[i-1] = b_in[i]^b_in[i-1]; 
  end
  
endmodule  
