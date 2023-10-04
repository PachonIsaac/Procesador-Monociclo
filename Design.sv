`include "modulos/ProgramCounter.sv"
`include "modulos/Sumador.sv"
`include "modulos/InstructionMemory.sv"
`include "modulos/ControlUnit.sv"
`include "modulos/RegistersUnit.sv"
`include "modulos/ImmGen.sv"
`include "modulos/MUXrs1.sv"
`include "modulos/MUXrs2.sv"
`include "modulos/BranchUnit.sv"
`include "modulos/ALU.sv"
`include "modulos/Muxsb.sv"
`include "modulos/DataMemory.sv"
`include "modulos/MuxData.sv" 

module Procesador(
  input wire CLK,
  input wire reset
);

wire [31:0] PCin; // Señal de entrada del PC
wire [31:0] PCAddress; // Señal de salida del sumador
wire [31:0] SMout; // Señal de salida del sumador
wire [31:0] IMInstruction; // Señal de salida del InstructionMemory


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
    .IMAddress(SMAddress),        // Conexión de la señal 'Address' del PC a 'Address' de InstructionMemory
    .IMInstruction(IMInstruction) // Conexión de la señal de salida 'Instruction'
  );
  
  ControlUnit miControlUnit(
    .CUOpcode(Opcode),         // Conecta Opcode a Opcode
    .CUFunct3(Funct3),         // Conecta Funct3 a Funct3
    .CUFunct7(Funct7),         // Conecta Funct7 a Funct7
    .CURUWr(CURUWr),             // Conecta RUWr a RUWr
    .CUImmSrc(CUImmSrc),         // Conecta ImmSrc a ImmSrc
    .ALUASrc(ALUASrc),       // Conecta ALUASrc a ALUASrc
    .ALUBSrc(ALUBSrc),       // Conecta ALUBSrc a ALUBSrc
    .BrOp(BrOp),             // Conecta BrOp a BrOp
    .ALUOp(ALUOp),           // Conecta ALUOp a ALUOp
    .DMWr(DMWr),             // Conecta DMWr a DMWr
    .DMCtrl(DMCtrl),         // Conecta DMCtrl a DMCtrl
    .RUDataWrSrc(RUDataWrSrc) // Conecta RUDataWrSrc a RUDataWrSrc
  );
  
  RegistersUnit miRegistersUnit(
    .rs1(rs1),          // Conexión de la señal 'rs1' a la entrada 'rs1' del RegistersUnit
    .rs2(rs2),          // Conexión de la señal 'rs2' a la entrada 'rs2' del RegistersUnit
    .rd(rd),            // Conexión de la señal 'rd' a la entrada 'rd' del RegistersUnit
    .Datawr(Datawr),    // Conexión de la señal 'Datawr' de miMuxData a la entrada Datawr del registerUnit
    .RUWr(RUWr),        // Conexión de la señal 'RUWr' del "design" a la entrada 'RUWr' del RegistersUnit
    .CLK(CLK),          // Sincronizacion con el clock
    .RUrs1(RUrs1),      // Conexión de la señal de salida 'RUrs1' del RegistersUnit
    .RUrs2(RUrs2)       // Conexión de la señal de salida 'RUrs2' del RegistersUnit
  );
  
  ImmGen miImmGen(
    .Inst(Inst),        // Conexión de la señal 'Inst' del Instruction Memory a la entrada 'Inst' del ImmGen
    .ImmSrc(ImmSrc),    // Conexión de la señal 'ImmSrc' del Control Unit a la entrada 'ImmSrc' del ImmGen
    .ImmExt(ImmExt)     // Conexión de la señal de salida 'ImmExt' del ImmGen
  );
  
  Muxrs1 miMuxrs1(
    .Address(Address),  // Conexión de la señal 'Address' a la entrada 'Address' del Muxrs1
    .RUrs1(RUrs1),      // Conexión de la señal 'RUrs1' a la entrada 'RUrs1' del Muxrs1
    .ALUASrc(ALUASrc),  // Conexión de la señal 'ALUASrc' a la entrada 'ALUASrc' del Muxrs1
    .A(A)               // Conexión de la señal de salida 'A' del Muxrs1
  );
  
  Muxrs2 miMuxrs2(
    .RUrs2(RUrs2),      //Conexión de la señal 'RUrs2' a la entrada 'RUrs2' del Muxrs2 
    .ImmExt(ImmExt),    //Conexión de la señal 'ImmExt' que viene de miImmGen a la entrada 'ImmExt'
    .ALUBSrc(ALUBSrc),  //Conexión de la señal 'ALUBSrc' que viene del ControlUnit a la entrada 'ALUBSrc'
    .B(B)               //Conexión de la señal de salida 'B'
    );
  
  BranchUnit miBranchUnit(
    .RUrs1(RUrs1),          // Conexión del RUrs1 que viene del register file a la entrada 'RUrs1'
    .RUrs2(RUrs2),          // Conexión del RUrs2 que viene del register file a la entrada 'RUrs2'
    .BrOp(BrOp),            // Conexión del BrOp que viene del control unity a la entrada 'BrOp'
    .NextPCSrc(NextPCSrc)   // Conexión del NextPCSrc
    );
  
  ALU miALU(                
    .A(A),              //Conexión de la señal 'A' que viene de miMuxrs1 a la entrada 'A'
    .B(B),              //Conexión de la señal 'B' que viene de miMuxrs2 a la entrada 'B'
    .ALUOp(ALUOp),      //Conexión de la señal 'ALUOp' que viene de ControlUnit a la entrada 'ALUOp'
    .ALURes(ALURes)     //Señal de salida 'ALURes'
    );
  
  Muxsb miMuxsb(
    .out(out),          //Conexión de la señal 'out' que viene del sumador a la entrada 'out'
    .ALURes(ALURes),    //Conexión de la señal 'ALURes' que viene de la ALU a la entrada 'ALURes'
    .NextPCSrc(NextPCSrc), //Conexión de la señal 'NextPCSrc' que viene de miBranchUnit a la entrada 'NextPCSrc'
    .in(in)               //Señal de salida 'in'
    );
  
  DataMemory miDataMemory(
    .Addresss(ALURes),      // La señal 'ALUres' que viene de la ALU se conecta a la entrada 'Address'
    .DataWr(RUrs2),         // La señal 'RUrs2' que viene del register file se conecta a la entrada 'DataWr' 
    .DMWr(DMWr),            // La señal 'DMWr' que viene del contro unity se conecta a la entrada 'DMWr'
    .DMCtrl(DMCtrl),        // La señal 'DMCtrl' que viene del control unity se conecta a la entrada 'DMCtrl'
    .DataRd(DataRd)         // La señal de salida 'DataRd' 
  );
  
  MuxData miMuxData(
    .out(out),              //La señal 'out' que viene del sumador se conecta con la entrada 'out'
    .DataRd(DataRd),        //La señal 'DataRd' que viene del DataMemory se conecta con la entrada 'DataRd'
    .ALURes(ALURes),        //La señal 'ALURes' que viene de la ALU se conecta con la entrada 'ALURes'
    .RUDataWrSrc(RUDataWrSrc), //La señal 'RUDataWrSrc' que viene del ControlUnit se conecta con la entrada 'RUDataWrSrc' 
    .Datawr(Datawr)          //La señal de salida 'Datawr'   
    );
 

endmodule