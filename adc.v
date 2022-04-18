module adc(
    input clk,
    input rstn,
    input real anadata,
    input start,              //开始转换信号
    input OE,                 //输出完成使能
    output EOC,               //转换完成信号
    output reg [11:0] adc_data,
);


endmodule