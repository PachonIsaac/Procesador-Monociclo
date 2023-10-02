module ImmGen(
  input [24:0] Inst,    // Entrada: campo inmediato de la instrucción
  input [2:0] ImmSrc,   // Entrada: selector de fuente de inmediato
  output reg [31:0] ImmExt  // Salida: valor inmediato extendido
);
  
  always@(*) begin
    case(ImmSrc)
      // Imm Tipo I: Extiende un inmediato de tipo I (por ejemplo, inmediato de carga)
      3'b000: 
        begin
          ImmExt[11:0]  = Inst[24:13];  // Extiende los bits 12-0
          ImmExt[31:12] = Inst[24];     // Copia el bit 12 para extender signo
        end
      // Imm Tipo S: Extiende un inmediato de tipo S (por ejemplo, inmediato de store)
      3'b001:
        begin
          ImmExt[4:0]   = Inst[4:0];    // Copia los bits 4-0
          ImmExt[11:5]  = Inst[24:18];  // Copia los bits 11-5
          ImmExt[31:12] = Inst[24];     // Copia el bit 12 para extender signo
        end
      // Imm Tipo SB: Extiende un inmediato de tipo SB (por ejemplo, inmediato de branch)
      3'b010:
        begin
          ImmExt[12]    = Inst[24];     // Copia el bit 12
          ImmExt[10:5]  = Inst[23:18];  // Copia los bits 10-5
          ImmExt[4:1]   = Inst[4:1];    // Copia los bits 4-1
          ImmExt[11]    = Inst[0];      // Copia el bit 0
          ImmExt[0]     = 0;            // Extiende con ceros
          ImmExt[31:13] = Inst[24];     // Copia el bit 12 para extender signo
        end
      // Imm Tipo U: Extiende un inmediato de tipo U (por ejemplo, inmediato upper)
      3'b011:
        begin
          ImmExt[31:12] = Inst[24:5];   // Extiende los bits 31-12
          ImmExt[11:0] = 0;             // Extiende con ceros
        end
      // Imm Tipo UJ: Extiende un inmediato de tipo UJ (por ejemplo, inmediato de jump)
      3'b100:
        begin
          ImmExt[20]    = Inst[24];     // Copia el bit 20
          ImmExt[10:1]  = Inst[23:14];  // Copia los bits 10-1
          ImmExt[11]    = Inst[13];     // Copia el bit 13
          ImmExt[19:12] = Inst[12:5];   // Copia los bits 19-12
          ImmExt[0]     = 0;            // Extiende con ceros
          ImmExt[31:21] = Inst[24];     // Copia el bit 20 para extender signo
        end
    endcase
  end
endmodule
