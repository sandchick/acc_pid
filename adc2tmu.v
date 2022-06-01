module adc2tmu(
    input wire clk,
    input wire rstn,
    input wire adc2tmu_en,
    input wire [11:0] adc_data_in,
    output reg [11:0] adc_data_out
);

reg [11:0] adc_data_reg1;
reg [11:0] adc_data_reg2;

always @(posedge clk or negedge rstn) begin
    if (!rstn or !adc2tmu_en)begin
      adc_data_reg1 <= 1'b0;
    end
    else begin
        adc_data_reg1 <= adc_data_in;
    end
end

always @(posedge clk or negedge rstn) begin
    if (!rstn or !adc2tmu_en)begin
      adc_data_reg2 <= 1'b0;
    end
    else begin
        adc_data_reg2 <= adc_data_reg1;
    end
end
endmodule