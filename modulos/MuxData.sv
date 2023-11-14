module MuxData(
  input [31:0] MDout,
  input [31:0] MDDataRd,
  input [31:0] MDALURes,
  input [1:0]  MDRUDataWrSrc,
  output reg [31:0] MDDatawr
);
  
  always@(*) begin
    if (MDRUDataWrSrc == 2'b10)
      begin
        MDDatawr = MDout;
        $display("MDDatawr = %d", $signed(MDDatawr));
      end
    if (MDRUDataWrSrc == 2'b01)
      MDDatawr = MDDataRd;
    if (MDRUDataWrSrc == 2'b00)
      MDDatawr = MDALURes;
  end
endmodule