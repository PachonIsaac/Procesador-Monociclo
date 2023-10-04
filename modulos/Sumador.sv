module Sumador(
  input [31:0] SMAddress,
  output reg[31:0] SMout
);
  
  always@(*) begin
    SMout = SMAddress + 32'h00000004;
  end
  
endmodule
