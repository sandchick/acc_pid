module pwm (
   input clk,
   input rstn,
   input pwmenable,
   input EOC,
   output reg start,
   output reg OE
);

reg [2:0] current_state, next_state;

parameter   idle = 3'b000,
            start_pullup = 3'b001, 
            convert_on = 3'b011,
            EOC_pullup = 3'b010,
            OE_pullup = 3'b110,

always @(posedge clk or negedge rstn) begin
   if (rstn == 1'b0 or pwmenable == 1'b1) begin
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
    if(EOC == 1'b0)
        next_state <= OE_pullup;
    else 
        next_state <= EOC_pullup;
   end

   OE_pullup:begin
        next_state <= idle;
   end

   default:begin
     next_state = idle;
   end
end

always @(posedge clk or negedge rstn) begin
    if(rstn == 1'b0 or pwmenable == 1'b1)begin
      start <= 1'b0;
      OE <= 1'b0;
    end
    else begin
      case(next_state)
        idle:begin
          start <= 1'b0;
          OE <= 1'b0;
        end 
        start_pullup:begin
          start <= 1'b1;
          OE <= 1'b0;
        end 
        convert_on:begin
            start <= 1'b0;
            OE <= 1'b0;end
        EOC_pullup:begin
            start <= 1'b0;
            OE <= 1'b0;end
        OE_pull:begin
            start <= 1'b0;
            OE <= 1'b1;end
        default:
            start <= 1'b0;
            OE <= 1'b0;end
      endcase
    end

endmodule