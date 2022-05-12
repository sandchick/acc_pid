module tmu(
  input  wire        clk,    // PCLK for timer operation
  input  wire        rstn, // Reset
  //input wire [11:0] adc_data1,
  //input wire [11:0] adc_data2,
  input wire [11:0] data_pid_in,
  input wire [11:0] data_cordic_in,
  input wire write_enablecordic,
  input wire write_enablepid,
  output wire [11:0] data_pid_out,
  output wire [11:0] data_cordic_out,
  output wire enable_pid,
  output wire enable_cordic
  ); 

wire [11:0] data_pid;
wire [11:0] data_cordic;

assign data_pid = (write_enablepid) ? data_pid_in : {12{1'b0}};
assign data_cordic = (write_enablecordic) ? data_cordic_in : {12{1'b0}};

cordic u_cordic(
     .clk (clk)
    ,.atanin (data_cordic)
    ,.atanout (data_cordic_out)
);
 
//pid u_pid(
//
//);


endmodule