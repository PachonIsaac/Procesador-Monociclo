module RegistersUnit(
  input [4:0] RUrs1,
  input [4:0] RUrs2,
  input [4:0] RUrd,
  input [31:0] RUDatawr,
  input RUWr,
  input CLK,
  output [31:0] RUoutrs1,
  output [31:0] RUoutrs2
);
  
  logic [31:0] RU [31:0];
  
  initial begin
    $readmemb("registros.txt", RU);
  end
  
  
  assign RUoutrs1 = RU[RUrs1];
  assign RUoutrs2 = RU[RUrs2];
  
  always @(posedge CLK) begin

    if (RUWr == 1 && RUrd != 0)
      RU[RUrd] = RUDatawr;
    else RU[RUrd] = 0;
    $display("Registros aqui ---------------------------------");
    for (int i = 0; i < 10; i = i + 1)
      $display("RU[%d] = %d", i, RU[i]);
  end
  
endmodule