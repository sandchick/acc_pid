module divider #(parameter DW = 8) (
    input clk,
    input rstn,
    input en,

    input wire [DW-1:0] divisor,//除数
    input wire [DW-1:0] dividend,//被除数
    output reg [DW-1:0] quotient,//商
    output reg [DW-1:0] remainder//余数
);
 reg	[DW+DW-1:0]		tempa	;	
 reg	[DW+DW-1:0]		tempb	;	
	integer	i;
	always @(divisor or dividend)begin 
		if(dividend != 0)begin
			tempa = {{DW{1'b0}},divisor};  
			tempb = {dividend,{DW{1'b0}}};  
			for(i = 0;i < DW;i = i + 1)begin
				tempa = {tempa[(DW+DW-2) :0 ],1'b0};
				if(tempa[DW+DW-1:DW] >= dividend)begin
					tempa = tempa - tempb + 1;
				end else begin
					tempa = tempa;
				end
			end
			quotient 	= tempa[DW-1:0];
			remainders 	= tempa[DW+DW-1:DW];
		end
        else begin
			quotient	= {DW{1'b0}};
			remainders	= {DW{1'b0}};
		end
	end
	
endmodule
