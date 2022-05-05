module adc2tmu(
    input wire clk,
    input wire rstn,
    input wire [11:0] adc_data1_in,
    input wire [11:0] adc_data2_in,
    output reg [11:0] adc_data1_out,
    output reg [11:0] adc_data2_out 
);
reg [11:0] adc_data1_reg1;
reg [11:0] adc_data1_reg2;
reg [11:0] adc_data2_reg1;
reg [11:0] adc_data2_reg2;

always @(posedge clk) begin
    if (!rstn)begin
      adc_data1_reg1 <= 1'b0;
    end
    else begin
        adc_data1_reg1 <= adc_data1_in;
    end
end

always @(posedge clk) begin
    if (!rstn)begin
      adc_data1_reg2 <= 1'b0;
    end
    else begin
        adc_data1_reg2 <= adc_data1_1;
    end
end

always @(posedge clk) begin
    if (!rstn)begin
      adc_data2_reg1 <= 1'b0;
    end
    else begin
        adc_data2_reg1 <= adc_data2_in;
    end
end

always @(posedge clk) begin
    if (!rstn)begin
      adc_data2_reg2 <= 1'b0;
    end
    else begin
        adc_data2_reg2 <= adc_data2_reg1;
    end
end








endmodule