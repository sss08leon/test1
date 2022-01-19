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
//  1.0             2015/7/13           zhuyibin
//  1.1             2016.11.17          gzd
//
//  Revision History
//  1.1 Modified for Lattice ECP3-70EA-8FN672 in SVR2930 as Interface FPGA; 
//
// =============================================================================

`timescale 1 ns / 1 ps

module ddr3_manager_top
#(
    parameter           DATA_WIDTH          = 128,
    parameter           ADDR_WIDTH          = 27   // actually needed width is 27 in SVR2930.
) 
( 
    // ========================== ddr3 chip 
    input                           i_ddr3_clk            , // 100M for ddr3-800
    input                           i_ddr3_rst_n          , // reset until init_calib_done
    output                          o_ddr3_sclk           , // user interface clock, 200M for ddr3-800.
    output                          o_ddr3_busy           , // high active       
    output                          o_ddr3_op_done        , // operate done.pulse
    output                          o_ddr3_init_done      ,
    // ============= memory interface                       
    output                          o_em_ddr_reset_n      ,   
    output                          o_em_ddr_cs_n         ,   
    output                          o_em_ddr_cke          ,   
    output                          o_em_ddr_clk          ,   
    inout   [31:0]                  io_em_ddr_data        ,   
    inout   [ 3:0]                  io_em_ddr_dqs         ,   
    output                          o_em_ddr_we_n         ,   
    output                          o_em_ddr_cas_n        ,   
    output                          o_em_ddr_ras_n        ,   
    output  [ 2:0]                  o_em_ddr_ba           ,   
    output  [ADDR_WIDTH-14:0]       o_em_ddr_addr         ,   
    output  [ 3:0]                  o_em_ddr_dm           ,   
    output                          o_em_ddr_odt          ,  
    // ============= ch00                  
    input                           i_ddr3_ch00_req               , // request
    input   [15:0]                  i_ddr3_ch00_priority          , // priority.0:highest priority
    input                           i_ddr3_ch00_rd_wrn            , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]        i_ddr3_ch00_start_addr        , // start address. 27 bit
    input   [11:0]                  i_ddr3_ch00_length            , // 12bit's num.0~4095
    output                          o_ddr3_ch00_ack               , // ack
    output                          o_ddr3_ch00_op_done           , // operate done
    output                          o_ddr3_ch00_ram_rd_en         , // read data for writing ddr3
    output                          o_ddr3_ch00_ram_rd_en_last    , // read data for writing ddr3
    input  [DATA_WIDTH-1:0]         i_ddr3_ch00_ram_rd_data       , // input data.read data for writing ddr3
    output                          o_ddr3_ch00_ram_wr_en         , // write data from reading ddr3
    output                          o_ddr3_ch00_ram_wr_en_last    , // write data from reading ddr3
    output [DATA_WIDTH-1:0]         o_ddr3_ch00_ram_wr_data       , // write data from reading ddr3
    // ============= ch01
    input                           i_ddr3_ch01_req               , // request
    input   [15:0]                  i_ddr3_ch01_priority          , // priority.0:highest priority
    input                           i_ddr3_ch01_rd_wrn            , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]        i_ddr3_ch01_start_addr        , // start address. 27 bit
    input   [11:0]                  i_ddr3_ch01_length            , // 12bit's num.0~4095
    output                          o_ddr3_ch01_ack               , // ack         
    output                          o_ddr3_ch01_op_done           , // operate done
    output                          o_ddr3_ch01_ram_rd_en         , // read data for writing ddr3
    output                          o_ddr3_ch01_ram_rd_en_last    , // read data for writing ddr3
    input  [DATA_WIDTH-1:0]         i_ddr3_ch01_ram_rd_data       , // input data.read data for writing ddr3
    output                          o_ddr3_ch01_ram_wr_en         , // write data from reading ddr3
    output                          o_ddr3_ch01_ram_wr_en_last    , // write data from reading ddr3
    output [DATA_WIDTH-1:0]         o_ddr3_ch01_ram_wr_data       , // write data from reading ddr3
    // ============= ch02
    input                           i_ddr3_ch02_req               , // request
    input   [15:0]                  i_ddr3_ch02_priority          , // priority.0:highest priority
    input                           i_ddr3_ch02_rd_wrn            , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]        i_ddr3_ch02_start_addr        , // start address. 
    input   [11:0]                  i_ddr3_ch02_length            , // 12bit's num.0~4095
    output                          o_ddr3_ch02_ack               , // ack         
    output                          o_ddr3_ch02_op_done           , // operate done
    output                          o_ddr3_ch02_ram_rd_en         , // read data for writing ddr3
    output                          o_ddr3_ch02_ram_rd_en_last    , // read data for writing ddr3
    input  [DATA_WIDTH-1:0]         i_ddr3_ch02_ram_rd_data       , // input data.read data for writing ddr3
    output                          o_ddr3_ch02_ram_wr_en         , // write data from reading ddr3
    output                          o_ddr3_ch02_ram_wr_en_last    , // write data from reading ddr3
    output [DATA_WIDTH-1:0]         o_ddr3_ch02_ram_wr_data       , // write data from reading ddr3
    // ============= ch03
    input                           i_ddr3_ch03_req               , // request
    input   [15:0]                  i_ddr3_ch03_priority          , // priority.0:highest priority
    input                           i_ddr3_ch03_rd_wrn            , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]        i_ddr3_ch03_start_addr        , // start address. 
    input   [11:0]                  i_ddr3_ch03_length            , // 12bit's num.0~4095
    output                          o_ddr3_ch03_ack               , // ack         
    output                          o_ddr3_ch03_op_done           , // operate done
    output                          o_ddr3_ch03_ram_rd_en         , // read data for writing ddr3
    output                          o_ddr3_ch03_ram_rd_en_last    , // read data for writing ddr3
    input  [DATA_WIDTH-1:0]         i_ddr3_ch03_ram_rd_data       , // input data.read data for writing ddr3
    output                          o_ddr3_ch03_ram_wr_en         , // write data from reading ddr3
    output                          o_ddr3_ch03_ram_wr_en_last    , // write data from reading ddr3
    output [DATA_WIDTH-1:0]         o_ddr3_ch03_ram_wr_data       , // write data from reading ddr3
    // ============= ch04
    input                           i_ddr3_ch04_req               , // request
    input   [15:0]                  i_ddr3_ch04_priority          , // priority.0:highest priority
    input                           i_ddr3_ch04_rd_wrn            , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]        i_ddr3_ch04_start_addr        , // start address. 
    input   [11:0]                  i_ddr3_ch04_length            , // 12bit's num.0~4095
    output                          o_ddr3_ch04_ack               , // ack         
    output                          o_ddr3_ch04_op_done           , // operate done
    output                          o_ddr3_ch04_ram_rd_en         , // read data for writing ddr3
    output                          o_ddr3_ch04_ram_rd_en_last    , // read data for writing ddr3
    input  [DATA_WIDTH-1:0]         i_ddr3_ch04_ram_rd_data       , // input data.read data for writing ddr3
    output                          o_ddr3_ch04_ram_wr_en         , // write data from reading ddr3
    output                          o_ddr3_ch04_ram_wr_en_last    , // write data from reading ddr3
    output [DATA_WIDTH-1:0]         o_ddr3_ch04_ram_wr_data       , // write data from reading ddr3
    // ============= ch05
    input                           i_ddr3_ch05_req               , // request
    input   [15:0]                  i_ddr3_ch05_priority          , // priority.0:highest priority
    input                           i_ddr3_ch05_rd_wrn            , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]        i_ddr3_ch05_start_addr        , // start address. 
    input   [11:0]                  i_ddr3_ch05_length            , // 12bit's num.0~4095
    output                          o_ddr3_ch05_ack               , // ack         
    output                          o_ddr3_ch05_op_done           , // operate done
    output                          o_ddr3_ch05_ram_rd_en         , // read data for writing ddr3
    output                          o_ddr3_ch05_ram_rd_en_last    , // read data for writing ddr3
    input  [DATA_WIDTH-1:0]         i_ddr3_ch05_ram_rd_data       , // input data.read data for writing ddr3
    output                          o_ddr3_ch05_ram_wr_en         , // write data from reading ddr3
    output                          o_ddr3_ch05_ram_wr_en_last    , // write data from reading ddr3
    output [DATA_WIDTH-1:0]         o_ddr3_ch05_ram_wr_data       , // write data from reading ddr3
    // ============= ch06
    input                           i_ddr3_ch06_req               , // request
    input   [15:0]                  i_ddr3_ch06_priority          , // priority.0:highest priority
    input                           i_ddr3_ch06_rd_wrn            , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]        i_ddr3_ch06_start_addr        , // start address. 
    input   [11:0]                  i_ddr3_ch06_length            , // 12bit's num.0~4095
    output                          o_ddr3_ch06_ack               , // ack         
    output                          o_ddr3_ch06_op_done           , // operate done
    output                          o_ddr3_ch06_ram_rd_en         , // read data for writing ddr3
    output                          o_ddr3_ch06_ram_rd_en_last    , // read data for writing ddr3
    input  [DATA_WIDTH-1:0]         i_ddr3_ch06_ram_rd_data       , // input data.read data for writing ddr3
    output                          o_ddr3_ch06_ram_wr_en         , // write data from reading ddr3
    output                          o_ddr3_ch06_ram_wr_en_last    , // write data from reading ddr3
    output [DATA_WIDTH-1:0]         o_ddr3_ch06_ram_wr_data       , // write data from reading ddr3
    // ============= ch07
    input                           i_ddr3_ch07_req               , // request
    input   [15:0]                  i_ddr3_ch07_priority          , // priority.0:highest priority
    input                           i_ddr3_ch07_rd_wrn            , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]        i_ddr3_ch07_start_addr        , // start address. 
    input   [11:0]                  i_ddr3_ch07_length            , // 12bit's num.0~4095
    output                          o_ddr3_ch07_ack               , // ack         
    output                          o_ddr3_ch07_op_done           , // operate done
    output                          o_ddr3_ch07_ram_rd_en         , // read data for writing ddr3
    output                          o_ddr3_ch07_ram_rd_en_last    , // read data for writing ddr3
    input  [DATA_WIDTH-1:0]         i_ddr3_ch07_ram_rd_data       , // input data.read data for writing ddr3
    output                          o_ddr3_ch07_ram_wr_en         , // write data from reading ddr3
    output                          o_ddr3_ch07_ram_wr_en_last    , // write data from reading ddr3
    output [DATA_WIDTH-1:0]         o_ddr3_ch07_ram_wr_data       , // write data from reading ddr3
    // ============= ch08
    input                           i_ddr3_ch08_req               , // request
    input   [15:0]                  i_ddr3_ch08_priority          , // priority.0:highest priority
    input                           i_ddr3_ch08_rd_wrn            , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]        i_ddr3_ch08_start_addr        , // start address. 
    input   [11:0]                  i_ddr3_ch08_length            , // 12bit's num.0~4095
    output                          o_ddr3_ch08_ack               , // ack         
    output                          o_ddr3_ch08_op_done           , // operate done
    output                          o_ddr3_ch08_ram_rd_en         , // read data for writing ddr3
    output                          o_ddr3_ch08_ram_rd_en_last    , // read data for writing ddr3
    input  [DATA_WIDTH-1:0]         i_ddr3_ch08_ram_rd_data       , // input data.read data for writing ddr3
    output                          o_ddr3_ch08_ram_wr_en         , // write data from reading ddr3
    output                          o_ddr3_ch08_ram_wr_en_last    , // write data from reading ddr3
    output [DATA_WIDTH-1:0]         o_ddr3_ch08_ram_wr_data       , // write data from reading ddr3
    // ============= ch09
    input                           i_ddr3_ch09_req               , // request
    input   [15:0]                  i_ddr3_ch09_priority          , // priority.0:highest priority
    input                           i_ddr3_ch09_rd_wrn            , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]        i_ddr3_ch09_start_addr        , // start address. 
    input   [11:0]                  i_ddr3_ch09_length            , // 12bit's num.0~4095
    output                          o_ddr3_ch09_ack               , // ack         
    output                          o_ddr3_ch09_op_done           , // operate done
    output                          o_ddr3_ch09_ram_rd_en         , // read data for writing ddr3
    output                          o_ddr3_ch09_ram_rd_en_last    , // read data for writing ddr3
    input  [DATA_WIDTH-1:0]         i_ddr3_ch09_ram_rd_data       , // input data.read data for writing ddr3
    output                          o_ddr3_ch09_ram_wr_en         , // write data from reading ddr3
    output                          o_ddr3_ch09_ram_wr_en_last    , // write data from reading ddr3
    output [DATA_WIDTH-1:0]         o_ddr3_ch09_ram_wr_data       , // write data from reading ddr3
    // ============= ch10
    input                           i_ddr3_ch10_req               , // request
    input   [15:0]                  i_ddr3_ch10_priority          , // priority.0:highest priority
    input                           i_ddr3_ch10_rd_wrn            , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]        i_ddr3_ch10_start_addr        , // start address. 
    input   [11:0]                  i_ddr3_ch10_length            , // 12bit's num.0~4095
    output                          o_ddr3_ch10_ack               , // ack         
    output                          o_ddr3_ch10_op_done           , // operate done
    output                          o_ddr3_ch10_ram_rd_en         , // read data for writing ddr3
    output                          o_ddr3_ch10_ram_rd_en_last    , // read data for writing ddr3
    input  [DATA_WIDTH-1:0]         i_ddr3_ch10_ram_rd_data       , // input data.read data for writing ddr3
    output                          o_ddr3_ch10_ram_wr_en         , // write data from reading ddr3
    output                          o_ddr3_ch10_ram_wr_en_last    , // write data from reading ddr3
    output [DATA_WIDTH-1:0]         o_ddr3_ch10_ram_wr_data       , // write data from reading ddr3
    // ============= ch11
    input                           i_ddr3_ch11_req               , // request
    input   [15:0]                  i_ddr3_ch11_priority          , // priority.0:highest priority
    input                           i_ddr3_ch11_rd_wrn            , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]        i_ddr3_ch11_start_addr        , // start address. 
    input   [11:0]                  i_ddr3_ch11_length            , // 12bit's num.0~4095
    output                          o_ddr3_ch11_ack               , // ack         
    output                          o_ddr3_ch11_op_done           , // operate done
    output                          o_ddr3_ch11_ram_rd_en         , // read data for writing ddr3
    output                          o_ddr3_ch11_ram_rd_en_last    , // read data for writing ddr3
    input  [DATA_WIDTH-1:0]         i_ddr3_ch11_ram_rd_data       , // input data.read data for writing ddr3
    output                          o_ddr3_ch11_ram_wr_en         , // write data from reading ddr3
    output                          o_ddr3_ch11_ram_wr_en_last    , // write data from reading ddr3
    output [DATA_WIDTH-1:0]         o_ddr3_ch11_ram_wr_data       , // write data from reading ddr3
    // ============= ch12
    input                           i_ddr3_ch12_req               , // request
    input   [15:0]                  i_ddr3_ch12_priority          , // priority.0:highest priority
    input                           i_ddr3_ch12_rd_wrn            , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]        i_ddr3_ch12_start_addr        , // start address. 
    input   [11:0]                  i_ddr3_ch12_length            , // 12bit's num.0~4095
    output                          o_ddr3_ch12_ack               , // ack         
    output                          o_ddr3_ch12_op_done           , // operate done
    output                          o_ddr3_ch12_ram_rd_en         , // read data for writing ddr3
    output                          o_ddr3_ch12_ram_rd_en_last    , // read data for writing ddr3
    input  [DATA_WIDTH-1:0]         i_ddr3_ch12_ram_rd_data       , // input data.read data for writing ddr3
    output                          o_ddr3_ch12_ram_wr_en         , // write data from reading ddr3
    output                          o_ddr3_ch12_ram_wr_en_last    , // write data from reading ddr3
    output [DATA_WIDTH-1:0]         o_ddr3_ch12_ram_wr_data       , // write data from reading ddr3
    // ============= ch13
    input                           i_ddr3_ch13_req               , // request
    input   [15:0]                  i_ddr3_ch13_priority          , // priority.0:highest priority
    input                           i_ddr3_ch13_rd_wrn            , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]        i_ddr3_ch13_start_addr        , // start address. 
    input   [11:0]                  i_ddr3_ch13_length            , // 12bit's num.0~4095
    output                          o_ddr3_ch13_ack               , // ack         
    output                          o_ddr3_ch13_op_done           , // operate done
    output                          o_ddr3_ch13_ram_rd_en         , // read data for writing ddr3
    output                          o_ddr3_ch13_ram_rd_en_last    , // read data for writing ddr3
    input  [DATA_WIDTH-1:0]         i_ddr3_ch13_ram_rd_data       , // input data.read data for writing ddr3
    output                          o_ddr3_ch13_ram_wr_en         , // write data from reading ddr3
    output                          o_ddr3_ch13_ram_wr_en_last    , // write data from reading ddr3
    output [DATA_WIDTH-1:0]         o_ddr3_ch13_ram_wr_data       , // write data from reading ddr3
    // ============= ch14
    input                           i_ddr3_ch14_req               , // request
    input   [15:0]                  i_ddr3_ch14_priority          , // priority.0:highest priority
    input                           i_ddr3_ch14_rd_wrn            , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]        i_ddr3_ch14_start_addr        , // start address. 
    input   [11:0]                  i_ddr3_ch14_length            , // 12bit's num.0~4095
    output                          o_ddr3_ch14_ack               , // ack         
    output                          o_ddr3_ch14_op_done           , // operate done
    output                          o_ddr3_ch14_ram_rd_en         , // read data for writing ddr3
    output                          o_ddr3_ch14_ram_rd_en_last    , // read data for writing ddr3
    input  [DATA_WIDTH-1:0]         i_ddr3_ch14_ram_rd_data       , // input data.read data for writing ddr3
    output                          o_ddr3_ch14_ram_wr_en         , // write data from reading ddr3
    output                          o_ddr3_ch14_ram_wr_en_last    , // write data from reading ddr3
    output [DATA_WIDTH-1:0]         o_ddr3_ch14_ram_wr_data       , // write data from reading ddr3
    // =================================== ch15
    input                           i_ddr3_ch15_req               , // request
    input   [15:0]                  i_ddr3_ch15_priority          , // priority.0:highest priority
    input                           i_ddr3_ch15_rd_wrn            , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]        i_ddr3_ch15_start_addr        , // start address. 
    input   [11:0]                  i_ddr3_ch15_length            , // 12bit's num.0~4095
    output                          o_ddr3_ch15_ack               , // ack         
    output                          o_ddr3_ch15_op_done           , // operate done
    output                          o_ddr3_ch15_ram_rd_en         , // read data for writing ddr3
    output                          o_ddr3_ch15_ram_rd_en_last    , // read data for writing ddr3
    input  [DATA_WIDTH-1:0]         i_ddr3_ch15_ram_rd_data       , // input data.read data for writing ddr3
    output                          o_ddr3_ch15_ram_wr_en         , // write data from reading ddr3
    output                          o_ddr3_ch15_ram_wr_en_last    , // write data from reading ddr3
    output [DATA_WIDTH-1:0]         o_ddr3_ch15_ram_wr_data       , // write data from reading ddr3
    // =================================== ch16
    input                           i_ddr3_ch16_req               , // request
    input   [15:0]                  i_ddr3_ch16_priority          , // priority.0:highest priority
    input                           i_ddr3_ch16_rd_wrn            , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]        i_ddr3_ch16_start_addr        , // start address. 
    input   [11:0]                  i_ddr3_ch16_length            , // 12bit's num.0~4095
    output                          o_ddr3_ch16_ack               , // ack         
    output                          o_ddr3_ch16_op_done           , // operate done
    output                          o_ddr3_ch16_ram_rd_en         , // read data for writing ddr3
    output                          o_ddr3_ch16_ram_rd_en_last    , // read data for writing ddr3
    input  [DATA_WIDTH-1:0]         i_ddr3_ch16_ram_rd_data       , // input data.read data for writing ddr3
    output                          o_ddr3_ch16_ram_wr_en         , // write data from reading ddr3
    output                          o_ddr3_ch16_ram_wr_en_last    , // write data from reading ddr3
    output [DATA_WIDTH-1:0]         o_ddr3_ch16_ram_wr_data       , // write data from reading ddr3
    // =================================== ch17
    input                           i_ddr3_ch17_req               , // request
    input   [15:0]                  i_ddr3_ch17_priority          , // priority.0:highest priority
    input                           i_ddr3_ch17_rd_wrn            , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]        i_ddr3_ch17_start_addr        , // start address. 
    input   [11:0]                  i_ddr3_ch17_length            , // 12bit's num.0~4095
    output                          o_ddr3_ch17_ack               , // ack         
    output                          o_ddr3_ch17_op_done           , // operate done
    output                          o_ddr3_ch17_ram_rd_en         , // read data for writing ddr3
    output                          o_ddr3_ch17_ram_rd_en_last    , // read data for writing ddr3
    input  [DATA_WIDTH-1:0]         i_ddr3_ch17_ram_rd_data       , // input data.read data for writing ddr3
    output                          o_ddr3_ch17_ram_wr_en         , // write data from reading ddr3
    output                          o_ddr3_ch17_ram_wr_en_last    , // write data from reading ddr3
    output [DATA_WIDTH-1:0]         o_ddr3_ch17_ram_wr_data       , // write data from reading ddr3
    // =================================== ch18
    input                           i_ddr3_ch18_req               , // request
    input   [15:0]                  i_ddr3_ch18_priority          , // priority.0:highest priority
    input                           i_ddr3_ch18_rd_wrn            , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]        i_ddr3_ch18_start_addr        , // start address. 
    input   [11:0]                  i_ddr3_ch18_length            , // 12bit's num.0~4095
    output                          o_ddr3_ch18_ack               , // ack         
    output                          o_ddr3_ch18_op_done           , // operate done
    output                          o_ddr3_ch18_ram_rd_en         , // read data for writing ddr3
    output                          o_ddr3_ch18_ram_rd_en_last    , // read data for writing ddr3
    input  [DATA_WIDTH-1:0]         i_ddr3_ch18_ram_rd_data       , // input data.read data for writing ddr3
    output                          o_ddr3_ch18_ram_wr_en         , // write data from reading ddr3
    output                          o_ddr3_ch18_ram_wr_en_last    , // write data from reading ddr3
    output [DATA_WIDTH-1:0]         o_ddr3_ch18_ram_wr_data       , // write data from reading ddr3
    // =================================== ch19
    input                           i_ddr3_ch19_req               , // request
    input   [15:0]                  i_ddr3_ch19_priority          , // priority.0:highest priority
    input                           i_ddr3_ch19_rd_wrn            , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]        i_ddr3_ch19_start_addr        , // start address. 
    input   [11:0]                  i_ddr3_ch19_length            , // 12bit's num.0~4095
    output                          o_ddr3_ch19_ack               , // ack         
    output                          o_ddr3_ch19_op_done           , // operate done
    output                          o_ddr3_ch19_ram_rd_en         , // read data for writing ddr3
    output                          o_ddr3_ch19_ram_rd_en_last    , // read data for writing ddr3
    input  [DATA_WIDTH-1:0]         i_ddr3_ch19_ram_rd_data       , // input data.read data for writing ddr3
    output                          o_ddr3_ch19_ram_wr_en         , // write data from reading ddr3
    output                          o_ddr3_ch19_ram_wr_en_last    , // write data from reading ddr3
    output [DATA_WIDTH-1:0]         o_ddr3_ch19_ram_wr_data       , // write data from reading ddr3
    // =================================== ch20
    input                           i_ddr3_ch20_req               , // request
    input   [15:0]                  i_ddr3_ch20_priority          , // priority.0:highest priority
    input                           i_ddr3_ch20_rd_wrn            , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]        i_ddr3_ch20_start_addr        , // start address. 
    input   [11:0]                  i_ddr3_ch20_length            , // 12bit's num.0~4095
    output                          o_ddr3_ch20_ack               , // ack         
    output                          o_ddr3_ch20_op_done           , // operate done
    output                          o_ddr3_ch20_ram_rd_en         , // read data for writing ddr3
    output                          o_ddr3_ch20_ram_rd_en_last    , // read data for writing ddr3
    input  [DATA_WIDTH-1:0]         i_ddr3_ch20_ram_rd_data       , // input data.read data for writing ddr3
    output                          o_ddr3_ch20_ram_wr_en         , // write data from reading ddr3
    output                          o_ddr3_ch20_ram_wr_en_last    , // write data from reading ddr3
    output [DATA_WIDTH-1:0]         o_ddr3_ch20_ram_wr_data       , // write data from reading ddr3
    // =================================== ch21
    input                           i_ddr3_ch21_req               , // request
    input   [15:0]                  i_ddr3_ch21_priority          , // priority.0:highest priority
    input                           i_ddr3_ch21_rd_wrn            , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]        i_ddr3_ch21_start_addr        , // start address. 
    input   [11:0]                  i_ddr3_ch21_length            , // 12bit's num.0~4095
    output                          o_ddr3_ch21_ack               , // ack         
    output                          o_ddr3_ch21_op_done           , // operate done
    output                          o_ddr3_ch21_ram_rd_en         , // read data for writing ddr3
    output                          o_ddr3_ch21_ram_rd_en_last    , // read data for writing ddr3
    input  [DATA_WIDTH-1:0]         i_ddr3_ch21_ram_rd_data       , // input data.read data for writing ddr3
    output                          o_ddr3_ch21_ram_wr_en         , // write data from reading ddr3
    output                          o_ddr3_ch21_ram_wr_en_last    , // write data from reading ddr3
    output [DATA_WIDTH-1:0]         o_ddr3_ch21_ram_wr_data         // write data from reading ddr3
    
);

    // =====================================================
    // Internal Signals Declaration
    // =====================================================
    wire                     s_ddr3_sclk           ; // user interface clock.800/4
    wire                     s_ddr3_op_done        ; // operate done.pulse
    wire                     s_ddr3_req            ; // request
    wire                     s_ddr3_rd_wrn         ; // 1:read memory;0:write memory
    wire    [ADDR_WIDTH-1:0] s_ddr3_start_addr     ; // start address. 
    wire    [11:0]           s_ddr3_length         ; // 32bit's num.0~4095    
    wire                     s_ddr3_ack            ; // wire style.   
    wire                     s_ddr3_ram_rd_en      ; // wire style.read data for writing ddr3        
    wire                     s_ddr3_ram_rd_en_last ; // wire style.read data for writing ddr3        
    wire                     s_ddr3_ram_rd_vld     ; // input data valid.read data for writing ddr3  
    wire    [DATA_WIDTH-1:0] s_ddr3_ram_rd_data    ; // input data.read data for writing ddr3        
    wire                     s_ddr3_ram_wr_en      ; // wire style. write data from reading ddr3 
    wire                     s_ddr3_ram_wr_en_last ; // wire style. write data from reading ddr3 
    wire    [DATA_WIDTH-1:0] s_ddr3_ram_wr_data    ; // wire style. write data from reading ddr3 
    wire                     s_init_done;
    assign o_ddr3_init_done = s_init_done;
    assign o_ddr3_sclk      = s_ddr3_sclk;
// =============================================================================
// RTL Body
// =============================================================================

    // =====================================================
    //
    // =====================================================
wire    s_ddr3_busy;
reg     s_ddr3_busy_d1, s_ddr3_busy_d2, s_ddr3_busy_d3;
always @ (posedge s_ddr3_sclk or negedge i_ddr3_rst_n)
begin
    if (i_ddr3_rst_n == 1'b0) begin
        s_ddr3_busy_d1 <= 1'b0;
        s_ddr3_busy_d2 <= 1'b0;
        s_ddr3_busy_d3 <= 1'b0;
    end
    else begin
        s_ddr3_busy_d1 <= s_ddr3_busy   ;
        s_ddr3_busy_d2 <= s_ddr3_busy_d1;
        s_ddr3_busy_d3 <= s_ddr3_busy_d2;
    end
end

// assign  s_ddr3_ack = (s_ddr3_busy_d2 == 1'b1) && (s_ddr3_busy_d3 == 1'b0);
assign  s_ddr3_ack = (s_ddr3_busy == 1'b1) && (s_ddr3_busy_d1 == 1'b0);

    ddr3_arb 
    #(
        .DATA_WIDTH                 ( DATA_WIDTH                  ),
        .ADDR_WIDTH                 ( ADDR_WIDTH                  )   // actually needed width is 27 in SVR2930.
    ) 
    u_ddr3_arb(
        .i_rst_n                    ( i_ddr3_rst_n & s_init_done  ),
        .i_clk                      ( s_ddr3_sclk                 ),
        .i_soft_rst                 ( i_ddr3_soft_rst             ),
        
        
        .i_ch00_req                 ( i_ddr3_ch00_req             ),
        .i_ch00_priority            ( i_ddr3_ch00_priority        ),
        .i_ch00_rd_wrn              ( i_ddr3_ch00_rd_wrn          ),
        .i_ch00_start_addr          ( i_ddr3_ch00_start_addr      ),
        .i_ch00_length              ( i_ddr3_ch00_length          ),
        .o_ch00_ack                 ( o_ddr3_ch00_ack             ),
        .o_ch00_op_done             ( o_ddr3_ch00_op_done         ),
        .o_ch00_ram_rd_en           ( o_ddr3_ch00_ram_rd_en       ),
        .o_ch00_ram_rd_en_last      ( o_ddr3_ch00_ram_rd_en_last  ),
        .i_ch00_ram_rd_data         ( i_ddr3_ch00_ram_rd_data     ),
        .o_ch00_ram_wr_en           ( o_ddr3_ch00_ram_wr_en       ),
        .o_ch00_ram_wr_en_last      ( o_ddr3_ch00_ram_wr_en_last  ),
        .o_ch00_ram_wr_data         ( o_ddr3_ch00_ram_wr_data     ),
        
        .i_ch01_req                 ( i_ddr3_ch01_req             ),
        .i_ch01_priority            ( i_ddr3_ch01_priority        ),
        .i_ch01_rd_wrn              ( i_ddr3_ch01_rd_wrn          ),
        .i_ch01_start_addr          ( i_ddr3_ch01_start_addr      ),
        .i_ch01_length              ( i_ddr3_ch01_length          ),
        .o_ch01_ack                 ( o_ddr3_ch01_ack             ),
        .o_ch01_op_done             ( o_ddr3_ch01_op_done         ),
        .o_ch01_ram_rd_en           ( o_ddr3_ch01_ram_rd_en       ),
        .o_ch01_ram_rd_en_last      ( o_ddr3_ch01_ram_rd_en_last  ),
        .i_ch01_ram_rd_data         ( i_ddr3_ch01_ram_rd_data     ),
        .o_ch01_ram_wr_en           ( o_ddr3_ch01_ram_wr_en       ),
        .o_ch01_ram_wr_en_last      ( o_ddr3_ch01_ram_wr_en_last  ),
        .o_ch01_ram_wr_data         ( o_ddr3_ch01_ram_wr_data     ),
        
        .i_ch02_req                 ( i_ddr3_ch02_req             ),
        .i_ch02_priority            ( i_ddr3_ch02_priority        ),
        .i_ch02_rd_wrn              ( i_ddr3_ch02_rd_wrn          ),
        .i_ch02_start_addr          ( i_ddr3_ch02_start_addr      ),
        .i_ch02_length              ( i_ddr3_ch02_length          ),
        .o_ch02_ack                 ( o_ddr3_ch02_ack             ),
        .o_ch02_op_done             ( o_ddr3_ch02_op_done         ),
        .o_ch02_ram_rd_en           ( o_ddr3_ch02_ram_rd_en       ),
        .o_ch02_ram_rd_en_last      ( o_ddr3_ch02_ram_rd_en_last  ),
        .i_ch02_ram_rd_data         ( i_ddr3_ch02_ram_rd_data     ),
        .o_ch02_ram_wr_en           ( o_ddr3_ch02_ram_wr_en       ),
        .o_ch02_ram_wr_en_last      ( o_ddr3_ch02_ram_wr_en_last  ),
        .o_ch02_ram_wr_data         ( o_ddr3_ch02_ram_wr_data     ),
        
        .i_ch03_req                 ( i_ddr3_ch03_req             ),
        .i_ch03_priority            ( i_ddr3_ch03_priority        ),
        .i_ch03_rd_wrn              ( i_ddr3_ch03_rd_wrn          ),
        .i_ch03_start_addr          ( i_ddr3_ch03_start_addr      ),
        .i_ch03_length              ( i_ddr3_ch03_length          ),
        .o_ch03_ack                 ( o_ddr3_ch03_ack             ),
        .o_ch03_op_done             ( o_ddr3_ch03_op_done         ),
        .o_ch03_ram_rd_en           ( o_ddr3_ch03_ram_rd_en       ),
        .o_ch03_ram_rd_en_last      ( o_ddr3_ch03_ram_rd_en_last  ),
        .i_ch03_ram_rd_data         ( i_ddr3_ch03_ram_rd_data     ),
        .o_ch03_ram_wr_en           ( o_ddr3_ch03_ram_wr_en       ),
        .o_ch03_ram_wr_en_last      ( o_ddr3_ch03_ram_wr_en_last  ),
        .o_ch03_ram_wr_data         ( o_ddr3_ch03_ram_wr_data     ),
        
        .i_ch04_req                 ( i_ddr3_ch04_req             ),
        .i_ch04_priority            ( i_ddr3_ch04_priority        ),
        .i_ch04_rd_wrn              ( i_ddr3_ch04_rd_wrn          ),
        .i_ch04_start_addr          ( i_ddr3_ch04_start_addr      ),
        .i_ch04_length              ( i_ddr3_ch04_length          ),
        .o_ch04_ack                 ( o_ddr3_ch04_ack             ),
        .o_ch04_op_done             ( o_ddr3_ch04_op_done         ),
        .o_ch04_ram_rd_en           ( o_ddr3_ch04_ram_rd_en       ),
        .o_ch04_ram_rd_en_last      ( o_ddr3_ch04_ram_rd_en_last  ),
        .i_ch04_ram_rd_data         ( i_ddr3_ch04_ram_rd_data     ),
        .o_ch04_ram_wr_en           ( o_ddr3_ch04_ram_wr_en       ),
        .o_ch04_ram_wr_en_last      ( o_ddr3_ch04_ram_wr_en_last  ),
        .o_ch04_ram_wr_data         ( o_ddr3_ch04_ram_wr_data     ),
        
        .i_ch05_req                 ( i_ddr3_ch05_req             ),
        .i_ch05_priority            ( i_ddr3_ch05_priority        ),
        .i_ch05_rd_wrn              ( i_ddr3_ch05_rd_wrn          ),
        .i_ch05_start_addr          ( i_ddr3_ch05_start_addr      ),
        .i_ch05_length              ( i_ddr3_ch05_length          ),
        .o_ch05_ack                 ( o_ddr3_ch05_ack             ),
        .o_ch05_op_done             ( o_ddr3_ch05_op_done         ),
        .o_ch05_ram_rd_en           ( o_ddr3_ch05_ram_rd_en       ),
        .o_ch05_ram_rd_en_last      ( o_ddr3_ch05_ram_rd_en_last  ),
        .i_ch05_ram_rd_data         ( i_ddr3_ch05_ram_rd_data     ),
        .o_ch05_ram_wr_en           ( o_ddr3_ch05_ram_wr_en       ),
        .o_ch05_ram_wr_en_last      ( o_ddr3_ch05_ram_wr_en_last  ),
        .o_ch05_ram_wr_data         ( o_ddr3_ch05_ram_wr_data     ),
        
        .i_ch06_req                 ( i_ddr3_ch06_req             ),
        .i_ch06_priority            ( i_ddr3_ch06_priority        ),
        .i_ch06_rd_wrn              ( i_ddr3_ch06_rd_wrn          ),
        .i_ch06_start_addr          ( i_ddr3_ch06_start_addr      ),
        .i_ch06_length              ( i_ddr3_ch06_length          ),
        .o_ch06_ack                 ( o_ddr3_ch06_ack             ),
        .o_ch06_op_done             ( o_ddr3_ch06_op_done         ),
        .o_ch06_ram_rd_en           ( o_ddr3_ch06_ram_rd_en       ),
        .o_ch06_ram_rd_en_last      ( o_ddr3_ch06_ram_rd_en_last  ),
        .i_ch06_ram_rd_data         ( i_ddr3_ch06_ram_rd_data     ),
        .o_ch06_ram_wr_en           ( o_ddr3_ch06_ram_wr_en       ),
        .o_ch06_ram_wr_en_last      ( o_ddr3_ch06_ram_wr_en_last  ),
        .o_ch06_ram_wr_data         ( o_ddr3_ch06_ram_wr_data     ),
        
        .i_ch07_req                 ( i_ddr3_ch07_req             ),
        .i_ch07_priority            ( i_ddr3_ch07_priority        ),
        .i_ch07_rd_wrn              ( i_ddr3_ch07_rd_wrn          ),
        .i_ch07_start_addr          ( i_ddr3_ch07_start_addr      ),
        .i_ch07_length              ( i_ddr3_ch07_length          ),
        .o_ch07_ack                 ( o_ddr3_ch07_ack             ),
        .o_ch07_op_done             ( o_ddr3_ch07_op_done         ),
        .o_ch07_ram_rd_en           ( o_ddr3_ch07_ram_rd_en       ),
        .o_ch07_ram_rd_en_last      ( o_ddr3_ch07_ram_rd_en_last  ),
        .i_ch07_ram_rd_data         ( i_ddr3_ch07_ram_rd_data     ),
        .o_ch07_ram_wr_en           ( o_ddr3_ch07_ram_wr_en       ),
        .o_ch07_ram_wr_en_last      ( o_ddr3_ch07_ram_wr_en_last  ),
        .o_ch07_ram_wr_data         ( o_ddr3_ch07_ram_wr_data     ),
        
        .i_ch08_req                 ( i_ddr3_ch08_req             ),
        .i_ch08_priority            ( i_ddr3_ch08_priority        ),
        .i_ch08_rd_wrn              ( i_ddr3_ch08_rd_wrn          ),
        .i_ch08_start_addr          ( i_ddr3_ch08_start_addr      ),
        .i_ch08_length              ( i_ddr3_ch08_length          ),
        .o_ch08_ack                 ( o_ddr3_ch08_ack             ),
        .o_ch08_op_done             ( o_ddr3_ch08_op_done         ),
        .o_ch08_ram_rd_en           ( o_ddr3_ch08_ram_rd_en       ),
        .o_ch08_ram_rd_en_last      ( o_ddr3_ch08_ram_rd_en_last  ),
        .i_ch08_ram_rd_data         ( i_ddr3_ch08_ram_rd_data     ),
        .o_ch08_ram_wr_en           ( o_ddr3_ch08_ram_wr_en       ),
        .o_ch08_ram_wr_en_last      ( o_ddr3_ch08_ram_wr_en_last  ),
        .o_ch08_ram_wr_data         ( o_ddr3_ch08_ram_wr_data     ),
        
        .i_ch09_req                 ( i_ddr3_ch09_req             ),
        .i_ch09_priority            ( i_ddr3_ch09_priority        ),
        .i_ch09_rd_wrn              ( i_ddr3_ch09_rd_wrn          ),
        .i_ch09_start_addr          ( i_ddr3_ch09_start_addr      ),
        .i_ch09_length              ( i_ddr3_ch09_length          ),
        .o_ch09_ack                 ( o_ddr3_ch09_ack             ),
        .o_ch09_op_done             ( o_ddr3_ch09_op_done         ),
        .o_ch09_ram_rd_en           ( o_ddr3_ch09_ram_rd_en       ),
        .o_ch09_ram_rd_en_last      ( o_ddr3_ch09_ram_rd_en_last  ),
        .i_ch09_ram_rd_data         ( i_ddr3_ch09_ram_rd_data     ),
        .o_ch09_ram_wr_en           ( o_ddr3_ch09_ram_wr_en       ),
        .o_ch09_ram_wr_en_last      ( o_ddr3_ch09_ram_wr_en_last  ),
        .o_ch09_ram_wr_data         ( o_ddr3_ch09_ram_wr_data     ),
        
        .i_ch10_req                 ( i_ddr3_ch10_req             ),
        .i_ch10_priority            ( i_ddr3_ch10_priority        ),
        .i_ch10_rd_wrn              ( i_ddr3_ch10_rd_wrn          ),
        .i_ch10_start_addr          ( i_ddr3_ch10_start_addr      ),
        .i_ch10_length              ( i_ddr3_ch10_length          ),
        .o_ch10_ack                 ( o_ddr3_ch10_ack             ),
        .o_ch10_op_done             ( o_ddr3_ch10_op_done         ),
        .o_ch10_ram_rd_en           ( o_ddr3_ch10_ram_rd_en       ),
        .o_ch10_ram_rd_en_last      ( o_ddr3_ch10_ram_rd_en_last  ),
        .i_ch10_ram_rd_data         ( i_ddr3_ch10_ram_rd_data     ),
        .o_ch10_ram_wr_en           ( o_ddr3_ch10_ram_wr_en       ),
        .o_ch10_ram_wr_en_last      ( o_ddr3_ch10_ram_wr_en_last  ),
        .o_ch10_ram_wr_data         ( o_ddr3_ch10_ram_wr_data     ),
       
        .i_ch11_req                 ( i_ddr3_ch11_req             ),
        .i_ch11_priority            ( i_ddr3_ch11_priority        ),
        .i_ch11_rd_wrn              ( i_ddr3_ch11_rd_wrn          ),
        .i_ch11_start_addr          ( i_ddr3_ch11_start_addr      ),
        .i_ch11_length              ( i_ddr3_ch11_length          ),
        .o_ch11_ack                 ( o_ddr3_ch11_ack             ),
        .o_ch11_op_done             ( o_ddr3_ch11_op_done         ),
        .o_ch11_ram_rd_en           ( o_ddr3_ch11_ram_rd_en       ),
        .o_ch11_ram_rd_en_last      ( o_ddr3_ch11_ram_rd_en_last  ),
        .i_ch11_ram_rd_data         ( i_ddr3_ch11_ram_rd_data     ),
        .o_ch11_ram_wr_en           ( o_ddr3_ch11_ram_wr_en       ),
        .o_ch11_ram_wr_en_last      ( o_ddr3_ch11_ram_wr_en_last  ),
        .o_ch11_ram_wr_data         ( o_ddr3_ch11_ram_wr_data     ),
       
        .i_ch12_req                 ( i_ddr3_ch12_req             ),
        .i_ch12_priority            ( i_ddr3_ch12_priority        ),
        .i_ch12_rd_wrn              ( i_ddr3_ch12_rd_wrn          ),
        .i_ch12_start_addr          ( i_ddr3_ch12_start_addr      ),
        .i_ch12_length              ( i_ddr3_ch12_length          ),
        .o_ch12_ack                 ( o_ddr3_ch12_ack             ),
        .o_ch12_op_done             ( o_ddr3_ch12_op_done         ),
        .o_ch12_ram_rd_en           ( o_ddr3_ch12_ram_rd_en       ),
        .o_ch12_ram_rd_en_last      ( o_ddr3_ch12_ram_rd_en_last  ),
        .i_ch12_ram_rd_data         ( i_ddr3_ch12_ram_rd_data     ),
        .o_ch12_ram_wr_en           ( o_ddr3_ch12_ram_wr_en       ),
        .o_ch12_ram_wr_en_last      ( o_ddr3_ch12_ram_wr_en_last  ),
        .o_ch12_ram_wr_data         ( o_ddr3_ch12_ram_wr_data     ),
       
        .i_ch13_req                 ( i_ddr3_ch13_req             ),
        .i_ch13_priority            ( i_ddr3_ch13_priority        ),
        .i_ch13_rd_wrn              ( i_ddr3_ch13_rd_wrn          ),
        .i_ch13_start_addr          ( i_ddr3_ch13_start_addr      ),
        .i_ch13_length              ( i_ddr3_ch13_length          ),
        .o_ch13_ack                 ( o_ddr3_ch13_ack             ),
        .o_ch13_op_done             ( o_ddr3_ch13_op_done         ),
        .o_ch13_ram_rd_en           ( o_ddr3_ch13_ram_rd_en       ),
        .o_ch13_ram_rd_en_last      ( o_ddr3_ch13_ram_rd_en_last  ),
        .i_ch13_ram_rd_data         ( i_ddr3_ch13_ram_rd_data     ),
        .o_ch13_ram_wr_en           ( o_ddr3_ch13_ram_wr_en       ),
        .o_ch13_ram_wr_en_last      ( o_ddr3_ch13_ram_wr_en_last  ),
        .o_ch13_ram_wr_data         ( o_ddr3_ch13_ram_wr_data     ),
       
        .i_ch14_req                 ( i_ddr3_ch14_req             ),
        .i_ch14_priority            ( i_ddr3_ch14_priority        ),
        .i_ch14_rd_wrn              ( i_ddr3_ch14_rd_wrn          ),
        .i_ch14_start_addr          ( i_ddr3_ch14_start_addr      ),
        .i_ch14_length              ( i_ddr3_ch14_length          ),
        .o_ch14_ack                 ( o_ddr3_ch14_ack             ),
        .o_ch14_op_done             ( o_ddr3_ch14_op_done         ),
        .o_ch14_ram_rd_en           ( o_ddr3_ch14_ram_rd_en       ),
        .o_ch14_ram_rd_en_last      ( o_ddr3_ch14_ram_rd_en_last  ),
        .i_ch14_ram_rd_data         ( i_ddr3_ch14_ram_rd_data     ),
        .o_ch14_ram_wr_en           ( o_ddr3_ch14_ram_wr_en       ),
        .o_ch14_ram_wr_en_last      ( o_ddr3_ch14_ram_wr_en_last  ),
        .o_ch14_ram_wr_data         ( o_ddr3_ch14_ram_wr_data     ),
       
        .i_ch15_req                 ( i_ddr3_ch15_req             ),
        .i_ch15_priority            ( i_ddr3_ch15_priority        ),
        .i_ch15_rd_wrn              ( i_ddr3_ch15_rd_wrn          ),
        .i_ch15_start_addr          ( i_ddr3_ch15_start_addr      ),
        .i_ch15_length              ( i_ddr3_ch15_length          ),
        .o_ch15_ack                 ( o_ddr3_ch15_ack             ),
        .o_ch15_op_done             ( o_ddr3_ch15_op_done         ),
        .o_ch15_ram_rd_en           ( o_ddr3_ch15_ram_rd_en       ),
        .o_ch15_ram_rd_en_last      ( o_ddr3_ch15_ram_rd_en_last  ),
        .i_ch15_ram_rd_data         ( i_ddr3_ch15_ram_rd_data     ),
        .o_ch15_ram_wr_en           ( o_ddr3_ch15_ram_wr_en       ),
        .o_ch15_ram_wr_en_last      ( o_ddr3_ch15_ram_wr_en_last  ),
        .o_ch15_ram_wr_data         ( o_ddr3_ch15_ram_wr_data     ),
       
        .i_ch16_req                 ( i_ddr3_ch16_req             ),
        .i_ch16_priority            ( i_ddr3_ch16_priority        ),
        .i_ch16_rd_wrn              ( i_ddr3_ch16_rd_wrn          ),
        .i_ch16_start_addr          ( i_ddr3_ch16_start_addr      ),
        .i_ch16_length              ( i_ddr3_ch16_length          ),
        .o_ch16_ack                 ( o_ddr3_ch16_ack             ),
        .o_ch16_op_done             ( o_ddr3_ch16_op_done         ),
        .o_ch16_ram_rd_en           ( o_ddr3_ch16_ram_rd_en       ),
        .o_ch16_ram_rd_en_last      ( o_ddr3_ch16_ram_rd_en_last  ),
        .i_ch16_ram_rd_data         ( i_ddr3_ch16_ram_rd_data     ),
        .o_ch16_ram_wr_en           ( o_ddr3_ch16_ram_wr_en       ),
        .o_ch16_ram_wr_en_last      ( o_ddr3_ch16_ram_wr_en_last  ),
        .o_ch16_ram_wr_data         ( o_ddr3_ch16_ram_wr_data     ),
       
        .i_ch17_req                 ( i_ddr3_ch17_req             ),
        .i_ch17_priority            ( i_ddr3_ch17_priority        ),
        .i_ch17_rd_wrn              ( i_ddr3_ch17_rd_wrn          ),
        .i_ch17_start_addr          ( i_ddr3_ch17_start_addr      ),
        .i_ch17_length              ( i_ddr3_ch17_length          ),
        .o_ch17_ack                 ( o_ddr3_ch17_ack             ),
        .o_ch17_op_done             ( o_ddr3_ch17_op_done         ),
        .o_ch17_ram_rd_en           ( o_ddr3_ch17_ram_rd_en       ),
        .o_ch17_ram_rd_en_last      ( o_ddr3_ch17_ram_rd_en_last  ),
        .i_ch17_ram_rd_data         ( i_ddr3_ch17_ram_rd_data     ),
        .o_ch17_ram_wr_en           ( o_ddr3_ch17_ram_wr_en       ),
        .o_ch17_ram_wr_en_last      ( o_ddr3_ch17_ram_wr_en_last  ),
        .o_ch17_ram_wr_data         ( o_ddr3_ch17_ram_wr_data     ),
       
        .i_ch18_req                 ( i_ddr3_ch18_req             ),
        .i_ch18_priority            ( i_ddr3_ch18_priority        ),
        .i_ch18_rd_wrn              ( i_ddr3_ch18_rd_wrn          ),
        .i_ch18_start_addr          ( i_ddr3_ch18_start_addr      ),
        .i_ch18_length              ( i_ddr3_ch18_length          ),
        .o_ch18_ack                 ( o_ddr3_ch18_ack             ),
        .o_ch18_op_done             ( o_ddr3_ch18_op_done         ),
        .o_ch18_ram_rd_en           ( o_ddr3_ch18_ram_rd_en       ),
        .o_ch18_ram_rd_en_last      ( o_ddr3_ch18_ram_rd_en_last  ),
        .i_ch18_ram_rd_data         ( i_ddr3_ch18_ram_rd_data     ),
        .o_ch18_ram_wr_en           ( o_ddr3_ch18_ram_wr_en       ),
        .o_ch18_ram_wr_en_last      ( o_ddr3_ch18_ram_wr_en_last  ),
        .o_ch18_ram_wr_data         ( o_ddr3_ch18_ram_wr_data     ),
       
        .i_ch19_req                 ( i_ddr3_ch19_req             ),
        .i_ch19_priority            ( i_ddr3_ch19_priority        ),
        .i_ch19_rd_wrn              ( i_ddr3_ch19_rd_wrn          ),
        .i_ch19_start_addr          ( i_ddr3_ch19_start_addr      ),
        .i_ch19_length              ( i_ddr3_ch19_length          ),
        .o_ch19_ack                 ( o_ddr3_ch19_ack             ),
        .o_ch19_op_done             ( o_ddr3_ch19_op_done         ),
        .o_ch19_ram_rd_en           ( o_ddr3_ch19_ram_rd_en       ),
        .o_ch19_ram_rd_en_last      ( o_ddr3_ch19_ram_rd_en_last  ),
        .i_ch19_ram_rd_data         ( i_ddr3_ch19_ram_rd_data     ),
        .o_ch19_ram_wr_en           ( o_ddr3_ch19_ram_wr_en       ),
        .o_ch19_ram_wr_en_last      ( o_ddr3_ch19_ram_wr_en_last  ),
        .o_ch19_ram_wr_data         ( o_ddr3_ch19_ram_wr_data     ),
       
        .i_ch20_req                 ( i_ddr3_ch20_req             ),
        .i_ch20_priority            ( i_ddr3_ch20_priority        ),
        .i_ch20_rd_wrn              ( i_ddr3_ch20_rd_wrn          ),
        .i_ch20_start_addr          ( i_ddr3_ch20_start_addr      ),
        .i_ch20_length              ( i_ddr3_ch20_length          ),
        .o_ch20_ack                 ( o_ddr3_ch20_ack             ),
        .o_ch20_op_done             ( o_ddr3_ch20_op_done         ),
        .o_ch20_ram_rd_en           ( o_ddr3_ch20_ram_rd_en       ),
        .o_ch20_ram_rd_en_last      ( o_ddr3_ch20_ram_rd_en_last  ),
        .i_ch20_ram_rd_data         ( i_ddr3_ch20_ram_rd_data     ),
        .o_ch20_ram_wr_en           ( o_ddr3_ch20_ram_wr_en       ),
        .o_ch20_ram_wr_en_last      ( o_ddr3_ch20_ram_wr_en_last  ),
        .o_ch20_ram_wr_data         ( o_ddr3_ch20_ram_wr_data     ),
       
        .i_ch21_req                 ( i_ddr3_ch21_req             ),
        .i_ch21_priority            ( i_ddr3_ch21_priority        ),
        .i_ch21_rd_wrn              ( i_ddr3_ch21_rd_wrn          ),
        .i_ch21_start_addr          ( i_ddr3_ch21_start_addr      ),
        .i_ch21_length              ( i_ddr3_ch21_length          ),
        .o_ch21_ack                 ( o_ddr3_ch21_ack             ),
        .o_ch21_op_done             ( o_ddr3_ch21_op_done         ),
        .o_ch21_ram_rd_en           ( o_ddr3_ch21_ram_rd_en       ),
        .o_ch21_ram_rd_en_last      ( o_ddr3_ch21_ram_rd_en_last  ),
        .i_ch21_ram_rd_data         ( i_ddr3_ch21_ram_rd_data     ),
        .o_ch21_ram_wr_en           ( o_ddr3_ch21_ram_wr_en       ),
        .o_ch21_ram_wr_en_last      ( o_ddr3_ch21_ram_wr_en_last  ),
        .o_ch21_ram_wr_data         ( o_ddr3_ch21_ram_wr_data     ),
       
        // ddr3_controller I/F
        .o_ddr3_req                 ( s_ddr3_req                  ),
        .o_ddr3_rd_wrn              ( s_ddr3_rd_wrn               ),
        .o_ddr3_start_addr          ( s_ddr3_start_addr           ),
        .o_ddr3_length              ( s_ddr3_length               ),
        .i_ddr3_ack                 ( s_ddr3_ack                  ),
        .i_ddr3_op_done             ( s_ddr3_op_done              ),
        
        
        .i_ddr3_ram_rd_en           ( s_ddr3_ram_rd_en            ),
        .i_ddr3_ram_rd_en_last      (                             ),
        .o_ddr3_ram_rd_vld          (                             ),  // 2 clocks after s_ddr3_ram_rd_en;
        .o_ddr3_ram_rd_data         ( s_ddr3_ram_rd_data          ),
        
        .i_ddr3_ram_wr_en           ( s_ddr3_ram_wr_en            ),
        .i_ddr3_ram_wr_en_last      (                             ),
        .i_ddr3_ram_wr_data         ( s_ddr3_ram_wr_data          )
);

wire            s_ddr3_wdata_rdy;
wire    [127:0] s_ddr3_wr_data  ;
wire            s_ddr3_rd_data_vld;
wire    [127:0] s_ddr3_rd_data    ;
// ddr_access_buff_split ddr_access_buff(
ddr_access_buff ddr_access_buff(
    .i_ddr3_sclk         ( s_ddr3_sclk          ),
    .i_rst_n             ( i_ddr3_rst_n         ),
    .i_ddr3_wr_rdn       (~s_ddr3_rd_wrn        ),
    .i_ram_rd_data       ( s_ddr3_ram_rd_data   ),
    .i_ddr3_ack          ( s_ddr3_ack           ),
    .i_ddr3_wr_data_rdy  ( s_ddr3_wdata_rdy     ),
    .i_ddr3_op_done      ( s_ddr3_op_done       ),
    .o_ram_rd_en         ( s_ddr3_ram_rd_en     ),
    .o_ddr3_wr_data      ( s_ddr3_wr_data       ),
    
    .i_ddr3_rd_data_vld  ( s_ddr3_rd_data_vld   ),
    .i_ddr3_rd_data      ( s_ddr3_rd_data       ),
    .o_ram_wr_data_vld   ( s_ddr3_ram_wr_en     ),
    .o_ram_wr_data       ( s_ddr3_ram_wr_data   )
);



    ddr3_controller 
    #(
    .DATA_WIDTH             ( DATA_WIDTH                        ),
    .ADDR_WIDTH             ( ADDR_WIDTH                        )  // actually needed width is 27 in SVR2930.
    ) 
        u_ddr3_controller   ( 
        .i_rst_n            ( i_ddr3_rst_n                      ),
        .i_clk_in           ( i_ddr3_clk                        ), //100M for ddr3-800
        .o_sclk             ( s_ddr3_sclk                       ), //200M for DDR3-800
        
        .i_ddr3_req         ( s_ddr3_req                        ),
        .i_ddr3_we_rdn      (~s_ddr3_rd_wrn                     ), //1: write  0: read  // DIFFERENT from Xilinx!!!
        .i_ddr3_start_addr  ( s_ddr3_start_addr[ADDR_WIDTH-1:0] ),
        .i_ddr3_data_length ( s_ddr3_length[11:0]               ),
        
        .o_ddr3_busy        ( s_ddr3_busy                       ),
        .o_ddr3_operate_done( s_ddr3_op_done                    ),
        
        .o_ddr3_wdata_rdy   ( s_ddr3_wdata_rdy                  ),
        .i_ddr3_wdata       ( s_ddr3_wr_data[DATA_WIDTH-1:0]    ),
        .o_ddr3_rdata_vld   ( s_ddr3_rd_data_vld                ),
        .o_ddt3_rdata       ( s_ddr3_rd_data[DATA_WIDTH-1:0]    ),
        
        .i_read_pulse_tap   ( 12'd0                             ),
        .o_wr_error         (                                   ),
        .o_clk_good         (                                   ),
        .o_init_done        ( s_init_done                       ),
        
        /////////////////ddr3 sdram port////////////////////////////////
        .o_em_ddr_reset_n   ( o_em_ddr_reset_n                  ),
        .o_em_ddr_clk       ( o_em_ddr_clk                      ),
        .o_em_ddr_cke       ( o_em_ddr_cke                      ),
        .o_em_ddr_cs_n      ( o_em_ddr_cs_n                     ),
        .o_em_ddr_ras_n     ( o_em_ddr_ras_n                    ),
        .o_em_ddr_cas_n     ( o_em_ddr_cas_n                    ),
        .o_em_ddr_we_n      ( o_em_ddr_we_n                     ),
        .o_em_ddr_odt       ( o_em_ddr_odt                      ),
        .o_em_ddr_ba        ( o_em_ddr_ba[2:0]                  ),
        .o_em_ddr_addr      ( o_em_ddr_addr[ADDR_WIDTH-14:0]    ),
        .io_em_ddr_data     ( io_em_ddr_data[31:0]              ),
        .io_em_ddr_dqs      ( io_em_ddr_dqs[3:0]                ),
        .o_em_ddr_dm        ( o_em_ddr_dm[3:0]                  )
                                                                );
    
    assign o_ddr3_busy    = s_ddr3_busy   ;
    assign o_ddr3_op_done = s_ddr3_op_done;
    

endmodule