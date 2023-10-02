module Sumador(
  input [31:0] Address,
  output reg [31:0] out
);
  
  always@(*)
    out = Address + 4;
  
endmodule
