module ProgramCounter(
  input logic CLK, reset,
  input [31:0] in,
  output reg [31:0] Address = 0
);
  
 always @(posedge CLK or posedge reset) begin
    if (reset) begin
      // Cuando se activa el reset, establece Address en 0
      Address <= 0;
    end else begin
      // En otros casos, actualiza Address con la entrada in
      Address <= in;
    end
  end
  
endmodule