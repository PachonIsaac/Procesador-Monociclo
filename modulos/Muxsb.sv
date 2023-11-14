module Muxsb(
  input [31:0] MSBout,
  input [31:0] MSBALURes,
  input MSBNextPCSrc,
  output reg [31:0] MSBin
);
  
  always@(*) begin
    if (MSBNextPCSrc == 0) begin
      MSBin = MSBout;
    end
    if (MSBNextPCSrc == 1) begin
      MSBin = MSBALURes;
    end
  end
endmodule