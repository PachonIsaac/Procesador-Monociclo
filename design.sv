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
  input logic CLK
);
  
  logic [31:0] ALURes;
  logic [31:0] Instruction;
  
  
  //Salida Program Counter
  logic [31:0] Address;
  
  //Salida Sumador
  logic [31:0] out;
  
  //Salida Instruction Memory
  logic [6:0] Opcode;
  logic [2:0] Funct3;
  logic [6:0] Funct7;
  logic [4:0] rs1;
  logic [4:0] rs2;
  logic [4:0] rd;
  logic [24:0] Inst;
  
  assign Opcode = Instruction[6:0];
  assign Funct3 = Instruction[14:12];
  assign Funct7 = Instruction[31:25];
  assign rs1    = Instruction[19:15];
  assign rs2    = Instruction[24:20];
  assign rd     = Instruction[11:7];
  assign Inst   = Instruction[31:7];
  
  //Salida Control Unit
  logic RUWr;
  logic [2:0] ImmSrc;
  logic ALUASrc;
  logic ALUBSrc;
  logic [4:0] BrOp;
  logic [3:0] ALUOp;
  logic DMWr;
  logic [2:0] DMCtrl;
  logic [1:0] RUDataWrSrc;
  
  //Salida Registers Unit
  logic [31:0] RUrs1;
  logic [31:0] RUrs2;
  logic [31:0] DataWr;
  
  assign DataWr = RUrs2;
  
  //Salida Imm Gen
  logic [31:0] ImmExt;
  
  //Salida Muxrs1
  logic [31:0] A;
  
  //Salida Muxrs2
  logic [31:0] B;
  
  //Salida Branch Unit
  logic NextPCSrc;
  
  //Salida ALU
  logic [31:0] Addresss;
  
  assign Addresss = ALURes;
  
  //Salida Muxsb
  logic [31:0] in;
  
  //Salida Data Memory
  logic [31:0] DataRd;
  
  //Salida MuxData
  logic [31:0] Datawr;
  
  
  ProgramCounter miProgramCounter(
    .CLK(CLK),
    .reset(reset), // Conexión de la señal de reset
    .in(pc_in),    // Conexión de la señal 'in' al PC
    .Address(Address) // Conexión de la señal de salida 'Address' del PC);
  );

  Sumador miSumador(
    .Address(Address),  // Conexión de la señal 'Address' a la entrada 'Address' del Sumador
    .out(out)           // Conexión de la señal de salida 'out' del Sumador
  );
  
  InstructionMemory miInstructionMemory(
    .Address(Address),        // Conexión de la señal 'Address' del PC a 'Address' de InstructionMemory
    .Instruction(Instruction) // Conexión de la señal de salida 'Instruction'
  );
  
  ControlUnit miControlUnit(
    .Opcode(Opcode),         // Conecta Opcode a Opcode
    .Funct3(Funct3),         // Conecta Funct3 a Funct3
    .Funct7(Funct7),         // Conecta Funct7 a Funct7
    .RUWr(RUWr),             // Conecta RUWr a RUWr
    .ImmSrc(ImmSrc),         // Conecta ImmSrc a ImmSrc
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
    .Datawr(Datawr),    // Revisar hay dos DataWr y Datawr
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
    RUrs2, ImmExt, ALUBSrc, B);
  
  BranchUnit miBranchUnit(
    .RUrs1(RUrs1),          // Conexión del RUrs1 que viene del register file a la entrada 'RUrs1'
    .RUrs2(RUrs2),          // Conexión del RUrs2 que viene del register file a la entrada 'RUrs2'
    .BrOp(BrOp),            // Conexión del BrOp que viene del control unity a la entrada 'BrOp'
    .NextPCSrc(NextPCSrc)   // Conexión del NextPCSrc
    );
  
  ALU miALU(
    A, B, ALUOp, ALURes);
  
  Muxsb miMuxsb(
    out, ALURes, NextPCSrc, in);
  
  DataMemory miDataMemory(
    .Addresss(ALURes),      // La señal 'ALUres' que viene de la ALU se conecta a la entrada 'Address'
    .DataWr(RUrs2),         // La señal 'RUrs2' que viene del register file se conecta a la entrada 'DataWr' 
    .DMWr(DMWr),            // La señal 'DMWr' que viene del contro unity se conecta a la entrada 'DMWr'
    .DMCtrl(DMCtrl),        // La señal 'DMCtrl' que viene del control unity se conecta a la entrada 'DMCtrl'
    .DataRd(DataRd)         // La señal de salida 'DataRd' 
  );
  
  MuxData miMuxData(
    out, DataRd, ALURes, RUDataWrSrc, Datawr);
 

endmodule
  
  