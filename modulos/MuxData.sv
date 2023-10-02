module MuxData(
  input [31:0] out,
  input [31:0] DataRd,
  input [31:0] ALURes,
  input [1:0]  RUDataWrSrc,
  output reg [31:0] Datawr
);
  
  always@(*) begin
    if (RUDataWrSrc == 2'b10)
      Datawr = out;
    if (RUDataWrSrc == 2'b01)
      Datawr = DataRd;
    if (RUDataWrSrc == 2'b00)
      Datawr = ALURes;
  end
endmodule