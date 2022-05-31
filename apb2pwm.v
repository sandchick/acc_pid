module apb2pwm(
  input  wire         PCLK,        // APB clock
  input  wire         PRESETn,     // APB reset
  input  wire         PENABLE,     // APB enable
  input  wire         PSEL,        // APB periph select
  input  wire         PWRITE,      // APB write
  input wire [31:0]  PWDATA,      // APB write data
  output wire PREADY,
  output wire PSLVERR,
  output wire pwmenable 
);

assign write_enable = PWRITE & PSEL & (~PENABLE) & (PADDR[11:0] == 12'd0);
assign PSLVERR = 1'b0; //never error
assign PREADY = 1'b1;//always ready

always @(posedge PCLK or negedge PRESETn) begin
  if (~PRESETn)
    pwmenable <= 1'b0;
  else if (write_enablecordic)
    pwmenable <= PWDATA[0];
end


endmodule