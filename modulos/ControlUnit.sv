// Code your design here

module ControlUnit(
  input [6:0] Opcode,
  input [2:0] Funct3,
  input [6:0] Funct7,
  output reg RUWr,
  output reg [2:0] ImmSrc,
  output reg ALUASrc,
  output reg ALUBSrc,
  output reg [4:0] BrOp,
  output reg [3:0] ALUOp,
  output reg DMWr,
  output reg [2:0] DMCtrl,
  output reg [1:0] RUDataWrSrc
);
  
  always@(*)begin
    case(Opcode)
      // Tipo R
      7'b0110011:
        begin
          RUWr       = 1;
          ImmSrc      = 0;
          ALUASrc     = 0;
          ALUBSrc     = 0;
          BrOp        = 5'b10101;
          DMWr        = 0;
          DMCtrl      = 0;
          RUDataWrSrc = 0;
          case(Funct3)
          3'b000:
            case(Funct7)
              7'b0000000:
                ALUOp = 4'b0000; //add
              7'b0100000:
                ALUOp = 4'b1000; //sub
            endcase
          3'b001:
            ALUOp = 4'b0001;	 //sll
          3'b010:
            ALUOp = 4'b0010;	 //slt
          3'b011:
            ALUOp = 4'b0011;     //sltu
          3'b100:
            ALUOp = 4'b0100;     //xor
          3'b101:
            case(Funct7)
              7'b0000000:
                ALUOp = 4'b1101; //srl
              7'b0100000:
                ALUOp = 4'b0101; //sra
            endcase
          3'b110:
            ALUOp = 4'b0110;     //or
          3'b111: 
            ALUOp = 4'b0111;     //and
          endcase
        end
      // Tipo I
      7'b0010011:
        begin
          RUWr        = 1;
          ImmSrc      = 0;
          ALUASrc     = 0;
          ALUBSrc     = 1;
          BrOp        = 5'b10101;
          DMWr        = 0;
          DMCtrl      = 0;
          RUDataWrSrc = 0;
          case(Funct3)
            3'b000:
              ALUOp = 4'b0000; //addi
            3'b001:
              ALUOp = 4'b0001; //slli
            3'b010:
              ALUOp = 4'b0010; //slti
            3'b011:
              ALUOp = 4'b0011; //sltiu
            3'b100:
              ALUOp = 4'b0100; //xori
            3'b101:
              ALUOp = 4'b0101; //srai
            3'b110:
              ALUOp = 4'b0110; //ori
            3'b111:
              ALUOp = 4'b0111; //andi
          endcase
        end
      // Tipo I load
      7'b0000011:
        begin
          RUWr        = 1;
          ImmSrc      = 0;
          ALUASrc     = 0;
          ALUBSrc     = 1;
          BrOp        = 5'b10101;
          ALUOp       = 0;
          DMWr        = 0;
          RUDataWrSrc = 2'b01;
          case(Funct3)
            3'b000:
              DMCtrl = 3'b000; //lb
            3'b001:
              DMCtrl = 3'b001; //lh
            3'b010:
              DMCtrl = 3'b010; //lw
            3'b100:
              DMCtrl = 3'b100; //lbu
            3'b101:
              DMCtrl = 3'b101; //lhu
          endcase
        end
      // Tipo I jalr
      7'b1100111:
        begin
          RUWr    = 0;
          ImmSrc  = 0;
          ALUASrc = 0;
          ALUBSrc = 1;
          BrOp    = 5'b10101;
          ALUOp   = 0;
          DMWr    = 0;
          DMCtrl  = 0;
          RUDataWrSrc = 2'b10;
        end
      //Tipo S B branch 
      7'b1100011:
        begin
          RUWr        = 0;
          ImmSrc      = 3'b010;
          ALUASrc     = 0;
          ALUBSrc     = 1;
          ALUOp       = 0;
          DMWr        = 0;
          DMCtrl      = 0;
          RUDataWrSrc = 0;
          case(Funct3)
            3'b000:
              BrOp = 5'b00000; //beq
            3'b001:
              BrOp = 5'b00001; //bne
            3'b100:
              BrOp = 5'b00100; //blt
            3'b101:
              BrOp = 5'b00101; //bge
            3'b110:
              BrOp = 5'b00110; //bltu
            3'b111:
              BrOp = 5'b00111; //bgeu
          endcase
        end
      // Tipo S B storage
      7'b0100011:
        begin
          RUWr    = 1;
          ImmSrc  = 3'b010;
          ALUASrc = 0;
          ALUBSrc = 1;
          BrOp    = 5'b10101;
          ALUOp   = 0;
          DMWr    = 1;
          RUDataWrSrc = 2'b01;
          case(Funct3)
            3'b000:
              DMCtrl = 3'b000; //sb
            3'b001:
              DMCtrl = 3'b001; //sh
            3'b010:
              DMCtrl = 3'b010; //sw
          endcase
        end
      // Tipo U J jal
      7'b1101111:
        begin
          RUWr    = 1;
          ImmSrc  = 3'b100;
          ALUASrc = 1;
          ALUBSrc = 1;
          BrOp    = 5'b01111;
          ALUOp   = 0;
          DMWr    = 0;
          DMCtrl  = 0;          
          RUDataWrSrc = 2'b10;
        end
      // Tipo U J lui
      7'b0110111:
        begin
          RUWr    = 1;
          ImmSrc  = 3'b011;
          ALUASrc = 1;
          ALUBSrc = 1;
          BrOp    = 5'b10111;
          ALUOp   = 0;
          DMWr    = 0;
          DMCtrl  = 0;          
          RUDataWrSrc = 2'b10;
        end
      // Tipo U J auipc
      7'b0010111:
        begin
          RUWr    = 1;
          ImmSrc  = 3'b011;
          ALUASrc = 1;
          ALUBSrc = 1;
          BrOp    = 5'b10111;
          ALUOp   = 0;
          DMWr    = 0;
          DMCtrl  = 0;          
          RUDataWrSrc = 2'b10;
        end
    endcase
  end
endmodule