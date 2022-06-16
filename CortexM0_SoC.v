
module CortexM0_SoC #(parameter DATA_WIDTH = 12)(
        input   wire         clk,
        input   wire         RSTn,
        inout   wire         SWDIO,  
        input   wire         SWCLK,
        input   wire [31:0]      real_data1,
        input   wire [31:0]  real_data2
);

//------------------------------------------------------------------------------
// DEBUG IOBUF 
//------------------------------------------------------------------------------

wire SWDO;
wire SWDOEN;
wire SWDI;

assign SWDI = SWDIO;
assign SWDIO = (SWDOEN) ?  SWDO : 1'bz;

//------------------------------------------------------------------------------
// Interrupt
//------------------------------------------------------------------------------


wire RXEV;
assign RXEV = 1'b0;

//------------------------------------------------------------------------------
// AHB
//------------------------------------------------------------------------------

wire [31:0] HADDR;
wire [ 2:0] HBURST;
wire        HMASTLOCK;
wire [ 3:0] HPROT;
wire [ 2:0] HSIZE;
wire [ 1:0] HTRANS;
wire [31:0] HWDATA;
wire        HWRITE;
wire [31:0] HRDATA;
wire        HRESP;
wire        HMASTER;
wire        HREADY;

//------------------------------------------------------------------------------
// RESET AND DEBUG
//------------------------------------------------------------------------------

wire SYSRESETREQ;
reg cpuresetn;

always @(posedge clk or negedge RSTn)begin
        if (~RSTn) cpuresetn <= 1'b0;
        else if (SYSRESETREQ) cpuresetn <= 1'b0;
        else cpuresetn <= 1'b1;
end

wire CDBGPWRUPREQ;
reg CDBGPWRUPACK;

always @(posedge clk or negedge RSTn)begin
        if (~RSTn) CDBGPWRUPACK <= 1'b0;
        else CDBGPWRUPACK <= CDBGPWRUPREQ;
end


//------------------------------------------------------------------------------
// Instantiate Cortex-M0 processor logic level
//------------------------------------------------------------------------------

