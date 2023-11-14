module InstructionMemory(
  input [31:0] IMAddress,
  output reg [31:0] IMInstruction
);
  
  reg [31:0] direccion;
  
  logic [31:0] IM [1023:0];
  
  
  initial begin
    $readmemb("instructionMemory.txt", IM);
  end
  
  always@(IMAddress, IMInstruction)begin
    direccion = IMAddress/4;
    IMInstruction = IM[direccion];
    $display("Instruccion Memory: %b", IMInstruction);
  end
  
endmodule

