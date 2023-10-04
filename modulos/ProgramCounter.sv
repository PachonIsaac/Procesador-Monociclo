module ProgramCounter(
  input clk, 
  input reset,
  input [31:0] PCin,
  input [31:0] IAddress,
  output reg [31:0] PCAddress 
);
  
 always @(posedge clk) begin
    if (reset == 1'b1) 
      // Cuando se activa el reset, establece Address en 0
      PCAddress = IAddress;
    else 
      // En otros casos, actualiza Address con la entrada in
      PCAddress = PCin;
      $display("PCAddress: %d", PCAddress);
  end
  
endmodule