// =============================================================================
//                           COPYRIGHT NOTICE
// Copyright 2012 (c) Lattice Semiconductor Corporation
// ALL RIGHTS RESERVED
// This confidential and proprietary software may be used only as authorised by
// a licensing agreement from Lattice Semiconductor Corporation.
// The entire notice above must be reproduced on all authorized copies and
// copies may only be made to the extent permitted by a licensing agreement from
// Lattice Semiconductor Corporation.
//
// Lattice Semiconductor Corporation        TEL  : 1-800-Lattice (USA and Canada)
// 5555 NE Moore Court                            408-826-6000 (other locations)
// Hillsboro, OR 97124                      web  : http://www.latticesemi.com/
// U.S.A                                   email: techsupport@lscc.com
// =============================================================================
//                         FILE DETAILS
// Project          : DDR3 Versa EB Demo 
// File             : ddr3_test_top.v
// Title            : ddr3_test_top
// Dependencies     :
// Description      : Command and address generation block
//
//
// =============================================================================
//                        REVISION HISTORY
// Version          : 1.0
// Author(s)        : Kyoho Lee/ LSV Apps
// Mod. Date        : February, 2011
// Changes Made     :
//
// =============================================================================

`timescale 1 ns / 100 ps
`include "E:/project/SVR2930/interface_fpga/src/ddr3/err_dect_code/ddr3_test_params.v"

module ddr3_test_top (
    // LED display & dip sw signals

    input   wire                        i_rst_n                     ,
    input   wire                        i_clk_in                    ,

    input   wire    [ 7:0]              i_dip_sw                    ,
    input   wire                        i_ddr_wr_data_sel           ,

    output  wire                        o_led_1                     ,
    output  wire                        o_led_2                     ,
    output  wire                        o_led_3                     ,
    output  wire                        o_led_4                     ,

    output  wire                        o_em_ddr_reset_n            ,
    output  wire                        o_em_ddr_cs_n               ,
    output  wire                        o_em_ddr_cke                ,
    output  wire                        o_em_ddr_clk                ,
    inout   wire    [31:0]             io_em_ddr_data               ,
    inout   wire    [ 3:0]             io_em_ddr_dqs                ,
    output  wire                        o_em_ddr_we_n               ,
    output  wire                        o_em_ddr_cas_n              ,
    output  wire                        o_em_ddr_ras_n              ,
    output  wire    [ 2:0]              o_em_ddr_ba                 ,
    output  wire    [13:0]              o_em_ddr_addr               ,
    output  wire    [ 3:0]              o_em_ddr_dm                 ,
    output  wire                        o_em_ddr_odt                ,

    input   wire                        Pb1                         ,
    input   wire    [ 6:0]              TP                          ,
    output  wire                        ClkSel
    )/* synthesis syn_dspstyle=LOGIC */ /* synthesis syn_useioff = 0 */;

