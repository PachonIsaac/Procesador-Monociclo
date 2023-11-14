module DataMemory (
    input [31:0] DMAddresss,
    input [31:0] DMDataWr,
    input DMWr,
    input [2:0] DMCtrl,
    output reg [31:0] DMDataRd
);

  logic [7:0] DM[63:0];

  initial begin
    $readmemb("dataMemory.txt", DM);
  end

  always @(DMAddresss, DMDataWr, DMWr, DMCtrl, DMDataRd) begin
    if (DMWr == 0) begin
      case (DMCtrl)
        3'b000: begin
          if (DM[DMAddresss[7]] == 1) begin
            DMDataRd[31:8] = 1;
            DMDataRd[7:0]  = DM[DMAddresss+3];
          end else begin
            DMDataRd[31:8] = 0;
            DMDataRd[7:0]  = DM[DMAddresss+3];
          end
        end
        3'b001: begin
          if (DM[DMAddresss[15]] == 1) begin
            DMDataRd[31:16] = 1;
            DMDataRd[15:0]  = {DM[DMAddresss+2], DM[DMAddresss+3]};
          end else begin
            DMDataRd[31:16] = 0;
            DMDataRd[15:0]  = {DM[DMAddresss+2], DM[DMAddresss+3]};
          end
        end
        3'b010: begin
          DMDataRd = {DM[DMAddresss], DM[DMAddresss+1], DM[DMAddresss+2], DM[DMAddresss+3]};
        end

        3'b100: begin
          DMDataRd[31:8] = 0;
          DMDataRd[7:0]  = DM[DMAddresss+3];
        end
        3'b101: begin
          DMDataRd[31:16] = 0;
          DMDataRd[15:0]  = {DM[DMAddresss+2], DM[DMAddresss+3]};
        end
      endcase
    end else begin
      case (DMCtrl)

        3'b000: DM[DMAddresss+3] <= DMDataWr[7:0];
        3'b001: begin
          DM[DMAddresss+2] <= DMDataWr[15:8];
          DM[DMAddresss+3] <= DMDataWr[7:0];
        end
        3'b010: begin
          DM[DMAddresss]   <= DMDataWr[31:24];
          DM[DMAddresss+1] <= DMDataWr[23:16];
          DM[DMAddresss+2] <= DMDataWr[15:8];
          DM[DMAddresss+3] <= DMDataWr[7:0];
        end
      endcase
    end
  end


  always @(*) begin
    $display("Memoria aqui ---------------------------------");
    for (int i = 0; i < 32; i = i + 1) $display("DM[%d] = %b", i, DM[i]);
  end

endmodule
