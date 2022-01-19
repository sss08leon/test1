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

module  ddr3_top#(
    parameter   DATA_WIDTH  = 128,
    parameter   ADDR_WIDTH  = 27
)
(
    input   wire                        i_rst_n                     ,
    input   wire                        i_soft_rst                  ,
    input   wire                        i_ddr3_clk                  ,

    output  wire                        o_ddr3_busy                 ,
    output  wire                        o_ddr3_op_done              ,
    output  wire                        o_ddr3_init_done            ,
    output  wire                        o_em_ddr_reset_n            ,
    output  wire                        o_em_ddr_cs_n               ,
    output  wire                        o_em_ddr_cke                ,
    output  wire                        o_em_ddr_clk                ,
    inout   wire    [31:0]              io_em_ddr_data              ,
    inout   wire    [ 3:0]              io_em_ddr_dqs               ,
    output  wire                        o_em_ddr_we_n               ,
    output  wire                        o_em_ddr_cas_n              ,
    output  wire                        o_em_ddr_ras_n              ,
    output  wire    [ 2:0]              o_em_ddr_ba                 ,
    output  wire    [ADDR_WIDTH-14:0]   o_em_ddr_addr               ,
    output  wire    [ 3:0]              o_em_ddr_dm                 ,
    output  wire                        o_em_ddr_odt                ,

    input   wire    [ 2:0]              i_scaler_00_source_sel      ,
    input   wire    [ 2:0]              i_scaler_01_source_sel      ,
    input   wire    [ 2:0]              i_scaler_02_source_sel      ,
    input   wire    [ 2:0]              i_scaler_03_source_sel      ,
    input   wire    [ 2:0]              i_scaler_04_source_sel      ,
    
    input   wire                        i_vpi_00_pix_clk            ,
    input   wire                        i_vpi_00_vs                 ,
    input   wire                        i_vpi_00_de                 ,
    input   wire                        i_vpi_00_data_en            ,
    input   wire    [15:0]              i_vpi_00_pix_data           ,
    input   wire    [11:0]              i_vpi_00_save_numb          ,
    input   wire                        i_vpi_00_prio_ini_vld       ,
    input   wire    [15:0]              i_vpi_00_prio_ini           ,

    input   wire                        i_vpi_01_pix_clk            ,
    input   wire                        i_vpi_01_vs                 ,
    input   wire                        i_vpi_01_de                 ,
    input   wire                        i_vpi_01_data_en            ,
    input   wire    [15:0]              i_vpi_01_pix_data           ,
    input   wire    [11:0]              i_vpi_01_save_numb          ,
    input   wire                        i_vpi_01_prio_ini_vld       ,
    input   wire    [15:0]              i_vpi_01_prio_ini           ,

    input   wire                        i_vpi_02_pix_clk            ,
    input   wire                        i_vpi_02_vs                 ,
    input   wire                        i_vpi_02_de                 ,
    input   wire                        i_vpi_02_data_en            ,
    input   wire    [15:0]              i_vpi_02_pix_data           ,
    input   wire    [11:0]              i_vpi_02_save_numb          ,
    input   wire                        i_vpi_02_prio_ini_vld       ,
    input   wire    [15:0]              i_vpi_02_prio_ini           ,

    input   wire                        i_vpi_03_pix_clk            ,
    input   wire                        i_vpi_03_vs                 ,
    input   wire                        i_vpi_03_de                 ,
    input   wire                        i_vpi_03_data_en            ,
    input   wire    [15:0]              i_vpi_03_pix_data           ,
    input   wire    [11:0]              i_vpi_03_save_numb          ,
    input   wire                        i_vpi_03_prio_ini_vld       ,
    input   wire    [15:0]              i_vpi_03_prio_ini           ,

    input   wire                        i_vpi_04_pix_clk            ,
    input   wire                        i_vpi_04_vs                 ,
    input   wire                        i_vpi_04_de                 ,
    input   wire                        i_vpi_04_data_en            ,
    input   wire    [15:0]              i_vpi_04_pix_data           ,
    input   wire    [11:0]              i_vpi_04_save_numb          ,
    input   wire                        i_vpi_04_prio_ini_vld       ,
    input   wire    [15:0]              i_vpi_04_prio_ini           ,

    input   wire                        i_vpi_05_pix_clk            ,
    input   wire                        i_vpi_05_vs                 ,
    input   wire                        i_vpi_05_de                 ,
    input   wire                        i_vpi_05_data_en            ,
    input   wire    [15:0]              i_vpi_05_pix_data           ,
    input   wire    [11:0]              i_vpi_05_save_numb          ,
    input   wire                        i_vpi_05_prio_ini_vld       ,
    input   wire    [15:0]              i_vpi_05_prio_ini           ,

    input   wire                        i_vpi_06_pix_clk            ,
    input   wire                        i_vpi_06_vs                 ,
    input   wire                        i_vpi_06_de                 ,
    input   wire                        i_vpi_06_data_en            ,
    input   wire    [15:0]              i_vpi_06_pix_data           ,
    input   wire    [11:0]              i_vpi_06_save_numb          ,
    input   wire                        i_vpi_06_prio_ini_vld       ,
    input   wire    [15:0]              i_vpi_06_prio_ini           ,

    input   wire                        i_vpi_07_pix_clk            ,
    input   wire                        i_vpi_07_vs                 ,
    input   wire                        i_vpi_07_de                 ,
    input   wire                        i_vpi_07_data_en            ,
    input   wire    [15:0]              i_vpi_07_pix_data           ,
    input   wire    [11:0]              i_vpi_07_save_numb          ,
    input   wire                        i_vpi_07_prio_ini_vld       ,
    input   wire    [15:0]              i_vpi_07_prio_ini           ,

    input   wire                        i_vpi_08_pix_clk            ,
    input   wire                        i_vpi_08_vs                 ,
    input   wire                        i_vpi_08_de                 ,
    input   wire                        i_vpi_08_data_en            ,
    input   wire    [15:0]              i_vpi_08_pix_data           ,
    input   wire    [11:0]              i_vpi_08_save_numb          ,
    input   wire                        i_vpi_08_prio_ini_vld       ,
    input   wire    [15:0]              i_vpi_08_prio_ini           ,

    input   wire                        i_vpi_09_pix_clk            ,
    input   wire                        i_vpi_09_vs                 ,
    input   wire                        i_vpi_09_de                 ,
    input   wire                        i_vpi_09_data_en            ,
    input   wire    [15:0]              i_vpi_09_pix_data           ,
    input   wire    [11:0]              i_vpi_09_save_numb          ,
    input   wire                        i_vpi_09_prio_ini_vld       ,
    input   wire    [15:0]              i_vpi_09_prio_ini           ,

    input   wire                        i_vpo_00_pix_clk            ,
    input   wire                        i_vpo_00_vs                 ,
    input   wire                        i_vpo_00_de                 ,
    input   wire    [11:0]              i_vpo_00_read_numb          ,
    input   wire                        i_vpo_00_ram_rd_addr_clear  ,
    input   wire    [11:0]              i_vpo_00_start_row_numb     ,
    input   wire    [11:0]              i_vpo_00_start_col_numb     ,
    input   wire                        i_vpo_00_prio_ini_vld       ,
    input   wire    [15:0]              i_vpo_00_prio_ini           ,
    output  wire    [15:0]              o_vpo_00_pix_data           ,

    input   wire                        i_vpo_01_pix_clk            ,
    input   wire                        i_vpo_01_vs                 ,
    input   wire                        i_vpo_01_de                 ,
    input   wire    [11:0]              i_vpo_01_read_numb          ,
    input   wire                        i_vpo_01_ram_rd_addr_clear  ,
    input   wire    [11:0]              i_vpo_01_start_row_numb     ,
    input   wire    [11:0]              i_vpo_01_start_col_numb     ,
    input   wire                        i_vpo_01_prio_ini_vld       ,
    input   wire    [15:0]              i_vpo_01_prio_ini           ,
    output  wire    [15:0]              o_vpo_01_pix_data           ,

    input   wire                        i_vpo_02_pix_clk            ,
    input   wire                        i_vpo_02_vs                 ,
    input   wire                        i_vpo_02_de                 ,
    input   wire    [11:0]              i_vpo_02_read_numb          ,
    input   wire                        i_vpo_02_ram_rd_addr_clear  ,
    input   wire    [11:0]              i_vpo_02_start_row_numb     ,
    input   wire    [11:0]              i_vpo_02_start_col_numb     ,
    input   wire                        i_vpo_02_prio_ini_vld       ,
    input   wire    [15:0]              i_vpo_02_prio_ini           ,
    output  wire    [15:0]              o_vpo_02_pix_data           ,

    input   wire                        i_vpo_03_pix_clk            ,
    input   wire                        i_vpo_03_vs                 ,
    input   wire                        i_vpo_03_de                 ,
    input   wire    [11:0]              i_vpo_03_read_numb          ,
    input   wire                        i_vpo_03_ram_rd_addr_clear  ,
    input   wire    [11:0]              i_vpo_03_start_row_numb     ,
    input   wire    [11:0]              i_vpo_03_start_col_numb     ,
    input   wire                        i_vpo_03_prio_ini_vld       ,
    input   wire    [15:0]              i_vpo_03_prio_ini           ,
    output  wire    [15:0]              o_vpo_03_pix_data           ,

    input   wire                        i_vpo_04_pix_clk            ,
    input   wire                        i_vpo_04_vs                 ,
    input   wire                        i_vpo_04_de                 ,
    input   wire    [11:0]              i_vpo_04_read_numb          ,
    input   wire                        i_vpo_04_ram_rd_addr_clear  ,
    input   wire    [11:0]              i_vpo_04_start_row_numb     ,
    input   wire    [11:0]              i_vpo_04_start_col_numb     ,
    input   wire                        i_vpo_04_prio_ini_vld       ,
    input   wire    [15:0]              i_vpo_04_prio_ini           ,
    output  wire    [15:0]              o_vpo_04_pix_data           ,

    input   wire                        i_vpo_05_pix_clk            ,
    input   wire                        i_vpo_05_vs                 ,
    input   wire                        i_vpo_05_de                 ,
    input   wire    [11:0]              i_vpo_05_read_numb          ,
    input   wire                        i_vpo_05_ram_rd_addr_clear  ,
    input   wire    [11:0]              i_vpo_05_start_row_numb     ,
    input   wire    [11:0]              i_vpo_05_start_col_numb     ,
    input   wire                        i_vpo_05_prio_ini_vld       ,
    input   wire    [15:0]              i_vpo_05_prio_ini           ,
    output  wire    [15:0]              o_vpo_05_pix_data           ,

    input   wire                        i_vpo_06_pix_clk            ,
    input   wire                        i_vpo_06_vs                 ,
    input   wire                        i_vpo_06_de                 ,
    input   wire    [11:0]              i_vpo_06_read_numb          ,
    input   wire                        i_vpo_06_ram_rd_addr_clear  ,
    input   wire    [11:0]              i_vpo_06_start_row_numb     ,
    input   wire    [11:0]              i_vpo_06_start_col_numb     ,
    input   wire                        i_vpo_06_prio_ini_vld       ,
    input   wire    [15:0]              i_vpo_06_prio_ini           ,
    output  wire    [15:0]              o_vpo_06_pix_data           ,

    input   wire                        i_vpo_07_pix_clk            ,
    input   wire                        i_vpo_07_vs                 ,
    input   wire                        i_vpo_07_de                 ,
    input   wire    [11:0]              i_vpo_07_read_numb          ,
    input   wire                        i_vpo_07_ram_rd_addr_clear  ,
    input   wire    [11:0]              i_vpo_07_start_row_numb     ,
    input   wire    [11:0]              i_vpo_07_start_col_numb     ,
    input   wire                        i_vpo_07_prio_ini_vld       ,
    input   wire    [15:0]              i_vpo_07_prio_ini           ,
    output  wire    [15:0]              o_vpo_07_pix_data           ,

    input   wire                        i_vpo_08_pix_clk            ,
    input   wire                        i_vpo_08_vs                 ,
    input   wire                        i_vpo_08_de                 ,
    input   wire    [11:0]              i_vpo_08_read_numb          ,
    input   wire                        i_vpo_08_ram_rd_addr_clear  ,
    input   wire    [11:0]              i_vpo_08_start_row_numb     ,
    input   wire    [11:0]              i_vpo_08_start_col_numb     ,
    input   wire                        i_vpo_08_prio_ini_vld       ,
    input   wire    [15:0]              i_vpo_08_prio_ini           ,
    output  wire    [15:0]              o_vpo_08_pix_data           ,

    input   wire                        i_vpo_09_pix_clk            ,
    input   wire                        i_vpo_09_vs                 ,
    input   wire                        i_vpo_09_de                 ,
    input   wire    [11:0]              i_vpo_09_read_numb          ,
    input   wire                        i_vpo_09_ram_rd_addr_clear  ,
    input   wire    [11:0]              i_vpo_09_start_row_numb     ,
    input   wire    [11:0]              i_vpo_09_start_col_numb     ,
    input   wire                        i_vpo_09_prio_ini_vld       ,
    input   wire    [15:0]              i_vpo_09_prio_ini           ,
    output  wire    [15:0]              o_vpo_09_pix_data           ,

    input   wire    [ 3:0]              i_serdes_feature_select     ,
    input   wire                        i_vpo_10_pix_clk            ,
    input   wire                        i_vpo_10_vs                 ,
    input   wire                        i_vpo_10_de                 ,
    input   wire    [11:0]              i_vpo_10_read_numb          ,
    input   wire                        i_vpo_10_ram_rd_addr_clear  ,
    input   wire    [11:0]              i_vpo_10_start_row_numb     ,
    input   wire    [11:0]              i_vpo_10_start_col_numb     ,
    input   wire                        i_vpo_10_prio_ini_vld       ,
    input   wire    [15:0]              i_vpo_10_prio_ini           ,
    output  wire    [15:0]              o_vpo_10_pix_data           ,

    input   wire    [ 3:0]              i_vp_feature_select         ,
    input   wire                        i_vpo_11_pix_clk            ,
    input   wire                        i_vpo_11_vs                 ,
    input   wire                        i_vpo_11_de                 ,
    input   wire    [11:0]              i_vpo_11_read_numb          ,
    input   wire                        i_vpo_11_ram_rd_addr_clear  ,
    input   wire    [11:0]              i_vpo_11_start_row_numb     ,
    input   wire    [11:0]              i_vpo_11_start_col_numb     ,
    input   wire                        i_vpo_11_prio_ini_vld       ,
    input   wire    [15:0]              i_vpo_11_prio_ini           ,
    output  wire    [15:0]              o_vpo_11_pix_data           ,

    output  wire    [21:0]              o_ddr_req_lose              ,
    output  wire                        o_ddr3_sclk

);

