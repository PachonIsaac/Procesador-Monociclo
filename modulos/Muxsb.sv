module Muxsb(
  input [31:0] out,
  input [31:0] ALURes,
  input NextPCSrc,
  output reg [31:0] in
);
  
  always@(*) begin
    if (NextPCSrc == 0)
      in = out;
    if (NextPCSrc == 1)
      in = ALURes;
  end
endmodule