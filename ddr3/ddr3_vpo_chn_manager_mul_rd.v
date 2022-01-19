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

module ddr3_vpo_chn_manager_mul_rd#(
    parameter   DATA_WIDTH = 128,
    parameter   ADDR_WIDTH = 27
)
(
    input   wire                        i_rst_n                 ,
    input   wire                        i_soft_rst              ,
        
    input   wire                        i_vpo_pix_clk           ,
    input   wire                        i_vpo_vs                ,
    input   wire                        i_vpo_de                ,
    input   wire                        i_vpo_data_en           ,
    input   wire                        i_ram_rd_addr_clear     ,
    input   wire    [11:0]              i_start_col_numb        ,
    output  wire    [15:0]              o_vpo_pix_data          ,
        
    input   wire    [3:0]               i_sub_space_num         ,
    input   wire    [11:0]              i_read_numb             ,
    input   wire    [11:0]              i_start_row_numb        ,
    
    input   wire                        i_ddr_vpo_prio_ini_vld  ,
    input   wire    [15:0]              i_ddr_vpo_prio_ini      ,
    output  wire    [15:0]              o_ddr_vpo_priority      ,
        
    input   wire                        i_ddr_clk               ,
    input   wire                        i_ddr_vpo_ack           ,
    input   wire                        i_ddr_vpo_rdata_vld     ,
    input   wire                        i_ddr_rd_done           ,
    input   wire    [1:0]               i_frame_numb            ,
    input   wire    [DATA_WIDTH-1:0]    i_ddr_vpo_wdata         ,
        
    output  wire                        o_ddr_vpo_req           ,
    output  wire                        o_ddr_req_lose          ,
    output  wire    [11:0]              o_ddr_vpo_data_length   ,
    output  wire    [ADDR_WIDTH-1:0]    o_ddr_vpo_start_addr    
    
);
wire                     ddr_req     ;
wire                     ram_we      ;
wire    [7:0]            ram_wr_addr ;
wire    [DATA_WIDTH-1:0] ram_wr_data ;


vpo_ram_control_mul_rd vpo_ram_control(
.i_rst_n                 ( i_rst_n                      ),
.i_soft_rst              ( i_soft_rst                   ),
.i_pix_clk               ( i_vpo_pix_clk                ),
.i_vs                    ( i_vpo_vs                     ),
.i_de                    ( i_vpo_de                     ),
.i_data_en               ( i_vpo_data_en                ),
.i_ram_rd_addr_clear     ( i_ram_rd_addr_clear          ),
.i_ram_rd_start_addr     ( i_start_col_numb[11:0]       ),
.o_pix_data              ( o_vpo_pix_data[15:0]         ),
.i_ddr_clk               ( i_ddr_clk                    ),
.i_ddr_vpo_ack           ( i_ddr_vpo_ack                ),
.i_ram_wr_en             ( ram_we                       ),
.i_ram_wr_addr           ( ram_wr_addr[7:0]             ),
.i_ram_wr_data           ( ram_wr_data[DATA_WIDTH-1:0]  ),
.o_ddr_req               ( ddr_req                      )  // two pixel clock width;
);


ddr_read_control  ddr_read_control (  
.i_rst_n               ( i_rst_n                              ),
.i_sclk                ( i_ddr_clk                            ),
.i_soft_rst            ( i_soft_rst                           ),
.i_sub_space_num       ( i_sub_space_num[3:0]                 ),  // [26:23]: channel, [22:21]: fram, [20:10]row, [9:0]col,
.i_read_numb           ( i_read_numb[11:0]                    ),  // the max number is 1024
.i_syn_v               ( i_vpo_vs                             ),  // must have a width of several sclk
.i_ddr_req             ( ddr_req                              ),  // 3 pixel clock width;
.i_start_row_line      ( i_start_row_numb[11:0]               ),
.o_read_ram_addr       ( ram_wr_addr[7:0]                     ),
.o_read_ram_we         ( ram_we                               ),
.o_read_ram_data       ( ram_wr_data[DATA_WIDTH-1:0]          ),
.o_ddr_vpo_req         ( o_ddr_vpo_req                        ),
.i_ddr_vpo_ack         ( i_ddr_vpo_ack                        ),
.o_ddr_vpo_start_addr  ( o_ddr_vpo_start_addr[ADDR_WIDTH-1:0] ),
.o_ddr_vpo_data_length ( o_ddr_vpo_data_length[11:0]          ),
.i_ddr_vpo_prio_ini_vld( i_ddr_vpo_prio_ini_vld               ),
.i_ddr_vpo_prio_ini    ( i_ddr_vpo_prio_ini                   ),
.o_ddr_vpo_priority    ( o_ddr_vpo_priority                   ),
.i_ddr_vpo_rdata_vld   ( i_ddr_vpo_rdata_vld                  ),
.i_ddr_vpo_rdata       ( i_ddr_vpo_wdata[DATA_WIDTH-1:0]      ),
.i_ddr_vpo_end         ( i_ddr_rd_done                        ),
.i_frame_numb          ( i_frame_numb[1:0]                    ),
.o_ddr_req_lose        ( o_ddr_req_lose                       )
);

endmodule