module adc_sample(
   input clk,
   input rstn,
   input sample_enable,
   input EOC,
   output reg start,
   output reg OE
);

reg [2:0] current_state, next_state;

parameter   idle = 3'b000,
            start_pullup = 3'b001, 
            convert_on = 3'b011,
            EOC_pullup = 3'b010,
            OE_pullup = 3'b110;

freq_div #(.F_DIV(10)) ufreqdiv(
          .clk     (clk),
          .clk_out (clk_sample)
          );


always @(posedge clk_sample or negedge rstn) begin
   if (rstn == 1'b0 | sample_enable == 1'b0) begin
      current_state <= idle; 
   end
   else begin
       current_state <= next_state;
   end 
end

always @(*) begin
   case(current_state)
   idle:begin
        next_state <= start_pullup;
   end

   start_pullup:begin
        next_state <= convert_on;
   end

   convert_on:begin
    if(EOC == 1'b1)
        next_state <= EOC_pullup;
    else 
        next_state <= convert_on;
   end

   EOC_pullup:begin
 //   if(EOC == 1'b0)
        next_state <= OE_pullup;
    //else 
    //    next_state <= EOC_pullup;
   end

   OE_pullup:begin
        next_state <= idle;
   end

   default:begin
     next_state = idle;
   end
   endcase
end

always @(posedge clk_sample or negedge rstn) begin
    if(rstn == 1'b0 | sample_enable == 1'b0)begin
      start <= 1'b0;
      OE <= 1'b0;end
    else begin
      case(next_state)
        idle:begin
            start <= 1'b0;
            OE <= 1'b0;end 
        start_pullup:begin
            start <= 1'b1;
            OE <= 1'b0;end 
        convert_on:begin
            start <= 1'b0;
            OE <= 1'b0;end
        EOC_pullup:begin
            start <= 1'b0;
            OE <= 1'b0;end
        OE_pullup:begin
            start <= 1'b0;
            OE <= 1'b1;end
        default:begin
            start <= 1'b0;
            OE <= 1'b0;end
      endcase
    end
end 
endmodule