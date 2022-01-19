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
// Lattice Semiconductor Corporation        TEL :  1-800-Lattice (USA and Canada)
// 5555 NE Moore Court                             503-268-8001 (other locations)
// Hillsboro, OR 97124                      web  : http://www.latticesemi.com/
// U.S.A                                    email: techsupport@latticesemi.com
// =============================================================================
//                         FILE DETAILS
// Project          : DDR3 IOPB Demo
// File             : ddr3_test_params.v
// Title            : Parameters defined by user logic
// =============================================================================
//                        REVISION HISTORY
// Version          : 1.4
// Author(s)        : Kyoho Lee/ LSV Apps
// Mod. Date        : April, 2012
// Changes Made     : 1.4 -Formatted all tabs to spaces for consistent look 
//                        -Removed all unnecessary parameters
//
// =============================================================================

// `include "ddr3_sdram_mem_params.v"
`include "E:/project/SVR2930/interface_fpga/src/lattice_ip/ddr3_core/ddr_p_eval/ddr3_core/src/params/ddr3_sdram_mem_params.v"
`ifdef SIM
 `include "tb_config_params.v"
`endif

//== Define LED polarity
`define LED_ON                  0
`define LED_OFF                 1

//== Define write data latency
// `define   WrRqDDelay_2      // enable for an additional cycle

//== Define user command burst size
`define UsrCmdBrstCnt   2   // 2,4,8,16,32 allowed, default=2
                            // 1 can be used but dynamic OTF change from BC4 to BL8 may not work

