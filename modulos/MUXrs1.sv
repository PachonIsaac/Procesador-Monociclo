module Muxrs1(
  input [31:0] MR1Address,
  input [31:0] MR1RUrs1,
  input MR1ALUASrc,
  output reg [31:0] MR1A
);
  
  always@(*) begin
    if (MR1ALUASrc == 0)
      MR1A = MR1RUrs1;
    if (MR1ALUASrc == 1)
      MR1A = MR1Address;
  end
endmodule