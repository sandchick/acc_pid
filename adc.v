module adc #(parameter convert_time = 300)(
    input clk,             //时钟信号
    input rstn,
    input wire [31:0] anadata,
    input start,              //开始转换信号
    input OE,                 //输出完成使能
    output reg EOC,               //转换完成信号
    output reg [11:0] adc_data
);
wire [11:0] data_in;

assign data_in = anadata[31:20];
reg [2:0] current_state, next_state;
parameter   idle = 3'b000,
            start_pullup = 3'b001, 
            convert_on = 3'b011,
            EOC_pullup = 3'b010,
            OE_pullup = 3'b110;
always @(posedge clk or negedge rstn) begin
   if (rstn == 1'b0) begin
      current_state <= idle; 
   end
   else begin
       current_state <= next_state;
   end 
end

reg[32:0]converttime;

always @(*) begin
   case(current_state)
   idle:begin
    if(start == 1'b1)
        next_state <= start_pullup;
    else 
        next_state <= idle;
   end
   start_pullup:begin
    if(start == 1'b0)
        next_state <= convert_on;
    else 
        next_state <= start_pullup;
   end
   convert_on:begin
    if(converttime == convert_time)
        next_state <= EOC_pullup;
    else 
        next_state <= convert_on;
   end
   EOC_pullup:begin
    if(OE == 1'b1)
        next_state <= OE_pullup;
    else 
        next_state <= EOC_pullup;
   end
   OE_pullup:begin
    if(OE == 1'b0)
        next_state <= idle;
    else 
        next_state <= OE_pullup;
   end
   default:begin
     next_state = idle;
   end
   endcase
end

reg flag;

always @(posedge clk or negedge rstn) begin
    if(rstn == 1'b0)begin
      adc_data <= 12'b0;
    end
    else begin
      case(next_state)
        idle:begin EOC <= 1'b1;end 
        start_pullup:begin EOC <= 1'b1;end
        convert_on:begin
            EOC <= 1'b0;
            flag <= 1'b1;end
        EOC_pullup:begin
            EOC <= 1'b1;
            flag <= 1'b0;end
        OE_pullup:begin adc_data <= data_in;end
        default:begin EOC <= 1'b1;end
      endcase
    end
end

always @(posedge clk or negedge rstn) begin
    if(rstn == 1'b0)begin
        converttime <= 32'b0;
    end
    else begin
        if (flag == 1'b1)begin
            if (converttime == convert_time) converttime <= 32'b0;
            else converttime <= converttime + 1;
        end
        else converttime <= 32'b0;
    end
end




endmodule