localparam  SUB_SPACE0_DDR_BASE_ADDR = 4'd0;  // SDI0 input;
localparam  SUB_SPACE1_DDR_BASE_ADDR = 4'd1;  // SDI1 input;
localparam  SUB_SPACE2_DDR_BASE_ADDR = 4'd2;  // SDI2 input;
localparam  SUB_SPACE3_DDR_BASE_ADDR = 4'd3;  // SDI3 input;
localparam  SUB_SPACE4_DDR_BASE_ADDR = 4'd4;  // SERDES input;
localparam  SUB_SPACE5_DDR_BASE_ADDR = 4'd5;  // scaler0 result;
localparam  SUB_SPACE6_DDR_BASE_ADDR = 4'd6;  // scaler1 result;
localparam  SUB_SPACE7_DDR_BASE_ADDR = 4'd7;  // scaler2 result;
localparam  SUB_SPACE8_DDR_BASE_ADDR = 4'd8;  // scaler3 result;
localparam  SUB_SPACE9_DDR_BASE_ADDR = 4'd9;  // scaler4 result;

wire                        ddr3_sclk;

wire                        ddr3_ch00_ack               ;
wire                        ddr3_ch00_op_done           ;
wire                        ddr3_ch00_req               ;
wire                        ddr3_ch00_ram_rd_en         ;
wire    [15:0]              ddr3_ch00_priority          ;
wire    [15:0]              ddr3_ch00_data_length       ;
wire    [ADDR_WIDTH-1:0]    ddr3_ch00_start_addr        ;
wire    [DATA_WIDTH-1:0]    ddr3_ch00_ram_rd_data       ;
wire    [1:0]               ddr3_sub_space0_frame_num   ;
wire                        ddr3_init_done              ;
assign  o_ddr3_init_done  = ddr3_init_done              ;
assign  o_ddr3_sclk       = ddr3_sclk                   ;

