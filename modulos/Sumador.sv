module Sumador(
  input [31:0] SMAddress,
  output reg [31:0] SMout
);
  
  always@(*)
    SMout = SMAddress + 4;
  
endmodule
