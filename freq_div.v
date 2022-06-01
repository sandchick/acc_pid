module freq_div(
    input clk,
    output wire clk_out
    );
parameter F_DIV = 48000000;
parameter F_DIV_WIDTH = 32;

reg clk_p_r; //rising edge output
reg clk_n_r; //falling edge output
reg[F_DIV_WIDTH - 1:0]count_p; //rising edge counter
reg[F_DIV_WIDTH - 1:0]count_n; //falling edge counter

wire full_div_p;
wire half_div_p;
wire full_div_n;
wire half_div_n;

assign full_div_p = (count_p < F_DIV - 1);
assign half_div_p = (count_p < (F_DIV >> 1) - 1);
assign full_div_n = (count_n < F_DIV - 1);
assign half_div_n = (count_n < (F_DIV>>1) - 1);

//clk out
assign clk_out = (F_DIV == 1)?
			clk : (F_DIV[0] ? (clk_p_r & clk_n_r) : clk_p_r);

//rising counting
always@(posedge clk)
	begin
	if(full_div_p)
		begin
		count_p <= count_p + 1'b1;
		if(half_div_p)
			clk_p_r <= 1'b0;
		else 
			clk_p_r <= 1'b1;
		end
	else
		begin
		count_p <= 1'b0;
		clk_p_r <= 1'b0;
		end
	end

//falling counting
always@(negedge clk)
	begin
	if(full_div_n)
		begin
		count_n <= count_n + 1'b1;
		if(half_div_n)
			clk_n_r <= 1'b0;
		else 
			clk_n_r <= 1'b1;
		end
	else
		begin
		count_n <= 1'b0;
		clk_n_r <= 1'b0;
		end
	end	
	


endmodule