wire    [ 3:0]              scaler_00_ddr_base_addr     =   (i_scaler_00_source_sel == 3'd0) ? SUB_SPACE0_DDR_BASE_ADDR :
                                                            (i_scaler_00_source_sel == 3'd1) ? SUB_SPACE1_DDR_BASE_ADDR :
                                                            (i_scaler_00_source_sel == 3'd2) ? SUB_SPACE2_DDR_BASE_ADDR :
                                                            (i_scaler_00_source_sel == 3'd3) ? SUB_SPACE3_DDR_BASE_ADDR :
                                                                                               SUB_SPACE4_DDR_BASE_ADDR ;
wire    [ 3:0]              scaler_01_ddr_base_addr     =   (i_scaler_01_source_sel == 3'd0) ? SUB_SPACE0_DDR_BASE_ADDR :
                                                            (i_scaler_01_source_sel == 3'd1) ? SUB_SPACE1_DDR_BASE_ADDR :
                                                            (i_scaler_01_source_sel == 3'd2) ? SUB_SPACE2_DDR_BASE_ADDR :
                                                            (i_scaler_01_source_sel == 3'd3) ? SUB_SPACE3_DDR_BASE_ADDR :
                                                                                               SUB_SPACE4_DDR_BASE_ADDR ;
wire    [ 3:0]              scaler_02_ddr_base_addr     =   (i_scaler_02_source_sel == 3'd0) ? SUB_SPACE0_DDR_BASE_ADDR :
                                                            (i_scaler_02_source_sel == 3'd1) ? SUB_SPACE1_DDR_BASE_ADDR :
                                                            (i_scaler_02_source_sel == 3'd2) ? SUB_SPACE2_DDR_BASE_ADDR :
                                                            (i_scaler_02_source_sel == 3'd3) ? SUB_SPACE3_DDR_BASE_ADDR :
                                                                                               SUB_SPACE4_DDR_BASE_ADDR ;
wire    [ 3:0]              scaler_03_ddr_base_addr     =   (i_scaler_03_source_sel == 3'd0) ? SUB_SPACE0_DDR_BASE_ADDR :
                                                            (i_scaler_03_source_sel == 3'd1) ? SUB_SPACE1_DDR_BASE_ADDR :
                                                            (i_scaler_03_source_sel == 3'd2) ? SUB_SPACE2_DDR_BASE_ADDR :
                                                            (i_scaler_03_source_sel == 3'd3) ? SUB_SPACE3_DDR_BASE_ADDR :
                                                                                               SUB_SPACE4_DDR_BASE_ADDR ;
wire    [ 3:0]              scaler_04_ddr_base_addr     =   (i_scaler_04_source_sel == 3'd0) ? SUB_SPACE0_DDR_BASE_ADDR :
                                                            (i_scaler_04_source_sel == 3'd1) ? SUB_SPACE1_DDR_BASE_ADDR :
                                                            (i_scaler_04_source_sel == 3'd2) ? SUB_SPACE2_DDR_BASE_ADDR :
                                                            (i_scaler_04_source_sel == 3'd3) ? SUB_SPACE3_DDR_BASE_ADDR :
                                                                                               SUB_SPACE4_DDR_BASE_ADDR ;
ddr3_vpi_chn_manager
#(
    .DATA_WIDTH          (DATA_WIDTH),
    .ADDR_WIDTH          (ADDR_WIDTH)
)
ddr3_chn00_vpi00_sdi0(
.i_rst_n                 ( i_rst_n && ddr3_init_done                 ),
.i_soft_rst              ( i_soft_rst                                ),
.i_vpi_pix_clk           ( i_vpi_00_pix_clk                          ),
.i_vpi_vs                ( i_vpi_00_vs                               ),
.i_vpi_de                ( i_vpi_00_de                               ),
.i_vpi_data_en           ( i_vpi_00_data_en                          ),
.i_vpi_pix_data          ( i_vpi_00_pix_data[15:0]                   ),
.i_sub_space_num         ( SUB_SPACE0_DDR_BASE_ADDR                  ),
.i_save_numb             ( i_vpi_00_save_numb[11:0]                  ),
.i_ddr_vpi_prio_ini_vld  ( i_vpi_00_prio_ini_vld                     ),
.i_ddr_vpi_prio_ini      ( i_vpi_00_prio_ini                         ),
.o_ddr_vpi_priority      ( ddr3_ch00_priority                        ),
.i_ddr_clk               ( ddr3_sclk                                 ),
.i_ddr_vpi_ack           ( ddr3_ch00_ack                             ),
.i_ddr_vpi_wdata_rdy     ( ddr3_ch00_ram_rd_en                       ),
.i_ddr_wr_done           ( ddr3_ch00_op_done                         ),
.o_ddr_vpi_req           ( ddr3_ch00_req                             ),
.o_ddr_req_lose          ( o_ddr_req_lose[0]                         ),
.o_ddr_vpi_data_length   ( ddr3_ch00_data_length[11:0]               ),
.o_frame_numb            ( ddr3_sub_space0_frame_num[1:0]            ),
.o_ddr_vpi_start_addr    ( ddr3_ch00_start_addr[ADDR_WIDTH-1:0]      ),
.o_ddr_vpi_wdata         ( ddr3_ch00_ram_rd_data[DATA_WIDTH-1:0]     )
);

wire                        ddr3_ch01_ack               ;
wire                        ddr3_ch01_op_done           ;
wire                        ddr3_ch01_req               ;
wire                        ddr3_ch01_ram_rd_en         ;
wire    [15:0]              ddr3_ch01_priority          ;
wire    [15:0]              ddr3_ch01_data_length       ;
wire    [ADDR_WIDTH-1:0]    ddr3_ch01_start_addr        ;
wire    [DATA_WIDTH-1:0]    ddr3_ch01_ram_rd_data       ;
wire    [1:0]               ddr3_sub_space1_frame_num   ;

ddr3_vpi_chn_manager
#(
    .DATA_WIDTH          (DATA_WIDTH),
    .ADDR_WIDTH          (ADDR_WIDTH)
)
ddr3_chn01_vpi01_sdi1(
.i_rst_n                 ( i_rst_n && ddr3_init_done                 ),
.i_soft_rst              ( i_soft_rst                                ),
.i_vpi_pix_clk           ( i_vpi_01_pix_clk                          ),
.i_vpi_vs                ( i_vpi_01_vs                               ),
.i_vpi_de                ( i_vpi_01_de                               ),
.i_vpi_data_en           ( i_vpi_01_data_en                          ),
.i_vpi_pix_data          ( i_vpi_01_pix_data[15:0]                   ),
.i_sub_space_num         ( SUB_SPACE1_DDR_BASE_ADDR                  ),
.i_save_numb             ( i_vpi_01_save_numb[11:0]                  ),
.i_ddr_vpi_prio_ini_vld  ( i_vpi_01_prio_ini_vld                     ),
.i_ddr_vpi_prio_ini      ( i_vpi_01_prio_ini                         ),
.o_ddr_vpi_priority      ( ddr3_ch01_priority                        ),
.i_ddr_clk               ( ddr3_sclk                                 ),
.i_ddr_vpi_ack           ( ddr3_ch01_ack                             ),
.i_ddr_vpi_wdata_rdy     ( ddr3_ch01_ram_rd_en                       ),
.i_ddr_wr_done           ( ddr3_ch01_op_done                         ),
.o_ddr_vpi_req           ( ddr3_ch01_req                             ),
.o_ddr_req_lose          ( o_ddr_req_lose[1]                         ),
.o_ddr_vpi_data_length   ( ddr3_ch01_data_length[11:0]               ),
.o_frame_numb            ( ddr3_sub_space1_frame_num[1:0]            ),
.o_ddr_vpi_start_addr    ( ddr3_ch01_start_addr[ADDR_WIDTH-1:0]      ),
.o_ddr_vpi_wdata         ( ddr3_ch01_ram_rd_data[DATA_WIDTH-1:0]     )
);

wire                        ddr3_ch02_ack               ;
wire                        ddr3_ch02_op_done           ;
wire                        ddr3_ch02_req               ;
wire                        ddr3_ch02_ram_rd_en         ;
wire    [15:0]              ddr3_ch02_priority          ;
wire    [15:0]              ddr3_ch02_data_length       ;
wire    [ADDR_WIDTH-1:0]    ddr3_ch02_start_addr        ;
wire    [DATA_WIDTH-1:0]    ddr3_ch02_ram_rd_data       ;
wire    [1:0]               ddr3_sub_space2_frame_num   ;

ddr3_vpi_chn_manager
#(
    .DATA_WIDTH          (DATA_WIDTH),
    .ADDR_WIDTH          (ADDR_WIDTH)
)
ddr3_chn02_vpi02_sdi2(
.i_rst_n                 ( i_rst_n && ddr3_init_done                 ),
.i_soft_rst              ( i_soft_rst                                ),
.i_vpi_pix_clk           ( i_vpi_02_pix_clk                          ),
.i_vpi_vs                ( i_vpi_02_vs                               ),
.i_vpi_de                ( i_vpi_02_de                               ),
.i_vpi_data_en           ( i_vpi_02_data_en                          ),
.i_vpi_pix_data          ( i_vpi_02_pix_data[15:0]                   ),
.i_sub_space_num         ( SUB_SPACE2_DDR_BASE_ADDR                  ),
.i_save_numb             ( i_vpi_02_save_numb[11:0]                  ),
.i_ddr_vpi_prio_ini_vld  ( i_vpi_02_prio_ini_vld                     ),
.i_ddr_vpi_prio_ini      ( i_vpi_02_prio_ini                         ),
.o_ddr_vpi_priority      ( ddr3_ch02_priority                        ),
.i_ddr_clk               ( ddr3_sclk                                 ),
.i_ddr_vpi_ack           ( ddr3_ch02_ack                             ),
.i_ddr_vpi_wdata_rdy     ( ddr3_ch02_ram_rd_en                       ),
.i_ddr_wr_done           ( ddr3_ch02_op_done                         ),
.o_ddr_vpi_req           ( ddr3_ch02_req                             ),
.o_ddr_req_lose          ( o_ddr_req_lose[2]                         ),
.o_ddr_vpi_data_length   ( ddr3_ch02_data_length[11:0]               ),
.o_frame_numb            ( ddr3_sub_space2_frame_num[1:0]            ),
.o_ddr_vpi_start_addr    ( ddr3_ch02_start_addr[ADDR_WIDTH-1:0]      ),
.o_ddr_vpi_wdata         ( ddr3_ch02_ram_rd_data[DATA_WIDTH-1:0]     )
);


wire                        ddr3_ch03_ack               ;
wire                        ddr3_ch03_op_done           ;
wire                        ddr3_ch03_req               ;
wire                        ddr3_ch03_ram_rd_en         ;
wire    [15:0]              ddr3_ch03_priority          ;
wire    [15:0]              ddr3_ch03_data_length       ;
wire    [ADDR_WIDTH-1:0]    ddr3_ch03_start_addr        ;
wire    [DATA_WIDTH-1:0]    ddr3_ch03_ram_rd_data       ;
wire    [1:0]               ddr3_sub_space3_frame_num   ;

ddr3_vpi_chn_manager
#(
    .DATA_WIDTH          (DATA_WIDTH),
    .ADDR_WIDTH          (ADDR_WIDTH)
)
ddr3_chn03_vpi03_sdi3(
.i_rst_n                 ( i_rst_n && ddr3_init_done                 ),
.i_soft_rst              ( i_soft_rst                                ),
.i_vpi_pix_clk           ( i_vpi_03_pix_clk                          ),
.i_vpi_vs                ( i_vpi_03_vs                               ),
.i_vpi_de                ( i_vpi_03_de                               ),
.i_vpi_data_en           ( i_vpi_03_data_en                          ),
.i_vpi_pix_data          ( i_vpi_03_pix_data[15:0]                   ),
.i_sub_space_num         ( SUB_SPACE3_DDR_BASE_ADDR                  ),
.i_save_numb             ( i_vpi_03_save_numb[11:0]                  ),
.i_ddr_vpi_prio_ini_vld  ( i_vpi_03_prio_ini_vld                     ),
.i_ddr_vpi_prio_ini      ( i_vpi_03_prio_ini                         ),
.o_ddr_vpi_priority      ( ddr3_ch03_priority                        ),
.i_ddr_clk               ( ddr3_sclk                                 ),
.i_ddr_vpi_ack           ( ddr3_ch03_ack                             ),
.i_ddr_vpi_wdata_rdy     ( ddr3_ch03_ram_rd_en                       ),
.i_ddr_wr_done           ( ddr3_ch03_op_done                         ),
.o_ddr_vpi_req           ( ddr3_ch03_req                             ),
.o_ddr_req_lose          ( o_ddr_req_lose[3]                         ),
.o_ddr_vpi_data_length   ( ddr3_ch03_data_length[11:0]               ),
.o_frame_numb            ( ddr3_sub_space3_frame_num[1:0]            ),
.o_ddr_vpi_start_addr    ( ddr3_ch03_start_addr[ADDR_WIDTH-1:0]      ),
.o_ddr_vpi_wdata         ( ddr3_ch03_ram_rd_data[DATA_WIDTH-1:0]     )
);


wire                        ddr3_ch04_ack               ;
wire                        ddr3_ch04_op_done           ;
wire                        ddr3_ch04_req               ;
wire                        ddr3_ch04_ram_rd_en         ;
wire    [15:0]              ddr3_ch04_priority          ;
wire    [15:0]              ddr3_ch04_data_length       ;
wire    [ADDR_WIDTH-1:0]    ddr3_ch04_start_addr        ;
wire    [DATA_WIDTH-1:0]    ddr3_ch04_ram_rd_data       ;
wire    [1:0]               ddr3_sub_space4_frame_num   ;

ddr3_vpi_chn_manager
#(
    .DATA_WIDTH          (DATA_WIDTH),
    .ADDR_WIDTH          (ADDR_WIDTH)
)
ddr3_chn04_vpi04_serdes(
.i_rst_n                 ( i_rst_n && ddr3_init_done                 ),
.i_soft_rst              ( i_soft_rst                                ),
.i_vpi_pix_clk           ( i_vpi_04_pix_clk                          ),
.i_vpi_vs                ( i_vpi_04_vs                               ),
.i_vpi_de                ( i_vpi_04_de                               ),
.i_vpi_data_en           ( i_vpi_04_data_en                          ),
.i_vpi_pix_data          ( i_vpi_04_pix_data[15:0]                   ),
.i_sub_space_num         ( SUB_SPACE4_DDR_BASE_ADDR                  ),
.i_save_numb             ( i_vpi_04_save_numb[11:0]                  ),
.i_ddr_vpi_prio_ini_vld  ( i_vpi_04_prio_ini_vld                     ),
.i_ddr_vpi_prio_ini      ( i_vpi_04_prio_ini                         ),
.o_ddr_vpi_priority      ( ddr3_ch04_priority                        ),
.i_ddr_clk               ( ddr3_sclk                                 ),
.i_ddr_vpi_ack           ( ddr3_ch04_ack                             ),
.i_ddr_vpi_wdata_rdy     ( ddr3_ch04_ram_rd_en                       ),
.i_ddr_wr_done           ( ddr3_ch04_op_done                         ),
.o_ddr_vpi_req           ( ddr3_ch04_req                             ),
.o_ddr_req_lose          ( o_ddr_req_lose[4]                         ),
.o_ddr_vpi_data_length   ( ddr3_ch04_data_length[11:0]               ),
.o_frame_numb            ( ddr3_sub_space4_frame_num[1:0]            ),
.o_ddr_vpi_start_addr    ( ddr3_ch04_start_addr[ADDR_WIDTH-1:0]      ),
.o_ddr_vpi_wdata         ( ddr3_ch04_ram_rd_data[DATA_WIDTH-1:0]     )
);


wire                        ddr3_ch05_ack               ;
wire                        ddr3_ch05_op_done           ;
wire                        ddr3_ch05_req               ;
wire                        ddr3_ch05_ram_rd_en         ;
wire    [15:0]              ddr3_ch05_priority          ;
wire    [15:0]              ddr3_ch05_data_length       ;
wire    [ADDR_WIDTH-1:0]    ddr3_ch05_start_addr        ;
wire    [DATA_WIDTH-1:0]    ddr3_ch05_ram_rd_data       ;
wire    [1:0]               ddr3_sub_space5_frame_num   ;

ddr3_vpi_chn_manager
#(
    .DATA_WIDTH          (DATA_WIDTH),
    .ADDR_WIDTH          (ADDR_WIDTH)
)
ddr3_chn05_vpi05_scaler0_res(
.i_rst_n                 ( i_rst_n && ddr3_init_done                 ),
.i_soft_rst              ( i_soft_rst                                ),
.i_vpi_pix_clk           ( i_vpi_05_pix_clk                          ),
.i_sub_space_num         ( SUB_SPACE5_DDR_BASE_ADDR                  ),
.i_vpi_vs                ( i_vpi_05_vs                               ),
.i_vpi_de                ( i_vpi_05_de                               ),
.i_vpi_data_en           ( i_vpi_05_data_en                          ),
.i_vpi_pix_data          ( i_vpi_05_pix_data[15:0]                   ),
.i_save_numb             ( i_vpi_05_save_numb[11:0]                  ),
.i_ddr_vpi_prio_ini_vld  ( i_vpi_05_prio_ini_vld                     ),
.i_ddr_vpi_prio_ini      ( i_vpi_05_prio_ini                         ),
.i_ddr_clk               ( ddr3_sclk                                 ),
.o_ddr_req_lose          ( o_ddr_req_lose[5]                         ),
.o_frame_numb            ( ddr3_sub_space5_frame_num[1:0]            ),
.o_ddr_vpi_priority      ( ddr3_ch05_priority                        ),
.i_ddr_vpi_ack           ( ddr3_ch05_ack                             ),
.i_ddr_vpi_wdata_rdy     ( ddr3_ch05_ram_rd_en                       ),
.i_ddr_wr_done           ( ddr3_ch05_op_done                         ),
.o_ddr_vpi_req           ( ddr3_ch05_req                             ),
.o_ddr_vpi_data_length   ( ddr3_ch05_data_length[11:0]               ),
.o_ddr_vpi_start_addr    ( ddr3_ch05_start_addr[ADDR_WIDTH-1:0]      ),
.o_ddr_vpi_wdata         ( ddr3_ch05_ram_rd_data[DATA_WIDTH-1:0]     )
);


wire                        ddr3_ch06_ack               ;
wire                        ddr3_ch06_op_done           ;
wire                        ddr3_ch06_req               ;
wire                        ddr3_ch06_ram_rd_en         ;
wire    [15:0]              ddr3_ch06_priority          ;
wire    [15:0]              ddr3_ch06_data_length       ;
wire    [ADDR_WIDTH-1:0]    ddr3_ch06_start_addr        ;
wire    [DATA_WIDTH-1:0]    ddr3_ch06_ram_rd_data       ;
wire    [1:0]               ddr3_sub_space6_frame_num   ;

ddr3_vpi_chn_manager
#(
    .DATA_WIDTH          (DATA_WIDTH),
    .ADDR_WIDTH          (ADDR_WIDTH)
)
ddr3_chn06_vpi06_scaler1_res(
.i_rst_n                 ( i_rst_n && ddr3_init_done                 ),
.i_soft_rst              ( i_soft_rst                                ),
.i_vpi_pix_clk           ( i_vpi_06_pix_clk                          ),
.i_sub_space_num         ( SUB_SPACE6_DDR_BASE_ADDR                  ),
.i_vpi_vs                ( i_vpi_06_vs                               ),
.i_vpi_de                ( i_vpi_06_de                               ),
.i_vpi_data_en           ( i_vpi_06_data_en                          ),
.i_vpi_pix_data          ( i_vpi_06_pix_data[15:0]                   ),
.i_save_numb             ( i_vpi_06_save_numb[11:0]                  ),
.i_ddr_vpi_prio_ini_vld  ( i_vpi_06_prio_ini_vld                     ),
.i_ddr_vpi_prio_ini      ( i_vpi_06_prio_ini                         ),
.i_ddr_clk               ( ddr3_sclk                                 ),
.o_ddr_req_lose          ( o_ddr_req_lose[6]                         ),
.o_frame_numb            ( ddr3_sub_space6_frame_num[1:0]            ),
.o_ddr_vpi_priority      ( ddr3_ch06_priority                        ),
.i_ddr_vpi_ack           ( ddr3_ch06_ack                             ),
.i_ddr_vpi_wdata_rdy     ( ddr3_ch06_ram_rd_en                       ),
.i_ddr_wr_done           ( ddr3_ch06_op_done                         ),
.o_ddr_vpi_req           ( ddr3_ch06_req                             ),
.o_ddr_vpi_data_length   ( ddr3_ch06_data_length[11:0]               ),
.o_ddr_vpi_start_addr    ( ddr3_ch06_start_addr[ADDR_WIDTH-1:0]      ),
.o_ddr_vpi_wdata         ( ddr3_ch06_ram_rd_data[DATA_WIDTH-1:0]     )
);



wire                        ddr3_ch07_ack               ;
wire                        ddr3_ch07_op_done           ;
wire                        ddr3_ch07_req               ;
wire                        ddr3_ch07_ram_rd_en         ;
wire    [15:0]              ddr3_ch07_priority          ;
wire    [15:0]              ddr3_ch07_data_length       ;
wire    [ADDR_WIDTH-1:0]    ddr3_ch07_start_addr        ;
wire    [DATA_WIDTH-1:0]    ddr3_ch07_ram_rd_data       ;
wire    [1:0]               ddr3_sub_space7_frame_num   ;


ddr3_vpi_chn_manager
#(
    .DATA_WIDTH          (DATA_WIDTH),
    .ADDR_WIDTH          (ADDR_WIDTH)
)
ddr3_chn07_vpi07_scaler2_res(
.i_rst_n                 ( i_rst_n && ddr3_init_done                 ),
.i_soft_rst              ( i_soft_rst                                ),
.i_vpi_pix_clk           ( i_vpi_07_pix_clk                          ),
.i_sub_space_num         ( SUB_SPACE7_DDR_BASE_ADDR                  ),
.i_vpi_vs                ( i_vpi_07_vs                               ),
.i_vpi_de                ( i_vpi_07_de                               ),
.i_vpi_data_en           ( i_vpi_07_data_en                          ),
.i_vpi_pix_data          ( i_vpi_07_pix_data[15:0]                   ),
.i_save_numb             ( i_vpi_07_save_numb[11:0]                  ),
.i_ddr_vpi_prio_ini_vld  ( i_vpi_07_prio_ini_vld                     ),
.i_ddr_vpi_prio_ini      ( i_vpi_07_prio_ini                         ),
.i_ddr_clk               ( ddr3_sclk                                 ),
.o_ddr_req_lose          ( o_ddr_req_lose[7]                         ),
.o_frame_numb            ( ddr3_sub_space7_frame_num[1:0]            ),
.o_ddr_vpi_priority      ( ddr3_ch07_priority                        ),
.i_ddr_vpi_ack           ( ddr3_ch07_ack                             ),
.i_ddr_vpi_wdata_rdy     ( ddr3_ch07_ram_rd_en                       ),
.i_ddr_wr_done           ( ddr3_ch07_op_done                         ),
.o_ddr_vpi_req           ( ddr3_ch07_req                             ),
.o_ddr_vpi_data_length   ( ddr3_ch07_data_length[11:0]               ),
.o_ddr_vpi_start_addr    ( ddr3_ch07_start_addr[ADDR_WIDTH-1:0]      ),
.o_ddr_vpi_wdata         ( ddr3_ch07_ram_rd_data[DATA_WIDTH-1:0]     )
);




wire                        ddr3_ch08_ack               ;
wire                        ddr3_ch08_op_done           ;
wire                        ddr3_ch08_req               ;
wire                        ddr3_ch08_ram_rd_en         ;
wire    [15:0]              ddr3_ch08_priority          ;
wire    [15:0]              ddr3_ch08_data_length       ;
wire    [ADDR_WIDTH-1:0]    ddr3_ch08_start_addr        ;
wire    [DATA_WIDTH-1:0]    ddr3_ch08_ram_rd_data       ;
wire    [1:0]               ddr3_sub_space8_frame_num   ;

ddr3_vpi_chn_manager
#(
    .DATA_WIDTH          (DATA_WIDTH),
    .ADDR_WIDTH          (ADDR_WIDTH)
)
ddr3_chn08_vpi08_scaler3_res(
.i_rst_n                 ( i_rst_n && ddr3_init_done                 ),
.i_soft_rst              ( i_soft_rst                                ),
.i_vpi_pix_clk           ( i_vpi_08_pix_clk                          ),
.i_sub_space_num         ( SUB_SPACE8_DDR_BASE_ADDR                  ),
.i_vpi_vs                ( i_vpi_08_vs                               ),
.i_vpi_de                ( i_vpi_08_de                               ),
.i_vpi_data_en           ( i_vpi_08_data_en                          ),
.i_vpi_pix_data          ( i_vpi_08_pix_data[15:0]                   ),
.i_save_numb             ( i_vpi_08_save_numb[11:0]                  ),
.i_ddr_vpi_prio_ini_vld  ( i_vpi_08_prio_ini_vld                     ),
.i_ddr_vpi_prio_ini      ( i_vpi_08_prio_ini                         ),
.i_ddr_clk               ( ddr3_sclk                                 ),
.o_ddr_req_lose          ( o_ddr_req_lose[8]                         ),
.o_frame_numb            ( ddr3_sub_space8_frame_num[1:0]            ),
.o_ddr_vpi_priority      ( ddr3_ch08_priority                        ),
.i_ddr_vpi_ack           ( ddr3_ch08_ack                             ),
.i_ddr_vpi_wdata_rdy     ( ddr3_ch08_ram_rd_en                       ),
.i_ddr_wr_done           ( ddr3_ch08_op_done                         ),
.o_ddr_vpi_req           ( ddr3_ch08_req                             ),
.o_ddr_vpi_data_length   ( ddr3_ch08_data_length[11:0]               ),
.o_ddr_vpi_start_addr    ( ddr3_ch08_start_addr[ADDR_WIDTH-1:0]      ),
.o_ddr_vpi_wdata         ( ddr3_ch08_ram_rd_data[DATA_WIDTH-1:0]     )
);


wire                        ddr3_ch09_ack               ;
wire                        ddr3_ch09_op_done           ;
wire                        ddr3_ch09_req   = 1'b0      ;
wire                        ddr3_ch09_ram_rd_en         ;
wire    [15:0]              ddr3_ch09_priority          ;
wire    [15:0]              ddr3_ch09_data_length       ;
wire    [ADDR_WIDTH-1:0]    ddr3_ch09_start_addr        ;
wire    [DATA_WIDTH-1:0]    ddr3_ch09_ram_rd_data       ;
wire    [1:0]               ddr3_sub_space9_frame_num   ;
/*
ddr3_vpi_chn_manager
#(
    .DATA_WIDTH          (DATA_WIDTH),
    .ADDR_WIDTH          (ADDR_WIDTH)
)
ddr3_chn09_vpi09_scaler4_res(
.i_rst_n                 ( i_rst_n && ddr3_init_done                 ),
.i_soft_rst              ( i_soft_rst                                ),
.i_vpi_pix_clk           ( i_vpi_09_pix_clk                          ),
.i_sub_space_num         ( SUB_SPACE9_DDR_BASE_ADDR                  ),
.i_vpi_vs                ( i_vpi_09_vs                               ),
.i_vpi_de                ( i_vpi_09_de                               ),
.i_vpi_data_en           ( i_vpi_09_data_en                          ),
.i_vpi_pix_data          ( i_vpi_09_pix_data[15:0]                   ),
.i_save_numb             ( i_vpi_09_save_numb[11:0]                  ),
.i_ddr_vpi_prio_ini_vld  ( i_vpi_09_prio_ini_vld                     ),
.i_ddr_vpi_prio_ini      ( i_vpi_09_prio_ini                         ),
.i_ddr_clk               ( ddr3_sclk                                 ),
.o_ddr_req_lose          ( o_ddr_req_lose[9]                         ),
.o_frame_numb            ( ddr3_sub_space9_frame_num[1:0]            ),
.o_ddr_vpi_priority      ( ddr3_ch09_priority                        ),
.i_ddr_vpi_ack           ( ddr3_ch09_ack                             ),
.i_ddr_vpi_wdata_rdy     ( ddr3_ch09_ram_rd_en                       ),
.i_ddr_wr_done           ( ddr3_ch09_op_done                         ),
.o_ddr_vpi_req           ( ddr3_ch09_req                             ),
.o_ddr_vpi_data_length   ( ddr3_ch09_data_length[11:0]               ),
.o_ddr_vpi_start_addr    ( ddr3_ch09_start_addr[ADDR_WIDTH-1:0]      ),
.o_ddr_vpi_wdata         ( ddr3_ch09_ram_rd_data[DATA_WIDTH-1:0]     )
);
*/



wire                        ddr3_ch10_ack               ;
wire                        ddr3_ch10_op_done           ;
wire                        ddr3_ch10_req               ;
wire                        ddr3_ch10_ram_wr_en         ;
wire    [15:0]              ddr3_ch10_priority          ;
wire    [15:0]              ddr3_ch10_data_length       ;
wire    [ADDR_WIDTH-1:0]    ddr3_ch10_start_addr        ;
wire    [DATA_WIDTH-1:0]    ddr3_ch10_ram_wr_data       ;

ddr3_vpo_chn_manager_mul_rd#(
    .DATA_WIDTH (DATA_WIDTH),
    .ADDR_WIDTH (ADDR_WIDTH)
)
ddr3_chn10_vpo00_scaler0_ori(
.i_rst_n                 ( i_rst_n && ddr3_init_done             ),
.i_soft_rst              ( i_soft_rst                            ),
.i_vpo_pix_clk           ( i_vpo_00_pix_clk                      ),
.i_vpo_vs                ( i_vpo_00_vs                           ),
.i_vpo_de                ( i_vpo_00_de                           ),
.i_vpo_data_en           ( 1'b1                                  ),
.o_vpo_pix_data          ( o_vpo_00_pix_data[15:0]               ),
.i_sub_space_num         ( scaler_00_ddr_base_addr               ),
.i_read_numb             ( i_vpo_00_read_numb[11:0]              ),
.i_ram_rd_addr_clear     ( i_vpo_00_ram_rd_addr_clear            ),
.i_start_row_numb        ( i_vpo_00_start_row_numb[11:0]         ),
.i_start_col_numb        ( i_vpo_00_start_col_numb[11:0]         ),
.i_ddr_vpo_prio_ini_vld  ( i_vpo_00_prio_ini_vld                 ),
.i_ddr_vpo_prio_ini      ( i_vpo_00_prio_ini[15:0]               ),
.o_ddr_vpo_priority      ( ddr3_ch10_priority[15:0]              ),
.i_ddr_clk               ( ddr3_sclk                             ),
.i_ddr_vpo_ack           ( ddr3_ch10_ack                         ),
.i_ddr_vpo_rdata_vld     ( ddr3_ch10_ram_wr_en                   ),
.i_ddr_rd_done           ( ddr3_ch10_op_done                     ),
.i_frame_numb            ( ddr3_sub_space0_frame_num[1:0]        ),
.i_ddr_vpo_wdata         ( ddr3_ch10_ram_wr_data[DATA_WIDTH-1:0] ),
.o_ddr_vpo_req           ( ddr3_ch10_req                         ),
.o_ddr_req_lose          ( o_ddr_req_lose[10]                    ),
.o_ddr_vpo_data_length   ( ddr3_ch10_data_length[11:0]           ),
.o_ddr_vpo_start_addr    ( ddr3_ch10_start_addr[ADDR_WIDTH-1:0]  )

);



wire                        ddr3_ch11_ack               ;
wire                        ddr3_ch11_op_done           ;
wire                        ddr3_ch11_req               ;
wire                        ddr3_ch11_ram_wr_en         ;
wire    [15:0]              ddr3_ch11_priority          ;
wire    [15:0]              ddr3_ch11_data_length       ;
wire    [ADDR_WIDTH-1:0]    ddr3_ch11_start_addr        ;
wire    [DATA_WIDTH-1:0]    ddr3_ch11_ram_wr_data       ;

ddr3_vpo_chn_manager_mul_rd#(
    .DATA_WIDTH (DATA_WIDTH),
    .ADDR_WIDTH (ADDR_WIDTH)
)
ddr3_chn11_vpo01_scaler1_ori(
.i_rst_n                 ( i_rst_n && ddr3_init_done             ),
.i_soft_rst              ( i_soft_rst                            ),
.i_vpo_pix_clk           ( i_vpo_01_pix_clk                      ),
.i_vpo_vs                ( i_vpo_01_vs                           ),
.i_vpo_de                ( i_vpo_01_de                           ),
.i_vpo_data_en           ( 1'b1                                  ),
.o_vpo_pix_data          ( o_vpo_01_pix_data[15:0]               ),
.i_sub_space_num         ( scaler_01_ddr_base_addr               ),
.i_read_numb             ( i_vpo_01_read_numb[11:0]              ),
.i_ram_rd_addr_clear     ( i_vpo_01_ram_rd_addr_clear            ),
.i_start_row_numb        ( i_vpo_01_start_row_numb[11:0]         ),
.i_start_col_numb        ( i_vpo_01_start_col_numb[11:0]         ),
.i_ddr_vpo_prio_ini_vld  ( i_vpo_01_prio_ini_vld                 ),
.i_ddr_vpo_prio_ini      ( i_vpo_01_prio_ini[15:0]               ),
.o_ddr_vpo_priority      ( ddr3_ch11_priority[15:0]              ),
.i_ddr_clk               ( ddr3_sclk                             ),
.i_ddr_vpo_ack           ( ddr3_ch11_ack                         ),
.i_ddr_vpo_rdata_vld     ( ddr3_ch11_ram_wr_en                   ),
.i_ddr_rd_done           ( ddr3_ch11_op_done                     ),
.i_frame_numb            ( ddr3_sub_space1_frame_num[1:0]        ),
.i_ddr_vpo_wdata         ( ddr3_ch11_ram_wr_data[DATA_WIDTH-1:0] ),
.o_ddr_vpo_req           ( ddr3_ch11_req                         ),
.o_ddr_req_lose          ( o_ddr_req_lose[11]                    ),
.o_ddr_vpo_data_length   ( ddr3_ch11_data_length[11:0]           ),
.o_ddr_vpo_start_addr    ( ddr3_ch11_start_addr[ADDR_WIDTH-1:0]  )

);


wire                        ddr3_ch12_ack               ;
wire                        ddr3_ch12_op_done           ;
wire                        ddr3_ch12_req               ;
wire                        ddr3_ch12_ram_wr_en         ;
wire    [15:0]              ddr3_ch12_priority          ;
wire    [15:0]              ddr3_ch12_data_length       ;
wire    [ADDR_WIDTH-1:0]    ddr3_ch12_start_addr        ;
wire    [DATA_WIDTH-1:0]    ddr3_ch12_ram_wr_data       ;

ddr3_vpo_chn_manager_mul_rd#(
    .DATA_WIDTH (DATA_WIDTH),
    .ADDR_WIDTH (ADDR_WIDTH)
)
ddr3_chn12_vpo02_scaler2_ori(
.i_rst_n                 ( i_rst_n && ddr3_init_done             ),
.i_soft_rst              ( i_soft_rst                            ),
.i_vpo_pix_clk           ( i_vpo_02_pix_clk                      ),
.i_vpo_vs                ( i_vpo_02_vs                           ),
.i_vpo_de                ( i_vpo_02_de                           ),
.o_vpo_pix_data          ( o_vpo_02_pix_data[15:0]               ),
.i_read_numb             ( i_vpo_02_read_numb[11:0]              ),
.i_ram_rd_addr_clear     ( i_vpo_02_ram_rd_addr_clear            ),
.i_start_row_numb        ( i_vpo_02_start_row_numb[11:0]         ),
.i_start_col_numb        ( i_vpo_02_start_col_numb[11:0]         ),
.i_ddr_vpo_prio_ini_vld  ( i_vpo_02_prio_ini_vld                 ),
.i_ddr_vpo_prio_ini      ( i_vpo_02_prio_ini[15:0]               ),
.i_vpo_data_en           ( 1'b1                                  ),
.i_ddr_clk               ( ddr3_sclk                             ),
.i_sub_space_num         ( scaler_02_ddr_base_addr               ),
.i_frame_numb            ( ddr3_sub_space2_frame_num[1:0]        ),
.o_ddr_req_lose          ( o_ddr_req_lose[12]                    ),
.o_ddr_vpo_priority      ( ddr3_ch12_priority[15:0]              ),
.i_ddr_vpo_ack           ( ddr3_ch12_ack                         ),
.i_ddr_vpo_rdata_vld     ( ddr3_ch12_ram_wr_en                   ),
.i_ddr_rd_done           ( ddr3_ch12_op_done                     ),
.i_ddr_vpo_wdata         ( ddr3_ch12_ram_wr_data[DATA_WIDTH-1:0] ),
.o_ddr_vpo_req           ( ddr3_ch12_req                         ),
.o_ddr_vpo_data_length   ( ddr3_ch12_data_length[11:0]           ),
.o_ddr_vpo_start_addr    ( ddr3_ch12_start_addr[ADDR_WIDTH-1:0]  )

);


wire                        ddr3_ch13_ack               ;
wire                        ddr3_ch13_op_done           ;
wire                        ddr3_ch13_req               ;
wire                        ddr3_ch13_ram_wr_en         ;
wire    [15:0]              ddr3_ch13_priority          ;
wire    [15:0]              ddr3_ch13_data_length       ;
wire    [ADDR_WIDTH-1:0]    ddr3_ch13_start_addr        ;
wire    [DATA_WIDTH-1:0]    ddr3_ch13_ram_wr_data       ;

ddr3_vpo_chn_manager_mul_rd#(
    .DATA_WIDTH (DATA_WIDTH),
    .ADDR_WIDTH (ADDR_WIDTH)
)
ddr3_chn13_vpo03_scaler3_ori(
.i_rst_n                 ( i_rst_n && ddr3_init_done             ),
.i_soft_rst              ( i_soft_rst                            ),
.i_vpo_pix_clk           ( i_vpo_03_pix_clk                      ),
.i_vpo_vs                ( i_vpo_03_vs                           ),
.i_vpo_de                ( i_vpo_03_de                           ),
.o_vpo_pix_data          ( o_vpo_03_pix_data[15:0]               ),
.i_read_numb             ( i_vpo_03_read_numb[11:0]              ),
.i_ram_rd_addr_clear     ( i_vpo_03_ram_rd_addr_clear            ),
.i_start_row_numb        ( i_vpo_03_start_row_numb[11:0]         ),
.i_start_col_numb        ( i_vpo_03_start_col_numb[11:0]         ),
.i_ddr_vpo_prio_ini_vld  ( i_vpo_03_prio_ini_vld                 ),
.i_ddr_vpo_prio_ini      ( i_vpo_03_prio_ini[15:0]               ),
.i_vpo_data_en           ( 1'b1                                  ),
.i_ddr_clk               ( ddr3_sclk                             ),
.i_sub_space_num         ( scaler_03_ddr_base_addr               ),
.i_frame_numb            ( ddr3_sub_space3_frame_num[1:0]        ),
.o_ddr_req_lose          ( o_ddr_req_lose[13]                    ),
.o_ddr_vpo_priority      ( ddr3_ch13_priority[15:0]              ),
.i_ddr_vpo_ack           ( ddr3_ch13_ack                         ),
.i_ddr_vpo_rdata_vld     ( ddr3_ch13_ram_wr_en                   ),
.i_ddr_rd_done           ( ddr3_ch13_op_done                     ),
.i_ddr_vpo_wdata         ( ddr3_ch13_ram_wr_data[DATA_WIDTH-1:0] ),
.o_ddr_vpo_req           ( ddr3_ch13_req                         ),
.o_ddr_vpo_data_length   ( ddr3_ch13_data_length[11:0]           ),
.o_ddr_vpo_start_addr    ( ddr3_ch13_start_addr[ADDR_WIDTH-1:0]  )

);

wire                        ddr3_ch14_ack               ;
wire                        ddr3_ch14_op_done           ;
wire                        ddr3_ch14_req   = 1'b0      ;
wire                        ddr3_ch14_ram_wr_en         ;
wire    [15:0]              ddr3_ch14_priority          ;
wire    [15:0]              ddr3_ch14_data_length       ;
wire    [ADDR_WIDTH-1:0]    ddr3_ch14_start_addr        ;
wire    [DATA_WIDTH-1:0]    ddr3_ch14_ram_wr_data       ;
/*
ddr3_vpo_chn_manager_mul_rd#(
    .DATA_WIDTH (DATA_WIDTH),
    .ADDR_WIDTH (ADDR_WIDTH)
)
ddr3_chn14_vpo04_scaler4_ori(
.i_rst_n                 ( i_rst_n && ddr3_init_done             ),
.i_soft_rst              ( i_soft_rst                            ),
.i_vpo_pix_clk           ( i_vpo_04_pix_clk                      ),
.i_vpo_vs                ( i_vpo_04_vs                           ),
.i_vpo_de                ( i_vpo_04_de                           ),
.o_vpo_pix_data          ( o_vpo_04_pix_data[15:0]               ),
.i_read_numb             ( i_vpo_04_read_numb[11:0]              ),
.i_ram_rd_addr_clear     ( i_vpo_04_ram_rd_addr_clear            ),
.i_start_row_numb        ( i_vpo_04_start_row_numb[11:0]         ),
.i_start_col_numb        ( i_vpo_04_start_col_numb[11:0]         ),
.i_ddr_vpo_prio_ini_vld  ( i_vpo_04_prio_ini_vld                 ),
.i_ddr_vpo_prio_ini      ( i_vpo_04_prio_ini[15:0]               ),
.i_vpo_data_en           ( 1'b1                                  ),
.i_ddr_clk               ( ddr3_sclk                             ),
.i_sub_space_num         ( scaler_04_ddr_base_addr               ),
.i_frame_numb            ( ddr3_sub_space4_frame_num[1:0]        ),
.o_ddr_req_lose          ( o_ddr_req_lose[14]                    ),
.o_ddr_vpo_priority      ( ddr3_ch14_priority[15:0]              ),
.i_ddr_vpo_ack           ( ddr3_ch14_ack                         ),
.i_ddr_vpo_rdata_vld     ( ddr3_ch14_ram_wr_en                   ),
.i_ddr_rd_done           ( ddr3_ch14_op_done                     ),
.i_ddr_vpo_wdata         ( ddr3_ch14_ram_wr_data[DATA_WIDTH-1:0] ),
.o_ddr_vpo_req           ( ddr3_ch14_req                         ),
.o_ddr_vpo_data_length   ( ddr3_ch14_data_length[11:0]           ),
.o_ddr_vpo_start_addr    ( ddr3_ch14_start_addr[ADDR_WIDTH-1:0]  )

);
*/


wire                        ddr3_ch15_ack               ;
wire                        ddr3_ch15_op_done           ;
wire                        ddr3_ch15_req               ;
wire                        ddr3_ch15_ram_wr_en         ;
wire    [15:0]              ddr3_ch15_priority          ;
wire    [15:0]              ddr3_ch15_data_length       ;
wire    [ADDR_WIDTH-1:0]    ddr3_ch15_start_addr        ;
wire    [DATA_WIDTH-1:0]    ddr3_ch15_ram_wr_data       ;

ddr3_vpo_chn_manager_mul_rd#(
    .DATA_WIDTH (DATA_WIDTH),
    .ADDR_WIDTH (ADDR_WIDTH)
)
ddr3_chn15_vpo05_scaler0_res(
.i_rst_n                 ( i_rst_n && ddr3_init_done             ),
.i_soft_rst              ( i_soft_rst                            ),
.i_vpo_pix_clk           ( i_vpo_05_pix_clk                      ),
.i_vpo_vs                ( i_vpo_05_vs                           ),
.i_vpo_de                ( i_vpo_05_de                           ),
.o_vpo_pix_data          ( o_vpo_05_pix_data[15:0]               ),
.i_read_numb             ( i_vpo_05_read_numb[11:0]              ),
.i_ram_rd_addr_clear     ( i_vpo_05_ram_rd_addr_clear            ),
.i_start_row_numb        ( i_vpo_05_start_row_numb[11:0]         ),
.i_start_col_numb        ( i_vpo_05_start_col_numb[11:0]         ),
.i_ddr_vpo_prio_ini_vld  ( i_vpo_05_prio_ini_vld                 ),
.i_ddr_vpo_prio_ini      ( i_vpo_05_prio_ini[15:0]               ),
.i_vpo_data_en           ( 1'b1                                  ),
.i_ddr_clk               ( ddr3_sclk                             ),
.i_sub_space_num         ( SUB_SPACE5_DDR_BASE_ADDR              ),
.i_frame_numb            ( ddr3_sub_space5_frame_num[1:0]        ),
.o_ddr_req_lose          ( o_ddr_req_lose[15]                    ),
.o_ddr_vpo_priority      ( ddr3_ch15_priority[15:0]              ),
.i_ddr_vpo_ack           ( ddr3_ch15_ack                         ),
.i_ddr_vpo_rdata_vld     ( ddr3_ch15_ram_wr_en                   ),
.i_ddr_rd_done           ( ddr3_ch15_op_done                     ),
.i_ddr_vpo_wdata         ( ddr3_ch15_ram_wr_data[DATA_WIDTH-1:0] ),
.o_ddr_vpo_req           ( ddr3_ch15_req                         ),
.o_ddr_vpo_data_length   ( ddr3_ch15_data_length[11:0]           ),
.o_ddr_vpo_start_addr    ( ddr3_ch15_start_addr[ADDR_WIDTH-1:0]  )

);


wire                        ddr3_ch16_ack               ;
wire                        ddr3_ch16_op_done           ;
wire                        ddr3_ch16_req               ;
wire                        ddr3_ch16_ram_wr_en         ;
wire    [15:0]              ddr3_ch16_priority          ;
wire    [15:0]              ddr3_ch16_data_length       ;
wire    [ADDR_WIDTH-1:0]    ddr3_ch16_start_addr        ;
wire    [DATA_WIDTH-1:0]    ddr3_ch16_ram_wr_data       ;

ddr3_vpo_chn_manager_mul_rd#(
    .DATA_WIDTH (DATA_WIDTH),
    .ADDR_WIDTH (ADDR_WIDTH)
)
ddr3_chn16_vpo06_scaler1_res(
.i_rst_n                 ( i_rst_n && ddr3_init_done             ),
.i_soft_rst              ( i_soft_rst                            ),
.i_vpo_pix_clk           ( i_vpo_06_pix_clk                      ),
.i_vpo_vs                ( i_vpo_06_vs                           ),
.i_vpo_de                ( i_vpo_06_de                           ),
.o_vpo_pix_data          ( o_vpo_06_pix_data[15:0]               ),
.i_read_numb             ( i_vpo_06_read_numb[11:0]              ),
.i_ram_rd_addr_clear     ( i_vpo_06_ram_rd_addr_clear            ),
.i_start_row_numb        ( i_vpo_06_start_row_numb[11:0]         ),
.i_start_col_numb        ( i_vpo_06_start_col_numb[11:0]         ),
.i_ddr_vpo_prio_ini_vld  ( i_vpo_06_prio_ini_vld                 ),
.i_ddr_vpo_prio_ini      ( i_vpo_06_prio_ini[15:0]               ),
.i_vpo_data_en           ( 1'b1                                  ),
.i_ddr_clk               ( ddr3_sclk                             ),
.i_sub_space_num         ( SUB_SPACE6_DDR_BASE_ADDR              ),
.i_frame_numb            ( ddr3_sub_space6_frame_num[1:0]        ),
.o_ddr_req_lose          ( o_ddr_req_lose[16]                    ),
.o_ddr_vpo_priority      ( ddr3_ch16_priority[15:0]              ),
.i_ddr_vpo_ack           ( ddr3_ch16_ack                         ),
.i_ddr_vpo_rdata_vld     ( ddr3_ch16_ram_wr_en                   ),
.i_ddr_rd_done           ( ddr3_ch16_op_done                     ),
.i_ddr_vpo_wdata         ( ddr3_ch16_ram_wr_data[DATA_WIDTH-1:0] ),
.o_ddr_vpo_req           ( ddr3_ch16_req                         ),
.o_ddr_vpo_data_length   ( ddr3_ch16_data_length[11:0]           ),
.o_ddr_vpo_start_addr    ( ddr3_ch16_start_addr[ADDR_WIDTH-1:0]  )

);


wire                        ddr3_ch17_ack               ;
wire                        ddr3_ch17_op_done           ;
wire                        ddr3_ch17_req               ;
wire                        ddr3_ch17_ram_wr_en         ;
wire    [15:0]              ddr3_ch17_priority          ;
wire    [15:0]              ddr3_ch17_data_length       ;
wire    [ADDR_WIDTH-1:0]    ddr3_ch17_start_addr        ;
wire    [DATA_WIDTH-1:0]    ddr3_ch17_ram_wr_data       ;

ddr3_vpo_chn_manager_mul_rd#(
    .DATA_WIDTH (DATA_WIDTH),
    .ADDR_WIDTH (ADDR_WIDTH)
)
ddr3_chn17_vpo07_scaler2_res(
.i_rst_n                 ( i_rst_n && ddr3_init_done             ),
.i_soft_rst              ( i_soft_rst                            ),
.i_vpo_pix_clk           ( i_vpo_07_pix_clk                      ),
.i_vpo_vs                ( i_vpo_07_vs                           ),
.i_vpo_de                ( i_vpo_07_de                           ),
.o_vpo_pix_data          ( o_vpo_07_pix_data[15:0]               ),
.i_read_numb             ( i_vpo_07_read_numb[11:0]              ),
.i_ram_rd_addr_clear     ( i_vpo_07_ram_rd_addr_clear            ),
.i_start_row_numb        ( i_vpo_07_start_row_numb[11:0]         ),
.i_start_col_numb        ( i_vpo_07_start_col_numb[11:0]         ),
.i_ddr_vpo_prio_ini_vld  ( i_vpo_07_prio_ini_vld                 ),
.i_ddr_vpo_prio_ini      ( i_vpo_07_prio_ini[15:0]               ),
.i_vpo_data_en           ( 1'b1                                  ),
.i_ddr_clk               ( ddr3_sclk                             ),
.i_sub_space_num         ( SUB_SPACE7_DDR_BASE_ADDR              ),
.i_frame_numb            ( ddr3_sub_space7_frame_num[1:0]        ),
.o_ddr_req_lose          ( o_ddr_req_lose[17]                    ),
.o_ddr_vpo_priority      ( ddr3_ch17_priority[15:0]              ),
.i_ddr_vpo_ack           ( ddr3_ch17_ack                         ),
.i_ddr_vpo_rdata_vld     ( ddr3_ch17_ram_wr_en                   ),
.i_ddr_rd_done           ( ddr3_ch17_op_done                     ),
.i_ddr_vpo_wdata         ( ddr3_ch17_ram_wr_data[DATA_WIDTH-1:0] ),
.o_ddr_vpo_req           ( ddr3_ch17_req                         ),
.o_ddr_vpo_data_length   ( ddr3_ch17_data_length[11:0]           ),
.o_ddr_vpo_start_addr    ( ddr3_ch17_start_addr[ADDR_WIDTH-1:0]  )

);


wire                        ddr3_ch18_ack               ;
wire                        ddr3_ch18_op_done           ;
wire                        ddr3_ch18_req               ;
wire                        ddr3_ch18_ram_wr_en         ;
wire    [15:0]              ddr3_ch18_priority          ;
wire    [15:0]              ddr3_ch18_data_length       ;
wire    [ADDR_WIDTH-1:0]    ddr3_ch18_start_addr        ;
wire    [DATA_WIDTH-1:0]    ddr3_ch18_ram_wr_data       ;

ddr3_vpo_chn_manager_mul_rd#(
    .DATA_WIDTH (DATA_WIDTH),
    .ADDR_WIDTH (ADDR_WIDTH)
)
ddr3_chn18_vpo08_scaler3_res(
.i_rst_n                 ( i_rst_n && ddr3_init_done             ),
.i_soft_rst              ( i_soft_rst                            ),
.i_vpo_pix_clk           ( i_vpo_08_pix_clk                      ),
.i_vpo_vs                ( i_vpo_08_vs                           ),
.i_vpo_de                ( i_vpo_08_de                           ),
.o_vpo_pix_data          ( o_vpo_08_pix_data[15:0]               ),
.i_read_numb             ( i_vpo_08_read_numb[11:0]              ),
.i_ram_rd_addr_clear     ( i_vpo_08_ram_rd_addr_clear            ),
.i_start_row_numb        ( i_vpo_08_start_row_numb[11:0]         ),
.i_start_col_numb        ( i_vpo_08_start_col_numb[11:0]         ),
.i_ddr_vpo_prio_ini_vld  ( i_vpo_08_prio_ini_vld                 ),
.i_ddr_vpo_prio_ini      ( i_vpo_08_prio_ini[15:0]               ),
.i_vpo_data_en           ( 1'b1                                  ),
.i_ddr_clk               ( ddr3_sclk                             ),
.i_sub_space_num         ( SUB_SPACE8_DDR_BASE_ADDR              ),
.i_frame_numb            ( ddr3_sub_space8_frame_num[1:0]        ),
.o_ddr_req_lose          ( o_ddr_req_lose[18]                    ),
.o_ddr_vpo_priority      ( ddr3_ch18_priority[15:0]              ),
.i_ddr_vpo_ack           ( ddr3_ch18_ack                         ),
.i_ddr_vpo_rdata_vld     ( ddr3_ch18_ram_wr_en                   ),
.i_ddr_rd_done           ( ddr3_ch18_op_done                     ),
.i_ddr_vpo_wdata         ( ddr3_ch18_ram_wr_data[DATA_WIDTH-1:0] ),
.o_ddr_vpo_req           ( ddr3_ch18_req                         ),
.o_ddr_vpo_data_length   ( ddr3_ch18_data_length[11:0]           ),
.o_ddr_vpo_start_addr    ( ddr3_ch18_start_addr[ADDR_WIDTH-1:0]  )

);


wire                        ddr3_ch19_ack               ;
wire                        ddr3_ch19_op_done           ;
wire                        ddr3_ch19_req   = 1'b0      ;
wire                        ddr3_ch19_ram_wr_en         ;
wire    [15:0]              ddr3_ch19_priority          ;
wire    [15:0]              ddr3_ch19_data_length       ;
wire    [ADDR_WIDTH-1:0]    ddr3_ch19_start_addr        ;
wire    [DATA_WIDTH-1:0]    ddr3_ch19_ram_wr_data       ;
/*
ddr3_vpo_chn_manager_mul_rd#(
    .DATA_WIDTH (DATA_WIDTH),
    .ADDR_WIDTH (ADDR_WIDTH)
)
ddr3_chn19_vpo09_scaler4_res(
.i_rst_n                 ( i_rst_n && ddr3_init_done             ),
.i_soft_rst              ( i_soft_rst                            ),
.i_vpo_pix_clk           ( i_vpo_09_pix_clk                      ),
.i_vpo_vs                ( i_vpo_09_vs                           ),
.i_vpo_de                ( i_vpo_09_de                           ),
.o_vpo_pix_data          ( o_vpo_09_pix_data[15:0]               ),
.i_read_numb             ( i_vpo_09_read_numb[11:0]              ),
.i_ram_rd_addr_clear     ( i_vpo_09_ram_rd_addr_clear            ),
.i_start_row_numb        ( i_vpo_09_start_row_numb[11:0]         ),
.i_start_col_numb        ( i_vpo_09_start_col_numb[11:0]         ),
.i_ddr_vpo_prio_ini_vld  ( i_vpo_09_prio_ini_vld                 ),
.i_ddr_vpo_prio_ini      ( i_vpo_09_prio_ini[15:0]               ),
.i_vpo_data_en           ( 1'b1                                  ),
.i_ddr_clk               ( ddr3_sclk                             ),
.i_sub_space_num         ( SUB_SPACE9_DDR_BASE_ADDR              ),
.i_frame_numb            ( ddr3_sub_space9_frame_num[1:0]        ),
.o_ddr_req_lose          ( o_ddr_req_lose[19]                    ),
.o_ddr_vpo_priority      ( ddr3_ch19_priority[15:0]              ),
.i_ddr_vpo_ack           ( ddr3_ch19_ack                         ),
.i_ddr_vpo_rdata_vld     ( ddr3_ch19_ram_wr_en                   ),
.i_ddr_rd_done           ( ddr3_ch19_op_done                     ),
.i_ddr_vpo_wdata         ( ddr3_ch19_ram_wr_data[DATA_WIDTH-1:0] ),
.o_ddr_vpo_req           ( ddr3_ch19_req                         ),
.o_ddr_vpo_data_length   ( ddr3_ch19_data_length[11:0]           ),
.o_ddr_vpo_start_addr    ( ddr3_ch19_start_addr[ADDR_WIDTH-1:0]  )

);
*/

wire                        ddr3_ch20_ack               ;
wire                        ddr3_ch20_op_done           ;
wire                        ddr3_ch20_req               ;
wire                        ddr3_ch20_ram_wr_en         ;
wire    [15:0]              ddr3_ch20_priority          ;
wire    [15:0]              ddr3_ch20_data_length       ;
wire    [ADDR_WIDTH-1:0]    ddr3_ch20_start_addr        ;
wire    [DATA_WIDTH-1:0]    ddr3_ch20_ram_wr_data       ;
wire    [1:0]               serdes_feature_frame_numb   ;

assign    serdes_feature_frame_numb = (i_serdes_feature_select == 4'd0) ? ddr3_sub_space0_frame_num :
                                      (i_serdes_feature_select == 4'd1) ? ddr3_sub_space1_frame_num :
                                      (i_serdes_feature_select == 4'd2) ? ddr3_sub_space2_frame_num :
                                      (i_serdes_feature_select == 4'd3) ? ddr3_sub_space3_frame_num :
                                                                          ddr3_sub_space4_frame_num ;

ddr3_vpo_chn_manager_mul_rd#(
    .DATA_WIDTH (DATA_WIDTH),
    .ADDR_WIDTH (ADDR_WIDTH)
)
ddr3_chn20_vpo10_serdes_feature(
.i_rst_n                 ( i_rst_n && ddr3_init_done             ),
.i_soft_rst              ( i_soft_rst                            ),
.i_vpo_pix_clk           ( i_vpo_10_pix_clk                      ),
.i_vpo_vs                ( i_vpo_10_vs                           ),
.i_vpo_de                ( i_vpo_10_de                           ),
.o_vpo_pix_data          ( o_vpo_10_pix_data[15:0]               ),
.i_read_numb             ( i_vpo_10_read_numb[11:0]              ),
.i_ram_rd_addr_clear     ( i_vpo_10_ram_rd_addr_clear            ),
.i_start_row_numb        ( i_vpo_10_start_row_numb[11:0]         ),
.i_start_col_numb        ( i_vpo_10_start_col_numb[11:0]         ),
.i_ddr_vpo_prio_ini_vld  ( i_vpo_10_prio_ini_vld                 ),
.i_ddr_vpo_prio_ini      ( i_vpo_10_prio_ini[15:0]               ),
.i_vpo_data_en           ( 1'b1                                  ),
.i_ddr_clk               ( ddr3_sclk                             ),
.i_sub_space_num         ( i_serdes_feature_select[3:0]          ),
.i_frame_numb            ( serdes_feature_frame_numb[1:0]        ),
.o_ddr_req_lose          ( o_ddr_req_lose[20]                    ),
.o_ddr_vpo_priority      ( ddr3_ch20_priority[15:0]              ),
.i_ddr_vpo_ack           ( ddr3_ch20_ack                         ),
.i_ddr_vpo_rdata_vld     ( ddr3_ch20_ram_wr_en                   ),
.i_ddr_rd_done           ( ddr3_ch20_op_done                     ),
.i_ddr_vpo_wdata         ( ddr3_ch20_ram_wr_data[DATA_WIDTH-1:0] ),
.o_ddr_vpo_req           ( ddr3_ch20_req                         ),
.o_ddr_vpo_data_length   ( ddr3_ch20_data_length[11:0]           ),
.o_ddr_vpo_start_addr    ( ddr3_ch20_start_addr[ADDR_WIDTH-1:0]  )

);

wire                        ddr3_ch21_ack               ;
wire                        ddr3_ch21_op_done           ;
wire                        ddr3_ch21_req               ;
wire                        ddr3_ch21_ram_wr_en         ;
wire    [15:0]              ddr3_ch21_priority          ;
wire    [15:0]              ddr3_ch21_data_length       ;
wire    [ADDR_WIDTH-1:0]    ddr3_ch21_start_addr        ;
wire    [DATA_WIDTH-1:0]    ddr3_ch21_ram_wr_data       ;
wire    [1:0]               vp_feature_frame_numb       ;

assign    vp_feature_frame_numb = (i_vp_feature_select == 4'd0) ? ddr3_sub_space0_frame_num :
                                  (i_vp_feature_select == 4'd1) ? ddr3_sub_space1_frame_num :
                                  (i_vp_feature_select == 4'd2) ? ddr3_sub_space2_frame_num :
                                  (i_vp_feature_select == 4'd3) ? ddr3_sub_space3_frame_num :
                                                                  ddr3_sub_space4_frame_num ;

ddr3_vpo_chn_manager_mul_rd#(
    .DATA_WIDTH (DATA_WIDTH),
    .ADDR_WIDTH (ADDR_WIDTH)
)
ddr3_chn21_vpo11_vp_feature(
.i_rst_n                 ( i_rst_n && ddr3_init_done             ),
.i_soft_rst              ( i_soft_rst                            ),
.i_vpo_pix_clk           ( i_vpo_11_pix_clk                      ),
.i_vpo_vs                ( i_vpo_11_vs                           ),
.i_vpo_de                ( i_vpo_11_de                           ),
.o_vpo_pix_data          ( o_vpo_11_pix_data[15:0]               ),
.i_read_numb             ( i_vpo_11_read_numb[11:0]              ),
.i_ram_rd_addr_clear     ( i_vpo_11_ram_rd_addr_clear            ),
.i_start_row_numb        ( i_vpo_11_start_row_numb[11:0]         ),
.i_start_col_numb        ( i_vpo_11_start_col_numb[11:0]         ),
.i_ddr_vpo_prio_ini_vld  ( i_vpo_11_prio_ini_vld                 ),
.i_ddr_vpo_prio_ini      ( i_vpo_11_prio_ini[15:0]               ),
.i_vpo_data_en           ( 1'b1                                  ),
.i_ddr_clk               ( ddr3_sclk                             ),
.i_sub_space_num         ( i_vp_feature_select[3:0]              ),
.i_frame_numb            ( vp_feature_frame_numb[1:0]            ),
.o_ddr_req_lose          ( o_ddr_req_lose[21]                    ),
.o_ddr_vpo_priority      ( ddr3_ch21_priority[15:0]              ),
.i_ddr_vpo_ack           ( ddr3_ch21_ack                         ),
.i_ddr_vpo_rdata_vld     ( ddr3_ch21_ram_wr_en                   ),
.i_ddr_rd_done           ( ddr3_ch21_op_done                     ),
.i_ddr_vpo_wdata         ( ddr3_ch21_ram_wr_data[DATA_WIDTH-1:0] ),
.o_ddr_vpo_req           ( ddr3_ch21_req                         ),
.o_ddr_vpo_data_length   ( ddr3_ch21_data_length[11:0]           ),
.o_ddr_vpo_start_addr    ( ddr3_ch21_start_addr[ADDR_WIDTH-1:0]  )

);





ddr3_manager_top
#(
    .DATA_WIDTH          (DATA_WIDTH),
    .ADDR_WIDTH          (ADDR_WIDTH)
)
u_ddr3_manager_top(
.i_ddr3_clk                    ( i_ddr3_clk                            ), // 100M for ddr3-800
.i_ddr3_rst_n                  ( i_rst_n                               ), // reset until init_calib_done
.o_ddr3_sclk                   ( ddr3_sclk                             ), // user interface clock, 200M for ddr3-800.

.o_ddr3_busy                   ( o_ddr3_busy                           ), // high active
.o_ddr3_op_done                ( o_ddr3_op_done                        ), // operate done.pulse
.o_ddr3_init_done              ( ddr3_init_done                        ),
.o_em_ddr_reset_n              ( o_em_ddr_reset_n                      ),
.o_em_ddr_cs_n                 ( o_em_ddr_cs_n                         ),
.o_em_ddr_cke                  ( o_em_ddr_cke                          ),
.o_em_ddr_clk                  ( o_em_ddr_clk                          ),
.io_em_ddr_data                ( io_em_ddr_data[31:0]                  ),
.io_em_ddr_dqs                 ( io_em_ddr_dqs[ 3:0]                   ),
.o_em_ddr_we_n                 ( o_em_ddr_we_n                         ),
.o_em_ddr_cas_n                ( o_em_ddr_cas_n                        ),
.o_em_ddr_ras_n                ( o_em_ddr_ras_n                        ),
.o_em_ddr_ba                   ( o_em_ddr_ba[ 2:0]                     ),
.o_em_ddr_addr                 ( o_em_ddr_addr[ADDR_WIDTH-14:0]        ),
.o_em_ddr_dm                   ( o_em_ddr_dm[ 3:0]                     ),
.o_em_ddr_odt                  ( o_em_ddr_odt                          ),

.i_ddr3_ch00_req               ( ddr3_ch00_req                         ), // request
.i_ddr3_ch00_priority          ( ddr3_ch00_priority[15:0]              ), // priority.0:highest priority
.i_ddr3_ch00_rd_wrn            ( 1'b0                                  ), // 1:read memory;   0:write memory
.i_ddr3_ch00_start_addr        ( ddr3_ch00_start_addr[ADDR_WIDTH-1:0]  ), // start address. 27 bit
.i_ddr3_ch00_length            ( ddr3_ch00_data_length[11:0]           ), // 12bit's num.0~4095
.o_ddr3_ch00_ack               ( ddr3_ch00_ack                         ), // ack
.o_ddr3_ch00_op_done           ( ddr3_ch00_op_done                     ), // operate done
.o_ddr3_ch00_ram_rd_en         ( ddr3_ch00_ram_rd_en                   ), // read data for writing ddr3
.o_ddr3_ch00_ram_rd_en_last    (                                       ), // read data for writing ddr3
.i_ddr3_ch00_ram_rd_data       ( ddr3_ch00_ram_rd_data[DATA_WIDTH-1:0] ), // input data.read data for writing ddr3
.o_ddr3_ch00_ram_wr_en         (                                       ), // write data from reading ddr3
.o_ddr3_ch00_ram_wr_en_last    (                                       ), // write data from reading ddr3
.o_ddr3_ch00_ram_wr_data       (                                       ), // write data from reading ddr3

.i_ddr3_ch01_req               ( ddr3_ch01_req                         ), // request
.i_ddr3_ch01_priority          ( ddr3_ch01_priority[15:0]              ), // priority.0:highest priority
.i_ddr3_ch01_rd_wrn            ( 1'b0                                  ), // 1:read memory;0:write memory
.i_ddr3_ch01_start_addr        ( ddr3_ch01_start_addr[ADDR_WIDTH-1:0]  ), // start address. 27 bit
.i_ddr3_ch01_length            ( ddr3_ch01_data_length[11:0]           ), // 12bit's num.0~4095
.o_ddr3_ch01_ack               ( ddr3_ch01_ack                         ), // ack
.o_ddr3_ch01_op_done           ( ddr3_ch01_op_done                     ), // operate done
.o_ddr3_ch01_ram_rd_en         ( ddr3_ch01_ram_rd_en                   ), // read data for writing ddr3
.o_ddr3_ch01_ram_rd_en_last    (                                       ), // read data for writing ddr3
.i_ddr3_ch01_ram_rd_data       ( ddr3_ch01_ram_rd_data[DATA_WIDTH-1:0] ), // input data.read data for writing ddr3
.o_ddr3_ch01_ram_wr_en         (                                       ), // write data from reading ddr3
.o_ddr3_ch01_ram_wr_en_last    (                                       ), // write data from reading ddr3
.o_ddr3_ch01_ram_wr_data       (                                       ), // write data from reading ddr3

.i_ddr3_ch02_req               ( ddr3_ch02_req                         ), // request
.i_ddr3_ch02_priority          ( ddr3_ch02_priority[15:0]              ), // priority.0:highest priority
.i_ddr3_ch02_rd_wrn            ( 1'b0                                  ), // 1:read memory;0:write memory
.i_ddr3_ch02_start_addr        ( ddr3_ch02_start_addr[ADDR_WIDTH-1:0]  ), // start address.
.i_ddr3_ch02_length            ( ddr3_ch02_data_length[11:0]           ), // 12bit's num.0~4095
.o_ddr3_ch02_ack               ( ddr3_ch02_ack                         ), // ack
.o_ddr3_ch02_op_done           ( ddr3_ch02_op_done                     ), // operate done
.o_ddr3_ch02_ram_rd_en         ( ddr3_ch02_ram_rd_en                   ), // read data for writing ddr3
.o_ddr3_ch02_ram_rd_en_last    (                                       ), // read data for writing ddr3
.i_ddr3_ch02_ram_rd_data       ( ddr3_ch02_ram_rd_data[DATA_WIDTH-1:0] ), // input data.read data for writing ddr3
.o_ddr3_ch02_ram_wr_en         (                                       ), // write data from reading ddr3
.o_ddr3_ch02_ram_wr_en_last    (                                       ), // write data from reading ddr3
.o_ddr3_ch02_ram_wr_data       (                                       ), // write data from reading ddr3

.i_ddr3_ch03_req               ( ddr3_ch03_req                         ), // request
.i_ddr3_ch03_priority          ( ddr3_ch03_priority[15:0]              ), // priority.0:highest priority
.i_ddr3_ch03_rd_wrn            ( 1'b0                                  ), // 1:read memory;0:write memory
.i_ddr3_ch03_start_addr        ( ddr3_ch03_start_addr[ADDR_WIDTH-1:0]  ), // start address.
.i_ddr3_ch03_length            ( ddr3_ch03_data_length[11:0]           ), // 12bit's num.0~4095
.o_ddr3_ch03_ack               ( ddr3_ch03_ack                         ), // ack
.o_ddr3_ch03_op_done           ( ddr3_ch03_op_done                     ), // operate done
.o_ddr3_ch03_ram_rd_en         ( ddr3_ch03_ram_rd_en                   ), // read data for writing ddr3
.o_ddr3_ch03_ram_rd_en_last    (                                       ), // read data for writing ddr3
.i_ddr3_ch03_ram_rd_data       ( ddr3_ch03_ram_rd_data[DATA_WIDTH-1:0] ), // input data.read data for writing ddr3
.o_ddr3_ch03_ram_wr_en         (                                       ), // write data from reading ddr3
.o_ddr3_ch03_ram_wr_en_last    (                                       ), // write data from reading ddr3
.o_ddr3_ch03_ram_wr_data       (                                       ), // write data from reading ddr3

.i_ddr3_ch04_req               ( ddr3_ch04_req                         ), // request
.i_ddr3_ch04_priority          ( ddr3_ch04_priority[15:0]              ), // priority.0:highest priority
.i_ddr3_ch04_rd_wrn            ( 1'b0                                  ), // 1:read memory;0:write memory
.i_ddr3_ch04_start_addr        ( ddr3_ch04_start_addr[ADDR_WIDTH-1:0]  ), // start address.
.i_ddr3_ch04_length            ( ddr3_ch04_data_length[11:0]           ), // 12bit's num.0~4095
.o_ddr3_ch04_ack               ( ddr3_ch04_ack                         ), // ack
.o_ddr3_ch04_op_done           ( ddr3_ch04_op_done                     ), // operate done
.o_ddr3_ch04_ram_rd_en         ( ddr3_ch04_ram_rd_en                   ), // read data for writing ddr3
.o_ddr3_ch04_ram_rd_en_last    (                                       ), // read data for writing ddr3
.i_ddr3_ch04_ram_rd_data       ( ddr3_ch04_ram_rd_data[DATA_WIDTH-1:0] ), // input data.read data for writing ddr3
.o_ddr3_ch04_ram_wr_en         (                                       ), // write data from reading ddr3
.o_ddr3_ch04_ram_wr_en_last    (                                       ), // write data from reading ddr3
.o_ddr3_ch04_ram_wr_data       (                                       ), // write data from reading ddr3

.i_ddr3_ch05_req               ( ddr3_ch05_req                         ), // request
.i_ddr3_ch05_priority          ( ddr3_ch05_priority[15:0]              ), // priority.0:highest priority
.i_ddr3_ch05_rd_wrn            ( 1'b0                                  ), // 1:read memory;0:write memory
.i_ddr3_ch05_start_addr        ( ddr3_ch05_start_addr[ADDR_WIDTH-1:0]  ), // start address.
.i_ddr3_ch05_length            ( ddr3_ch05_data_length[11:0]           ), // 12bit's num.0~4095
.o_ddr3_ch05_ack               ( ddr3_ch05_ack                         ), // ack
.o_ddr3_ch05_op_done           ( ddr3_ch05_op_done                     ), // operate done
.o_ddr3_ch05_ram_rd_en         ( ddr3_ch05_ram_rd_en                   ), // read data for writing ddr3
.o_ddr3_ch05_ram_rd_en_last    (                                       ), // read data for writing ddr3
.i_ddr3_ch05_ram_rd_data       ( ddr3_ch05_ram_rd_data[DATA_WIDTH-1:0] ), // input data.read data for writing ddr3
.o_ddr3_ch05_ram_wr_en         (                                       ), // write data from reading ddr3
.o_ddr3_ch05_ram_wr_en_last    (                                       ), // write data from reading ddr3
.o_ddr3_ch05_ram_wr_data       (                                       ), // write data from reading ddr3

.i_ddr3_ch06_req               ( ddr3_ch06_req                         ), // request
.i_ddr3_ch06_priority          ( ddr3_ch06_priority[15:0]              ), // priority.0:highest priority
.i_ddr3_ch06_rd_wrn            ( 1'b0                                  ), // 1:read memory;0:write memory
.i_ddr3_ch06_start_addr        ( ddr3_ch06_start_addr[ADDR_WIDTH-1:0]  ), // start address.
.i_ddr3_ch06_length            ( ddr3_ch06_data_length[11:0]           ), // 12bit's num.0~4095
.o_ddr3_ch06_ack               ( ddr3_ch06_ack                         ), // ack
.o_ddr3_ch06_op_done           ( ddr3_ch06_op_done                     ), // operate done
.o_ddr3_ch06_ram_rd_en         ( ddr3_ch06_ram_rd_en                   ), // read data for writing ddr3
.o_ddr3_ch06_ram_rd_en_last    (                                       ), // read data for writing ddr3
.i_ddr3_ch06_ram_rd_data       ( ddr3_ch06_ram_rd_data[DATA_WIDTH-1:0] ), // input data.read data for writing ddr3
.o_ddr3_ch06_ram_wr_en         (                                       ), // write data from reading ddr3
.o_ddr3_ch06_ram_wr_en_last    (                                       ), // write data from reading ddr3
.o_ddr3_ch06_ram_wr_data       (                                       ), // write data from reading ddr3

.i_ddr3_ch07_req               ( ddr3_ch07_req                         ), // request
.i_ddr3_ch07_priority          ( ddr3_ch07_priority[15:0]              ), // priority.0:highest priority
.i_ddr3_ch07_rd_wrn            ( 1'b0                                  ), // 1:read memory;0:write memory
.i_ddr3_ch07_start_addr        ( ddr3_ch07_start_addr[ADDR_WIDTH-1:0]  ), // start address.
.i_ddr3_ch07_length            ( ddr3_ch07_data_length[11:0]           ), // 12bit's num.0~4095
.o_ddr3_ch07_ack               ( ddr3_ch07_ack                         ), // ack
.o_ddr3_ch07_op_done           ( ddr3_ch07_op_done                     ), // operate done
.o_ddr3_ch07_ram_rd_en         ( ddr3_ch07_ram_rd_en                   ), // read data for writing ddr3
.o_ddr3_ch07_ram_rd_en_last    (                                       ), // read data for writing ddr3
.i_ddr3_ch07_ram_rd_data       ( ddr3_ch07_ram_rd_data[DATA_WIDTH-1:0] ), // input data.read data for writing ddr3
.o_ddr3_ch07_ram_wr_en         (                                       ), // write data from reading ddr3
.o_ddr3_ch07_ram_wr_en_last    (                                       ), // write data from reading ddr3
.o_ddr3_ch07_ram_wr_data       (                                       ), // write data from reading ddr3

.i_ddr3_ch08_req               ( ddr3_ch08_req                         ), // request
.i_ddr3_ch08_priority          ( ddr3_ch08_priority[15:0]              ), // priority.0:highest priority
.i_ddr3_ch08_rd_wrn            ( 1'b0                                  ), // 1:read memory;0:write memory
.i_ddr3_ch08_start_addr        ( ddr3_ch08_start_addr[ADDR_WIDTH-1:0]  ), // start address.
.i_ddr3_ch08_length            ( ddr3_ch08_data_length[11:0]           ), // 12bit's num.0~4095
.o_ddr3_ch08_ack               ( ddr3_ch08_ack                         ), // ack
.o_ddr3_ch08_op_done           ( ddr3_ch08_op_done                     ), // operate done
.o_ddr3_ch08_ram_rd_en         ( ddr3_ch08_ram_rd_en                   ), // read data for writing ddr3
.o_ddr3_ch08_ram_rd_en_last    (                                       ), // read data for writing ddr3
.i_ddr3_ch08_ram_rd_data       ( ddr3_ch08_ram_rd_data[DATA_WIDTH-1:0] ), // input data.read data for writing ddr3
.o_ddr3_ch08_ram_wr_en         (                                       ), // write data from reading ddr3
.o_ddr3_ch08_ram_wr_en_last    (                                       ), // write data from reading ddr3
.o_ddr3_ch08_ram_wr_data       (                                       ), // write data from reading ddr3

.i_ddr3_ch09_req               ( ddr3_ch09_req                         ), // request
.i_ddr3_ch09_priority          ( ddr3_ch09_priority[15:0]              ), // priority.0:highest priority
.i_ddr3_ch09_rd_wrn            ( 1'b0                                  ), // 1:read memory;0:write memory
.i_ddr3_ch09_start_addr        ( ddr3_ch09_start_addr[ADDR_WIDTH-1:0]  ), // start address.
.i_ddr3_ch09_length            ( ddr3_ch09_data_length[11:0]           ), // 12bit's num.0~4095
.o_ddr3_ch09_ack               ( ddr3_ch09_ack                         ), // ack
.o_ddr3_ch09_op_done           ( ddr3_ch09_op_done                     ), // operate done
.o_ddr3_ch09_ram_rd_en         ( ddr3_ch09_ram_rd_en                   ), // read data for writing ddr3
.o_ddr3_ch09_ram_rd_en_last    (                                       ), // read data for writing ddr3
.i_ddr3_ch09_ram_rd_data       ( ddr3_ch09_ram_rd_data[DATA_WIDTH-1:0] ), // input data.read data for writing ddr3
.o_ddr3_ch09_ram_wr_en         (                                       ), // write data from reading ddr3
.o_ddr3_ch09_ram_wr_en_last    (                                       ), // write data from reading ddr3
.o_ddr3_ch09_ram_wr_data       (                                       ), // write data from reading ddr3

.i_ddr3_ch10_req               ( ddr3_ch10_req                         ), // request
.i_ddr3_ch10_priority          ( ddr3_ch10_priority[15:0]              ), // priority.0:highest priority
.i_ddr3_ch10_rd_wrn            ( 1'b1                                  ), // 1:read memory;0:write memory
.i_ddr3_ch10_start_addr        ( ddr3_ch10_start_addr[ADDR_WIDTH-1:0]  ), // start address.
.i_ddr3_ch10_length            ( ddr3_ch10_data_length[11:0]           ), // 12bit's num.0~4095
.o_ddr3_ch10_ack               ( ddr3_ch10_ack                         ), // ack
.o_ddr3_ch10_op_done           ( ddr3_ch10_op_done                     ), // operate done
.o_ddr3_ch10_ram_rd_en         (                                       ), // read data for writing ddr3
.o_ddr3_ch10_ram_rd_en_last    (                                       ), // read data for writing ddr3
.i_ddr3_ch10_ram_rd_data       (                                       ), // input data.read data for writing ddr3
.o_ddr3_ch10_ram_wr_en         ( ddr3_ch10_ram_wr_en                   ), // write data from reading ddr3
.o_ddr3_ch10_ram_wr_en_last    (                                       ), // write data from reading ddr3
.o_ddr3_ch10_ram_wr_data       ( ddr3_ch10_ram_wr_data[DATA_WIDTH-1:0] ), // write data from reading ddr3

.i_ddr3_ch11_req               ( ddr3_ch11_req                         ), // request
.i_ddr3_ch11_priority          ( ddr3_ch11_priority[15:0]              ), // priority.0:highest priority
.i_ddr3_ch11_rd_wrn            ( 1'b1                                  ), // 1:read memory;0:write memory
.i_ddr3_ch11_start_addr        ( ddr3_ch11_start_addr[ADDR_WIDTH-1:0]  ), // start address.
.i_ddr3_ch11_length            ( ddr3_ch11_data_length[11:0]           ), // 12bit's num.0~4095
.o_ddr3_ch11_ack               ( ddr3_ch11_ack                         ), // ack
.o_ddr3_ch11_op_done           ( ddr3_ch11_op_done                     ), // operate done
.o_ddr3_ch11_ram_rd_en         (                                       ), // read data for writing ddr3
.o_ddr3_ch11_ram_rd_en_last    (                                       ), // read data for writing ddr3
.i_ddr3_ch11_ram_rd_data       (                                       ), // input data.read data for writing ddr3
.o_ddr3_ch11_ram_wr_en         ( ddr3_ch11_ram_wr_en                   ), // write data from reading ddr3
.o_ddr3_ch11_ram_wr_en_last    (                                       ), // write data from reading ddr3
.o_ddr3_ch11_ram_wr_data       ( ddr3_ch11_ram_wr_data[DATA_WIDTH-1:0] ), // write data from reading ddr3

.i_ddr3_ch12_req               ( ddr3_ch12_req                         ), // request
.i_ddr3_ch12_priority          ( ddr3_ch12_priority[15:0]              ), // priority.0:highest priority
.i_ddr3_ch12_rd_wrn            ( 1'b1                                  ), // 1:read memory;0:write memory
.i_ddr3_ch12_start_addr        ( ddr3_ch12_start_addr[ADDR_WIDTH-1:0]  ), // start address.
.i_ddr3_ch12_length            ( ddr3_ch12_data_length[11:0]           ), // 12bit's num.0~4095
.o_ddr3_ch12_ack               ( ddr3_ch12_ack                         ), // ack
.o_ddr3_ch12_op_done           ( ddr3_ch12_op_done                     ), // operate done
.o_ddr3_ch12_ram_rd_en         (                                       ), // read data for writing ddr3
.o_ddr3_ch12_ram_rd_en_last    (                                       ), // read data for writing ddr3
.i_ddr3_ch12_ram_rd_data       (                                       ), // input data.read data for writing ddr3
.o_ddr3_ch12_ram_wr_en         ( ddr3_ch12_ram_wr_en                   ), // write data from reading ddr3
.o_ddr3_ch12_ram_wr_en_last    (                                       ), // write data from reading ddr3
.o_ddr3_ch12_ram_wr_data       ( ddr3_ch12_ram_wr_data[DATA_WIDTH-1:0] ), // write data from reading ddr3

.i_ddr3_ch13_req               ( ddr3_ch13_req                         ), // request
.i_ddr3_ch13_priority          ( ddr3_ch13_priority[15:0]              ), // priority.0:highest priority
.i_ddr3_ch13_rd_wrn            ( 1'b1                                  ), // 1:read memory;0:write memory
.i_ddr3_ch13_start_addr        ( ddr3_ch13_start_addr[ADDR_WIDTH-1:0]  ), // start address.
.i_ddr3_ch13_length            ( ddr3_ch13_data_length[11:0]           ), // 12bit's num.0~4095
.o_ddr3_ch13_ack               ( ddr3_ch13_ack                         ), // ack
.o_ddr3_ch13_op_done           ( ddr3_ch13_op_done                     ), // operate done
.o_ddr3_ch13_ram_rd_en         (                                       ), // read data for writing ddr3
.o_ddr3_ch13_ram_rd_en_last    (                                       ), // read data for writing ddr3
.i_ddr3_ch13_ram_rd_data       (                                       ), // input data.read data for writing ddr3
.o_ddr3_ch13_ram_wr_en         ( ddr3_ch13_ram_wr_en                   ), // write data from reading ddr3
.o_ddr3_ch13_ram_wr_en_last    (                                       ), // write data from reading ddr3
.o_ddr3_ch13_ram_wr_data       ( ddr3_ch13_ram_wr_data[DATA_WIDTH-1:0] ), // write data from reading ddr3

.i_ddr3_ch14_req               ( ddr3_ch14_req                         ), // request
.i_ddr3_ch14_priority          ( ddr3_ch14_priority[15:0]              ), // priority.0:highest priority
.i_ddr3_ch14_rd_wrn            ( 1'b1                                  ), // 1:read memory;0:write memory
.i_ddr3_ch14_start_addr        ( ddr3_ch14_start_addr[ADDR_WIDTH-1:0]  ), // start address.
.i_ddr3_ch14_length            ( ddr3_ch14_data_length[11:0]           ), // 12bit's num.0~4095
.o_ddr3_ch14_ack               ( ddr3_ch14_ack                         ), // ack
.o_ddr3_ch14_op_done           ( ddr3_ch14_op_done                     ), // operate done
.o_ddr3_ch14_ram_rd_en         (                                       ), // read data for writing ddr3
.o_ddr3_ch14_ram_rd_en_last    (                                       ), // read data for writing ddr3
.i_ddr3_ch14_ram_rd_data       (                                       ), // input data.read data for writing ddr3
.o_ddr3_ch14_ram_wr_en         ( ddr3_ch14_ram_wr_en                   ), // write data from reading ddr3
.o_ddr3_ch14_ram_wr_en_last    (                                       ), // write data from reading ddr3
.o_ddr3_ch14_ram_wr_data       ( ddr3_ch14_ram_wr_data[DATA_WIDTH-1:0] ), // write data from reading ddr3

.i_ddr3_ch15_req               ( ddr3_ch15_req                         ), // request
.i_ddr3_ch15_priority          ( ddr3_ch15_priority[15:0]              ), // priority.0:highest priority
.i_ddr3_ch15_rd_wrn            ( 1'b1                                  ), // 1:read memory;0:write memory
.i_ddr3_ch15_start_addr        ( ddr3_ch15_start_addr[ADDR_WIDTH-1:0]  ), // start address.
.i_ddr3_ch15_length            ( ddr3_ch15_data_length[11:0]           ), // 12bit's num.0~4095
.o_ddr3_ch15_ack               ( ddr3_ch15_ack                         ), // ack
.o_ddr3_ch15_op_done           ( ddr3_ch15_op_done                     ), // operate done
.o_ddr3_ch15_ram_rd_en         (                                       ), // read data for writing ddr3
.o_ddr3_ch15_ram_rd_en_last    (                                       ), // read data for writing ddr3
.i_ddr3_ch15_ram_rd_data       (                                       ), // input data.read data for writing ddr3
.o_ddr3_ch15_ram_wr_en         ( ddr3_ch15_ram_wr_en                   ), // write data from reading ddr3
.o_ddr3_ch15_ram_wr_en_last    (                                       ), // write data from reading ddr3
.o_ddr3_ch15_ram_wr_data       ( ddr3_ch15_ram_wr_data[DATA_WIDTH-1:0] ), // write data from reading ddr3

.i_ddr3_ch16_req               ( ddr3_ch16_req                         ), // request
.i_ddr3_ch16_priority          ( ddr3_ch16_priority[15:0]              ), // priority.0:highest priority
.i_ddr3_ch16_rd_wrn            ( 1'b1                                  ), // 1:read memory;0:write memory
.i_ddr3_ch16_start_addr        ( ddr3_ch16_start_addr[ADDR_WIDTH-1:0]  ), // start address.
.i_ddr3_ch16_length            ( ddr3_ch16_data_length[11:0]           ), // 12bit's num.0~4095
.o_ddr3_ch16_ack               ( ddr3_ch16_ack                         ), // ack
.o_ddr3_ch16_op_done           ( ddr3_ch16_op_done                     ), // operate done
.o_ddr3_ch16_ram_rd_en         (                                       ), // read data for writing ddr3
.o_ddr3_ch16_ram_rd_en_last    (                                       ), // read data for writing ddr3
.i_ddr3_ch16_ram_rd_data       (                                       ), // input data.read data for writing ddr3
.o_ddr3_ch16_ram_wr_en         ( ddr3_ch16_ram_wr_en                   ), // write data from reading ddr3
.o_ddr3_ch16_ram_wr_en_last    (                                       ), // write data from reading ddr3
.o_ddr3_ch16_ram_wr_data       ( ddr3_ch16_ram_wr_data[DATA_WIDTH-1:0] ), // write data from reading ddr3

.i_ddr3_ch17_req               ( ddr3_ch17_req                         ), // request
.i_ddr3_ch17_priority          ( ddr3_ch17_priority[15:0]              ), // priority.0:highest priority
.i_ddr3_ch17_rd_wrn            ( 1'b1                                  ), // 1:read memory;0:write memory
.i_ddr3_ch17_start_addr        ( ddr3_ch17_start_addr[ADDR_WIDTH-1:0]  ), // start address.
.i_ddr3_ch17_length            ( ddr3_ch17_data_length[11:0]           ), // 12bit's num.0~4095
.o_ddr3_ch17_ack               ( ddr3_ch17_ack                         ), // ack
.o_ddr3_ch17_op_done           ( ddr3_ch17_op_done                     ), // operate done
.o_ddr3_ch17_ram_rd_en         (                                       ), // read data for writing ddr3
.o_ddr3_ch17_ram_rd_en_last    (                                       ), // read data for writing ddr3
.i_ddr3_ch17_ram_rd_data       (                                       ), // input data.read data for writing ddr3
.o_ddr3_ch17_ram_wr_en         ( ddr3_ch17_ram_wr_en                   ), // write data from reading ddr3
.o_ddr3_ch17_ram_wr_en_last    (                                       ), // write data from reading ddr3
.o_ddr3_ch17_ram_wr_data       ( ddr3_ch17_ram_wr_data[DATA_WIDTH-1:0] ), // write data from reading ddr3

.i_ddr3_ch18_req               ( ddr3_ch18_req                         ), // request
.i_ddr3_ch18_priority          ( ddr3_ch18_priority[15:0]              ), // priority.0:highest priority
.i_ddr3_ch18_rd_wrn            ( 1'b1                                  ), // 1:read memory;0:write memory
.i_ddr3_ch18_start_addr        ( ddr3_ch18_start_addr[ADDR_WIDTH-1:0]  ), // start address.
.i_ddr3_ch18_length            ( ddr3_ch18_data_length[11:0]           ), // 12bit's num.0~4095
.o_ddr3_ch18_ack               ( ddr3_ch18_ack                         ), // ack
.o_ddr3_ch18_op_done           ( ddr3_ch18_op_done                     ), // operate done
.o_ddr3_ch18_ram_rd_en         (                                       ), // read data for writing ddr3
.o_ddr3_ch18_ram_rd_en_last    (                                       ), // read data for writing ddr3
.i_ddr3_ch18_ram_rd_data       (                                       ), // input data.read data for writing ddr3
.o_ddr3_ch18_ram_wr_en         ( ddr3_ch18_ram_wr_en                   ), // write data from reading ddr3
.o_ddr3_ch18_ram_wr_en_last    (                                       ), // write data from reading ddr3
.o_ddr3_ch18_ram_wr_data       ( ddr3_ch18_ram_wr_data[DATA_WIDTH-1:0] ), // write data from reading ddr3

.i_ddr3_ch19_req               ( ddr3_ch19_req                         ), // request
.i_ddr3_ch19_priority          ( ddr3_ch19_priority[15:0]              ), // priority.0:highest priority
.i_ddr3_ch19_rd_wrn            ( 1'b1                                  ), // 1:read memory;0:write memory
.i_ddr3_ch19_start_addr        ( ddr3_ch19_start_addr[ADDR_WIDTH-1:0]  ), // start address.
.i_ddr3_ch19_length            ( ddr3_ch19_data_length[11:0]           ), // 12bit's num.0~4095
.o_ddr3_ch19_ack               ( ddr3_ch19_ack                         ), // ack
.o_ddr3_ch19_op_done           ( ddr3_ch19_op_done                     ), // operate done
.o_ddr3_ch19_ram_rd_en         (                                       ), // read data for writing ddr3
.o_ddr3_ch19_ram_rd_en_last    (                                       ), // read data for writing ddr3
.i_ddr3_ch19_ram_rd_data       (                                       ), // input data.read data for writing ddr3
.o_ddr3_ch19_ram_wr_en         ( ddr3_ch19_ram_wr_en                   ), // write data from reading ddr3
.o_ddr3_ch19_ram_wr_en_last    (                                       ), // write data from reading ddr3
.o_ddr3_ch19_ram_wr_data       ( ddr3_ch19_ram_wr_data[DATA_WIDTH-1:0] ), // write data from reading ddr3

.i_ddr3_ch20_req               ( ddr3_ch20_req                         ), // request
.i_ddr3_ch20_priority          ( ddr3_ch20_priority[15:0]              ), // priority.0:highest priority
.i_ddr3_ch20_rd_wrn            ( 1'b1                                  ), // 1:read memory;0:write memory
.i_ddr3_ch20_start_addr        ( ddr3_ch20_start_addr[ADDR_WIDTH-1:0]  ), // start address.
.i_ddr3_ch20_length            ( ddr3_ch20_data_length[11:0]           ), // 12bit's num.0~4095
.o_ddr3_ch20_ack               ( ddr3_ch20_ack                         ), // ack
.o_ddr3_ch20_op_done           ( ddr3_ch20_op_done                     ), // operate done
.o_ddr3_ch20_ram_rd_en         (                                       ), // read data for writing ddr3
.o_ddr3_ch20_ram_rd_en_last    (                                       ), // read data for writing ddr3
.i_ddr3_ch20_ram_rd_data       (                                       ), // input data.read data for writing ddr3
.o_ddr3_ch20_ram_wr_en         ( ddr3_ch20_ram_wr_en                   ), // write data from reading ddr3
.o_ddr3_ch20_ram_wr_en_last    (                                       ), // write data from reading ddr3
.o_ddr3_ch20_ram_wr_data       ( ddr3_ch20_ram_wr_data[DATA_WIDTH-1:0] ), // write data from reading ddr3

.i_ddr3_ch21_req               ( ddr3_ch21_req                         ), // request
.i_ddr3_ch21_priority          ( ddr3_ch21_priority[15:0]              ), // priority.0:highest priority
.i_ddr3_ch21_rd_wrn            ( 1'b1                                  ), // 1:read memory;0:write memory
.i_ddr3_ch21_start_addr        ( ddr3_ch21_start_addr[ADDR_WIDTH-1:0]  ), // start address.
.i_ddr3_ch21_length            ( ddr3_ch21_data_length[11:0]           ), // 12bit's num.0~4095
.o_ddr3_ch21_ack               ( ddr3_ch21_ack                         ), // ack
.o_ddr3_ch21_op_done           ( ddr3_ch21_op_done                     ), // operate done
.o_ddr3_ch21_ram_rd_en         (                                       ), // read data for writing ddr3
.o_ddr3_ch21_ram_rd_en_last    (                                       ), // read data for writing ddr3
.i_ddr3_ch21_ram_rd_data       (                                       ), // input data.read data for writing ddr3
.o_ddr3_ch21_ram_wr_en         ( ddr3_ch21_ram_wr_en                   ), // write data from reading ddr3
.o_ddr3_ch21_ram_wr_en_last    (                                       ), // write data from reading ddr3
.o_ddr3_ch21_ram_wr_data       ( ddr3_ch21_ram_wr_data[DATA_WIDTH-1:0] )  // write data from reading ddr3

);




endmodule