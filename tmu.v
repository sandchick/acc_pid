module tmu(
  input  wire        clk,    // PCLK for timer operation
  input  wire        rstn, // Reset
  input wire [11:0] adc_data1,
  input wire [11:0] adc_data2,
  input wire write_enablecordic,
  input wire write_enablepid,
  output wire [11:0] data_pid,
  output wire [11:0] data_cordic,
  output wire enable_pid,
  output wire enable_cordic
  ); 

always @(posedge clk or negedge rstn) begin
    if (~rstn)
        
end

always @(posedge clk or negedge rstn) begin
    if (~rstn)
    
end

endmodule