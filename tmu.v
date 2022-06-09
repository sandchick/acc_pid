module tmu(
  input  wire        clk,    // PCLK for timer operation
  input  wire        rstn, // Reset
  input wire [11:0] adc_data1,
  input wire [11:0] adc_data2,
  input wire [11:0] data_pid_in,
  input wire [11:0] data_cordic_in,
  input wire write_enablecordic,
  input wire write_enablepid,
  output wire [16:0] data_pid_out,
  output wire [11:0] data_cordic_out,
  output wire enable_pid,
  output wire enable_cordic,
  input wire [11:0] para,
  input wire [11:0] target
  ); 

reg [11:0] data_pid;
reg [11:0] data_cordic;
reg write_enablecordic_reg;
reg write_enablepid_reg;

always @(posedge clk or negedge rstn ) begin
  if (~rstn)
    write_enablecordic_reg <= 1'b0;
  else 
    write_enablecordic_reg <= write_enablecordic; 
end

always @(posedge clk or negedge rstn ) begin
  if (~rstn)
    data_cordic <= {12{1'b0}};
  else if(write_enablecordic_reg)
    data_cordic <= data_cordic_in; 
end

always @(posedge clk or negedge rstn ) begin
  if (~rstn)
    write_enablepid_reg <= 1'b0;
  else 
    write_enablepid_reg <= write_enablepid; 
end

always @(posedge clk or negedge rstn ) begin
  if (~rstn)
    data_pid <= {12{1'b0}};
  else if(write_enablepid_reg)
    data_pid <= data_pid_in; 
end



reg [11:0] data_cordic_mux;
always @(posedge clk or negedge rstn) begin
 if (~rstn) 
  data_cordic_mux <= {12{1'b0}};
  else if (write_enablecordic_reg)
  data_cordic_mux <= data_cordic;
  else 
  data_cordic_mux <= adc_data1;
end
//assign data_cordic_mux = write_enablecordic_reg ? data_cordic : adc_data1;
//assign data_cordic_mux = adc_data1;
cordic u_cordic(
     .i_clk (clk)
    ,.i_reset (rstn)
    ,.i_ce  (1'b1)
    ,.i_xval  (data_cordic_mux)
    ,.i_yval  (12'd0)
    ,.o_mag   (data_cordic_out)
);
reg [11:0] data_pid_mux; 
always @(posedge clk or negedge rstn) begin
 if (~rstn) 
  data_pid_mux <= {12{1'b0}};
  else if (write_enablecordic_reg)
  data_pid_mux <= data_pid;
  else 
  data_cordic_mux <= adc_data2;
end

pid u_pid(
  .clk (clk)
  ,.rst_n (rstn)
  ,.target (target)
  ,.y (data_pid_mux)
  ,.kp (para[3:0])
  ,.ki (para[7:4])
  ,.kd (para[11:8])
  ,.uk0(data_pid_out)
);


endmodule