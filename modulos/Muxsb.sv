module Muxsb(
  input [31:0] MSBout,
  input [31:0] MSBALURes,
  input MSBNextPCSrc,
  output reg [31:0] MSBin
);
  
  always@(*) begin
    // Muestra los valores de las entradas y la selección antes de realizar la operación del multiplexor
    $display("----------------MSBNextPCSrc: %b, MSBout: %h, MSBALURes: %h------------", MSBNextPCSrc, MSBout, MSBALURes);

    if (MSBNextPCSrc == 0) begin
      MSBin = MSBout;
      // Muestra el valor de MSBin después de la asignación
      $display("-----No salta------MSBNextPCSrc is 0, MSBin (MSBout) is assigned to: %d-----------", MSBin);
      $display("El posible salto era: %d", MSBALURes);
    end
    if (MSBNextPCSrc == 1) begin
      $display("MSBin antes de asignacion: %b", MSBin);
      MSBin = MSBALURes;
      // Muestra el valor de MSBin después de la asignación
      $display("------Saltó------MSBNextPCSrc is 1, MSBin (MSBALURes) is assigned to: %d----------", MSBin);
      $display("MSBin despues de asignacion: %b", MSBin);
      $display("Sin el salto era: %d", MSBout);
    end
  end
endmodule