// ============================ KEDACOM Corporation ============================
//      Information contained in this Confidential and Proprietary work has
//      been obtained by KEDACOM Corporation. This Design may be used only as
//      authorized by a Licensing Agreement from KEDACOM Corporation.
// =============================================================================
//          KEDACOM
// address  :  No131  jinshan road,  Suzhou city,  Jiangsu Province
// zip code :  215011
// Tel      :  0512-68418188
// Fax      :  0512-68412699
// =============================================================================
//      Description
// =============================================================================
//  Version         date                author
//  1.0             2016.11.17          gzd
//
//  Revision History
//  1.0 Modified for Lattice ECP3-70EA-8FN672 in SVR2930 as Interface FPGA; 
//
// =============================================================================

// synopsys translate_off
`timescale 1ns/1ps
// synopsys translate_on

module ddr3_vpi_chn_manager#(
    parameter   DATA_WIDTH = 128,
    parameter   ADDR_WIDTH = 27
)
(
    input   wire                        i_rst_n                 ,
    input   wire                        i_soft_rst              ,
        
    input   wire                        i_vpi_pix_clk           ,
    input   wire                        i_vpi_vs                ,
    input   wire                        i_vpi_de                ,
    input   wire                        i_vpi_data_en           ,
    input   wire    [15:0]              i_vpi_pix_data          ,
        
    input   wire    [3:0]               i_sub_space_num         ,
    input   wire    [11:0]              i_save_numb             ,
        
    input   wire                        i_ddr_clk               ,
    input   wire                        i_ddr_vpi_ack           ,
    input   wire                        i_ddr_vpi_wdata_rdy     ,
    input   wire                        i_ddr_wr_done           ,
    
    input   wire                        i_ddr_vpi_prio_ini_vld  ,
    input   wire    [15:0]              i_ddr_vpi_prio_ini      ,
    output  wire    [15:0]              o_ddr_vpi_priority      ,
        
    output  wire                        o_ddr_vpi_req           ,
    output  wire                        o_ddr_req_lose          ,
    output  wire    [11:0]              o_ddr_vpi_data_length   ,
    output  wire    [1:0]               o_frame_numb            ,
    output  wire    [ADDR_WIDTH-1:0]    o_ddr_vpi_start_addr    ,
    output  wire    [DATA_WIDTH-1:0]    o_ddr_vpi_wdata         
    
);
wire                     ddr_req     ;
wire    [7:0]            ram_rd_addr ;
wire    [DATA_WIDTH-1:0] ram_rd_data ;


vpi_ram_control vpi_ram_control(
.i_rst_n             ( i_rst_n                      ),
.i_soft_rst          ( i_soft_rst                   ),
.i_pix_clk           ( i_vpi_pix_clk                ),
.i_vs                ( i_vpi_vs                     ),
.i_de                ( i_vpi_de                     ),
.i_data_en           ( i_vpi_data_en                ),
.i_pix_data          ( i_vpi_pix_data               ),
.i_ddr_clk           ( i_ddr_clk                    ),
.i_ddr_vpi_ack       ( i_ddr_vpi_ack                ),
.i_ddr_wr_done       ( i_ddr_wr_done                ),
// .i_ram_rd_en         (                              ),
.i_ram_rd_addr       ( ram_rd_addr[7:0]             ),
.o_ram_rd_data       ( ram_rd_data[DATA_WIDTH-1:0]  ),
.o_ddr_req           ( ddr_req                      )  // two pixel clock width;
                                                    );

ddr_write_control  ddr_write_control ( 
.i_rst_n                 ( i_rst_n                       ),
.i_sclk                  ( i_ddr_clk                     ),
.i_soft_rst              ( i_soft_rst                    ),
.i_sub_space_num         ( i_sub_space_num[3:0]          ),  
.i_save_numb             ( i_save_numb[11:0]             ),  // the max number is 1024
.i_syn_v                 ( i_vpi_vs                      ),  // must have a width of several sclk
.i_ddr_req               ( ddr_req                       ),  // 3 pixel clock width;
.o_save_ram_addr         ( ram_rd_addr[7:0]              ),
.o_save_ram_rd           (                               ),
.i_save_ram_data         ( ram_rd_data[DATA_WIDTH-1:0]   ),
.i_ddr_vpi_prio_ini_vld  ( i_ddr_vpi_prio_ini_vld        ),
.i_ddr_vpi_prio_ini      ( i_ddr_vpi_prio_ini            ),
.o_ddr_vpi_priority      ( o_ddr_vpi_priority            ),
.o_ddr_vpi_req           ( o_ddr_vpi_req                 ),
.i_ddr_vpi_ack           ( i_ddr_vpi_ack                 ),
.o_ddr_vpi_start_addr    ( o_ddr_vpi_start_addr[ADDR_WIDTH-1:0]), //[26:23]: channel, [22:21]: fram, [20:10]row, [9:0]col,
.o_ddr_vpi_data_length   ( o_ddr_vpi_data_length[11:0]   ),
.i_ddr_vpi_wdata_rdy     ( i_ddr_vpi_wdata_rdy           ),
.o_ddr_vpi_wdata         ( o_ddr_vpi_wdata[DATA_WIDTH-1:0]), 
.i_ddr_vpi_end           ( i_ddr_wr_done                 ), // need one clock lagged?--gzd
.o_frame_numb            ( o_frame_numb[1:0]             ),
.o_ddr_req_lose          ( o_ddr_req_lose                )  // ddr request lose signal;--gzd
                                                         );


endmodule