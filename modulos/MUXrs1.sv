module Muxrs1(
  input [31:0] Address,
  input [31:0] RUrs1,
  input ALUASrc,
  output reg [31:0] A
);
  
  always@(*) begin
    if (ALUASrc == 0)
      A = RUrs1;
    if (ALUASrc == 1)
      A = Address;
  end
endmodule