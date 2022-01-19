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
//                  for kintex 7's 2 ddr3 controllers
//
//  Revision History
//
//
// =============================================================================

`timescale 1 ns / 1 ps

module ddr3_arb_compare
(
    input                   i_rst_n                 , // async reset.low active   
    input                   i_clk                   , // clock
    input                   i_soft_rst              , // soft reset.high active      
    // ========================== 
    // ============= ch00
    input                   i_ch00_req              , // request
    input   [ 4:0]          i_ch00_num              , // channel num
    input   [15:0]          i_ch00_priority         , // priority.0:highest priority
    input                   i_ch00_rd_wrn           , // 1:read memory;0:write memory
    input   [26:0]          i_ch00_start_addr       , // start address. 32 bit
    input   [11:0]          i_ch00_length           , // 32bit's num.encoded as 0 to 4095,representing 0 to 4095.
    // ============= ch01
    input                   i_ch01_req              , // request
    input   [ 4:0]          i_ch01_num              , // channel num
    input   [15:0]          i_ch01_priority         , // priority.0:highest priority
    input                   i_ch01_rd_wrn           , // 1:read memory;0:write memory
    input   [26:0]          i_ch01_start_addr       , // start address. 32 bit
    input   [11:0]          i_ch01_length           , // 32bit's num.encoded as 0 to 4095,representing 0 to 4095.
    // ============= ch15
    output                  o_ch_req                , // request
    output  [ 4:0]          o_ch_num                , // channel num                   
    output  [15:0]          o_ch_priority           , // priority.0:highest priority  
    output                  o_ch_rd_wrn             , // 1:read memory;0:write memory
    output  [26:0]          o_ch_start_addr         , // start address. 32 bit
    output  [11:0]          o_ch_length               // 32bit's num.encoded as 0 to 4095,representing 0 to 4095.
);

    // =====================================================
    // Internal Signals Declaration
    // =====================================================
    wire    [16:0]          s_sub                   ;
    reg                     r_ch_req                ;  
    reg     [ 4:0]          r_ch_num                ; 
    reg     [15:0]          r_ch_priority           ; 
    reg                     r_ch_rd_wrn             ;    
    reg     [26:0]          r_ch_start_addr         ;    
    reg     [11:0]          r_ch_length             ;                    

// =============================================================================
// RTL Body
// =============================================================================

    // =====================================================
    //
    // =====================================================
    assign s_sub = {1'b0,i_ch01_priority} - {1'b0,i_ch00_priority};
    
    always @ (posedge i_clk or negedge i_rst_n) begin
        if (i_rst_n == 1'b0) begin
            r_ch_req <= 1'b0;
        end else begin
            if (i_soft_rst == 1'b1) begin
                r_ch_req <= 1'b0;
            end else begin
                r_ch_req <= i_ch00_req | i_ch01_req;
            end
        end
    end
    
    always @ (posedge i_clk) begin
        if (i_ch00_req == 1'b1 && i_ch01_req == 1'b1) begin
            if (s_sub[16] == 1'b0) begin   // i_ch00_priority <= i_ch01_priority
                r_ch_num        <= i_ch00_num       ;
                r_ch_priority   <= i_ch00_priority  ;
                r_ch_rd_wrn     <= i_ch00_rd_wrn    ;   
                r_ch_start_addr <= i_ch00_start_addr;
                r_ch_length     <= i_ch00_length    ;
             end else begin 
                r_ch_num        <= i_ch01_num       ;
                r_ch_priority   <= i_ch01_priority  ;
                r_ch_rd_wrn     <= i_ch01_rd_wrn    ;   
                r_ch_start_addr <= i_ch01_start_addr;   
                r_ch_length     <= i_ch01_length    ;   
             end 
        end else if (i_ch00_req == 1'b1 && i_ch01_req == 1'b0) begin
                r_ch_num        <= i_ch00_num       ;
                r_ch_priority   <= i_ch00_priority  ;
                r_ch_rd_wrn     <= i_ch00_rd_wrn    ;   
                r_ch_start_addr <= i_ch00_start_addr;
                r_ch_length     <= i_ch00_length    ;
        end else begin
                r_ch_num        <= i_ch01_num       ;
                r_ch_priority   <= i_ch01_priority  ;
                r_ch_rd_wrn     <= i_ch01_rd_wrn    ;   
                r_ch_start_addr <= i_ch01_start_addr;   
                r_ch_length     <= i_ch01_length    ; 
        end
    end
    
    // =====================================================
    // output
    // =====================================================
    assign o_ch_req        = r_ch_req        ;
    assign o_ch_num        = r_ch_num        ;
    assign o_ch_priority   = r_ch_priority   ;
    assign o_ch_rd_wrn     = r_ch_rd_wrn     ;
    assign o_ch_start_addr = r_ch_start_addr ;
    assign o_ch_length     = r_ch_length     ;

endmodule