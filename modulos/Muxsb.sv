module Muxsb(
  input [31:0] MSBout,
  input [31:0] MSBALURes,
  input MSBNextPCSrc,
  output reg [31:0] MSBin
);
  
  always@(*) begin
    if (MSBNextPCSrc == 0)
      MSBin = MSBout;
    if (MSBNextPCSrc == 1)
      MSBin = MSBALURes;
  end
endmodule