module ControlUnit(
  input [6:0] CUOpcode,
  input [2:0] CUFunct3,
  input [6:0] CUFunct7,
  output reg CURUWr,
  output reg [2:0] CUImmSrc,
  output reg CUALUASrc,
  output reg CUALUBSrc,
  output reg [4:0] CUBrOp,
  output reg [3:0] CUALUOp,
  output reg CUDMWr,
  output reg [2:0] CUDMCtrl,
  output reg [1:0] CURUDataWrSrc
);
  
  always@(*)begin
    case(CUOpcode)
      // Tipo R
      7'b0110011:
        begin
          CURUWr       = 1;
          CUImmSrc      = 0;
          CUALUASrc     = 0;
          CUALUBSrc     = 0;
          CUBrOp        = 5'b10101;
          CUDMWr        = 0;
          CUDMCtrl      = 0;
          CURUDataWrSrc = 0;
          case(CUFunct3)
          3'b000:
            case(CUFunct7)
              7'b0000000:
                CUALUOp = 4'b0000; //add
              7'b0100000:
                CUALUOp = 4'b1000; //sub
            endcase
          3'b001:
            CUALUOp = 4'b0001;	 //sll
          3'b010:
            CUALUOp = 4'b0010;	 //slt
          3'b011:
            CUALUOp = 4'b0011;     //sltu
          3'b100:
            CUALUOp = 4'b0100;     //xor
          3'b101:
            case(CUFunct7)
              7'b0000000:
                CUALUOp = 4'b1101; //srl
              7'b0100000:
                CUALUOp = 4'b0101; //sra
            endcase
          3'b110:
            CUALUOp = 4'b0110;     //or
          3'b111: 
            CUALUOp = 4'b0111;     //and
          endcase
        end
      // Tipo I
      7'b0010011:
        begin
          CURUWr        = 1;
          CUImmSrc      = 0;
          CUALUASrc     = 0;
          CUALUBSrc     = 1;
          CUBrOp        = 5'b10101;
          CUDMWr        = 0;
          CUDMCtrl      = 0;
          CURUDataWrSrc = 0;
          case(CUFunct3)
            3'b000:
              CUALUOp = 4'b0000; //addi
            3'b001:
              CUALUOp = 4'b0001; //slli
            3'b010:
              CUALUOp = 4'b0010; //slti
            3'b011:
              CUALUOp = 4'b0011; //sltiu
            3'b100:
              CUALUOp = 4'b0100; //xori
            3'b101:
              CUALUOp = 4'b0101; //srai
            3'b110:
              CUALUOp = 4'b0110; //ori
            3'b111:
              CUALUOp = 4'b0111; //andi
          endcase
        end
      // Tipo I load
      7'b0000011:
        begin
          CURUWr        = 1;
          CUImmSrc      = 0;
          CUALUASrc     = 0;
          CUALUBSrc     = 1;
          CUBrOp        = 5'b10101;
          CUALUOp       = 0;
          CUDMWr        = 0;
          CURUDataWrSrc = 2'b01;
          case(CUFunct3)
            3'b000:
              CUDMCtrl = 3'b000; //lb
            3'b001:
              CUDMCtrl = 3'b001; //lh
            3'b010:
              CUDMCtrl = 3'b010; //lw
            3'b100:
              CUDMCtrl = 3'b100; //lbu
            3'b101:
              CUDMCtrl = 3'b101; //lhu
          endcase
        end
      // Tipo I jalr
      7'b1100111:
        begin
          CURUWr    = 0;
          CUImmSrc  = 0;
          CUALUASrc = 0;
          CUALUBSrc = 1;
          CUBrOp    = 5'b10101;
          CUALUOp   = 0;
          CUDMWr    = 0;
          CUDMCtrl  = 0;
          CURUDataWrSrc = 2'b10;
        end
      //Tipo S B branch 
      7'b1100011:
        begin
          CURUWr        = 0;
          CUImmSrc      = 3'b010;
          CUALUASrc     = 0;
          CUALUBSrc     = 1;
          CUALUOp       = 0;
          CUDMWr        = 0;
          CUDMCtrl      = 0;
          CURUDataWrSrc = 0;
          case(CUFunct3)
            3'b000:
              CUBrOp = 5'b00000; //beq
            3'b001:
              CUBrOp = 5'b00001; //bne
            3'b100:
              CUBrOp = 5'b00100; //blt
            3'b101:
              CUBrOp = 5'b00101; //bge
            3'b110:
              CUBrOp = 5'b00110; //bltu
            3'b111:
              CUBrOp = 5'b00111; //bgeu
          endcase
        end
      // Tipo S B storage
      7'b0100011:
        begin
          CURUWr    = 1;
          CUImmSrc  = 3'b010;
          CUALUASrc = 0;
          CUALUBSrc = 1;
          CUBrOp    = 5'b10101;
          CUALUOp   = 0;
          CUDMWr    = 1;
          CURUDataWrSrc = 2'b01;
          case(CUFunct3)
            3'b000:
              CUDMCtrl = 3'b000; //sb
            3'b001:
              CUDMCtrl = 3'b001; //sh
            3'b010:
              CUDMCtrl = 3'b010; //sw
          endcase
        end
      // Tipo U J jal
      7'b1101111:
        begin
          CURUWr    = 1;
          CUImmSrc  = 3'b100;
          CUALUASrc = 1;
          CUALUBSrc = 1;
          CUBrOp    = 5'b01111;
          CUALUOp   = 0;
          CUDMWr    = 0;
          CUDMCtrl  = 0;          
          CURUDataWrSrc = 2'b10;
        end
      // Tipo U J lui
      7'b0110111:
        begin
          CURUWr    = 1;
          CUImmSrc  = 3'b011;
          CUALUASrc = 1;
          CUALUBSrc = 1;
          CUBrOp    = 5'b10111;
          CUALUOp   = 0;
          CUDMWr    = 0;
          CUDMCtrl  = 0;          
          CURUDataWrSrc = 2'b10;
        end
      // Tipo U J auipc
      7'b0010111:
        begin
          CURUWr    = 1;
          CUImmSrc  = 3'b011;
          CUALUASrc = 1;
          CUALUBSrc = 1;
          CUBrOp    = 5'b10111;
          CUALUOp   = 0;
          CUDMWr    = 0;
          CUDMCtrl  = 0;          
          CURUDataWrSrc = 2'b10;
        end
    endcase
  end
endmodule