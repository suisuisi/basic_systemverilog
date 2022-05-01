module full_adder
  #(parameter WIDTH = 4)
  (input logic [WIDTH - 1: 0] a, 
                              b, 
   input logic carry_in,
   output logic carry_out,
   output logic [WIDTH - 1: 0] sum);

  assign {carry_out, sum} = a + b + carry_in;

endmodule
