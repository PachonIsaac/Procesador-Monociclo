// Code your design here

module DataMemory(
  input [31:0] DMAddresss,
  input [31:0] DMDataWr,
  input DMWr,
  input [2:0] DMCtrl,
  output reg [31:0] DMDataRd
);
  
  logic [7:0] DM [63:0];
  
    initial begin
      $readmemb("dataMemory.txt", DM);
  end
  
  always @(Addresss, DataWr, DMWr, DMCtrl, DataRd) begin
    if(DMWr == 0)begin
      case(DMCtrl)
        3'b000: 
          if(DM[Addresss[7]] == 1)begin
            DataRd[31:8] = 1;
            DataRd[7:0] = DM[Addresss];
          end else begin
            DataRd[31:8] = 0;
            DataRd[7:0] = DM[Addresss];
          end
        3'b001:
          if(DM[Addresss[15]] == 1)begin
            DataRd[31:16] = 1;
            DataRd[15:0] = {DM[Addresss],DM[Addresss+1]};
          end else begin
            DataRd[31:16] = 0;
            DataRd[15:0] = {DM[Addresss],DM[Addresss+1]};
          end
        3'b010: DataRd = {DM[Addresss], DM[Addresss+1], 	       						      DM[Addresss+2], DM[Addresss+3]};
        
        3'b100: 
          begin
            DataRd[31:8] = 0;
            DataRd[7:0]  = DM[Addresss];
          end
        3'b101:
          begin
            DataRd[31:16] = 0;
            DataRd[15:0]  = {DM[Addresss], DM[Addresss+1]};
          end
      endcase
    end else begin
            case(DMCtrl)
              3'b000: DM[Addresss]   <= DataWr[7:0];
              3'b001: 
                begin
                  DM[Addresss]   <= DataWr[7:0];
                  DM[Addresss+1] <= DataWr[15:8];
                end
              3'b010:
                begin
                  DM[Addresss]   <= DataWr[7:0];
                  DM[Addresss+1] <= DataWr[15:8];
                  DM[Addresss+2] <= DataWr[23:16];
                  DM[Addresss+3] <= DataWr[31:23];
                end
            endcase
      //DataRd[7:0] = DM[Addresss];
        end
    end
endmodule
          
            
  