module apb2tmu(
  input  wire         PCLK,        // APB clock
  input  wire         PRESETn,     // APB reset
  input  wire         PENABLE,     // APB enable
  input  wire         PSEL,        // APB periph select
  input  wire         PWRITE,      // APB write
  input  wire [31:0]  PADDR,       // APB ADDR
  input  wire [31:0]  PWDATA,      // APB write data
  output wire [31:0]  PRDATA,      // APB read data
  output wire PSLVERR,
  output wire PREADY,
  
  input wire [11:0] data_cordic_in,
  input wire [16:0] data_pid_in,
  output reg [11:0] data_cordic_out,
  output reg [11:0] data_pid_out,
  output wire write_enablecordic,
  output wire write_enablepid,
  output wire [11:0] para,
  output wire [11:0] target,
  output wire [11:0] y

);
reg [31:0] read_mux_word;
wire read_enable;
wire write_enable;
assign PREADY = 1'b1; //always ready
assign PSLVERR = 1'b0; //never error
// Read and write control signals
assign  read_enable  = PSEL & (~PWRITE); // assert for whole APB read transfer
assign  write_enable = PSEL & (~PENABLE) & PWRITE; // assert for 1st cycle of write transfer
assign  write_enablecordic = write_enable & (PADDR[11:2] == 10'h000);
assign  write_enablepid = write_enable & (PADDR[11:2] == 10'h001);
assign  write_enabletarget = wtite_enable & (PADDR[11:2] == 10'h002);
assign  write_enabley = wtite_enable & (PADDR[11:2] == 10'h003);
assign  write_enablepara = wtite_enable & (PADDR[11:2] == 10'h004);
always @(*) begin
   case(PADDR[3:2])
    2'b00: read_mux_word = data_cordic_in;
    2'b01: read_mux_word = data_pid_in;
    default: read_mux_word = {32{1'bx}};
   endcase
end



always @(posedge PCLK or negedge PRESETn) begin
  if (~PRESETn)
    data_cordic_out <= {12{1'b0}};
  else if (write_enablecordic)
    data_cordic_out <= PWDATA[11:0];
end


always @(posedge PCLK or negedge PRESETn) begin
  if (~PRESETn)
    data_pid_out <= {12{1'b0}};
  else if (write_enablepid)
    data_pid_out <= PWDATA[11:0];
end

always @(posedge PCLK or negedge PRESETn) begin
  if (~PRESETn)
    para <= {12{1'b0}};
  else if (write_enablepara)
    para <= PWDATA[11:0];
end

always @(posedge PCLK or negedge PRESETn) begin
  if (~PRESETn)
    target <= {12{1'b0}};
  else if (write_enabletarget)
    target <= PWDATA[11:0];
end

always @(posedge PCLK or negedge PRESETn) begin
  if (~PRESETn)
    y<= {12{1'b0}};
  else if (write_enabley)
    y<= PWDATA[11:0];
end

assign PRDATA = (read_enable) ? read_mux_word : {32{1'b0}};
endmodule