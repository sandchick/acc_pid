module AHBlite_ADC #(parameter DATA_WIDTH = 8)
    (
    input  wire          HCLK,    
    input  wire          HRESETn, 
    input  wire          HSEL,    
    input  wire   [31:0] HADDR,   
    input  wire    [1:0] HTRANS,  
    input  wire    [2:0] HSIZE,   
    input  wire    [3:0] HPROT,   
    input  wire          HWRITE,  
    input  wire   [31:0] HWDATA,  
    input  wire          HREADY,  
    output wire          HREADYOUT, 
    output wire   [31:0] HRDATA,  
    output wire          HRESP,
    input wire   [DATA_WIDTH-1:0]data_in
);
reg     full;
wire    wr_en;
reg [DATA_WIDTH-1:0] dout;
always @(posedge HCLK or negedge HRESETn)begin
   if(HRESETn== 1'b0)begin
       dout <= 0;
       full <= 0;
   end
   else if(wr_en == 1'b1)begin
       if(HREADY== 1'b1)begin
           full <= 1;
           dout <= data_in;
       end
       else begin
           full <= 0;
           dout <= dout;
       end
   end
   else begin
       full <= full;
       dout <= dout;
   end
end

assign  wr_en = ~full | HREADY;

assign  HREADYOUT = wr_en;
//reg [DATA_WIDTH-1:0]data_reg2,data_reg1;
//always @(posedge HCLK or negedege HRESETn) begin
//    if(~HRESETn) data_reg1 <= 0;
//    else data_reg1 <= data_in;
//end
//
//  
//always @(posedge HCLK or negedege HRESETn) begin
//    if (~HRESETn) data_reg2 <= 0;
//    else data_reg2 <= data_reg1;
//end

assign HRDATA = {24'b0,dout};

endmodule