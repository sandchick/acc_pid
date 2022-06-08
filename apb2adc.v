module apb2adc(
  input  wire         PCLK,        // APB clock
  input  wire         PRESETn,     // APB reset
  input  wire         PENABLE,     // APB enable
  input  wire         PSEL,        // APB periph select
  input  wire         PWRITE,      // APB write
  input  wire [31:0]  PADDR,
  input  wire [31:0]  PWDATA,
  output  wire [31:0]  PRDATA,      // APB write data
  output wire PREADY,
  output wire PSLVERR,
  input wire [11:0]  ADC_DATA,
  output reg sample_enable,
  output reg adc2tmu_en
);
reg full;
wire wr_en;
wire read_enable;
wire write_enable;
wire write_enable_sample;
wire write_enable_adc2tmu;

assign read_enable = (~PWRITE) & PSEL;
//assign write_enable = PSEL & (~PENABLE) & PWRITE; 
assign write_enable = PSEL &  PWRITE; 
assign write_enable_sample = write_enable & (PADDR[11:2] == 12'h000);
assign write_enable_adc2tmu = write_enable & (PADDR[11:2] == 12'h001);
assign PSLVERR = 1'b0; //never error
reg [11:0] dout;

always @(posedge PCLK or negedge PRESETn) begin
  if (~PRESETn)
    sample_enable <= 1'b0;
  else if (write_enable_sample)
    sample_enable <= PWDATA[0];
end

always @(posedge PCLK or negedge PRESETn) begin
  if (~PRESETn)
    adc2tmu_en <= 1'b0;
  else if (write_enable_adc2tmu)
    adc2tmu_en <= PWDATA[0];
end

always @(posedge PCLK or negedge PRESETn) begin
    if (PRESETn == 1'b0)begin
      dout <= 0;
      full <= 0;
    end
    else if (wr_en == 1'b1)begin
        if(read_enable == 1'b1)begin
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

assign wr_en = ~full | read_enable;
assign PREADY = 1'b1;
assign PRDATA = dout;


endmodule