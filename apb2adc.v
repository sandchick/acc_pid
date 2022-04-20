module apbtoadc(
  input  wire         PCLK,        // APB clock
  input  wire         PRESETn,     // APB reset
  input  wire         PENABLE,     // APB enable
  input  wire         PSEL,        // APB periph select
  input  wire         PWRITE,      // APB write
  output  wire [31:0]  PRDATA,      // APB write data

  input wire [11:0]  ADC_DATA
);
reg full;
wire wr_en;
wire ready;

assign ready = (~PWRITE) & PSEL & PENABLE;

reg [11:0] dout;

always @(posedge PCLK or negedge PRESETn) begin
    if (PRESETn == 1'b0)begin
      dout <= 0;
      full <= 0;
    end
    else if (wr_en == 1'b1)begin
        if(ready == 1'b1)begin
            full <= 1;
            dout <= ADC_DATA;
        end
        else begin
            full <= 0;
            dout <= dout;
        end
    end
    else begin 
        full <= full;
        dout <= dout;
    end
end

assign wr_en = ~full | ready;
endmodule