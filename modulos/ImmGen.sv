module ImmGen (
    input [24:0] IMMinst,  // Entrada: campo inmediato de la instrucción
    input [2:0] IMMsrc,  // Entrada: selector de fuente de inmediato
    output reg [31:0] IMMout  // Salida: valor inmediato extendido
);

  always @(*) begin
    case (IMMsrc)
      // Imm Tipo I: Extiende un inmediato de tipo I (por ejemplo, inmediato de carga)
      3'b000: begin
        IMMout[11:0]  = IMMinst[24:13];
        IMMout[31:12] = {20{IMMinst[24]}}; //cambio agregué los corchetes 2:29 pm 13/11
      end
      // Imm Tipo S: Extiende un inmediato de tipo S (por ejemplo, inmediato de store)
      3'b001: begin
        IMMout[4:0]   = IMMinst[4:0];  // No cambia, es correcto.
        IMMout[11:5]  = IMMinst[11:5]; // Ajustado para coincidir con la salida del decoder.
        IMMout[31:12] = {20{IMMinst[11]}}; // Extiende el signo correctamente.
      end
      // Imm Tipo SB: Extiende un inmediato de tipo SB (por ejemplo, inmediato de branch)
      3'b010: begin
        IMMout[12]    = IMMinst[12];
        IMMout[10:5]  = IMMinst[10:5];
        IMMout[4:1]   = IMMinst[4:1];
        IMMout[11]    = IMMinst[11]; // Ajustado para coincidir con la salida del decoder.
        IMMout[0]     = 0;

        IMMout[31:13] = {19{IMMinst[12]}}; // Extiende el signo correctamente incluyendo el bit [13].
      end
      // Imm Tipo U: Extiende un inmediato de tipo U (por ejemplo, inmediato upper)
      3'b011: begin
        IMMout[31:12] = IMMinst[19:0];
        IMMout[11:0]  = 12'b0;
      end
      // Imm Tipo UJ: Extiende un inmediato de tipo UJ (por ejemplo, inmediato de jump)
      3'b100: begin
        IMMout[20:0]  = IMMinst[20:0];
        IMMout[31:21] = {12{IMMinst[20]}};
      end
    endcase
  end
endmodule