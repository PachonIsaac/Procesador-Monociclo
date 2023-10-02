// Code your design here

module BranchUnit(
  input [31:0] RUrs2,
  input [31:0] RUrs1,
  input [4:0] BrOp,
  output reg NextPCSrc
);
  
  always@(*) begin
    case(BrOp)
      5'b00000:
        //RUrs2 == RUrs1
        if (RUrs2 == RUrs1)begin
          NextPCSrc = 1;
        end else begin
          NextPCSrc = 0;
        end
      
      5'b00001:
        //RUrs2 != RUrs1
        if (RUrs2 != RUrs1)begin
          NextPCSrc = 1;
        end else begin
          NextPCSrc = 0;
        end
      
      5'b00100:
        //RUrs2 < RUrs1
        if (RUrs2 < RUrs1)begin
          NextPCSrc = 1;
        end else begin
          NextPCSrc = 0;
        end
      
      5'b00101:
        //RUrs2 >= RUrs1
        if (RUrs2 >= RUrs1)begin
          NextPCSrc = 1;
        end else begin
          NextPCSrc = 0;
        end
      
      5'b00110:
        //RUrs2 < RUrs1
        if (RUrs2 < RUrs1)begin
          NextPCSrc = 1;
        end else begin
          NextPCSrc = 0;
        end
      
      5'b00111:
        //RUrs2 >= RUrs1
        if (RUrs2 >= RUrs1)begin
          NextPCSrc = 1;
        end else begin
          NextPCSrc = 0;
        end
      
      5'b01111:
        NextPCSrc = 1;
      
      5'b10111:
        NextPCSrc = 1;
      
      5'b10101:
        NextPCSrc = 0;
    endcase
  end
endmodule