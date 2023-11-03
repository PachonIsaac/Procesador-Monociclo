
module testbench;
  reg clk;
  reg reset;
  reg [31:0] IAddress; 

  procesador dut(
    .clk(clk),
    .reset(reset),
    .IAddress(IAddress)
  );

  always #5 clk = ~clk;
// 
  initial begin
    $dumpfile("procesadorTB.vcd");
    $dumpvars(0, testbench);

    clk = 0;
    reset = 1;
    IAddress = 0;

    #10 reset = 0;

    #80

    $finish;
 end
endmodule
