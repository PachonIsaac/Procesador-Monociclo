// Code your design here

module InstructionMemory(
  input [31:0] Address,
  output reg [31:0] Instruction
);
  
  reg [31:0] direccion;
  
  logic [31:0] IM [31:0];
  
  
  initial begin
    $readmemb("instructionMemory.txt", IM);
  end
  
  always@(Address, Instruction)begin
    direccion = Address/4;
    Instruction = IM[direccion];
  end
  
endmodule