module RegistersUnit(
  input [4:0] rs1,
  input [4:0] rs2,
  input [4:0] rd,
  input [31:0] Datawr,
  input RUWr,
  input logic CLK,
  output [31:0] RUrs1,
  output [31:0] RUrs2
);
  
  logic [31:0] RU [31:0];
  
  initial begin
    $readmemb("registros.txt", RU);
  end
  
  
  assign RUrs1 = RU[rs1];
  assign RUrs2 = RU[rs2];
  
  always @(posedge CLK) begin
    if (RUWr == 1 && rd != 0)
      RU[rd] = Datawr;
    else RU[rd] = 0;
  end
  
endmodule