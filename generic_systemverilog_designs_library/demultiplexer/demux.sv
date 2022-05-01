module demux #(parameter WIDTH = 1, 
               parameter NUMBER = 2, 
               localparam SELECT_W = $clog2(NUMBER)) 
 (input logic [SELECT_W-1:0] sel, 
  input logic [WIDTH-1:0] demux_in,                   
  output logic [WIDTH-1:0] demux_out [NUMBER-1:0]);
  
  assign demux_out[sel] = demux_in;
    
endmodule  
