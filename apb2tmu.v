module apb2tmu(
  input  wire         PCLK,        // APB clock
  input  wire         PRESETn,     // APB reset
  input  wire         PENABLE,     // APB enable
  input  wire         PSEL,        // APB periph select
  input  wire         PWRITE,      // APB write
  input  wire [31:0]  PWDATA,      // APB write data
  output wire [31:0]  PRDATA,      // APB read data
  output wire PREADY,
  
  input wire [11:0] data_cordic,
  input wire [11:0] data_pid,
  output wire write_enablecordic,

);
reg [31:0] read_mux_byte;
wire read_enable;
wire write_enable;
wire write_enablecordic;
wire write_enablepid;

// Read and write control signals
assign  read_enable  = PSEL & (~PWRITE); // assert for whole APB read transfer
assign  write_enable = PSEL & (~PENABLE) & PWRITE; // assert for 1st cycle of write transfer
assign  write_enablecordic = write_enable & (PADDR[11:2] == 10'h000);
assign  write_enablepid = write_enable & (PADDR[11:2] == 10'h001);

always @(*) begin
   case(PADDR[3:2])
    2'b00: read_mux_word = data_cordic;
    2'b01: read_mux_word = data_pid;
    default: read_mux_word = {32{1'bx}};
   endcase
end

assign PRDATA = (read_enable) ? read_mux_word : {32{1'b0}};
endmodule