// ==============================================================================
// internal signals
// ==============================================================================
wire                           sclk /* synthesis syn_keep=1 */;
wire   [`CS_WIDTH-1:0]         em_ddr_clk;
wire   [`CS_WIDTH-1:0]         em_ddr_cke;
wire                           init_start;
wire                           mem_rst_n;
wire                           err_notify;
wire   [3:0]                   cmd;
wire   [`ADDR_WIDTH-1:0]       addr;
wire                           cmd_valid;
wire   [4:0]                   cmd_burst_cnt;
wire   [`DSIZE-1:0]            write_data;
wire   [`USER_DM-1:0]          data_mask;
wire                           cmd_rdy;
wire                           init_done;
wire                           datain_rdy;
wire   [`DSIZE-1:0]            read_data;
wire                           read_data_valid;
wire                           err_det;
wire   [2:0]                   rpt;
wire   [`DQS_WIDTH*3-1:0]      read_pulse_tap;
wire    [14:0]                  seg;
reg    [25:0]                  hb_cnt;
reg                            init_done_det;
reg                            cmd_rdy_det;
reg                            datain_rdy_det;
reg                            rd_dat_val_det;
reg    [25:0]                  read_num, write_num;
reg    [22:0]                  data_1_cnt;
reg    [22:0]                  data_0_cnt;
wire                           reset_n = i_rst_n;
wire   [127:0]                 ddr_write_data = (i_ddr_wr_data_sel == 1'b0) ? write_data : 128'habcdef12_12345678_fedcba12_98765432;


// ==============================================================================
// READ_PULSE_TAP setting for PCB and fly-by wiring compensation
// - Enable the RPT_CONTROL parameter if you want to change the setting
// - using external jumpers
// ==============================================================================
`ifdef SIM
assign  rpt  = 0; // no layout delay considered in functional simulation, 0 for UDIMM
`else
assign rpt  = {1'b0, 1'b0, 1'b0};   // use the default = 2
`endif

//`ifdef DATA_SIZE_64
// assign read_pulse_tap = {rpt1,{`DQS_WIDTH-1{rpt}}};  // if DQS[7] has more delay
//`else
 assign read_pulse_tap = {`DQS_WIDTH{rpt}};
//`endif


// ==============================================================================
// Output LED display
// ==============================================================================
assign  o_led_1 =   hb_cnt[25];
assign  o_led_2 =   read_num[22];
assign  o_led_3 =   i_dip_sw[6] ? (data_1_cnt[20] && data_0_cnt[20]) : data_1_cnt[2] && data_0_cnt[2];
assign  o_led_4 =   err_notify;

assign  err_notify  =   err_det ? hb_cnt[25] : `LED_ON;


always@(posedge sclk or negedge reset_n) begin
    if (reset_n == 1'b0) begin
        hb_cnt          <= 26'h0;
        read_num        <= 26'b0;
        write_num       <= 26'b0;
        data_0_cnt      <= 23'b0;
        data_1_cnt      <= 23'b0;
        datain_rdy_det  <=`LED_OFF;
        rd_dat_val_det  <=`LED_OFF;
        init_done_det   <=`LED_OFF;
        cmd_rdy_det     <=`LED_OFF;
    end
    else begin
        hb_cnt  <=  hb_cnt + 1;
        if (cmd_rdy)            cmd_rdy_det         <=  `LED_ON;
        if (datain_rdy)         datain_rdy_det      <=  `LED_ON;
        if (read_data_valid)    rd_dat_val_det      <=  `LED_ON;

        if (read_data_valid && read_data[7])    data_1_cnt  <=  data_1_cnt + 1;
        if (read_data_valid && ~read_data[7])   data_0_cnt  <=  data_0_cnt + 1;
        if (read_data_valid)                    read_num    <=  read_num + 1;
        if (datain_rdy)                         write_num   <=  write_num + 1;
    end
end


//=============================================================================
// User Refresh assertion when EXT_AUTO_REF is defined
//=============================================================================
`ifdef EXT_AUTO_REF
 reg        req_pending;
 reg        ext_auto_ref;
 wire       ext_auto_ref_ack;

 always@(posedge sclk or negedge reset_n) begin
    if (reset_n == 1'b0) begin
        ext_auto_ref        <= 1'b0;
        req_pending     <= 1'b0;
    end
    else begin
        if (hb_cnt[12] && !req_pending) begin
            ext_auto_ref    <= 1'b1;
            req_pending     <= 1'b1;
        end
        else if (ext_auto_ref_ack)
            ext_auto_ref    <= 1'b0;

        if (!hb_cnt[12])
            req_pending     <= 1'b0;
    end
 end
`endif


// ==============================================================================
// DDR3 IP core instantiation
// ==============================================================================

ddr3_sdram_mem_top u_ddr3_sdram_mem_top (
    .clk_in                 (i_clk_in),
    .rst_n                  (reset_n),
    .mem_rst_n              (mem_rst_n),
    .cmd                    (cmd),
    .addr                   (addr),
    .cmd_valid              (cmd_valid),
    .ofly_burst_len         (ofly_burst_len),
    .cmd_burst_cnt          (cmd_burst_cnt),
    .init_start             (init_start),
    .write_data             (ddr_write_data),
    .data_mask              (data_mask),
    .cmd_rdy                (cmd_rdy),
    .init_done              (init_done),
    .datain_rdy             (datain_rdy),
    .wl_err                 (wl_err),
    .clocking_good          (clocking_good),
  `ifdef EXT_AUTO_REF
    .ext_auto_ref           (ext_auto_ref),
    .ext_auto_ref_ack       (ext_auto_ref_ack),
  `endif
    .read_data              (read_data),
    .read_data_valid        (read_data_valid),
    .read_pulse_tap         (read_pulse_tap),
    .em_ddr_data            (io_em_ddr_data),
    .em_ddr_dqs             (io_em_ddr_dqs),
    .em_ddr_clk             (o_em_ddr_clk),
    .em_ddr_reset_n         (o_em_ddr_reset_n),
    .em_ddr_cke             (o_em_ddr_cke),
    .em_ddr_ras_n           (o_em_ddr_ras_n),
    .em_ddr_cas_n           (o_em_ddr_cas_n),
    .em_ddr_we_n            (o_em_ddr_we_n),
    .em_ddr_cs_n            (o_em_ddr_cs_n),
    .em_ddr_odt             (o_em_ddr_odt),
    .em_ddr_dm              (o_em_ddr_dm),
    .em_ddr_ba              (o_em_ddr_ba),
    .em_ddr_addr            (o_em_ddr_addr),
    .sclk_out               (sclk)
);

// ==============================================================================
// User Test Logic instantiation
// ==============================================================================
ddr_ulogic  u_ddr_ulogic (
//---------inputs-------------
    .sclk                   (sclk),
    .reset_n                (reset_n),
    .init_done              (init_done),
    .cmd_rdy                (cmd_rdy),
    .datain_rdy             (datain_rdy),
    .read_data              (read_data),
    .read_data_valid        (read_data_valid),
    .dip_sw                 (i_dip_sw[4:0]),
    .cmd                    (cmd),
    .cmd_valid              (cmd_valid),
    .addr                   (addr),
    .cmd_burst_cnt          (cmd_burst_cnt),
    .write_data             (write_data),
    .init_start             (init_start),
    .mem_rst_n              (mem_rst_n),
    .data_mask              (data_mask),
    .otf_bl_sel             (ofly_burst_len),
    .err_det                (err_det)
    ) /*synthesis UGROUP="ddr3_ulogic" PBBOX="25,20" BBOXTYPE= "DEVSIZE" */;


endmodule
