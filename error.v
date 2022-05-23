module  error(
	//system signals
	input		clk						, // 时钟信号
	input		rst_n					, // 复位信号，低电平有效
	input		signed [11:0]		target	, // 目标值
	input		signed [11:0]		   y	, // 实际输出值
	output		signed [11:0]		  ek0	, // e(k)
	output		reg	 signed [11:0]		  ek1	, // e(k-1)
	output		reg	 signed [11:0]		  ek2	  // e(k-2)
);
 
assign ek0 = target - y; // 计算e(k)
 
always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin // 初始化误差值
		ek1 <= 12'd0;
		ek2 <= 12'd0;
	end 	
	else begin
		ek1 <= ek0; // 延时一个时钟周期，得到e(k-1)
        ek2 <= ek1; // 再延时一个时钟周期，得到e(k-2) 
	end	   
end
endmodule