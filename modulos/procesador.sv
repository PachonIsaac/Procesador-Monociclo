`include "./ProgramCounter.sv"
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
`include "decoder.sv"

module procesador(
  input  clk,
  input  reset,
  input [31:0] IAddress
);

  wire [31:0] PCin; // Señal de entrada del PC
  wire [31:0] PCAddresss; // Señal de salida del PC conectada al sumador 
  wire [31:0] SMout; // Señal de salida del sumador
  wire [4:0] CUBrOp; // Señal de salida del ControlUnit
  wire [31:0] IMMout;
  wire [31:0] Mr1A;
  wire [31:0] Mr2B;
  wire [31:0] ALURes; // Señal de salida de la AlU
  wire [6:0] opcode;
  wire [2:0] funct3;
  wire [6:0] funct7;
  wire [4:0] rs1;
  wire [4:0] rs2;
  wire [4:0] rd;
  wire [31:0] PCAddressIn;
  wire [31:0] InmOut;
  wire CURUWr;
  wire [2:0] CUImmSrc;
  wire [31:0] RUoutrs2;
  wire CUALUBSrc;
  wire [31:0] RUoutrs1;
  wire [3:0] CUALUOp;
  wire CUDMWr;
  wire [2:0] CUDMCtrl;
  wire [31:0] DMDataRd;
  wire [1:0] CURUDataWrSrc;
  wire [31:0] MDDatawr;
  wire [31:0] IMMExt;
  wire [24:0] ImmData;

  Sumador miSumador(
    .SMAddress(PCAddress),  // Conexión de la señal 'Address' a la entrada 'Address' del Sumador
    .SMout(SMout)           // Conexión de la señal de salida 'out' del Sumador
  );

  BranchUnit miBranchUnit(
    .BURUrs1(RUoutrs1),          // Conexión del RUrs1 que viene del register file a la entrada 'RUrs1'
    .BURUrs2(RUoutrs2),          // Conexión del RUrs2 que viene del register file a la entrada 'RUrs2'
    .BUBrOp(CUBrOp),            // Conexión del BrOp que viene del control unity a la entrada 'BrOp'
    .BUNextPCSrc(BUNextPCSrc)   // Conexión del NextPCSrc
    );

  Muxsb miMuxsb(
    .MSBout(SMout),          //Conexión de la señal 'out' que viene del sumador a la entrada 'out'
    .MSBALURes(ALURes),    //Conexión de la señal 'ALURes' que viene de la ALU a la entrada 'ALURes'
    .MSBNextPCSrc(BUNextPCSrc), //Conexión de la señal 'NextPCSrc' que viene de miBranchUnit a la entrada 'NextPCSrc'
    .MSBin(PCAddressIn)               //Señal de salida 'in'
    );

  ProgramCounter miProgramCounter(
    .clk(clk),
    .reset(reset), // Conexión de la señal de reset
    .PCin(PCAddressIn),    // Conexión de la señal 'in' al PC
    .IAddress(IAddress),
    .PCAddress(PCAddress) // Conexión de la señal de salida 'Address' del PC);
  );

  
  InstructionMemory miInstructionMemory(
    .IMAddress(PCAddress),        // Conexión de la señal 'Address' del PC a 'Address' de InstructionMemory
    .IMInstruction(InmOut) // Conexión de la señal de salida 'Instruction'
  );

  decoder decoder(
    .instruction(InmOut),
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .imm(ImmData)
  );
  
  ControlUnit miControlUnit(
    .CUOpcode(opcode),         // Conecta Opcode a Opcode
    .CUFunct3(funct3),         // Conecta Funct3 a Funct3
    .CUFunct7(funct7),         // Conecta Funct7 a Funct7
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
    .RUrs1(rs1),          // Conexión de la señal 'rs1' a la entrada 'rs1' del RegistersUnit
    .RUrs2(rs2),          // Conexión de la señal 'rs2' a la entrada 'rs2' del RegistersUnit
    .RUrd(rd),            // Conexión de la señal 'rd' a la entrada 'rd' del RegistersUnit
    .RUDatawr(MDDatawr),    // Conexión de la señal 'Datawr' de miMuxData a la entrada Datawr del registerUnit
    .RUWr(CURUWr),        // Conexión de la señal 'RUWr' del "design" a la entrada 'RUWr' del RegistersUnit
    .CLK(clk),          // Sincronizacion con el clock
    .RUoutrs1(RUoutrs1),      // Conexión de la señal de salida 'RUrs1' del RegistersUnit
    .RUoutrs2(RUoutrs2)       // Conexión de la señal de salida 'RUrs2' del RegistersUnit
  );
  
  ImmGen miImmGen(
    .IMMinst(ImmData),        // Conexión de la señal 'Inst' del Instruction Memory a la entrada 'Inst' del ImmGen
    .IMMsrc(CUImmSrc),    // Conexión de la señal 'ImmSrc' del Control Unit a la entrada 'ImmSrc' del ImmGen
    .IMMout(IMMExt)     // Conexión de la señal de salida 'ImmExt' del ImmGen Inmediato Extendido
  );
  
  Muxrs1 miMuxrs1(
    .MR1Address(PCAddress),  // Conexión de la señal 'Address' a la entrada 'Address' del Muxrs1
    .MR1RUrs1(RUoutrs1),      // Conexión de la señal 'RUrs1' a la entrada 'RUrs1' del Muxrs1
    .MR1ALUASrc(CUALUASrc),  // Conexión de la señal 'ALUASrc' a la entrada 'ALUASrc' del Muxrs1
    .MR1A(Mr1A)               // Conexión de la señal de salida 'A' del Muxrs1
  );
  
  Muxrs2 miMuxrs2(
    .MR2RUrs2(RUoutrs2),      //Conexión de la señal 'RUrs2' a la entrada 'RUrs2' del Muxrs2 
    .MR2ImmExt(IMMExt),    //Conexión de la señal 'ImmExt' que viene de miImmGen a la entrada 'ImmExt'
    .MR2ALUBSrc(CUALUBSrc),  //Conexión de la señal 'ALUBSrc' que viene del ControlUnit a la entrada 'ALUBSrc'
    .MR2B(Mr2B)               //Conexión de la señal de salida 'B'
    );
  
  ALU miALU(                
    .ALUA(Mr1A),              //Conexión de la señal 'A' que viene de miMuxrs1 a la entrada 'A'
    .ALUB(Mr2B),              //Conexión de la señal 'B' que viene de miMuxrs2 a la entrada 'B'
    .ALUOp(CUALUOp),      //Conexión de la señal 'ALUOp' que viene de ControlUnit a la entrada 'ALUOp'
    .ALURes(ALURes)     //Señal de salida 'ALURes'
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

endmodule