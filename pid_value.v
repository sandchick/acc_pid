module pid_value (
	//system signals
	input		clk						, // 时钟信号
	input		rst_n					, // 复位信号，低电平有效
	input		signed [16:0]	  d_uk	    , // pid增量
	output	    reg signed [16:0]      uk0		  // pid输出值
);
 
reg signed [16:0] uk1 = 17'd0; // 上一时刻u(k-1)的值
 
always @ (d_uk) begin
	uk0 = uk1 + d_uk; // 计算pid输出值
	uk1 = uk0;// 寄存上一时刻 u(k-1)的值    
end
 
endmodule