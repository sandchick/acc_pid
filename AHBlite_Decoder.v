module AHBlite_Decoder
#(
    /*RAMCODE enable parameter*/
    parameter Port0_en = 1,
    /************************/

    /*RAMDATA enable parameter*/
    parameter Port1_en = 1,
    /************************/

    /*APB enable parameter*/
    parameter Port2_en = 0
    /************************/

)(
    input [31:0] HADDR,

    /*RAMCODE OUTPUT SELECTION SIGNAL*/
    output wire P0_HSEL,

    output wire P1_HSEL,

    output wire P2_HSEL

);

//RAMCODE-----------------------------------

//0x00000000-0x0000ffff
assign P0_HSEL = (HADDR[31:16] == 16'h0000) ? Port0_en : 1'b0; 
/***********************************/

//RAMDATA-----------------------------

//0X20000000-0X2000FFFF
assign P1_HSEL = (HADDR[31:16] == 16'h2000) ? Port1_en : 1'b0; 
/***********************************/

//PERIPHRAL-----------------------------

//0X40000000 APB
assign P2_HSEL = (HADDR[31:16] == 16'h4000) ? Port2_en : 1'b0; 
/***********************************/

//0X40000010 ACC 
/*Insert ACC decoder code there*/
//assign P3_HSEL = (HADDR[31:4] == 28'h4000001) ? Port3_en : 1'b0;
/***********************************/


endmodule