cortexm0ds_logic u_logic (

        // System inputs
        .FCLK           (clk),           //FREE running clock 
        .SCLK           (clk),           //system clock
        .HCLK           (clk),           //AHB clock
        .DCLK           (clk),           //Debug clock
        .PORESETn       (RSTn),          //Power on reset
        .HRESETn        (cpuresetn),     //AHB and System reset
        .DBGRESETn      (RSTn),          //Debug Reset
        .RSTBYPASS      (1'b0),          //Reset bypass
        .SE             (1'b0),          // dummy scan enable port for synthesis

        // Power management inputs
        .SLEEPHOLDREQn  (1'b1),          // Sleep extension request from PMU
        .WICENREQ       (1'b0),          // WIC enable request from PMU
        .CDBGPWRUPACK   (CDBGPWRUPACK),  // Debug Power Up ACK from PMU

        // Power management outputs
        .CDBGPWRUPREQ   (CDBGPWRUPREQ),
        .SYSRESETREQ    (SYSRESETREQ),

        // System bus
        .HADDR          (HADDR[31:0]),
        .HTRANS         (HTRANS[1:0]),
        .HSIZE          (HSIZE[2:0]),
        .HBURST         (HBURST[2:0]),
        .HPROT          (HPROT[3:0]),
        .HMASTER        (HMASTER),
        .HMASTLOCK      (HMASTLOCK),
        .HWRITE         (HWRITE),
        .HWDATA         (HWDATA[31:0]),
        .HRDATA         (HRDATA[31:0]),
        .HREADY         (HREADY),
        .HRESP          (HRESP),

        // Interrupts
        .IRQ            (IRQ),          //Interrupt
        .NMI            (1'b0),         //Watch dog interrupt
        .IRQLATENCY     (8'h0),
        .ECOREVNUM      (28'h0),

        // Systick
        .STCLKEN        (1'b0),
        .STCALIB        (26'h0),

        // Debug - JTAG or Serial wire
        // Inputs
        .nTRST          (1'b1),
        .SWDITMS        (SWDI),
        .SWCLKTCK       (SWCLK),
        .TDI            (1'b0),
        // Outputs
        .SWDO           (SWDO),
        .SWDOEN         (SWDOEN),

        .DBGRESTART     (1'b0),

        // Event communication
        .RXEV           (RXEV),         // Generate event when a DMA operation completed.
        .EDBGRQ         (1'b0)          // multi-core synchronous halt request
);

//------------------------------------------------------------------------------
// AHBlite Interconncet
//------------------------------------------------------------------------------

wire            HSEL_P0;
wire    [31:0]  HADDR_P0;
wire    [2:0]   HBURST_P0;
wire            HMASTLOCK_P0;
wire    [3:0]   HPROT_P0;
wire    [2:0]   HSIZE_P0;
wire    [1:0]   HTRANS_P0;
wire    [31:0]  HWDATA_P0;
wire            HWRITE_P0;
wire            HREADY_P0;
wire            HREADYOUT_P0;
wire    [31:0]  HRDATA_P0;
wire            HRESP_P0;

wire            HSEL_P1;
wire    [31:0]  HADDR_P1;
wire    [2:0]   HBURST_P1;
wire            HMASTLOCK_P1;
wire    [3:0]   HPROT_P1;
wire    [2:0]   HSIZE_P1;
wire    [1:0]   HTRANS_P1;
wire    [31:0]  HWDATA_P1;
wire            HWRITE_P1;
wire            HREADY_P1;
wire            HREADYOUT_P1;
wire    [31:0]  HRDATA_P1;
wire            HRESP_P1;

wire            HSEL_P2;
wire    [31:0]  HADDR_P2;
wire    [2:0]   HBURST_P2;
wire            HMASTLOCK_P2;
wire    [3:0]   HPROT_P2;
wire    [2:0]   HSIZE_P2;
wire    [1:0]   HTRANS_P2;
wire    [31:0]  HWDATA_P2;
wire            HWRITE_P2;
wire            HREADY_P2;
wire            HREADYOUT_P2;
wire    [31:0]  HRDATA_P2;
wire            HRESP_P2;

//wire            HSEL_P3;
//wire    [31:0]  HADDR_P3;
//wire    [2:0]   HBURST_P3;
//wire            HMASTLOCK_P3;
//wire    [3:0]   HPROT_P3;
//wire    [2:0]   HSIZE_P3;
//wire    [1:0]   HTRANS_P3;
//wire    [31:0]  HWDATA_P3;
//wire            HWRITE_P3;
//wire            HREADY_P3;
//wire            HREADYOUT_P3;
//wire    [31:0]  HRDATA_P3;
//wire            HRESP_P3;

AHBlite_Interconnect Interconncet(
        .HCLK           (clk),
        .HRESETn        (cpuresetn),

        // CORE SIDE
        .HADDR          (HADDR),
        .HTRANS         (HTRANS),
        .HSIZE          (HSIZE),
        .HBURST         (HBURST),
        .HPROT          (HPROT),
        .HMASTLOCK      (HMASTLOCK),
        .HWRITE         (HWRITE),
        .HWDATA         (HWDATA),
        .HRDATA         (HRDATA),
        .HREADY         (HREADY),
        .HRESP          (HRESP),

        // P0
        .HSEL_P0        (HSEL_P0),
        .HADDR_P0       (HADDR_P0),
        .HBURST_P0      (HBURST_P0),
        .HMASTLOCK_P0   (HMASTLOCK_P0),
        .HPROT_P0       (HPROT_P0),
        .HSIZE_P0       (HSIZE_P0),
        .HTRANS_P0      (HTRANS_P0),
        .HWDATA_P0      (HWDATA_P0),
        .HWRITE_P0      (HWRITE_P0),
        .HREADY_P0      (HREADY_P0),
        .HREADYOUT_P0   (HREADYOUT_P0),
        .HRDATA_P0      (HRDATA_P0),
        .HRESP_P0       (HRESP_P0),

        // P1
        .HSEL_P1        (HSEL_P1),
        .HADDR_P1       (HADDR_P1),
        .HBURST_P1      (HBURST_P1),
        .HMASTLOCK_P1   (HMASTLOCK_P1),
        .HPROT_P1       (HPROT_P1),
        .HSIZE_P1       (HSIZE_P1),
        .HTRANS_P1      (HTRANS_P1),
        .HWDATA_P1      (HWDATA_P1),
        .HWRITE_P1      (HWRITE_P1),
        .HREADY_P1      (HREADY_P1),
        .HREADYOUT_P1   (HREADYOUT_P1),
        .HRDATA_P1      (HRDATA_P1),
        .HRESP_P1       (HRESP_P1),

        // P2
        .HSEL_P2        (HSEL_P2),
        .HADDR_P2       (HADDR_P2),
        .HBURST_P2      (HBURST_P2),
        .HMASTLOCK_P2   (HMASTLOCK_P2),
        .HPROT_P2       (HPROT_P2),
        .HSIZE_P2       (HSIZE_P2),
        .HTRANS_P2      (HTRANS_P2),
        .HWDATA_P2      (HWDATA_P2),
        .HWRITE_P2      (HWRITE_P2),
        .HREADY_P2      (HREADY_P2),
        .HREADYOUT_P2   (HREADYOUT_P2),
        .HRDATA_P2      (HRDATA_P2),
        .HRESP_P2       (HRESP_P2)

        // P3
  //      .HSEL_P3        (HSEL_P3),
  //      .HADDR_P3       (HADDR_P3),
  //      .HBURST_P3      (HBURST_P3),
  //      .HMASTLOCK_P3   (HMASTLOCK_P3),
  //      .HPROT_P3       (HPROT_P3),
  //      .HSIZE_P3       (HSIZE_P3),
  //      .HTRANS_P3      (HTRANS_P3),
  //      .HWDATA_P3      (HWDATA_P3),
  //      .HWRITE_P3      (HWRITE_P3),
  //      .HREADY_P3      (HREADY_P3),
  //      .HREADYOUT_P3   (HREADYOUT_P3),
  //      .HRDATA_P3      (HRDATA_P3),
  //      .HRESP_P3       (HRESP_P3)
);

//------------------------------------------------------------------------------
// AHB RAMCODE
//------------------------------------------------------------------------------

wire [31:0] RAMCODE_RDATA,RAMCODE_WDATA;
wire [13:0] RAMCODE_ADDR;
wire [3:0]  RAMCODE_WRITE;
wire SRAMCS_CODE;
AHBlite_Sram RAMCODE_Interface(
        /* Connect to Interconnect Port 0 */
        .HCLK           (clk),
        .HRESETn        (cpuresetn),
        .HSEL           (HSEL_P0),
        .HADDR          (HADDR_P0),
        .HSIZE          (HSIZE_P0),
        .HTRANS         (HTRANS_P0),
        .HWDATA         (HWDATA_P0),
        .HWRITE         (HWRITE_P0),
        .HRDATA         (HRDATA_P0),
        .HREADY         (HREADY_P0),
        .HREADYOUT      (HREADYOUT_P0),
        .HRESP          (HRESP_P0),
        .SRAMADDR      (RAMCODE_ADDR),
        .SRAMRDATA     (RAMCODE_RDATA),
        .SRAMWDATA     (RAMCODE_WDATA),
        .SRAMWEN       (RAMCODE_WRITE),
        .SRAMCS        (SRAMCS_CODE)
        /**********************************/
);

//------------------------------------------------------------------------------
// AHB RAMDATA
//------------------------------------------------------------------------------

wire [31:0] RAMDATA_RDATA;
wire [31:0] RAMDATA_WDATA;
wire [13:0] RAMDATA_ADDR;
wire [3:0]  RAMDATA_WRITE;
wire SRAMCS_DATA;
AHBlite_Sram RAMDATA_Interface(
        /* Connect to Interconnect Port 1 */
        .HCLK           (clk),
        .HRESETn        (cpuresetn),
        .HSEL           (HSEL_P1),
        .HADDR          (HADDR_P1),
        .HSIZE          (HSIZE_P1),
        .HTRANS         (HTRANS_P1),
        .HWDATA         (HWDATA_P1),
        .HWRITE         (HWRITE_P1),
        .HRDATA         (HRDATA_P1),
        .HREADY         (HREADY_P1),
        .HREADYOUT      (HREADYOUT_P1),
        .HRESP          (HRESP_P1),
        .SRAMADDR      (RAMDATA_ADDR),
        .SRAMWDATA     (RAMDATA_WDATA),
        .SRAMRDATA     (RAMDATA_RDATA),
        .SRAMWEN       (RAMDATA_WRITE),
        .SRAMCS        (SRAMCS_DATA)
        /**********************************/
);

//-------------------------------------------
//APB bridge
//-------------------------------------------

   wire          [31:0] PADDR;     // APB Address
   wire                 PENABLE;   // APB Enable
   wire                 PWRITE;    // APB Write
   wire           [3:0] PSTRB;     // APB Byte Strobe
   wire           [2:0] PPROT;     // APB Prot
   wire          [31:0] PWDATA;    // APB write data
   wire                 PSEL;      // APB Selectoo
   wire                 APBACTIVE; // APB bus is active, for clock gating
                                    // of APB bus
   wire          [31:0] PRDATA;    // Read data for each APB slave
   wire                 PREADY;    // Ready for each APB slave
   wire                 PSLVERR;  // Error state for each APB slave
   
   assign PSLVERR = 1'b0; //never error
 
 AHB2apb AHB_apb(
        /* Connect to Interconnect Port 2 */
        .HCLK                   (clk),
        .HRESETn                (cpuresetn),
        .HSEL                   (HSEL_P2),
        .HADDR                  (HADDR_P2),
        .HTRANS                 (HTRANS_P2),
        .HSIZE                  (HSIZE_P2),
        .HPROT                  (HPROT_P2),
        .HWRITE                 (HWRITE_P2),
        .HWDATA                 (HWDATA_P2),
        .HREADY                 (HREADY_P2),
        .HREADYOUT              (HREADYOUT_P2),
        .HRDATA                 (HRDATA_P2),
        .HRESP                  (HRESP_P2),
        .PADDR                  (PADDR)  ,
        .PCLKEN                 (cpuresetn),
        .PENABLE                (PENABLE),
        .PWRITE                 (PWRITE) ,
        .PSTRB                  (PSTRB)  ,
        .PPROT                  (PPROT)  ,
        .PWDATA                 (PWDATA) ,
        .PSEL                   (PSEL)   ,
        .APBACTIVE              (APBACTIVE),
        .PRDATA                 (PRDATA) ,
        .PREADY                 (PREADY) ,
        .PSLVERR                (PSLVERR)
);


wire [3:0]DECODE4BIT;

wire PSEL0;
wire PREADY0;
wire [31:0]  PRDATA0;
wire PSLVERR0;
wire PSEL1;
wire PREADY1;
wire [31:0]  PRDATA1;
wire PSLVERR1;
wire PSEL2;
wire PREADY2;
wire [31:0]  PRDATA2;
wire PSLVERR2;
wire PSEL3;
wire PREADY3;
wire [31:0]  PRDATA3;
wire PSLVERR3;

apb_slave_mux apb_mux (
        .PSEL0          (PSEL0),
        .PSEL1          (PSEL1),
        .PSEL2          (PSEL2),
        .PSEL3          (PSEL3),
        .PREADY0        (PREADY0),
        .PREADY1        (PREADY1),
        .PREADY2        (PREADY2),
        .PREADY3        (PREADY3),
        .PRDATA0        (PRDATA0),
        .PRDATA1        (PRDATA1),
        .PRDATA2        (PRDATA2),
        .PRDATA3        (PRDATA3),
        .PSLVERR0       (PSLVERR0),
        .PSLVERR1       (PSLVERR1),
        .PSLVERR2       (PSLVERR2),
        .PSLVERR3       (PSLVERR3),
        .PSEL           (PSEL),
        .PREADY         (PREADY),
        .PRDATA         (PRDATA),
        .PSLVERR        (PSLVERR),
        .DECODE4BIT     (PADDR[15:12])
);
wire [11:0] ADC_DATA1;
wire [11:0] ADC_DATA2;
wire sample_enable1;
wire sample_enable2;
wire adc2tmu1_en;
wire adc2tmu2_en;
//assign ADC_DATA = data_adc;
apb2adc apb_adc1 (
        .PCLK           (clk),
        .PRESETn        (cpuresetn),
        .PENABLE        (PENABLE),
        .PREADY         (PREADY0),
        .PSEL           (PSEL0),
        .PADDR          (PADDR),
        .PWRITE         (PWRITE),
        .PRDATA         (PRDATA0),
        .PWDATA         (PWDATA),
        .PSLVERR        (PSLVERR0),
        .sample_enable  (sample_enable1),
        .adc2tmu_en     (adc2tmu1_en),
        .ADC_DATA       (ADC_DATA1)
        
);
apb2adc apb_adc2 (
        .PCLK           (clk),
        .PRESETn        (cpuresetn),
        .PENABLE        (PENABLE),
        .PREADY         (PREADY3),
        .PSEL           (PSEL3),
        .PADDR          (PADDR),
        .PWRITE         (PWRITE),
        .PRDATA         (PRDATA3),
        .PWDATA         (PWDATA),
        .PSLVERR        (PSLVERR3),
        .sample_enable  (sample_enable2),
        .adc2tmu_en     (adc2tmu2_en),
        .ADC_DATA       (ADC_DATA2)
        
);
wire [11:0] cordic_data_acnt;//计算后的cordicdata
wire [11:0] cordic_data_bcnt;//计算前的cordicdata
wire [16:0] pid_data_acnt;//计算后的cordicdata
wire [11:0] pid_data_bcnt;//计算前的cordicdata
wire [11:0] para;
wire [11:0] target;
apb2tmu apb_tmu (      
        .PCLK           (clk),
        .PRESETn        (cpuresetn),
        .PENABLE        (PENABLE),
        .PREADY         (PREADY1),
        .PSEL           (PSEL1),
        .PADDR          (PADDR),
        .PWRITE         (PWRITE),
        .PRDATA         (PRDATA1),
        .PSLVERR        (PSLVERR1),
        .PWDATA         (PWDATA),
        .data_cordic_in (cordic_data_acnt),
        .data_cordic_out (cordic_data_bcnt),
        .write_enablecordic (write_enablecordic),
        .data_pid_in (pid_data_acnt),
        .data_pid_out (pid_data_bcnt),
        .write_enablepid (write_enablepid),
        .para           (para), 
        .target          (target)
);


wire [11:0] adc_data1;
wire [11:0] adc_data2;
tmu utmu(
        .clk (clk)
        ,.rstn (cpuresetn)
        ,.adc_data1 (adc_data1)
        ,.adc_data2 (adc_data2)
        ,.data_cordic_in (cordic_data_bcnt)
        ,.write_enablecordic (write_enablecordic)
        ,.data_cordic_out (cordic_data_acnt),
        .data_pid_in (pid_data_bcnt),
        .data_pid_out (pid_data_acnt),
        .write_enablepid (write_enablepid),
        .para           (para), 
        .target          (target)
);


adc2tmu adc_tmu1(
        .clk    (clk)
        ,.rstn  (cpuresetn)
        ,.adc2tmu_en (adc2tmu1_en)
        ,.adc_data_in (ADC_DATA1)
        ,.adc_data_out (adc_data1)
);

adc2tmu adc_tmu2(
        .clk    (clk)
        ,.rstn  (cpuresetn)
        ,.adc2tmu_en (adc2tmu2_en)
        ,.adc_data_in (ADC_DATA2)
        ,.adc_data_out (adc_data2)
);

wire pwmenable;
apb2pwm apb_pwm(
        .PCLK           (clk),
        .PRESETn        (cpuresetn),
        .PENABLE        (PENABLE),
        .PREADY         (PREADY2),
        .PSEL           (PSEL2),
        .PWRITE         (PWRITE),
      //  .PRDATA         (PRDATA2),
        .PSLVERR        (PSLVERR2),
        .PWDATA         (PWDATA),
        .pwmenable      (pwmenable)
);
//------------
//adc sample
//------------
wire start;
wire OE;
wire EOC;
wire sample_enable;
assign sample_enable = sample_enable1 | sample_enable2;

adc_sample uadc_sample(
        .clk            (clk),
        .rstn           (cpuresetn),
        .sample_enable  (sample_enable),
        .EOC            (EOC)
        ,.start         (start)
        ,.OE            (OE)
);
//--------------
//adc
//--------------
adc uadc1(
        .clk            (clk),
        .rstn           (cpuresetn),
        .anadata        (real_data1),
        .start          (start),
        .OE             (OE),
        .EOC            (EOC),
        .adc_data       (ADC_DATA1)
);
adc uadc2(
        .clk            (clk),
        .rstn           (cpuresetn),
        .anadata        (real_data2),
        .start          (start),
        .OE             (OE),
        .EOC            (EOC),
        .adc_data       (ADC_DATA2)
);
//------------------------------------------------------------------------------
// RAM
//------------------------------------------------------------------------------

Sram RAM_CODE(
        .CLK            (clk),
        .ADDR           (RAMCODE_ADDR),
        .WDATA          (RAMCODE_WDATA),
        .RDATA          (RAMCODE_RDATA),
        .WREN           (RAMCODE_WRITE),
        .CS        (SRAMCS_CODE)
);

Sram RAM_DATA(
        .CLK            (clk),
        .ADDR           (RAMDATA_ADDR),
        .WDATA          (RAMDATA_WDATA),
        .RDATA          (RAMDATA_RDATA),
        .WREN           (RAMDATA_WRITE),
        .CS             (SRAMCS_DATA)
);



endmodule
