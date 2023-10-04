`include "ProgramCounter.sv"
`include "Sumador.sv"
`include "InstructionMemory.sv"
`include "ControlUnit.sv"
`include "RegistersUnit.sv"
`include "ImmGen.sv"
`include "MUXrs1.sv"
`include "MUXrs2.sv"
`include "BranchUnit.sv"
`include "ALU.sv"
`include "Muxsb.sv"
`include "DataMemory.sv"
`include "MuxData.sv" 

module Procesador(
  input wire CLK,
  input wire reset
);

wire [31:0] PCin; // Señal de entrada del PC
wire [31:0] PCAddress; // Señal de salida del sumador
wire [31:0] SMout; // Señal de salida del sumador
wire [31:0] IMInstruction; // Señal de salida del InstructionMemory
wire CURUWr; // Señal de salida del ControlUnit
wire [2:0] CUImmSrc; // Señal de salida del ControlUnit
wire CUALUASrc; // Señal de salida del ControlUnit
wire CUALUBSrc; // Señal de salida del ControlUnit
wire [4:0] CUBrOp; // Señal de salida del ControlUnit
wire [3:0] CUALUOp; // Señal de salida del ControlUnit
wire CUDMWr; // Señal de salida del ControlUnit
wire [2:0] CUDMCtrl; // Señal de salida del ControlUnit
wire [1:0] CURUDataWrSrc; // Señal de salida del ControlUnit
wire [31:0] MDDatawr;
wire [31:0] RUoutrs1;
wire [31:0] RUoutrs2;
wire [31:0] IMMout;
wire [31:0] MR1A;
wire [31:0] MR2B;
wire BUNextPCSrc;
wire [31:0] ALURes;
wire [31:0] MSBin;
wire [31:0] DMDataRd;
reg [6:0] Opcode;
reg [2:0] Funct3;
reg [6:0] Funct7;
reg [4:0] Rs1;
reg [4:0] Rs2;
reg [4:0] Rd;

  ProgramCounter miProgramCounter(
    .CLK(CLK),
    .reset(reset), // Conexión de la señal de reset
    .PCin(PCin),    // Conexión de la señal 'in' al PC
    .PCAddress(PCAddress) // Conexión de la señal de salida 'Address' del PC);
  );

  Sumador miSumador(
    .SMAddress(PCAddress),  // Conexión de la señal 'Address' a la entrada 'Address' del Sumador
    .SMout(SMout)           // Conexión de la señal de salida 'out' del Sumador
  );
  
  InstructionMemory miInstructionMemory(
    .IMAddress(PCAddress),        // Conexión de la señal 'Address' del PC a 'Address' de InstructionMemory
    .IMInstruction(IMInstruction) // Conexión de la señal de salida 'Instruction'
  );
  
  ControlUnit miControlUnit(
    .CUOpcode(Opcode),         // Conecta Opcode a Opcode
    .CUFunct3(Funct3),         // Conecta Funct3 a Funct3
    .CUFunct7(Funct7),         // Conecta Funct7 a Funct7
    .CURUWr(CURUWr),             // Conecta RUWr a RUWr
    .CUImmSrc(CUImmSrc),         // Conecta ImmSrc a ImmSrc
    .CUALUASrc(CUALUASrc),       // Conecta ALUASrc a ALUASrc
    .CUALUBSrc(CUALUBSrc),       // Conecta ALUBSrc a ALUBSrc
    .CUBrOp(CUBrOp),             // Conecta BrOp a BrOp
    .CUALUOp(CUALUOp),           // Conecta ALUOp a ALUOp
    .CUDMWr(CUDMWr),             // Conecta DMWr a DMWr
    .CUDMCtrl(CUDMCtrl),         // Conecta DMCtrl a DMCtrl
    .CURUDataWrSrc(CURUDataWrSrc) // Conecta RUDataWrSrc a RUDataWrSrc
  );
  
  RegistersUnit miRegistersUnit(
    .RUrs1(Rs1),          // Conexión de la señal 'rs1' a la entrada 'rs1' del RegistersUnit
    .RUrs2(Rs2),          // Conexión de la señal 'rs2' a la entrada 'rs2' del RegistersUnit
    .RUrd(Rd),            // Conexión de la señal 'rd' a la entrada 'rd' del RegistersUnit
    .RUDatawr(MDDatawr),    // Conexión de la señal 'Datawr' de miMuxData a la entrada Datawr del registerUnit
    .RUWr(CURUWr),        // Conexión de la señal 'RUWr' del "design" a la entrada 'RUWr' del RegistersUnit
    .CLK(CLK),          // Sincronizacion con el clock
    .RUoutrs1(RUoutrs1),      // Conexión de la señal de salida 'RUrs1' del RegistersUnit
    .RUoutrs2(RUoutrs2)       // Conexión de la señal de salida 'RUrs2' del RegistersUnit
  );
  
  ImmGen miImmGen(
    .IMMinst(IMInstruction),        // Conexión de la señal 'Inst' del Instruction Memory a la entrada 'Inst' del ImmGen
    .IMMsrc(CUImmSrc),    // Conexión de la señal 'ImmSrc' del Control Unit a la entrada 'ImmSrc' del ImmGen
    .IMMout(IMMout)     // Conexión de la señal de salida 'ImmExt' del ImmGen
  );
  
  Muxrs1 miMuxrs1(
    .MR1Address(PCAddress),  // Conexión de la señal 'Address' a la entrada 'Address' del Muxrs1
    .MR1RUrs1(RUoutrs1),      // Conexión de la señal 'RUrs1' a la entrada 'RUrs1' del Muxrs1
    .MR1ALUASrc(CUALUASrc),  // Conexión de la señal 'ALUASrc' a la entrada 'ALUASrc' del Muxrs1
    .MR1A(MR1A)               // Conexión de la señal de salida 'A' del Muxrs1
  );
  
  Muxrs2 miMuxrs2(
    .MR2RUrs2(RUoutrs2),      //Conexión de la señal 'RUrs2' a la entrada 'RUrs2' del Muxrs2 
    .MR2ImmExt(IMMout),    //Conexión de la señal 'ImmExt' que viene de miImmGen a la entrada 'ImmExt'
    .MR2ALUBSrc(CUALUBSrc),  //Conexión de la señal 'ALUBSrc' que viene del ControlUnit a la entrada 'ALUBSrc'
    .MR2B(MR2B)               //Conexión de la señal de salida 'B'
    );
  
  BranchUnit miBranchUnit(
    .BURUrs1(RUoutrs1),          // Conexión del RUrs1 que viene del register file a la entrada 'RUrs1'
    .BURUrs2(RUoutrs2),          // Conexión del RUrs2 que viene del register file a la entrada 'RUrs2'
    .BUBrOp(CUBrOp),            // Conexión del BrOp que viene del control unity a la entrada 'BrOp'
    .BUNextPCSrc(BUNextPCSrc)   // Conexión del NextPCSrc
    );
  
  ALU miALU(                
    .ALUA(MR1A),              //Conexión de la señal 'A' que viene de miMuxrs1 a la entrada 'A'
    .ALUB(MR2B),              //Conexión de la señal 'B' que viene de miMuxrs2 a la entrada 'B'
    .ALUOp(CUALUOp),      //Conexión de la señal 'ALUOp' que viene de ControlUnit a la entrada 'ALUOp'
    .ALURes(ALURes)     //Señal de salida 'ALURes'
    );
  
  Muxsb miMuxsb(
    .MSBout(SMout),          //Conexión de la señal 'out' que viene del sumador a la entrada 'out'
    .MSBALURes(ALURes),    //Conexión de la señal 'ALURes' que viene de la ALU a la entrada 'ALURes'
    .MSBNextPCSrc(BUNextPCSrc), //Conexión de la señal 'NextPCSrc' que viene de miBranchUnit a la entrada 'NextPCSrc'
    .MSBin(MSBin)               //Señal de salida 'in'
    );
  
  DataMemory miDataMemory(
    .DMAddresss(ALURes),      // La señal 'ALUres' que viene de la ALU se conecta a la entrada 'Address'
    .DMDataWr(RUoutrs2),         // La señal 'RUrs2' que viene del register file se conecta a la entrada 'DataWr' 
    .DMWr(CUDMWr),            // La señal 'DMWr' que viene del contro unity se conecta a la entrada 'DMWr'
    .DMCtrl(CUDMCtrl),        // La señal 'DMCtrl' que viene del control unity se conecta a la entrada 'DMCtrl'
    .DMDataRd(DMDataRd)         // La señal de salida 'DataRd' 
  );
  
  MuxData miMuxData(
    .MDout(SMout),              //La señal 'out' que viene del sumador se conecta con la entrada 'out'
    .MDDataRd(DMDataRd),        //La señal 'DataRd' que viene del DataMemory se conecta con la entrada 'DataRd'
    .MDALURes(ALURes),        //La señal 'ALURes' que viene de la ALU se conecta con la entrada 'ALURes'
    .MDRUDataWrSrc(CURUDataWrSrc), //La señal 'RUDataWrSrc' que viene del ControlUnit se conecta con la entrada 'RUDataWrSrc' 
    .MDDatawr(MDDatawr)          //La señal de salida 'Datawr'   
    );

    always @(posedge CLK) begin
      Opcode <= IMInstruction[6:0];
      Funct3 <= IMInstruction[14:12];
      Funct7 <= IMInstruction[31:25];
      Rs1 <= IMInstruction[19:15];
      Rs2 <= IMInstruction[24:20];
      Rd <= IMInstruction[11:7];
    end

endmodule