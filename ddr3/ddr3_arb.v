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
//  1.1             2016/11/16          gzd
//                  
//
//  Revision History
//  1.1 Modified for Lattice ECP3-70EA-8FN672 in SVR2930 as Interface FPGA; 
//      The output is continuous, it's up to ddr controller module to determine when to respond;
// 
// =============================================================================

`timescale 1 ns / 1 ps

module ddr3_arb#(
    parameter           DATA_WIDTH          = 128,
    parameter           ADDR_WIDTH          = 27   // actually needed width is 27 in SVR2930.
)
(
    input                   i_rst_n                 , // async reset.low active    
    input                   i_clk                   , // clock                     
    input                   i_soft_rst              , // soft reset.high active    
    // ==========================
    // ============= ch00
    input                   i_ch00_req              , // request
    input   [15:0]          i_ch00_priority         , // priority.0:highest priority
    input                   i_ch00_rd_wrn           , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]i_ch00_start_addr       , // start address. 32 bit
    input   [11:0]          i_ch00_length           , // 32bit's num.encoded as 0 to 4095,representing 0 to 4095.
    output                  o_ch00_ack              , // ack
    output                  o_ch00_op_done          , // operate done
    output                  o_ch00_ram_rd_en        , // read data for writing ddr3
    output                  o_ch00_ram_rd_en_last   , // read data for writing ddr3
    input  [DATA_WIDTH-1:0] i_ch00_ram_rd_data      , // input data.read data for writing ddr3
    output                  o_ch00_ram_wr_en        , // write data from reading ddr3
    output                  o_ch00_ram_wr_en_last   , // write data from reading ddr3
    output [DATA_WIDTH-1:0] o_ch00_ram_wr_data      , // write data from reading ddr3
    // ============= ch01
    input                   i_ch01_req              , // request
    input   [15:0]          i_ch01_priority         , // priority.0:highest priority
    input                   i_ch01_rd_wrn           , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]i_ch01_start_addr       , // start address. 32 bit
    input   [11:0]          i_ch01_length           , // 32bit's num.encoded as 0 to 4095,representing 0 to 4095.
    output                  o_ch01_ack              , // ack         
    output                  o_ch01_op_done          , // operate done
    output                  o_ch01_ram_rd_en        , // read data for writing ddr3
    output                  o_ch01_ram_rd_en_last   , // read data for writing ddr3
    input  [DATA_WIDTH-1:0] i_ch01_ram_rd_data      , // input data.read data for writing ddr3
    output                  o_ch01_ram_wr_en        , // write data from reading ddr3
    output                  o_ch01_ram_wr_en_last   , // write data from reading ddr3
    output [DATA_WIDTH-1:0] o_ch01_ram_wr_data      , // write data from reading ddr3
    // ============= ch02
    input                   i_ch02_req              , // request
    input   [15:0]          i_ch02_priority         , // priority.0:highest priority
    input                   i_ch02_rd_wrn           , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]i_ch02_start_addr       , // start address. 32 bit
    input   [11:0]          i_ch02_length           , // 32bit's num.encoded as 0 to 4095,representing 0 to 4095.
    output                  o_ch02_ack              , // ack         
    output                  o_ch02_op_done          , // operate done
    output                  o_ch02_ram_rd_en        , // read data for writing ddr3
    output                  o_ch02_ram_rd_en_last   , // read data for writing ddr3
    input  [DATA_WIDTH-1:0] i_ch02_ram_rd_data      , // input data.read data for writing ddr3
    output                  o_ch02_ram_wr_en        , // write data from reading ddr3
    output                  o_ch02_ram_wr_en_last   , // write data from reading ddr3
    output [DATA_WIDTH-1:0] o_ch02_ram_wr_data      , // write data from reading ddr3
    // ============= ch03
    input                   i_ch03_req              , // request
    input   [15:0]          i_ch03_priority         , // priority.0:highest priority
    input                   i_ch03_rd_wrn           , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]i_ch03_start_addr       , // start address. 32 bit
    input   [11:0]          i_ch03_length           , // 32bit's num.encoded as 0 to 4095,representing 0 to 4095.
    output                  o_ch03_ack              , // ack         
    output                  o_ch03_op_done          , // operate done
    output                  o_ch03_ram_rd_en        , // read data for writing ddr3
    output                  o_ch03_ram_rd_en_last   , // read data for writing ddr3
    input  [DATA_WIDTH-1:0] i_ch03_ram_rd_data      , // input data.read data for writing ddr3
    output                  o_ch03_ram_wr_en        , // write data from reading ddr3
    output                  o_ch03_ram_wr_en_last   , // write data from reading ddr3
    output [DATA_WIDTH-1:0] o_ch03_ram_wr_data      , // write data from reading ddr3
    // ============= ch04
    input                   i_ch04_req              , // request
    input   [15:0]          i_ch04_priority         , // priority.0:highest priority
    input                   i_ch04_rd_wrn           , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]i_ch04_start_addr       , // start address. 32 bit
    input   [11:0]          i_ch04_length           , // 32bit's num.encoded as 0 to 4095,representing 0 to 4095.
    output                  o_ch04_ack              , // ack         
    output                  o_ch04_op_done          , // operate done
    output                  o_ch04_ram_rd_en        , // read data for writing ddr3
    output                  o_ch04_ram_rd_en_last   , // read data for writing ddr3
    input  [DATA_WIDTH-1:0] i_ch04_ram_rd_data      , // input data.read data for writing ddr3
    output                  o_ch04_ram_wr_en        , // write data from reading ddr3
    output                  o_ch04_ram_wr_en_last   , // write data from reading ddr3
    output [DATA_WIDTH-1:0] o_ch04_ram_wr_data      , // write data from reading ddr3
    // ============= ch05
    input                   i_ch05_req              , // request
    input   [15:0]          i_ch05_priority         , // priority.0:highest priority
    input                   i_ch05_rd_wrn           , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]i_ch05_start_addr       , // start address. 32 bit
    input   [11:0]          i_ch05_length           , // 32bit's num.encoded as 0 to 4095,representing 0 to 4095.
    output                  o_ch05_ack              , // ack         
    output                  o_ch05_op_done          , // operate done
    output                  o_ch05_ram_rd_en        , // read data for writing ddr3
    output                  o_ch05_ram_rd_en_last   , // read data for writing ddr3
    input  [DATA_WIDTH-1:0] i_ch05_ram_rd_data      , // input data.read data for writing ddr3
    output                  o_ch05_ram_wr_en        , // write data from reading ddr3
    output                  o_ch05_ram_wr_en_last   , // write data from reading ddr3
    output [DATA_WIDTH-1:0] o_ch05_ram_wr_data      , // write data from reading ddr3
    // ============= ch06
    input                   i_ch06_req              , // request
    input   [15:0]          i_ch06_priority         , // priority.0:highest priority
    input                   i_ch06_rd_wrn           , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]i_ch06_start_addr       , // start address. 32 bit
    input   [11:0]          i_ch06_length           , // 32bit's num.encoded as 0 to 4095,representing 0 to 4095.
    output                  o_ch06_ack              , // ack         
    output                  o_ch06_op_done          , // operate done
    output                  o_ch06_ram_rd_en        , // read data for writing ddr3
    output                  o_ch06_ram_rd_en_last   , // read data for writing ddr3
    input  [DATA_WIDTH-1:0] i_ch06_ram_rd_data      , // input data.read data for writing ddr3
    output                  o_ch06_ram_wr_en        , // write data from reading ddr3
    output                  o_ch06_ram_wr_en_last   , // write data from reading ddr3
    output [DATA_WIDTH-1:0] o_ch06_ram_wr_data      , // write data from reading ddr3
    // ============= ch07
    input                   i_ch07_req              , // request
    input   [15:0]          i_ch07_priority         , // priority.0:highest priority
    input                   i_ch07_rd_wrn           , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]i_ch07_start_addr       , // start address. 32 bit
    input   [11:0]          i_ch07_length           , // 32bit's num.encoded as 0 to 4095,representing 0 to 4095.
    output                  o_ch07_ack              , // ack         
    output                  o_ch07_op_done          , // operate done
    output                  o_ch07_ram_rd_en        , // read data for writing ddr3
    output                  o_ch07_ram_rd_en_last   , // read data for writing ddr3
    input  [DATA_WIDTH-1:0] i_ch07_ram_rd_data      , // input data.read data for writing ddr3
    output                  o_ch07_ram_wr_en        , // write data from reading ddr3
    output                  o_ch07_ram_wr_en_last   , // write data from reading ddr3
    output [DATA_WIDTH-1:0] o_ch07_ram_wr_data      , // write data from reading ddr3
    // ============= ch08
    input                   i_ch08_req              , // request
    input   [15:0]          i_ch08_priority         , // priority.0:highest priority
    input                   i_ch08_rd_wrn           , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]i_ch08_start_addr       , // start address. 32 bit
    input   [11:0]          i_ch08_length           , // 32bit's num.encoded as 0 to 4095,representing 0 to 4095.
    output                  o_ch08_ack              , // ack         
    output                  o_ch08_op_done          , // operate done
    output                  o_ch08_ram_rd_en        , // read data for writing ddr3
    output                  o_ch08_ram_rd_en_last   , // read data for writing ddr3
    input  [DATA_WIDTH-1:0] i_ch08_ram_rd_data      , // input data.read data for writing ddr3
    output                  o_ch08_ram_wr_en        , // write data from reading ddr3
    output                  o_ch08_ram_wr_en_last   , // write data from reading ddr3
    output [DATA_WIDTH-1:0] o_ch08_ram_wr_data      , // write data from reading ddr3
    // ============= ch09
    input                   i_ch09_req              , // request
    input   [15:0]          i_ch09_priority         , // priority.0:highest priority
    input                   i_ch09_rd_wrn           , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]i_ch09_start_addr       , // start address. 32 bit
    input   [11:0]          i_ch09_length           , // 32bit's num.encoded as 0 to 4095,representing 0 to 4095.
    output                  o_ch09_ack              , // ack         
    output                  o_ch09_op_done          , // operate done
    output                  o_ch09_ram_rd_en        , // read data for writing ddr3
    output                  o_ch09_ram_rd_en_last   , // read data for writing ddr3
    input  [DATA_WIDTH-1:0] i_ch09_ram_rd_data      , // input data.read data for writing ddr3
    output                  o_ch09_ram_wr_en        , // write data from reading ddr3
    output                  o_ch09_ram_wr_en_last   , // write data from reading ddr3
    output [DATA_WIDTH-1:0] o_ch09_ram_wr_data      , // write data from reading ddr3
    // ============= ch10
    input                   i_ch10_req              , // request
    input   [15:0]          i_ch10_priority         , // priority.0:highest priority
    input                   i_ch10_rd_wrn           , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]i_ch10_start_addr       , // start address. 32 bit
    input   [11:0]          i_ch10_length           , // 32bit's num.encoded as 0 to 4095,representing 0 to 4095.
    output                  o_ch10_ack              , // ack         
    output                  o_ch10_op_done          , // operate done
    output                  o_ch10_ram_rd_en        , // read data for writing ddr3
    output                  o_ch10_ram_rd_en_last   , // read data for writing ddr3
    input  [DATA_WIDTH-1:0] i_ch10_ram_rd_data      , // input data.read data for writing ddr3
    output                  o_ch10_ram_wr_en        , // write data from reading ddr3
    output                  o_ch10_ram_wr_en_last   , // write data from reading ddr3
    output [DATA_WIDTH-1:0] o_ch10_ram_wr_data      , // write data from reading ddr3
    // ============= ch11
    input                   i_ch11_req              , // request
    input   [15:0]          i_ch11_priority         , // priority.0:highest priority
    input                   i_ch11_rd_wrn           , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]i_ch11_start_addr       , // start address. 32 bit
    input   [11:0]          i_ch11_length           , // 32bit's num.encoded as 0 to 4095,representing 0 to 4095.
    output                  o_ch11_ack              , // ack         
    output                  o_ch11_op_done          , // operate done
    output                  o_ch11_ram_rd_en        , // read data for writing ddr3
    output                  o_ch11_ram_rd_en_last   , // read data for writing ddr3
    input  [DATA_WIDTH-1:0] i_ch11_ram_rd_data      , // input data.read data for writing ddr3
    output                  o_ch11_ram_wr_en        , // write data from reading ddr3
    output                  o_ch11_ram_wr_en_last   , // write data from reading ddr3
    output [DATA_WIDTH-1:0] o_ch11_ram_wr_data      , // write data from reading ddr3
    // ============= ch12
    input                   i_ch12_req              , // request
    input   [15:0]          i_ch12_priority         , // priority.0:highest priority
    input                   i_ch12_rd_wrn           , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]i_ch12_start_addr       , // start address. 32 bit
    input   [11:0]          i_ch12_length           , // 32bit's num.encoded as 0 to 4095,representing 0 to 4095.
    output                  o_ch12_ack              , // ack         
    output                  o_ch12_op_done          , // operate done
    output                  o_ch12_ram_rd_en        , // read data for writing ddr3
    output                  o_ch12_ram_rd_en_last   , // read data for writing ddr3
    input  [DATA_WIDTH-1:0] i_ch12_ram_rd_data      , // input data.read data for writing ddr3
    output                  o_ch12_ram_wr_en        , // write data from reading ddr3
    output                  o_ch12_ram_wr_en_last   , // write data from reading ddr3
    output [DATA_WIDTH-1:0] o_ch12_ram_wr_data      , // write data from reading ddr3
    // ============= ch13
    input                   i_ch13_req              , // request
    input   [15:0]          i_ch13_priority         , // priority.0:highest priority
    input                   i_ch13_rd_wrn           , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]i_ch13_start_addr       , // start address. 32 bit
    input   [11:0]          i_ch13_length           , // 32bit's num.encoded as 0 to 4095,representing 0 to 4095.
    output                  o_ch13_ack              , // ack         
    output                  o_ch13_op_done          , // operate done
    output                  o_ch13_ram_rd_en        , // read data for writing ddr3
    output                  o_ch13_ram_rd_en_last   , // read data for writing ddr3
    input  [DATA_WIDTH-1:0] i_ch13_ram_rd_data      , // input data.read data for writing ddr3
    output                  o_ch13_ram_wr_en        , // write data from reading ddr3
    output                  o_ch13_ram_wr_en_last   , // write data from reading ddr3
    output [DATA_WIDTH-1:0] o_ch13_ram_wr_data      , // write data from reading ddr3
    // ============= ch14
    input                   i_ch14_req              , // request
    input   [15:0]          i_ch14_priority         , // priority.0:highest priority
    input                   i_ch14_rd_wrn           , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]i_ch14_start_addr       , // start address. 32 bit
    input   [11:0]          i_ch14_length           , // 32bit's num.encoded as 0 to 4095,representing 0 to 4095.
    output                  o_ch14_ack              , // ack         
    output                  o_ch14_op_done          , // operate done
    output                  o_ch14_ram_rd_en        , // read data for writing ddr3
    output                  o_ch14_ram_rd_en_last   , // read data for writing ddr3
    input  [DATA_WIDTH-1:0] i_ch14_ram_rd_data      , // input data.read data for writing ddr3
    output                  o_ch14_ram_wr_en        , // write data from reading ddr3
    output                  o_ch14_ram_wr_en_last   , // write data from reading ddr3
    output [DATA_WIDTH-1:0] o_ch14_ram_wr_data      , // write data from reading ddr3
    // ============= ch15
    input                   i_ch15_req              , // request
    input   [15:0]          i_ch15_priority         , // priority.0:highest priority
    input                   i_ch15_rd_wrn           , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]i_ch15_start_addr       , // start address. 32 bit
    input   [11:0]          i_ch15_length           , // 32bit's num.encoded as 0 to 4095,representing 0 to 4095.
    output                  o_ch15_ack              , // ack         
    output                  o_ch15_op_done          , // operate done
    output                  o_ch15_ram_rd_en        , // read data for writing ddr3
    output                  o_ch15_ram_rd_en_last   , // read data for writing ddr3
    input  [DATA_WIDTH-1:0] i_ch15_ram_rd_data      , // input data.read data for writing ddr3
    output                  o_ch15_ram_wr_en        , // write data from reading ddr3
    output                  o_ch15_ram_wr_en_last   , // write data from reading ddr3
    output [DATA_WIDTH-1:0] o_ch15_ram_wr_data      , // write data from reading ddr3
    // ============= ch16
    input                   i_ch16_req              , // request
    input   [15:0]          i_ch16_priority         , // priority.0:highest priority
    input                   i_ch16_rd_wrn           , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]i_ch16_start_addr       , // start address. 32 bit
    input   [11:0]          i_ch16_length           , // 32bit's num.encoded as 0 to 4095,representing 0 to 4095.
    output                  o_ch16_ack              , // ack         
    output                  o_ch16_op_done          , // operate done
    output                  o_ch16_ram_rd_en        , // read data for writing ddr3
    output                  o_ch16_ram_rd_en_last   , // read data for writing ddr3
    input  [DATA_WIDTH-1:0] i_ch16_ram_rd_data      , // input data.read data for writing ddr3
    output                  o_ch16_ram_wr_en        , // write data from reading ddr3
    output                  o_ch16_ram_wr_en_last   , // write data from reading ddr3
    output [DATA_WIDTH-1:0] o_ch16_ram_wr_data      , // write data from reading ddr3
    // ============= ch17
    input                   i_ch17_req              , // request
    input   [15:0]          i_ch17_priority         , // priority.0:highest priority
    input                   i_ch17_rd_wrn           , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]i_ch17_start_addr       , // start address. 32 bit
    input   [11:0]          i_ch17_length           , // 32bit's num.encoded as 0 to 4095,representing 0 to 4095.
    output                  o_ch17_ack              , // ack         
    output                  o_ch17_op_done          , // operate done
    output                  o_ch17_ram_rd_en        , // read data for writing ddr3
    output                  o_ch17_ram_rd_en_last   , // read data for writing ddr3
    input  [DATA_WIDTH-1:0] i_ch17_ram_rd_data      , // input data.read data for writing ddr3
    output                  o_ch17_ram_wr_en        , // write data from reading ddr3
    output                  o_ch17_ram_wr_en_last   , // write data from reading ddr3
    output [DATA_WIDTH-1:0] o_ch17_ram_wr_data      , // write data from reading ddr3
    // ============= ch18
    input                   i_ch18_req              , // request
    input   [15:0]          i_ch18_priority         , // priority.0:highest priority
    input                   i_ch18_rd_wrn           , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]i_ch18_start_addr       , // start address. 32 bit
    input   [11:0]          i_ch18_length           , // 32bit's num.encoded as 0 to 4095,representing 0 to 4095.
    output                  o_ch18_ack              , // ack         
    output                  o_ch18_op_done          , // operate done
    output                  o_ch18_ram_rd_en        , // read data for writing ddr3
    output                  o_ch18_ram_rd_en_last   , // read data for writing ddr3
    input  [DATA_WIDTH-1:0] i_ch18_ram_rd_data      , // input data.read data for writing ddr3
    output                  o_ch18_ram_wr_en        , // write data from reading ddr3
    output                  o_ch18_ram_wr_en_last   , // write data from reading ddr3
    output [DATA_WIDTH-1:0] o_ch18_ram_wr_data      , // write data from reading ddr3
    // ============= ch19
    input                   i_ch19_req              , // request
    input   [15:0]          i_ch19_priority         , // priority.0:highest priority
    input                   i_ch19_rd_wrn           , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]i_ch19_start_addr       , // start address. 32 bit
    input   [11:0]          i_ch19_length           , // 32bit's num.encoded as 0 to 4095,representing 0 to 4095.
    output                  o_ch19_ack              , // ack         
    output                  o_ch19_op_done          , // operate done
    output                  o_ch19_ram_rd_en        , // read data for writing ddr3
    output                  o_ch19_ram_rd_en_last   , // read data for writing ddr3
    input  [DATA_WIDTH-1:0] i_ch19_ram_rd_data      , // input data.read data for writing ddr3
    output                  o_ch19_ram_wr_en        , // write data from reading ddr3
    output                  o_ch19_ram_wr_en_last   , // write data from reading ddr3
    output [DATA_WIDTH-1:0] o_ch19_ram_wr_data      , // write data from reading ddr3
    // ============= ch20
    input                   i_ch20_req              , // request
    input   [15:0]          i_ch20_priority         , // priority.0:highest priority
    input                   i_ch20_rd_wrn           , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]i_ch20_start_addr       , // start address. 32 bit
    input   [11:0]          i_ch20_length           , // 32bit's num.encoded as 0 to 4095,representing 0 to 4095.
    output                  o_ch20_ack              , // ack         
    output                  o_ch20_op_done          , // operate done
    output                  o_ch20_ram_rd_en        , // read data for writing ddr3
    output                  o_ch20_ram_rd_en_last   , // read data for writing ddr3
    input  [DATA_WIDTH-1:0] i_ch20_ram_rd_data      , // input data.read data for writing ddr3
    output                  o_ch20_ram_wr_en        , // write data from reading ddr3
    output                  o_ch20_ram_wr_en_last   , // write data from reading ddr3
    output [DATA_WIDTH-1:0] o_ch20_ram_wr_data      , // write data from reading ddr3
    // ============= ch21
    input                   i_ch21_req              , // request
    input   [15:0]          i_ch21_priority         , // priority.0:highest priority
    input                   i_ch21_rd_wrn           , // 1:read memory;0:write memory
    input   [ADDR_WIDTH-1:0]i_ch21_start_addr       , // start address. 32 bit
    input   [11:0]          i_ch21_length           , // 32bit's num.encoded as 0 to 4095,representing 0 to 4095.
    output                  o_ch21_ack              , // ack         
    output                  o_ch21_op_done          , // operate done
    output                  o_ch21_ram_rd_en        , // read data for writing ddr3
    output                  o_ch21_ram_rd_en_last   , // read data for writing ddr3
    input  [DATA_WIDTH-1:0] i_ch21_ram_rd_data      , // input data.read data for writing ddr3
    output                  o_ch21_ram_wr_en        , // write data from reading ddr3
    output                  o_ch21_ram_wr_en_last   , // write data from reading ddr3
    output [DATA_WIDTH-1:0] o_ch21_ram_wr_data      , // write data from reading ddr3
    // ==========================
    //
    output                  o_ddr3_req              , // request
    output                  o_ddr3_rd_wrn           , // 1:read memory;0:write memory
    output  [ADDR_WIDTH-1:0]o_ddr3_start_addr       , // start address. 32 bit
    output  [11:0]          o_ddr3_length           , // 32bit's num.encoded as 0 to 4095,representing 0 to 4095.
    input                   i_ddr3_ack              , // wire style.
    input                   i_ddr3_op_done          , // operate done.pulse
    //
    input                   i_ddr3_ram_rd_en        , // wire style.read data for writing ddr3
    input                   i_ddr3_ram_rd_en_last   , // wire style.read data for writing ddr3
    output                  o_ddr3_ram_rd_vld       , // input data valid.read data for writing ddr3
    output [DATA_WIDTH-1:0] o_ddr3_ram_rd_data      , // input data.read data for writing ddr3
    //
    input                   i_ddr3_ram_wr_en        , // wire style. write data from reading ddr3
    input                   i_ddr3_ram_wr_en_last   , // wire style. write data from reading ddr3
    input  [DATA_WIDTH-1:0] i_ddr3_ram_wr_data        // wire style. write data from reading ddr3
);

    // =====================================================
    // Internal Signals Declaration
    // =====================================================
    // ==========================
    //     width*num-1:0
    // stage 5
    wire    [ 1         *32 -1 :0]   s_ch_stage5_req         ;
    wire    [ 5         *32 -1 :0]   s_ch_stage5_num         ; // bit expansion;
    wire    [16         *32 -1 :0]   s_ch_stage5_priority    ;
    wire    [ 1         *32 -1 :0]   s_ch_stage5_rd_wrn      ;
    wire    [ADDR_WIDTH *32 -1 :0]   s_ch_stage5_start_addr  ;
    wire    [12         *32 -1 :0]   s_ch_stage5_length      ;
    // stage 4
    wire    [ 1         *16 -1 :0]   s_ch_stage4_req         ;
    wire    [ 5         *16 -1 :0]   s_ch_stage4_num         ;
    wire    [16         *16 -1 :0]   s_ch_stage4_priority    ;
    wire    [ 1         *16 -1 :0]   s_ch_stage4_rd_wrn      ;
    wire    [ADDR_WIDTH *16 -1 :0]   s_ch_stage4_start_addr  ;
    wire    [12         *16 -1 :0]   s_ch_stage4_length      ;
    // stage 3
    wire    [ 1         * 8 -1 :0]   s_ch_stage3_req         ;
    wire    [ 5         * 8 -1 :0]   s_ch_stage3_num         ;
    wire    [16         * 8 -1 :0]   s_ch_stage3_priority    ;
    wire    [ 1         * 8 -1 :0]   s_ch_stage3_rd_wrn      ;
    wire    [ADDR_WIDTH * 8 -1 :0]   s_ch_stage3_start_addr  ;
    wire    [12         * 8 -1 :0]   s_ch_stage3_length      ;
    // stage 2
    wire    [ 1         * 4 -1 :0]   s_ch_stage2_req         ;
    wire    [ 5         * 4 -1 :0]   s_ch_stage2_num         ;
    wire    [16         * 4 -1 :0]   s_ch_stage2_priority    ;
    wire    [ 1         * 4 -1 :0]   s_ch_stage2_rd_wrn      ;
    wire    [ADDR_WIDTH * 4 -1 :0]   s_ch_stage2_start_addr  ;
    wire    [12         * 4 -1 :0]   s_ch_stage2_length      ;
    // stage 1
    wire    [ 1         * 2 -1 :0]   s_ch_stage1_req         ;
    wire    [ 5         * 2 -1 :0]   s_ch_stage1_num         ;
    wire    [16         * 2 -1 :0]   s_ch_stage1_priority    ;
    wire    [ 1         * 2 -1 :0]   s_ch_stage1_rd_wrn      ;
    wire    [ADDR_WIDTH * 2 -1 :0]   s_ch_stage1_start_addr  ;
    wire    [12         * 2 -1 :0]   s_ch_stage1_length      ;
    // stage 0
    wire    [ 1         * 1 -1 :0]   s_ch_stage0_req         ;
    wire    [ 5         * 1 -1 :0]   s_ch_stage0_num         ;
    wire    [16         * 1 -1 :0]   s_ch_stage0_priority    ;
    wire    [ 1         * 1 -1 :0]   s_ch_stage0_rd_wrn      ;
    wire    [ADDR_WIDTH * 1 -1 :0]   s_ch_stage0_start_addr  ;
    wire    [12         * 1 -1 :0]   s_ch_stage0_length      ;
    // ==========================
(* max_fanout = 500 *)     reg     [ 5:0]  r_ack_ch_num            ; // bit expansion;
    reg             r_req_dis_en            ;
    reg     [ 2:0]  r_req_dis_en_cnt        ;
    //
    reg     [ 1        *22 -1 :0]   r_chxx_ack              ;  // 22 channels;
    reg     [ 1        *22 -1 :0]   r_chxx_op_done          ;
    reg     [ 1        *22 -1 :0]   r_chxx_ram_rd_en        ;
    reg     [ 1        *22 -1 :0]   r_chxx_ram_rd_en_last   ;
    reg     [ 1        *22 -1 :0]   r_chxx_ram_wr_en        ;
    reg     [ 1        *22 -1 :0]   r_chxx_ram_wr_en_last   ;
    reg     [DATA_WIDTH*22 -1 :0]   r_chxx_ram_wr_data      ;

    //
    reg                             r_ddr3_ram_rd_en_0_dff  ;
    reg                             r_ddr3_ram_rd_en_1_dff  ;
    reg                             r_ddr3_ram_rd_vld       ; // input data valid.read data for writing ddr3
//    reg     [DATA_WIDTH-1:0     ]   r_ddr3_ram_rd_data      ; // input data.read data for writing ddr3
    
    
    // no so many read channels -- gzd
    reg     [DATA_WIDTH-1:0     ]   r_ch00_ram_rd_data      ;
    reg     [DATA_WIDTH-1:0     ]   r_ch01_ram_rd_data      ;
    reg     [DATA_WIDTH-1:0     ]   r_ch02_ram_rd_data      ;
    reg     [DATA_WIDTH-1:0     ]   r_ch03_ram_rd_data      ;
    reg     [DATA_WIDTH-1:0     ]   r_ch04_ram_rd_data      ;
    reg     [DATA_WIDTH-1:0     ]   r_ch05_ram_rd_data      ;
    reg     [DATA_WIDTH-1:0     ]   r_ch06_ram_rd_data      ;
    reg     [DATA_WIDTH-1:0     ]   r_ch07_ram_rd_data      ;
    reg     [DATA_WIDTH-1:0     ]   r_ch08_ram_rd_data      ;
    reg     [DATA_WIDTH-1:0     ]   r_ch09_ram_rd_data      ;
    reg     [DATA_WIDTH-1:0     ]   r_ch10_ram_rd_data      ;
    reg     [DATA_WIDTH-1:0     ]   r_ch11_ram_rd_data      ;
    reg     [DATA_WIDTH-1:0     ]   r_ch12_ram_rd_data      ;
    reg     [DATA_WIDTH-1:0     ]   r_ch13_ram_rd_data      ;
    reg     [DATA_WIDTH-1:0     ]   r_ch14_ram_rd_data      ;
    reg     [DATA_WIDTH-1:0     ]   r_ch15_ram_rd_data      ;
    reg     [DATA_WIDTH-1:0     ]   r_ch16_ram_rd_data      ;
    reg     [DATA_WIDTH-1:0     ]   r_ch17_ram_rd_data      ;
    reg     [DATA_WIDTH-1:0     ]   r_ch18_ram_rd_data      ;
    reg     [DATA_WIDTH-1:0     ]   r_ch19_ram_rd_data      ;
    reg     [DATA_WIDTH-1:0     ]   r_ch20_ram_rd_data      ;
    reg     [DATA_WIDTH-1:0     ]   r_ch21_ram_rd_data      ;
    
    wire    [DATA_WIDTH-1:0     ]   s_ddr3_ram_rd_data      ; // input data.read data for writing ddr3
        
    

// =============================================================================
// RTL Body
// =============================================================================
    // =====================================================
    // compare priority
    // =====================================================
    // ========================== stage5
    assign s_ch_stage5_req      = {{10{1'b0}} ,
                                   i_ch21_req ,
                                   i_ch20_req ,
                                   i_ch19_req ,
                                   i_ch18_req ,
                                   i_ch17_req ,
                                   i_ch16_req ,
                                   i_ch15_req ,
                                   i_ch14_req ,
                                   i_ch13_req ,
                                   i_ch12_req ,
                                   i_ch11_req ,
                                   i_ch10_req ,
                                   i_ch09_req ,
                                   i_ch08_req ,
                                   i_ch07_req ,
                                   i_ch06_req ,
                                   i_ch05_req ,
                                   i_ch04_req ,
                                   i_ch03_req ,
                                   i_ch02_req ,
                                   i_ch01_req ,
                                   i_ch00_req
                                  };

    assign s_ch_stage5_num      = {5'd31 ,
                                   5'd30 ,
                                   5'd29 ,
                                   5'd28 ,
                                   5'd27 ,
                                   5'd26 ,
                                   5'd25 ,
                                   5'd24 ,
                                   5'd23 ,
                                   5'd22 ,
                                   5'd21 ,
                                   5'd20 ,
                                   5'd19 ,
                                   5'd18 ,
                                   5'd17 ,
                                   5'd16 ,
                                   5'd15 ,
                                   5'd14 ,
                                   5'd13 ,
                                   5'd12 ,
                                   5'd11 ,
                                   5'd10 ,
                                   5'd9  ,
                                   5'd8  ,
                                   5'd7  ,
                                   5'd6  ,
                                   5'd5  ,
                                   5'd4  ,
                                   5'd3  ,
                                   5'd2  ,
                                   5'd1  ,
                                   5'd0
                                  };

    assign s_ch_stage5_priority = {{10{16'hFFFF}}  ,
                                   i_ch21_priority ,
                                   i_ch20_priority ,
                                   i_ch19_priority ,
                                   i_ch18_priority ,
                                   i_ch17_priority ,
                                   i_ch16_priority ,
                                   i_ch15_priority ,
                                   i_ch14_priority ,
                                   i_ch13_priority ,
                                   i_ch12_priority ,
                                   i_ch11_priority ,
                                   i_ch10_priority ,
                                   i_ch09_priority ,
                                   i_ch08_priority ,
                                   i_ch07_priority ,
                                   i_ch06_priority ,
                                   i_ch05_priority ,
                                   i_ch04_priority ,
                                   i_ch03_priority ,
                                   i_ch02_priority ,
                                   i_ch01_priority ,
                                   i_ch00_priority
                                  };

    assign s_ch_stage5_rd_wrn   = {{10{1'b0}}    ,
                                   i_ch21_rd_wrn ,
                                   i_ch20_rd_wrn ,
                                   i_ch19_rd_wrn ,
                                   i_ch18_rd_wrn ,
                                   i_ch17_rd_wrn ,
                                   i_ch16_rd_wrn ,
                                   i_ch15_rd_wrn ,
                                   i_ch14_rd_wrn ,
                                   i_ch13_rd_wrn ,
                                   i_ch12_rd_wrn ,
                                   i_ch11_rd_wrn ,
                                   i_ch10_rd_wrn ,
                                   i_ch09_rd_wrn ,
                                   i_ch08_rd_wrn ,
                                   i_ch07_rd_wrn ,
                                   i_ch06_rd_wrn ,
                                   i_ch05_rd_wrn ,
                                   i_ch04_rd_wrn ,
                                   i_ch03_rd_wrn ,
                                   i_ch02_rd_wrn ,
                                   i_ch01_rd_wrn ,
                                   i_ch00_rd_wrn
                                  };

    assign s_ch_stage5_start_addr = {
                                    {(10*ADDR_WIDTH){1'b0}} ,
                                     i_ch21_start_addr ,
                                     i_ch20_start_addr ,
                                     i_ch19_start_addr ,
                                     i_ch18_start_addr ,
                                     i_ch17_start_addr ,
                                     i_ch16_start_addr ,
                                     i_ch15_start_addr ,
                                     i_ch14_start_addr ,
                                     i_ch13_start_addr ,
                                     i_ch12_start_addr ,
                                     i_ch11_start_addr ,
                                     i_ch10_start_addr ,
                                     i_ch09_start_addr ,
                                     i_ch08_start_addr ,
                                     i_ch07_start_addr ,
                                     i_ch06_start_addr ,
                                     i_ch05_start_addr ,
                                     i_ch04_start_addr ,
                                     i_ch03_start_addr ,
                                     i_ch02_start_addr ,
                                     i_ch01_start_addr ,
                                     i_ch00_start_addr
                                    };

    assign s_ch_stage5_length     = {{10{12'b0}}   ,
                                     i_ch21_length ,
                                     i_ch20_length ,
                                     i_ch19_length ,
                                     i_ch18_length ,
                                     i_ch17_length ,
                                     i_ch16_length ,
                                     i_ch15_length ,
                                     i_ch14_length ,
                                     i_ch13_length ,
                                     i_ch12_length ,
                                     i_ch11_length ,
                                     i_ch10_length ,
                                     i_ch09_length ,
                                     i_ch08_length ,
                                     i_ch07_length ,
                                     i_ch06_length ,
                                     i_ch05_length ,
                                     i_ch04_length ,
                                     i_ch03_length ,
                                     i_ch02_length ,
                                     i_ch01_length ,
                                     i_ch00_length
                                    };

// ========================== stage4
genvar      i4         ;
generate
    for (i4 = 0; i4 <= 15; i4 = i4 + 1) begin : u_stage4
        ddr3_arb_compare u_ddr3_arb_compare_stage4   // one clock;
        (
            .i_rst_n            ( i_rst_n                                                          ),
            .i_clk              ( i_clk                                                            ),
            .i_soft_rst         ( i_soft_rst                                                       ),

            .i_ch00_req         ( s_ch_stage5_req[        (i4*2+1  )* 1         -1:(i4*2)* 1          ]   ),
            .i_ch00_num         ( s_ch_stage5_num[        (i4*2+1  )* 5         -1:(i4*2)* 5          ]   ), // bit expansion;
            .i_ch00_priority    ( s_ch_stage5_priority[   (i4*2+1  )*16         -1:(i4*2)* 16         ]   ),
            .i_ch00_rd_wrn      ( s_ch_stage5_rd_wrn[     (i4*2+1  )* 1         -1:(i4*2)* 1          ]   ),
            .i_ch00_start_addr  ( s_ch_stage5_start_addr[ (i4*2+1  )*ADDR_WIDTH -1:(i4*2)* ADDR_WIDTH ]   ),
            .i_ch00_length      ( s_ch_stage5_length[     (i4*2+1  )*12         -1:(i4*2)* 12         ]   ),

            .i_ch01_req         ( s_ch_stage5_req[        (i4*2+1+1)* 1         -1:(i4*2+1)* 1        ]   ),
            .i_ch01_num         ( s_ch_stage5_num[        (i4*2+1+1)* 5         -1:(i4*2+1)* 5        ]   ),
            .i_ch01_priority    ( s_ch_stage5_priority[   (i4*2+1+1)*16         -1:(i4*2+1)*16        ]   ),
            .i_ch01_rd_wrn      ( s_ch_stage5_rd_wrn[     (i4*2+1+1)* 1         -1:(i4*2+1)* 1        ]   ),
            .i_ch01_start_addr  ( s_ch_stage5_start_addr[ (i4*2+1+1)*ADDR_WIDTH -1:(i4*2+1)*ADDR_WIDTH]   ),
            .i_ch01_length      ( s_ch_stage5_length[     (i4*2+1+1)*12         -1:(i4*2+1)*12        ]   ),
                                                                                  
            .o_ch_req           ( s_ch_stage4_req[        (i4+1    )* 1         -1:(i4    )* 1        ]   ),
            .o_ch_num           ( s_ch_stage4_num[        (i4+1    )* 5         -1:(i4    )* 5        ]   ),
            .o_ch_priority      ( s_ch_stage4_priority[   (i4+1    )*16         -1:(i4    )*16        ]   ),
            .o_ch_rd_wrn        ( s_ch_stage4_rd_wrn[     (i4+1    )* 1         -1:(i4    )* 1        ]   ),
            .o_ch_start_addr    ( s_ch_stage4_start_addr[ (i4+1    )*ADDR_WIDTH -1:(i4    )*ADDR_WIDTH]   ),
            .o_ch_length        ( s_ch_stage4_length[     (i4+1    )*12         -1:(i4    )*12        ]   )
        );
    end
endgenerate
    
    // ========================== stage3
    genvar      i3         ;
    generate
        for (i3 = 0; i3 <= 7; i3 = i3 + 1) begin : u_stage3
            ddr3_arb_compare u_ddr3_arb_compare_stage3
            (
                .i_rst_n                 ( i_rst_n                                                          ),
                .i_clk                   ( i_clk                                                            ),
                .i_soft_rst              ( i_soft_rst                                                       ),

                .i_ch00_req              ( s_ch_stage4_req[             (i3*2+1  )* 1 -1:(i3*2)* 1      ]   ),
                .i_ch00_num              ( s_ch_stage4_num[             (i3*2+1  )* 5 -1:(i3*2)* 5      ]   ),
                .i_ch00_priority         ( s_ch_stage4_priority[        (i3*2+1  )*16 -1:(i3*2)* 16     ]   ),
                .i_ch00_rd_wrn           ( s_ch_stage4_rd_wrn[          (i3*2+1  )* 1 -1:(i3*2)* 1      ]   ),
                .i_ch00_start_addr       ( s_ch_stage4_start_addr[      (i3*2+1  )*ADDR_WIDTH -1:(i3*2)* ADDR_WIDTH     ]   ),
                .i_ch00_length           ( s_ch_stage4_length[          (i3*2+1  )*12 -1:(i3*2)* 12     ]   ),

                .i_ch01_req              ( s_ch_stage4_req[             (i3*2+1+1)* 1 -1:(i3*2+1)* 1    ]   ),
                .i_ch01_num              ( s_ch_stage4_num[             (i3*2+1+1)* 5 -1:(i3*2+1)* 5    ]   ),
                .i_ch01_priority         ( s_ch_stage4_priority[        (i3*2+1+1)*16 -1:(i3*2+1)*16    ]   ),
                .i_ch01_rd_wrn           ( s_ch_stage4_rd_wrn[          (i3*2+1+1)* 1 -1:(i3*2+1)* 1    ]   ),
                .i_ch01_start_addr       ( s_ch_stage4_start_addr[      (i3*2+1+1)*ADDR_WIDTH -1:(i3*2+1)*ADDR_WIDTH    ]   ),
                .i_ch01_length           ( s_ch_stage4_length[          (i3*2+1+1)*12 -1:(i3*2+1)*12    ]   ),

                .o_ch_req                ( s_ch_stage3_req[             (i3+1    )* 1 -1:(i3    )* 1    ]   ),
                .o_ch_num                ( s_ch_stage3_num[             (i3+1    )* 5 -1:(i3    )* 5    ]   ),
                .o_ch_priority           ( s_ch_stage3_priority[        (i3+1    )*16 -1:(i3    )*16    ]   ),
                .o_ch_rd_wrn             ( s_ch_stage3_rd_wrn[          (i3+1    )* 1 -1:(i3    )* 1    ]   ),
                .o_ch_start_addr         ( s_ch_stage3_start_addr[      (i3+1    )*ADDR_WIDTH -1:(i3    )*ADDR_WIDTH    ]   ),
                .o_ch_length             ( s_ch_stage3_length[          (i3+1    )*12 -1:(i3    )*12    ]   )
            );
        end
    endgenerate
    
    // ========================== stage2
    genvar      i2         ;
    generate
        for (i2 = 0; i2 <= 3; i2 = i2 + 1) begin : u_stage2
            ddr3_arb_compare u_ddr3_arb_compare_stage2
            (
                .i_rst_n                 ( i_rst_n                                                          ),
                .i_clk                   ( i_clk                                                            ),
                .i_soft_rst              ( i_soft_rst                                                       ),

                .i_ch00_req              ( s_ch_stage3_req[             (i2*2+1  )* 1 -1:(i2*2)* 1      ]   ),
                .i_ch00_num              ( s_ch_stage3_num[             (i2*2+1  )* 5 -1:(i2*2)* 5      ]   ),
                .i_ch00_priority         ( s_ch_stage3_priority[        (i2*2+1  )*16 -1:(i2*2)* 16     ]   ),
                .i_ch00_rd_wrn           ( s_ch_stage3_rd_wrn[          (i2*2+1  )* 1 -1:(i2*2)* 1      ]   ),
                .i_ch00_start_addr       ( s_ch_stage3_start_addr[      (i2*2+1  )*ADDR_WIDTH -1:(i2*2)* ADDR_WIDTH     ]   ),
                .i_ch00_length           ( s_ch_stage3_length[          (i2*2+1  )*12 -1:(i2*2)* 12     ]   ),

                .i_ch01_req              ( s_ch_stage3_req[             (i2*2+1+1)* 1 -1:(i2*2+1)* 1    ]   ),
                .i_ch01_num              ( s_ch_stage3_num[             (i2*2+1+1)* 5 -1:(i2*2+1)* 5    ]   ),
                .i_ch01_priority         ( s_ch_stage3_priority[        (i2*2+1+1)*16 -1:(i2*2+1)*16    ]   ),
                .i_ch01_rd_wrn           ( s_ch_stage3_rd_wrn[          (i2*2+1+1)* 1 -1:(i2*2+1)* 1    ]   ),
                .i_ch01_start_addr       ( s_ch_stage3_start_addr[      (i2*2+1+1)*ADDR_WIDTH -1:(i2*2+1)*ADDR_WIDTH    ]   ),
                .i_ch01_length           ( s_ch_stage3_length[          (i2*2+1+1)*12 -1:(i2*2+1)*12    ]   ),

                .o_ch_req                ( s_ch_stage2_req[             (i2+1    )* 1 -1:(i2    )* 1    ]   ),
                .o_ch_num                ( s_ch_stage2_num[             (i2+1    )* 5 -1:(i2    )* 5    ]   ),
                .o_ch_priority           ( s_ch_stage2_priority[        (i2+1    )*16 -1:(i2    )*16    ]   ),
                .o_ch_rd_wrn             ( s_ch_stage2_rd_wrn[          (i2+1    )* 1 -1:(i2    )* 1    ]   ),
                .o_ch_start_addr         ( s_ch_stage2_start_addr[      (i2+1    )*ADDR_WIDTH -1:(i2    )*ADDR_WIDTH    ]   ),
                .o_ch_length             ( s_ch_stage2_length[          (i2+1    )*12 -1:(i2    )*12    ]   )
            );
        end
    endgenerate

    // ========================== stage1
    genvar      i1         ;
    generate
        for (i1 = 0; i1 <= 1; i1 = i1 + 1) begin : u_stage1
            ddr3_arb_compare u_ddr3_arb_compare_stage3
            (
                .i_rst_n                 ( i_rst_n                                                          ),
                .i_clk                   ( i_clk                                                            ),
                .i_soft_rst              ( i_soft_rst                                                       ),

                .i_ch00_req              ( s_ch_stage2_req[             (i1*2+1  )* 1 -1:(i1*2)* 1      ]   ),
                .i_ch00_num              ( s_ch_stage2_num[             (i1*2+1  )* 5 -1:(i1*2)* 5      ]   ),
                .i_ch00_priority         ( s_ch_stage2_priority[        (i1*2+1  )*16 -1:(i1*2)* 16     ]   ),
                .i_ch00_rd_wrn           ( s_ch_stage2_rd_wrn[          (i1*2+1  )* 1 -1:(i1*2)* 1      ]   ),
                .i_ch00_start_addr       ( s_ch_stage2_start_addr[      (i1*2+1  )*ADDR_WIDTH -1:(i1*2)* ADDR_WIDTH     ]   ),
                .i_ch00_length           ( s_ch_stage2_length[          (i1*2+1  )*12 -1:(i1*2)* 12     ]   ),

                .i_ch01_req              ( s_ch_stage2_req[             (i1*2+1+1)* 1 -1:(i1*2+1)* 1    ]   ),
                .i_ch01_num              ( s_ch_stage2_num[             (i1*2+1+1)* 5 -1:(i1*2+1)* 5    ]   ),
                .i_ch01_priority         ( s_ch_stage2_priority[        (i1*2+1+1)*16 -1:(i1*2+1)*16    ]   ),
                .i_ch01_rd_wrn           ( s_ch_stage2_rd_wrn[          (i1*2+1+1)* 1 -1:(i1*2+1)* 1    ]   ),
                .i_ch01_start_addr       ( s_ch_stage2_start_addr[      (i1*2+1+1)*ADDR_WIDTH -1:(i1*2+1)*ADDR_WIDTH    ]   ),
                .i_ch01_length           ( s_ch_stage2_length[          (i1*2+1+1)*12 -1:(i1*2+1)*12    ]   ),

                .o_ch_req                ( s_ch_stage1_req[             (i1+1    )* 1 -1:(i1    )* 1    ]   ),
                .o_ch_num                ( s_ch_stage1_num[             (i1+1    )* 5 -1:(i1    )* 5    ]   ),
                .o_ch_priority           ( s_ch_stage1_priority[        (i1+1    )*16 -1:(i1    )*16    ]   ),
                .o_ch_rd_wrn             ( s_ch_stage1_rd_wrn[          (i1+1    )* 1 -1:(i1    )* 1    ]   ),
                .o_ch_start_addr         ( s_ch_stage1_start_addr[      (i1+1    )*ADDR_WIDTH -1:(i1    )*ADDR_WIDTH    ]   ),
                .o_ch_length             ( s_ch_stage1_length[          (i1+1    )*12 -1:(i1    )*12    ]   )
            );
        end
    endgenerate

    // ========================== stage0
    genvar      i0         ;
    generate
        for (i0 = 0; i0 <= 0; i0 = i0 + 1) begin : u_stage0
            ddr3_arb_compare u_ddr3_arb_compare_stage0
            (
                .i_rst_n                 ( i_rst_n                                                          ),
                .i_clk                   ( i_clk                                                            ),
                .i_soft_rst              ( i_soft_rst                                                       ),

                .i_ch00_req              ( s_ch_stage1_req[             (i0*2+1  )* 1 -1:(i0*2)* 1      ]   ),
                .i_ch00_num              ( s_ch_stage1_num[             (i0*2+1  )* 5 -1:(i0*2)* 5      ]   ),
                .i_ch00_priority         ( s_ch_stage1_priority[        (i0*2+1  )*16 -1:(i0*2)* 16     ]   ),
                .i_ch00_rd_wrn           ( s_ch_stage1_rd_wrn[          (i0*2+1  )* 1 -1:(i0*2)* 1      ]   ),
                .i_ch00_start_addr       ( s_ch_stage1_start_addr[      (i0*2+1  )*ADDR_WIDTH -1:(i0*2)* ADDR_WIDTH     ]   ),
                .i_ch00_length           ( s_ch_stage1_length[          (i0*2+1  )*12 -1:(i0*2)* 12     ]   ),
                
                .i_ch01_req              ( s_ch_stage1_req[             (i0*2+1+1)* 1 -1:(i0*2+1)* 1    ]   ),
                .i_ch01_num              ( s_ch_stage1_num[             (i0*2+1+1)* 5 -1:(i0*2+1)* 5    ]   ),
                .i_ch01_priority         ( s_ch_stage1_priority[        (i0*2+1+1)*16 -1:(i0*2+1)*16    ]   ),
                .i_ch01_rd_wrn           ( s_ch_stage1_rd_wrn[          (i0*2+1+1)* 1 -1:(i0*2+1)* 1    ]   ),
                .i_ch01_start_addr       ( s_ch_stage1_start_addr[      (i0*2+1+1)*ADDR_WIDTH -1:(i0*2+1)*ADDR_WIDTH    ]   ),
                .i_ch01_length           ( s_ch_stage1_length[          (i0*2+1+1)*12 -1:(i0*2+1)*12    ]   ),
                
                .o_ch_req                ( s_ch_stage0_req[             (i0+1    )* 1 -1:(i0    )* 1    ]   ),
                .o_ch_num                ( s_ch_stage0_num[             (i0+1    )* 5 -1:(i0    )* 5    ]   ),
                .o_ch_priority           ( s_ch_stage0_priority[        (i0+1    )*16 -1:(i0    )*16    ]   ),
                .o_ch_rd_wrn             ( s_ch_stage0_rd_wrn[          (i0+1    )* 1 -1:(i0    )* 1    ]   ),
                .o_ch_start_addr         ( s_ch_stage0_start_addr[      (i0+1    )*ADDR_WIDTH -1:(i0    )*ADDR_WIDTH    ]   ),
                .o_ch_length             ( s_ch_stage0_length[          (i0+1    )*12 -1:(i0    )*12    ]   )
            );
        end
    endgenerate

    // =====================================================
    //
    // =====================================================
    reg    [4:0]                    s_ch_stage0_num_d1          ;
    // reg                             s_ch_stage0_rd_wrn_d1       ;
    // reg    [ADDR_WIDTH-1:0]         s_ch_stage0_start_addr_d1   ;
    // reg    [11:0]                   s_ch_stage0_length_d1       ;
    always @ (posedge i_clk)
    begin
          s_ch_stage0_num_d1           <= s_ch_stage0_num       ;
          // s_ch_stage0_rd_wrn_d1        <= s_ch_stage0_rd_wrn    ;
          // s_ch_stage0_start_addr_d1    <= s_ch_stage0_start_addr;
          // s_ch_stage0_length_d1        <= s_ch_stage0_length    ;
    end
    
    
    always @ (posedge i_clk or negedge i_rst_n) begin
        if (i_rst_n == 1'b0) begin
            r_ack_ch_num <= 6'b0;
        end else begin
            if (i_soft_rst == 1'b1) begin
                r_ack_ch_num <= 6'b0;
            end else begin
                if (i_ddr3_ack == 1'b1) begin
//                    r_ack_ch_num <= s_ch_stage0_num;
                    r_ack_ch_num <= s_ch_stage0_num_d1;
                end
            end
        end
    end 
    
    always @ (posedge i_clk or negedge i_rst_n) begin
        if (i_rst_n == 1'b0) begin
            r_req_dis_en <= 1'b0;
        end else begin
            if (i_soft_rst == 1'b1) begin
                r_req_dis_en <= 1'b0;
            end else begin
                if (i_ddr3_ack == 1'b1) begin
                    r_req_dis_en <= 1'b1;
                // end else if (r_req_dis_en_cnt == 3'b100) begin
                end else if (r_req_dis_en_cnt == 3'b101) begin  // 5 arb stages;
                    r_req_dis_en <= 1'b0;
                end
            end
        end
    end

    always @ (posedge i_clk or negedge i_rst_n) begin
        if (i_rst_n == 1'b0) begin
            r_req_dis_en_cnt <= 3'b0;
        end else begin
            if (i_soft_rst == 1'b1) begin
                r_req_dis_en_cnt <= 3'b0;
            end else begin
                if (i_ddr3_ack == 1'b1) begin
                    r_req_dis_en_cnt <= 3'b0;
                end else if (r_req_dis_en == 1'b1) begin
                    r_req_dis_en_cnt <= r_req_dis_en_cnt + 1'b1;
                end
            end
        end
    end

    // =====================================================
    //
    // =====================================================
    //
    
    genvar j ;
    generate
        for (j = 0; j <= 21; j = j + 1) begin : u_out_ch  // 22 channels
            // =============
            always @ (posedge i_clk or negedge i_rst_n) begin
                if (i_rst_n == 1'b0) begin
                    r_chxx_ack[(j+1)* 1 -1:(j)* 1] <= 1'b0;
                end else begin
                    if (i_soft_rst == 1'b1) begin
                        r_chxx_ack[(j+1)* 1 -1:(j)* 1] <= 1'b0;
                    end else begin
                        // if (i_ddr3_ack == 1'b1 && s_ch_stage0_num == j) begin // 
                        if (i_ddr3_ack == 1'b1 && s_ch_stage0_num_d1 == j) begin // 
                            r_chxx_ack[(j+1)* 1 -1:(j)* 1] <= 1'b1;
                        end else begin
                            r_chxx_ack[(j+1)* 1 -1:(j)* 1] <= 1'b0;
                        end
                    end
                end
            end
            // =============
            always @ (posedge i_clk or negedge i_rst_n) begin
                if (i_rst_n == 1'b0) begin
                    r_chxx_op_done[         (j+1)* 1          -1:(j)* 1         ]    <= 1'b0;
                    r_chxx_ram_rd_en[       (j+1)* 1          -1:(j)* 1         ]    <= 1'b0;
                    r_chxx_ram_rd_en_last[  (j+1)* 1          -1:(j)* 1         ]    <= 1'b0;
                    r_chxx_ram_wr_en[       (j+1)* 1          -1:(j)* 1         ]    <= 1'b0;
                    r_chxx_ram_wr_en_last[  (j+1)* 1          -1:(j)* 1         ]    <= 1'b0;
                    r_chxx_ram_wr_data[     (j+1)* DATA_WIDTH -1:(j)* DATA_WIDTH]    <= {DATA_WIDTH{1'b0}};
                end else begin
                    if (i_soft_rst == 1'b1) begin
                        r_chxx_op_done[         (j+1)* 1          -1:(j)* 1         ]    <= 1'b0;
                        r_chxx_ram_rd_en[       (j+1)* 1          -1:(j)* 1         ]    <= 1'b0;
                        r_chxx_ram_rd_en_last[  (j+1)* 1          -1:(j)* 1         ]    <= 1'b0;
                        r_chxx_ram_wr_en[       (j+1)* 1          -1:(j)* 1         ]    <= 1'b0;
                        r_chxx_ram_wr_en_last[  (j+1)* 1          -1:(j)* 1         ]    <= 1'b0;
                        r_chxx_ram_wr_data[     (j+1)* DATA_WIDTH -1:(j)* DATA_WIDTH]    <= {DATA_WIDTH{1'b0}};
                    end else begin
                        if (r_ack_ch_num == j) begin
                            r_chxx_op_done[         (j+1)* 1          -1:(j)* 1         ]    <= i_ddr3_op_done        ;
                            r_chxx_ram_rd_en[       (j+1)* 1          -1:(j)* 1         ]    <= i_ddr3_ram_rd_en      ;
                            r_chxx_ram_rd_en_last[  (j+1)* 1          -1:(j)* 1         ]    <= i_ddr3_ram_rd_en_last ;
                            r_chxx_ram_wr_en[       (j+1)* 1          -1:(j)* 1         ]    <= i_ddr3_ram_wr_en      ;
                            r_chxx_ram_wr_en_last[  (j+1)* 1          -1:(j)* 1         ]    <= i_ddr3_ram_wr_en_last ;
                            r_chxx_ram_wr_data[     (j+1)* DATA_WIDTH -1:(j)* DATA_WIDTH]    <= i_ddr3_ram_wr_data    ;
                        end else begin
                            r_chxx_op_done[         (j+1)* 1          -1:(j)* 1         ]    <= 1'b0;
                            r_chxx_ram_rd_en[       (j+1)* 1          -1:(j)* 1         ]    <= 1'b0;
                            r_chxx_ram_rd_en_last[  (j+1)* 1          -1:(j)* 1         ]    <= 1'b0;
                            r_chxx_ram_wr_en[       (j+1)* 1          -1:(j)* 1         ]    <= 1'b0;
                            r_chxx_ram_wr_en_last[  (j+1)* 1          -1:(j)* 1         ]    <= 1'b0;
                            r_chxx_ram_wr_data[     (j+1)* DATA_WIDTH -1:(j)* DATA_WIDTH]    <= {DATA_WIDTH{1'b0}};
                        end
                    end
                end
            end

        end
    endgenerate

    // =====================================================
    //
    // =====================================================
    always @ (posedge i_clk or negedge i_rst_n) begin
        if (i_rst_n == 1'b0) begin
            r_ddr3_ram_rd_en_0_dff <= 1'b0;
            r_ddr3_ram_rd_en_1_dff <= 1'b0;
            r_ddr3_ram_rd_vld      <= 1'b0;
        end else begin
            if (i_soft_rst == 1'b1) begin
                r_ddr3_ram_rd_en_0_dff <= 1'b0;
                r_ddr3_ram_rd_en_1_dff <= 1'b0;
                r_ddr3_ram_rd_vld      <= 1'b0;
            end else begin
                r_ddr3_ram_rd_en_0_dff <= i_ddr3_ram_rd_en      ;
                r_ddr3_ram_rd_en_1_dff <= r_ddr3_ram_rd_en_0_dff;
                r_ddr3_ram_rd_vld      <= r_ddr3_ram_rd_en_1_dff;
            end
        end
    end

//    always @ (posedge i_clk or negedge i_rst_n) begin
//        if (i_rst_n == 1'b0) begin
//            r_ddr3_ram_rd_data <= {DATA_WIDTH{1'b0}};
//        end else begin
//            if (i_soft_rst == 1'b1) begin
//                r_ddr3_ram_rd_data <= {DATA_WIDTH{1'b0}};
//            end else begin
//                case (r_ack_ch_num)
//                        4'd0             : r_ddr3_ram_rd_data <= i_ch00_ram_rd_data;
//                        4'd1             : r_ddr3_ram_rd_data <= i_ch01_ram_rd_data;
//                        4'd2             : r_ddr3_ram_rd_data <= i_ch02_ram_rd_data;
//                        4'd3             : r_ddr3_ram_rd_data <= i_ch03_ram_rd_data;
//                        4'd4             : r_ddr3_ram_rd_data <= i_ch04_ram_rd_data;
//                        4'd5             : r_ddr3_ram_rd_data <= i_ch05_ram_rd_data;
//                        4'd6             : r_ddr3_ram_rd_data <= i_ch06_ram_rd_data;
//                        4'd7             : r_ddr3_ram_rd_data <= i_ch07_ram_rd_data;
//                        4'd8             : r_ddr3_ram_rd_data <= i_ch08_ram_rd_data;
//                        4'd9             : r_ddr3_ram_rd_data <= i_ch09_ram_rd_data;
//                        4'd10            : r_ddr3_ram_rd_data <= i_ch10_ram_rd_data;
//                        4'd11            : r_ddr3_ram_rd_data <= i_ch11_ram_rd_data;
//                        4'd12            : r_ddr3_ram_rd_data <= i_ch12_ram_rd_data;
//                        4'd13            : r_ddr3_ram_rd_data <= i_ch13_ram_rd_data;
//                        4'd14            : r_ddr3_ram_rd_data <= i_ch14_ram_rd_data;
//                        4'd15            : r_ddr3_ram_rd_data <= i_ch15_ram_rd_data;
//                        default          : r_ddr3_ram_rd_data <= i_ch00_ram_rd_data;
//                    endcase
//            end
//        end
//    end
    
    always @ (posedge i_clk or negedge i_rst_n) begin
        if (i_rst_n == 1'b0) begin
            r_ch00_ram_rd_data <= {DATA_WIDTH{1'b0}};
            r_ch01_ram_rd_data <= {DATA_WIDTH{1'b0}};
            r_ch02_ram_rd_data <= {DATA_WIDTH{1'b0}};
            r_ch03_ram_rd_data <= {DATA_WIDTH{1'b0}};
            r_ch04_ram_rd_data <= {DATA_WIDTH{1'b0}};
            r_ch05_ram_rd_data <= {DATA_WIDTH{1'b0}};
            r_ch06_ram_rd_data <= {DATA_WIDTH{1'b0}};
            r_ch07_ram_rd_data <= {DATA_WIDTH{1'b0}};
            r_ch08_ram_rd_data <= {DATA_WIDTH{1'b0}};
            r_ch09_ram_rd_data <= {DATA_WIDTH{1'b0}};
            r_ch10_ram_rd_data <= {DATA_WIDTH{1'b0}};
            r_ch11_ram_rd_data <= {DATA_WIDTH{1'b0}};
            r_ch12_ram_rd_data <= {DATA_WIDTH{1'b0}};
            r_ch13_ram_rd_data <= {DATA_WIDTH{1'b0}};
            r_ch14_ram_rd_data <= {DATA_WIDTH{1'b0}};
            r_ch15_ram_rd_data <= {DATA_WIDTH{1'b0}};
            r_ch16_ram_rd_data <= {DATA_WIDTH{1'b0}};
            r_ch17_ram_rd_data <= {DATA_WIDTH{1'b0}};
            r_ch18_ram_rd_data <= {DATA_WIDTH{1'b0}};
            r_ch19_ram_rd_data <= {DATA_WIDTH{1'b0}};
            r_ch20_ram_rd_data <= {DATA_WIDTH{1'b0}};
            r_ch21_ram_rd_data <= {DATA_WIDTH{1'b0}};
        end else begin
            if (i_soft_rst == 1'b1) begin
                r_ch00_ram_rd_data <= {DATA_WIDTH{1'b0}};
                r_ch01_ram_rd_data <= {DATA_WIDTH{1'b0}};
                r_ch02_ram_rd_data <= {DATA_WIDTH{1'b0}};
                r_ch03_ram_rd_data <= {DATA_WIDTH{1'b0}};
                r_ch04_ram_rd_data <= {DATA_WIDTH{1'b0}};
                r_ch05_ram_rd_data <= {DATA_WIDTH{1'b0}};
                r_ch06_ram_rd_data <= {DATA_WIDTH{1'b0}};
                r_ch07_ram_rd_data <= {DATA_WIDTH{1'b0}};
                r_ch08_ram_rd_data <= {DATA_WIDTH{1'b0}};
                r_ch09_ram_rd_data <= {DATA_WIDTH{1'b0}};
                r_ch10_ram_rd_data <= {DATA_WIDTH{1'b0}};
                r_ch11_ram_rd_data <= {DATA_WIDTH{1'b0}};
                r_ch12_ram_rd_data <= {DATA_WIDTH{1'b0}};
                r_ch13_ram_rd_data <= {DATA_WIDTH{1'b0}};
                r_ch14_ram_rd_data <= {DATA_WIDTH{1'b0}};
                r_ch15_ram_rd_data <= {DATA_WIDTH{1'b0}};
                r_ch16_ram_rd_data <= {DATA_WIDTH{1'b0}};
                r_ch17_ram_rd_data <= {DATA_WIDTH{1'b0}};
                r_ch18_ram_rd_data <= {DATA_WIDTH{1'b0}};
                r_ch19_ram_rd_data <= {DATA_WIDTH{1'b0}};
                r_ch20_ram_rd_data <= {DATA_WIDTH{1'b0}};
                r_ch21_ram_rd_data <= {DATA_WIDTH{1'b0}};
            end else begin
                r_ch00_ram_rd_data <= i_ch00_ram_rd_data; 
                r_ch01_ram_rd_data <= i_ch01_ram_rd_data; 
                r_ch02_ram_rd_data <= i_ch02_ram_rd_data; 
                r_ch03_ram_rd_data <= i_ch03_ram_rd_data; 
                r_ch04_ram_rd_data <= i_ch04_ram_rd_data; 
                r_ch05_ram_rd_data <= i_ch05_ram_rd_data; 
                r_ch06_ram_rd_data <= i_ch06_ram_rd_data; 
                r_ch07_ram_rd_data <= i_ch07_ram_rd_data; 
                r_ch08_ram_rd_data <= i_ch08_ram_rd_data; 
                r_ch09_ram_rd_data <= i_ch09_ram_rd_data; 
                r_ch10_ram_rd_data <= i_ch10_ram_rd_data; 
                r_ch11_ram_rd_data <= i_ch11_ram_rd_data; 
                r_ch12_ram_rd_data <= i_ch12_ram_rd_data; 
                r_ch13_ram_rd_data <= i_ch13_ram_rd_data; 
                r_ch14_ram_rd_data <= i_ch14_ram_rd_data; 
                r_ch15_ram_rd_data <= i_ch15_ram_rd_data; 
                r_ch16_ram_rd_data <= i_ch16_ram_rd_data; 
                r_ch17_ram_rd_data <= i_ch17_ram_rd_data; 
                r_ch18_ram_rd_data <= i_ch18_ram_rd_data; 
                r_ch19_ram_rd_data <= i_ch19_ram_rd_data; 
                r_ch20_ram_rd_data <= i_ch20_ram_rd_data; 
                r_ch21_ram_rd_data <= i_ch21_ram_rd_data; 
            end
        end
    end 
    
    assign s_ddr3_ram_rd_data = (r_ack_ch_num == 5'd00) ? r_ch00_ram_rd_data :
                                (r_ack_ch_num == 5'd01) ? r_ch01_ram_rd_data :
                                (r_ack_ch_num == 5'd02) ? r_ch02_ram_rd_data :
                                (r_ack_ch_num == 5'd03) ? r_ch03_ram_rd_data :
                                (r_ack_ch_num == 5'd04) ? r_ch04_ram_rd_data :
                                (r_ack_ch_num == 5'd05) ? r_ch05_ram_rd_data :
                                (r_ack_ch_num == 5'd06) ? r_ch06_ram_rd_data :
                                (r_ack_ch_num == 5'd07) ? r_ch07_ram_rd_data :
                                (r_ack_ch_num == 5'd08) ? r_ch08_ram_rd_data :
                                (r_ack_ch_num == 5'd09) ? r_ch09_ram_rd_data :
                                (r_ack_ch_num == 5'd10) ? r_ch10_ram_rd_data :
                                (r_ack_ch_num == 5'd11) ? r_ch11_ram_rd_data :
                                (r_ack_ch_num == 5'd12) ? r_ch12_ram_rd_data :
                                (r_ack_ch_num == 5'd13) ? r_ch13_ram_rd_data :
                                (r_ack_ch_num == 5'd14) ? r_ch14_ram_rd_data :
                                (r_ack_ch_num == 5'd15) ? r_ch15_ram_rd_data :
                                (r_ack_ch_num == 5'd16) ? r_ch16_ram_rd_data :
                                (r_ack_ch_num == 5'd17) ? r_ch17_ram_rd_data :
                                (r_ack_ch_num == 5'd18) ? r_ch18_ram_rd_data :
                                (r_ack_ch_num == 5'd19) ? r_ch19_ram_rd_data :
                                (r_ack_ch_num == 5'd20) ? r_ch20_ram_rd_data :
                                                          r_ch21_ram_rd_data ;
    
    // =====================================================
    // output
    // =====================================================

    assign o_ch00_ack            = r_chxx_ack[              ( 0+1)* 1          -1:( 0)* 1          ];
    assign o_ch00_op_done        = r_chxx_op_done[          ( 0+1)* 1          -1:( 0)* 1          ];
    assign o_ch00_ram_rd_en      = r_chxx_ram_rd_en[        ( 0+1)* 1          -1:( 0)* 1          ];
    assign o_ch00_ram_rd_en_last = r_chxx_ram_rd_en_last[   ( 0+1)* 1          -1:( 0)* 1          ];
    assign o_ch00_ram_wr_en      = r_chxx_ram_wr_en[        ( 0+1)* 1          -1:( 0)* 1          ];
    assign o_ch00_ram_wr_en_last = r_chxx_ram_wr_en_last[   ( 0+1)* 1          -1:( 0)* 1          ];
    assign o_ch00_ram_wr_data    = r_chxx_ram_wr_data[      ( 0+1)* DATA_WIDTH -1:( 0)* DATA_WIDTH ];
                                                                                     
    assign o_ch01_ack            = r_chxx_ack[              ( 1+1)* 1          -1:( 1)* 1          ];
    assign o_ch01_op_done        = r_chxx_op_done[          ( 1+1)* 1          -1:( 1)* 1          ];
    assign o_ch01_ram_rd_en      = r_chxx_ram_rd_en[        ( 1+1)* 1          -1:( 1)* 1          ];
    assign o_ch01_ram_rd_en_last = r_chxx_ram_rd_en_last[   ( 1+1)* 1          -1:( 1)* 1          ];
    assign o_ch01_ram_wr_en      = r_chxx_ram_wr_en[        ( 1+1)* 1          -1:( 1)* 1          ];
    assign o_ch01_ram_wr_en_last = r_chxx_ram_wr_en_last[   ( 1+1)* 1          -1:( 1)* 1          ];
    assign o_ch01_ram_wr_data    = r_chxx_ram_wr_data[      ( 1+1)* DATA_WIDTH -1:( 1)* DATA_WIDTH ];
                                                                                     
    assign o_ch02_ack            = r_chxx_ack[              ( 2+1)* 1          -1:( 2)* 1          ];
    assign o_ch02_op_done        = r_chxx_op_done[          ( 2+1)* 1          -1:( 2)* 1          ];
    assign o_ch02_ram_rd_en      = r_chxx_ram_rd_en[        ( 2+1)* 1          -1:( 2)* 1          ];
    assign o_ch02_ram_rd_en_last = r_chxx_ram_rd_en_last[   ( 2+1)* 1          -1:( 2)* 1          ];
    assign o_ch02_ram_wr_en      = r_chxx_ram_wr_en[        ( 2+1)* 1          -1:( 2)* 1          ];
    assign o_ch02_ram_wr_en_last = r_chxx_ram_wr_en_last[   ( 2+1)* 1          -1:( 2)* 1          ];
    assign o_ch02_ram_wr_data    = r_chxx_ram_wr_data[      ( 2+1)* DATA_WIDTH -1:( 2)* DATA_WIDTH ];
                                                                                     
    assign o_ch03_ack            = r_chxx_ack[              ( 3+1)* 1          -1:( 3)* 1          ];
    assign o_ch03_op_done        = r_chxx_op_done[          ( 3+1)* 1          -1:( 3)* 1          ];
    assign o_ch03_ram_rd_en      = r_chxx_ram_rd_en[        ( 3+1)* 1          -1:( 3)* 1          ];
    assign o_ch03_ram_rd_en_last = r_chxx_ram_rd_en_last[   ( 3+1)* 1          -1:( 3)* 1          ];
    assign o_ch03_ram_wr_en      = r_chxx_ram_wr_en[        ( 3+1)* 1          -1:( 3)* 1          ];
    assign o_ch03_ram_wr_en_last = r_chxx_ram_wr_en_last[   ( 3+1)* 1          -1:( 3)* 1          ];
    assign o_ch03_ram_wr_data    = r_chxx_ram_wr_data[      ( 3+1)* DATA_WIDTH -1:( 3)* DATA_WIDTH ];
                                                                                     
    assign o_ch04_ack            = r_chxx_ack[              ( 4+1)* 1          -1:( 4)* 1          ];
    assign o_ch04_op_done        = r_chxx_op_done[          ( 4+1)* 1          -1:( 4)* 1          ];
    assign o_ch04_ram_rd_en      = r_chxx_ram_rd_en[        ( 4+1)* 1          -1:( 4)* 1          ];
    assign o_ch04_ram_rd_en_last = r_chxx_ram_rd_en_last[   ( 4+1)* 1          -1:( 4)* 1          ];
    assign o_ch04_ram_wr_en      = r_chxx_ram_wr_en[        ( 4+1)* 1          -1:( 4)* 1          ];
    assign o_ch04_ram_wr_en_last = r_chxx_ram_wr_en_last[   ( 4+1)* 1          -1:( 4)* 1          ];
    assign o_ch04_ram_wr_data    = r_chxx_ram_wr_data[      ( 4+1)* DATA_WIDTH -1:( 4)* DATA_WIDTH ];
                                                                                     
    assign o_ch05_ack            = r_chxx_ack[              ( 5+1)* 1          -1:( 5)* 1          ];
    assign o_ch05_op_done        = r_chxx_op_done[          ( 5+1)* 1          -1:( 5)* 1          ];
    assign o_ch05_ram_rd_en      = r_chxx_ram_rd_en[        ( 5+1)* 1          -1:( 5)* 1          ];
    assign o_ch05_ram_rd_en_last = r_chxx_ram_rd_en_last[   ( 5+1)* 1          -1:( 5)* 1          ];
    assign o_ch05_ram_wr_en      = r_chxx_ram_wr_en[        ( 5+1)* 1          -1:( 5)* 1          ];
    assign o_ch05_ram_wr_en_last = r_chxx_ram_wr_en_last[   ( 5+1)* 1          -1:( 5)* 1          ];
    assign o_ch05_ram_wr_data    = r_chxx_ram_wr_data[      ( 5+1)* DATA_WIDTH -1:( 5)* DATA_WIDTH ];
                                                                                     
    assign o_ch06_ack            = r_chxx_ack[              ( 6+1)* 1          -1:( 6)* 1          ];
    assign o_ch06_op_done        = r_chxx_op_done[          ( 6+1)* 1          -1:( 6)* 1          ];
    assign o_ch06_ram_rd_en      = r_chxx_ram_rd_en[        ( 6+1)* 1          -1:( 6)* 1          ];
    assign o_ch06_ram_rd_en_last = r_chxx_ram_rd_en_last[   ( 6+1)* 1          -1:( 6)* 1          ];
    assign o_ch06_ram_wr_en      = r_chxx_ram_wr_en[        ( 6+1)* 1          -1:( 6)* 1          ];
    assign o_ch06_ram_wr_en_last = r_chxx_ram_wr_en_last[   ( 6+1)* 1          -1:( 6)* 1          ];
    assign o_ch06_ram_wr_data    = r_chxx_ram_wr_data[      ( 6+1)* DATA_WIDTH -1:( 6)* DATA_WIDTH ];
                                                                                     
    assign o_ch07_ack            = r_chxx_ack[              ( 7+1)* 1          -1:( 7)* 1          ];
    assign o_ch07_op_done        = r_chxx_op_done[          ( 7+1)* 1          -1:( 7)* 1          ];
    assign o_ch07_ram_rd_en      = r_chxx_ram_rd_en[        ( 7+1)* 1          -1:( 7)* 1          ];
    assign o_ch07_ram_rd_en_last = r_chxx_ram_rd_en_last[   ( 7+1)* 1          -1:( 7)* 1          ];
    assign o_ch07_ram_wr_en      = r_chxx_ram_wr_en[        ( 7+1)* 1          -1:( 7)* 1          ];
    assign o_ch07_ram_wr_en_last = r_chxx_ram_wr_en_last[   ( 7+1)* 1          -1:( 7)* 1          ];
    assign o_ch07_ram_wr_data    = r_chxx_ram_wr_data[      ( 7+1)* DATA_WIDTH -1:( 7)* DATA_WIDTH ];
                                                                                     
    assign o_ch08_ack            = r_chxx_ack[              ( 8+1)* 1          -1:( 8)* 1          ];
    assign o_ch08_op_done        = r_chxx_op_done[          ( 8+1)* 1          -1:( 8)* 1          ];
    assign o_ch08_ram_rd_en      = r_chxx_ram_rd_en[        ( 8+1)* 1          -1:( 8)* 1          ];
    assign o_ch08_ram_rd_en_last = r_chxx_ram_rd_en_last[   ( 8+1)* 1          -1:( 8)* 1          ];
    assign o_ch08_ram_wr_en      = r_chxx_ram_wr_en[        ( 8+1)* 1          -1:( 8)* 1          ];
    assign o_ch08_ram_wr_en_last = r_chxx_ram_wr_en_last[   ( 8+1)* 1          -1:( 8)* 1          ];
    assign o_ch08_ram_wr_data    = r_chxx_ram_wr_data[      ( 8+1)* DATA_WIDTH -1:( 8)* DATA_WIDTH ];
                                                                                     
    assign o_ch09_ack            = r_chxx_ack[              ( 9+1)* 1          -1:( 9)* 1          ];
    assign o_ch09_op_done        = r_chxx_op_done[          ( 9+1)* 1          -1:( 9)* 1          ];
    assign o_ch09_ram_rd_en      = r_chxx_ram_rd_en[        ( 9+1)* 1          -1:( 9)* 1          ];
    assign o_ch09_ram_rd_en_last = r_chxx_ram_rd_en_last[   ( 9+1)* 1          -1:( 9)* 1          ];
    assign o_ch09_ram_wr_en      = r_chxx_ram_wr_en[        ( 9+1)* 1          -1:( 9)* 1          ];
    assign o_ch09_ram_wr_en_last = r_chxx_ram_wr_en_last[   ( 9+1)* 1          -1:( 9)* 1          ];
    assign o_ch09_ram_wr_data    = r_chxx_ram_wr_data[      ( 9+1)* DATA_WIDTH -1:( 9)* DATA_WIDTH ];
                                                                                     
    assign o_ch10_ack            = r_chxx_ack[              (10+1)* 1          -1:(10)* 1          ];
    assign o_ch10_op_done        = r_chxx_op_done[          (10+1)* 1          -1:(10)* 1          ];
    assign o_ch10_ram_rd_en      = r_chxx_ram_rd_en[        (10+1)* 1          -1:(10)* 1          ];
    assign o_ch10_ram_rd_en_last = r_chxx_ram_rd_en_last[   (10+1)* 1          -1:(10)* 1          ];
    assign o_ch10_ram_wr_en      = r_chxx_ram_wr_en[        (10+1)* 1          -1:(10)* 1          ];
    assign o_ch10_ram_wr_en_last = r_chxx_ram_wr_en_last[   (10+1)* 1          -1:(10)* 1          ];
    assign o_ch10_ram_wr_data    = r_chxx_ram_wr_data[      (10+1)* DATA_WIDTH -1:(10)* DATA_WIDTH ];
                                                                                     
    assign o_ch11_ack            = r_chxx_ack[              (11+1)* 1          -1:(11)* 1          ];
    assign o_ch11_op_done        = r_chxx_op_done[          (11+1)* 1          -1:(11)* 1          ];
    assign o_ch11_ram_rd_en      = r_chxx_ram_rd_en[        (11+1)* 1          -1:(11)* 1          ];
    assign o_ch11_ram_rd_en_last = r_chxx_ram_rd_en_last[   (11+1)* 1          -1:(11)* 1          ];
    assign o_ch11_ram_wr_en      = r_chxx_ram_wr_en[        (11+1)* 1          -1:(11)* 1          ];
    assign o_ch11_ram_wr_en_last = r_chxx_ram_wr_en_last[   (11+1)* 1          -1:(11)* 1          ];
    assign o_ch11_ram_wr_data    = r_chxx_ram_wr_data[      (11+1)* DATA_WIDTH -1:(11)* DATA_WIDTH ];
                                                                                     
    assign o_ch12_ack            = r_chxx_ack[              (12+1)* 1          -1:(12)* 1          ];
    assign o_ch12_op_done        = r_chxx_op_done[          (12+1)* 1          -1:(12)* 1          ];
    assign o_ch12_ram_rd_en      = r_chxx_ram_rd_en[        (12+1)* 1          -1:(12)* 1          ];
    assign o_ch12_ram_rd_en_last = r_chxx_ram_rd_en_last[   (12+1)* 1          -1:(12)* 1          ];
    assign o_ch12_ram_wr_en      = r_chxx_ram_wr_en[        (12+1)* 1          -1:(12)* 1          ];
    assign o_ch12_ram_wr_en_last = r_chxx_ram_wr_en_last[   (12+1)* 1          -1:(12)* 1          ];
    assign o_ch12_ram_wr_data    = r_chxx_ram_wr_data[      (12+1)* DATA_WIDTH -1:(12)* DATA_WIDTH ];
                                                                                     
    assign o_ch13_ack            = r_chxx_ack[              (13+1)* 1          -1:(13)* 1          ];
    assign o_ch13_op_done        = r_chxx_op_done[          (13+1)* 1          -1:(13)* 1          ];
    assign o_ch13_ram_rd_en      = r_chxx_ram_rd_en[        (13+1)* 1          -1:(13)* 1          ];
    assign o_ch13_ram_rd_en_last = r_chxx_ram_rd_en_last[   (13+1)* 1          -1:(13)* 1          ];
    assign o_ch13_ram_wr_en      = r_chxx_ram_wr_en[        (13+1)* 1          -1:(13)* 1          ];
    assign o_ch13_ram_wr_en_last = r_chxx_ram_wr_en_last[   (13+1)* 1          -1:(13)* 1          ];
    assign o_ch13_ram_wr_data    = r_chxx_ram_wr_data[      (13+1)* DATA_WIDTH -1:(13)* DATA_WIDTH ];
                                                                                     
    assign o_ch14_ack            = r_chxx_ack[              (14+1)* 1          -1:(14)* 1          ];
    assign o_ch14_op_done        = r_chxx_op_done[          (14+1)* 1          -1:(14)* 1          ];
    assign o_ch14_ram_rd_en      = r_chxx_ram_rd_en[        (14+1)* 1          -1:(14)* 1          ];
    assign o_ch14_ram_rd_en_last = r_chxx_ram_rd_en_last[   (14+1)* 1          -1:(14)* 1          ];
    assign o_ch14_ram_wr_en      = r_chxx_ram_wr_en[        (14+1)* 1          -1:(14)* 1          ];
    assign o_ch14_ram_wr_en_last = r_chxx_ram_wr_en_last[   (14+1)* 1          -1:(14)* 1          ];
    assign o_ch14_ram_wr_data    = r_chxx_ram_wr_data[      (14+1)* DATA_WIDTH -1:(14)* DATA_WIDTH ];
                                                                                     
    assign o_ch15_ack            = r_chxx_ack[              (15+1)* 1          -1:(15)* 1          ];
    assign o_ch15_op_done        = r_chxx_op_done[          (15+1)* 1          -1:(15)* 1          ];
    assign o_ch15_ram_rd_en      = r_chxx_ram_rd_en[        (15+1)* 1          -1:(15)* 1          ];
    assign o_ch15_ram_rd_en_last = r_chxx_ram_rd_en_last[   (15+1)* 1          -1:(15)* 1          ];
    assign o_ch15_ram_wr_en      = r_chxx_ram_wr_en[        (15+1)* 1          -1:(15)* 1          ];
    assign o_ch15_ram_wr_en_last = r_chxx_ram_wr_en_last[   (15+1)* 1          -1:(15)* 1          ];
    assign o_ch15_ram_wr_data    = r_chxx_ram_wr_data[      (15+1)* DATA_WIDTH -1:(15)* DATA_WIDTH ];
    
    assign o_ch16_ack            = r_chxx_ack[              (16+1)* 1          -1:(16)* 1          ];
    assign o_ch16_op_done        = r_chxx_op_done[          (16+1)* 1          -1:(16)* 1          ];
    assign o_ch16_ram_rd_en      = r_chxx_ram_rd_en[        (16+1)* 1          -1:(16)* 1          ];
    assign o_ch16_ram_rd_en_last = r_chxx_ram_rd_en_last[   (16+1)* 1          -1:(16)* 1          ];
    assign o_ch16_ram_wr_en      = r_chxx_ram_wr_en[        (16+1)* 1          -1:(16)* 1          ];
    assign o_ch16_ram_wr_en_last = r_chxx_ram_wr_en_last[   (16+1)* 1          -1:(16)* 1          ];
    assign o_ch16_ram_wr_data    = r_chxx_ram_wr_data[      (16+1)* DATA_WIDTH -1:(16)* DATA_WIDTH ];
    
    assign o_ch17_ack            = r_chxx_ack[              (17+1)* 1          -1:(17)* 1          ];
    assign o_ch17_op_done        = r_chxx_op_done[          (17+1)* 1          -1:(17)* 1          ];
    assign o_ch17_ram_rd_en      = r_chxx_ram_rd_en[        (17+1)* 1          -1:(17)* 1          ];
    assign o_ch17_ram_rd_en_last = r_chxx_ram_rd_en_last[   (17+1)* 1          -1:(17)* 1          ];
    assign o_ch17_ram_wr_en      = r_chxx_ram_wr_en[        (17+1)* 1          -1:(17)* 1          ];
    assign o_ch17_ram_wr_en_last = r_chxx_ram_wr_en_last[   (17+1)* 1          -1:(17)* 1          ];
    assign o_ch17_ram_wr_data    = r_chxx_ram_wr_data[      (17+1)* DATA_WIDTH -1:(17)* DATA_WIDTH ];
    
    assign o_ch18_ack            = r_chxx_ack[              (18+1)* 1          -1:(18)* 1          ];
    assign o_ch18_op_done        = r_chxx_op_done[          (18+1)* 1          -1:(18)* 1          ];
    assign o_ch18_ram_rd_en      = r_chxx_ram_rd_en[        (18+1)* 1          -1:(18)* 1          ];
    assign o_ch18_ram_rd_en_last = r_chxx_ram_rd_en_last[   (18+1)* 1          -1:(18)* 1          ];
    assign o_ch18_ram_wr_en      = r_chxx_ram_wr_en[        (18+1)* 1          -1:(18)* 1          ];
    assign o_ch18_ram_wr_en_last = r_chxx_ram_wr_en_last[   (18+1)* 1          -1:(18)* 1          ];
    assign o_ch18_ram_wr_data    = r_chxx_ram_wr_data[      (18+1)* DATA_WIDTH -1:(18)* DATA_WIDTH ];
    
    assign o_ch19_ack            = r_chxx_ack[              (19+1)* 1          -1:(19)* 1          ];
    assign o_ch19_op_done        = r_chxx_op_done[          (19+1)* 1          -1:(19)* 1          ];
    assign o_ch19_ram_rd_en      = r_chxx_ram_rd_en[        (19+1)* 1          -1:(19)* 1          ];
    assign o_ch19_ram_rd_en_last = r_chxx_ram_rd_en_last[   (19+1)* 1          -1:(19)* 1          ];
    assign o_ch19_ram_wr_en      = r_chxx_ram_wr_en[        (19+1)* 1          -1:(19)* 1          ];
    assign o_ch19_ram_wr_en_last = r_chxx_ram_wr_en_last[   (19+1)* 1          -1:(19)* 1          ];
    assign o_ch19_ram_wr_data    = r_chxx_ram_wr_data[      (19+1)* DATA_WIDTH -1:(19)* DATA_WIDTH ];
    
    assign o_ch20_ack            = r_chxx_ack[              (20+1)* 1          -1:(20)* 1          ];
    assign o_ch20_op_done        = r_chxx_op_done[          (20+1)* 1          -1:(20)* 1          ];
    assign o_ch20_ram_rd_en      = r_chxx_ram_rd_en[        (20+1)* 1          -1:(20)* 1          ];
    assign o_ch20_ram_rd_en_last = r_chxx_ram_rd_en_last[   (20+1)* 1          -1:(20)* 1          ];
    assign o_ch20_ram_wr_en      = r_chxx_ram_wr_en[        (20+1)* 1          -1:(20)* 1          ];
    assign o_ch20_ram_wr_en_last = r_chxx_ram_wr_en_last[   (20+1)* 1          -1:(20)* 1          ];
    assign o_ch20_ram_wr_data    = r_chxx_ram_wr_data[      (20+1)* DATA_WIDTH -1:(20)* DATA_WIDTH ];
    
    assign o_ch21_ack            = r_chxx_ack[              (21+1)* 1          -1:(21)* 1          ];
    assign o_ch21_op_done        = r_chxx_op_done[          (21+1)* 1          -1:(21)* 1          ];
    assign o_ch21_ram_rd_en      = r_chxx_ram_rd_en[        (21+1)* 1          -1:(21)* 1          ];
    assign o_ch21_ram_rd_en_last = r_chxx_ram_rd_en_last[   (21+1)* 1          -1:(21)* 1          ];
    assign o_ch21_ram_wr_en      = r_chxx_ram_wr_en[        (21+1)* 1          -1:(21)* 1          ];
    assign o_ch21_ram_wr_en_last = r_chxx_ram_wr_en_last[   (21+1)* 1          -1:(21)* 1          ];
    assign o_ch21_ram_wr_data    = r_chxx_ram_wr_data[      (21+1)* DATA_WIDTH -1:(21)* DATA_WIDTH ];
    
    assign o_ddr3_req            = (~r_req_dis_en) &  s_ch_stage0_req   ;
    assign o_ddr3_rd_wrn         = s_ch_stage0_rd_wrn                   ;
    assign o_ddr3_start_addr     = s_ch_stage0_start_addr               ;
    assign o_ddr3_length         = s_ch_stage0_length                   ;
    // assign o_ddr3_rd_wrn         = s_ch_stage0_rd_wrn_d1                   ;
    // assign o_ddr3_start_addr     = s_ch_stage0_start_addr_d1               ;
    // assign o_ddr3_length         = s_ch_stage0_length_d1                   ;
                                 
    assign o_ddr3_ram_rd_vld     = r_ddr3_ram_rd_vld                    ;
//    assign o_ddr3_ram_rd_data    = r_ddr3_ram_rd_data                   ;
    assign o_ddr3_ram_rd_data    = s_ddr3_ram_rd_data                   ;    
    
endmodule