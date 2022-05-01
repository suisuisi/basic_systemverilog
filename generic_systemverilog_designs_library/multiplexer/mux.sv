module mux #(parameter WIDTH = 1, 
             parameter NUMBER = 2, 
             localparam SELECT_W = $clog2(NUMBER)) 
 (input logic [SELECT_W-1:0] sel, 
  input logic [WIDTH-1:0] mux_in [NUMBER-1:0],                   
  output logic [WIDTH-1:0] mux_out);
  
  assign mux_out = mux_in[sel];
    
endmodule    
