module ALU(
  input [31:0] ALUA,
  input [31:0] ALUB,
  input [3:0] ALUOp,
  output reg [31:0] ALURes
);
  
  always @(*) begin
    case(ALUOp)
      4'b0000: ALURes = ALUA + ALUB;
      4'b0001: ALURes = ALUA << ALUB;
      4'b0010: ALURes = ALUA < ALUB;
      4'b0011: ALURes = ALUA < ~ALUB;
      4'b0100: ALURes = ALUA ^ ALUB;
      4'b0101: ALURes = ALUA >> ALUB;
      4'b0110: ALURes = ALUA | ALUB;
      4'b0111: ALURes = ALUA & ALUB;
      4'b1000: ALURes = ALUA - ALUB;
      4'b1101: ALURes = ALUA >>> ALUB;
    endcase
  end
endmodule
  