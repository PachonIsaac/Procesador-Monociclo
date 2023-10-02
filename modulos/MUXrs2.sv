module Muxrs2(
  input [31:0] RUrs2,
  input [31:0] ImmExt,
  input ALUBSrc,
  output reg [31:0] B
);
  
  always@(*) begin
    if (ALUBSrc == 0)
      B = RUrs2;
    if (ALUBSrc == 1)
      B = ImmExt;
  end
endmodule