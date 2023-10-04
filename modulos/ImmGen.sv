module ImmGen(
  input [31:0] IMMinst,    // Entrada: campo inmediato de la instrucción
  input [2:0] IMMsrc,   // Entrada: selector de fuente de inmediato
  output reg [31:0] IMMout  // Salida: valor inmediato extendido
);
  
  always@(*) begin
    case(IMMsrc)
      // Imm Tipo I: Extiende un inmediato de tipo I (por ejemplo, inmediato de carga)
      3'b000: 
        begin
          IMMout[11:0]  = IMMinst[24:13];  // Extiende los bits 12-0
          IMMout[31:12] = IMMinst[24];     // Copia el bit 12 para extender signo
        end
      // Imm Tipo S: Extiende un inmediato de tipo S (por ejemplo, inmediato de store)
      3'b001:
        begin
          IMMout[4:0]   = IMMinst[4:0];    // Copia los bits 4-0
          IMMout[11:5]  = IMMinst[24:18];  // Copia los bits 11-5
          IMMout[31:12] = IMMinst[24];     // Copia el bit 12 para extender signo
        end
      // Imm Tipo SB: Extiende un inmediato de tipo SB (por ejemplo, inmediato de branch)
      3'b010:
        begin
          IMMout[12]    = IMMinst[24];     // Copia el bit 12
          IMMout[10:5]  = IMMinst[23:18];  // Copia los bits 10-5
          IMMout[4:1]   = IMMinst[4:1];    // Copia los bits 4-1
          IMMout[11]    = IMMinst[0];      // Copia el bit 0
          IMMout[0]     = 0;            // Extiende con ceros
          IMMout[31:13] = IMMinst[24];     // Copia el bit 12 para extender signo
        end
      // Imm Tipo U: Extiende un inmediato de tipo U (por ejemplo, inmediato upper)
      3'b011:
        begin
          IMMout[31:12] = IMMinst[24:5];   // Extiende los bits 31-12
          IMMout[11:0] = 0;             // Extiende con ceros
        end
      // Imm Tipo UJ: Extiende un inmediato de tipo UJ (por ejemplo, inmediato de jump)
      3'b100:
        begin
          IMMout[20]    = IMMinst[24];     // Copia el bit 20
          IMMout[10:1]  = IMMinst[23:14];  // Copia los bits 10-1
          IMMout[11]    = IMMinst[13];     // Copia el bit 13
          IMMout[19:12] = IMMinst[12:5];   // Copia los bits 19-12
          IMMout[0]     = 0;            // Extiende con ceros
          IMMout[31:21] = IMMinst[24];     // Copia el bit 20 para extender signo
        end
    endcase
  end
endmodule
