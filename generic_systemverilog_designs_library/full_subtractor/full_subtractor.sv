module full_subtractor
  #(parameter WIDTH = 4)
  (input logic [WIDTH - 1: 0] a, 
                              b, 
   input logic borrow_in,
   output logic borrow_out,
   output logic [WIDTH - 1: 0] result);

assign {borrow_out, result} = a - b - borrow_in;

endmodule
