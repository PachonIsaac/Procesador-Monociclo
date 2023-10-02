// Code your testbench here
// or browse Examples

module test;
  logic CLK;
  
  Procesador miProcesador(CLK);
  
  parameter PERIODO = 20;
  
  always begin
    CLK = 0;
    #(PERIODO/2);
    CLK = 1;
    #(PERIODO/2);
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(2);
    
    
    #160 $finish;
  end
endmodule