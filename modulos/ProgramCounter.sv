module ProgramCounter(
  input CLK, 
  input reset,
  input [31:0] PCin,
  output reg [31:0] PCAddress = 0
);
  
 always @(posedge CLK or posedge reset) begin
    if (reset) begin
      // Cuando se activa el reset, establece Address en 0
      PCAddress <= 32'b0;
    end else begin
      // En otros casos, actualiza Address con la entrada in
      Address <= PCin;
    end
  end
  
endmodule