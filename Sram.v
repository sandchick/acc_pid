module Sram #(
// --------------------------------------------------------------------------
// Parameters
// --------------------------------------------------------------------------
  parameter AW = 14
 )
 (
  // Inputs
  input  wire          CLK,
  input  wire [AW-1:0] ADDR,
  input  wire [31:0]   WDATA,
  input  wire [3:0]    WREN,
  input  wire          CS,

  // Outputs
  output wire [31:0]   RDATA
  );

// -----------------------------------------------------------------------------
// Constant Declarations
// -----------------------------------------------------------------------------
localparam AWT = ((1<<(AW-0))-1);

  // Memory Array
  reg     [31:0]   BRAM [AWT:0];
//initial memory
  initial begin
    $readmemh("D:/cortexm0acc/code/code.hex",BRAM);
  end

  reg     [AW-1:0]  addr_q1;
  wire    [3:0]     write_enable;
  reg               cs_reg;
  wire    [31:0]    read_data;

  assign write_enable[3:0] = WREN[3:0] & {4{CS}};

  always @ (posedge CLK)
    begin
    cs_reg <= CS;
    end

  // Infer Block RAM - syntax is very specific.
  always @ (posedge CLK)
    begin
      if (write_enable[0])
        BRAM[ADDR][7:0] <= WDATA[7:0];
      if (write_enable[1])
        BRAM[ADDR][15:8] <= WDATA[15:8];
      if (write_enable[2])
        BRAM[ADDR][23:16] <= WDATA[23:16];
      if (write_enable[3])
        BRAM[ADDR][31:24] <= WDATA[31:24];
      // do not use enable on read interface.
      addr_q1 <= ADDR[AW-1:0];
    end
  assign read_data = BRAM[addr_q1];


  assign RDATA = (cs_reg) ? read_data : {32{1'b0}};


//`ifdef SIMULATION
//  integer i;
// // localparam MEM_SIZE = 2**(AW+2);
// // reg [7:0] fileimage [0:((MEM_SIZE)-1)];
//
//  initial begin
//    //  Initialize memory content to avoid X value on bus
//    for (i = 0; i <= AWT; i=i+1)
//      begin
//        BRAM0[i] = 8'h10;
//        BRAM1[i] = 8'h30;
//        BRAM2[i] = 8'h50;
//        BRAM3[i] = 8'h90;
//      end
//    end
////`endif 
endmodule
//`ifndef RAMPRELOAD_SPI
//  // Simulation
//  $readmemh(MEMFILE, fileimage);
//      // Copy from single array to splitted array
//    for (i=0;i<(MEM_SIZE/4); i= i+1)
//    begin
//      BRAM3[i] = fileimage[i*4+3];
//      BRAM2[i] = fileimage[i*4+2];
//      BRAM1[i] = fileimage[i*4+1];
//      BRAM0[i] = fileimage[i*4];
//
//    end
//`endif // RAMPRELOAD_SPI
//  end
//`endif // SIMULATION
//
