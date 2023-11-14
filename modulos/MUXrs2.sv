module Muxrs2(
  input [31:0] MR2RUrs2,
  input [31:0] MR2ImmExt,
  input MR2ALUBSrc,
  output reg [31:0] MR2B
);
  
  always@(*) begin
    if (MR2ALUBSrc == 0)
      MR2B = MR2RUrs2;
    if (MR2ALUBSrc == 1)
      MR2B = MR2ImmExt;
      $display("MR2B = %h, MR2ALUBSrc = %h", MR2B, MR2ALUBSrc);
  end
endmodule