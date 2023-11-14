module BranchUnit (
    input [31:0] BURUrs2,
    input [31:0] BURUrs1,
    input [4:0] BUBrOp,
    output reg BUNextPCSrc
);

  always @(*) begin
    case (BUBrOp)
      5'b00000:
      //BURUrs2 == BURUrs1
      if (BURUrs2 == BURUrs1) begin
        BUNextPCSrc = 1;
      end else begin
        BUNextPCSrc = 0;
      end

      5'b00001:
      //BURUrs2 != BURUrs1
      if (BURUrs2 != BURUrs1) begin
        BUNextPCSrc = 1;
      end else begin
        BUNextPCSrc = 0;
      end

      5'b00100:
      //BURUrs2 < BURUrs1
      if (BURUrs1 < BURUrs2) begin
        BUNextPCSrc = 1;
        $display("blt True");
      end else begin
        BUNextPCSrc = 0;
        $display("blt False");
      end

      5'b00101:
      //BURUrs2 >= BURUrs1
      if (BURUrs1 >= BURUrs2) begin
        BUNextPCSrc = 1;
        $display("bge True");
      end else begin
        BUNextPCSrc = 0;
        $display("bge False");
      end

      5'b00110:
      //BURUrs2 < BURUrs1
      if (BURUrs1 < BURUrs2) begin
        BUNextPCSrc = 1;
      end else begin
        BUNextPCSrc = 0;
      end

      5'b00111:
      //BURUrs2 >= BURUrs1
      if (BURUrs1 >= BURUrs2) begin
        BUNextPCSrc = 1;
      end else begin
        BUNextPCSrc = 0;
      end

      5'b01111: BUNextPCSrc = 1;

      5'b10111: BUNextPCSrc = 1;

      5'b10101: BUNextPCSrc = 0;
    endcase
  end
endmodule
