module decoder(
    input [31:0] instruction,

    output [6:0] opcode,
    output [2:0] funct3,
    output [6:0] funct7,
    output [4:0] rs1,
    output [4:0] rs2,
    output [4:0] rd, 
    output [24:0] imm

    );

  reg [6:0] opcode;
  reg [2:0] funct3;
  reg [6:0] funct7;
  reg [4:0] rs1;
  reg [4:0] rs2;
  reg [4:0] rd;
  reg [24:0] imm;

  always @*
    begin
        opcode = instruction[6:0];
        funct3 = instruction[14:12];
        funct7 = instruction[31:25];

        rs1 = instruction[19:15];
        rs2 = instruction[24:20];

        rd = instruction[11:7];

        imm = instruction[31:7];

    end
endmodule