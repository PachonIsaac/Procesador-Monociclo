module decoder (
    input [31:0] instruction,
    output reg [6:0] opcode,
    output reg [2:0] funct3,
    output reg [6:0] funct7,
    output reg [4:0] rs1,
    output reg [4:0] rs2,
    output reg [4:0] rd,
    output reg [24:0] imm
);

  // Decodificar los campos que son comunes en todos los tipos de instrucciones
  always @(*) begin
    opcode = instruction[6:0];
    funct3 = instruction[14:12];
    rd     = instruction[11:7];

    // Decodificar rs1, rs2 y funct7 que son específicos de R-Type
    rs1    = instruction[19:15];
    rs2    = instruction[24:20];
    funct7 = instruction[31:25];

    // Inicializar imm a 0
    imm    = 25'd0;

    // Decidir el formato del inmediato basado en el opcode
    case (opcode)
      // Para I-Type
      7'b0000011, 7'b0010011: begin
        imm[24:13] = instruction[31:20];
      end
      // Para S-Type
      7'b0100011: begin
        imm[11:5] = instruction[31:25];
        imm[4:0]  = instruction[11:7];
      end
      // Para B-Type
      7'b1100011: begin
        imm[12]   = instruction[31];
        imm[11]   = instruction[7];
        imm[10:5] = instruction[30:25];
        imm[4:1]  = instruction[11:8];
        imm[0]    = 0;
      end

      // Para U-Type
      7'b0110111, 7'b0010111: begin
        imm[19:0] = instruction[31:12];
      end
      // Para J-Type
      7'b1101111: begin
        imm[20]  = instruction[31];
        imm[19:12] = instruction[19:12];
        imm[11] = instruction[20];
        imm[10:1] = instruction[30:21];
        imm[0]    = 0;
      end
      // Para R-Type
      7'b0110011: begin
      end
      default: begin
        $display("Invalid opcode = %b", opcode);
        imm = 25'd0;
      end
    endcase
  end

endmodule