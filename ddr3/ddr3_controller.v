//=========================== KEDACOM Corporation======================
//      Information contained in this Confidential and Proprietary work has
//      been obtained by KEDACOM Corporation. This Design may be used only as
//      authorized by a Licensing Agreement from KEDACOM Corporation.
//===================================================================
//          KEDACOM
//Address:  No131 Jinshan Rd. New District,  Suzhou City,  Jiangsu Province, China
//Zip code: 215011
//Tel:      0512-68418188
//Fax:      0512-68412699 
//==============================================================
//      Description
//===============================================================
//      Version            date               author       
//      
//
//      Revision History
//         
//          
//==================================================================
// synopsys translate_off
`timescale 1ns/1ps
// synopsys translate_on

module ddr3_controller   
#(
    parameter           DATA_WIDTH          = 128,
    parameter           ADDR_WIDTH          = 27   // actually needed width is 27 in SVR2930.
)
( 
        input   wire                     i_rst_n,
        input   wire                     i_clk_in,           //100M for ddr3-800
        output  wire                     o_sclk,             //200M for DDR3-800
//      input   wire                     i_soft_rst,
                    
        input   wire                     i_ddr3_req,
        input   wire                     i_ddr3_we_rdn,      // 1: write      0: read
        input   wire    [ADDR_WIDTH-1:0] i_ddr3_start_addr,  // 27bit address width in svr2930.
        input   wire    [11:0]           i_ddr3_data_length, // MAX number is 4095;
                                         
        output  reg                      o_ddr3_busy,
        output  reg                      o_ddr3_operate_done,                    
        output  wire                     o_ddr3_wdata_rdy,
        input   wire    [DATA_WIDTH-1:0] i_ddr3_wdata,
        output  wire                     o_ddr3_rdata_vld,
        output  wire    [DATA_WIDTH-1:0] o_ddt3_rdata,
                    
        input   wire    [11:0]           i_read_pulse_tap,
        output  wire                     o_wr_error,
        output  wire                     o_clk_good,
        output  reg                      o_init_done,
        /////////////////ddr3 sdram port////////////////////////////////
        output  wire                     o_em_ddr_reset_n,    
        output  wire                     o_em_ddr_clk,
        output  wire                     o_em_ddr_cke,
                                         
        output  wire                     o_em_ddr_cs_n,
        output  wire                     o_em_ddr_ras_n,
        output  wire                     o_em_ddr_cas_n,
        output  wire                     o_em_ddr_we_n,
        output  wire                     o_em_ddr_odt,
                    
        output  wire    [2:0]            o_em_ddr_ba,
        output  wire    [ADDR_WIDTH-14:0]o_em_ddr_addr,
        inout   wire    [31:0]           io_em_ddr_data,
        inout   wire    [3:0]            io_em_ddr_dqs,
        output  wire    [3:0]            o_em_ddr_dm
                );
//***************************************************************************
localparam  CMD_IDLE        = 4'b0000;
localparam  CMD_READ        = 4'b0001;
localparam  CMD_WRITE       = 4'b0010;
localparam  CMD_READA       = 4'b0011;
localparam  CMD_WRITEA      = 4'b0100;
localparam  CMD_PDOWN_ENT   = 4'b0101;
localparam  CMD_LOAD_MR     = 4'b0110;
localparam  CMD_SEL_REF_ENT = 4'b1000;
localparam  CMD_SEL_REF_EXIT= 4'b1001;
localparam  CMD_PDOWN_EXIT  = 4'b1011;
localparam  CMD_ZQ_LNG      = 4'b1100;
localparam  CMD_ZQ_SHRT     = 4'b1101;

localparam  IDLE            = 3'd0;
localparam  DDR3_INITIAL    = 3'd1;
localparam  INITIAL_DONE    = 3'd2;
localparam  DDR3_CMD_RDY    = 3'd3;
localparam  CMD_ACCESAPT    = 3'd4;
localparam  DDR3_READ       = 3'd5;
localparam  DDR3_WRITE      = 3'd6;
localparam  DDR3_OPERATE_END= 3'd7;
//////////////////////////////////////////////////////////////////////////////
reg     [2:0]               state,  next_state      ;
reg                         ddr3_init_start         ;
reg     [3:0]               ddr3_cmd                ;
reg     [4:0]               ddr3_burst_cnt          ;
reg                         ddr3_cmd_vld            ;
reg     [ADDR_WIDTH-1:0]    ddr3_addr               ;
reg     [7:0]               continual_numb/* synthesis syn_keep=1 */;
reg     [7:0]               continual_numb_c/* synthesis syn_keep=1 */;
wire                        last_operate_flag       ;
////////////////////////////////////
wire        ddr3_cmd_rdy        ;
wire        ddr3_init_done      ;
wire        ddr3_operate_done   ;
wire        sclk                ;
assign      o_sclk = sclk       ;
//******************************************************************************
reg ddr3_we_rdn;
always@(negedge i_rst_n or posedge sclk)
begin
    if (i_rst_n==1'b0)
    begin
        ddr3_we_rdn<=1'b0;
    end
//    else
//    begin
//        if (i_soft_rst==1'b1)
//        begin
//            ddr3_we_rdn<=1'b0;
//        end 
        else
        begin
            ddr3_we_rdn <=  i_ddr3_we_rdn;
        end
//    end
end
//*******************************************************************************
always@(negedge i_rst_n or posedge sclk)
begin
    if (i_rst_n==1'b0)
    begin
        state[2:0]  <=  IDLE;
    end
//    else
//    begin
//        if (i_soft_rst==1'b1)
//        begin
//            if(state[2:0]!=IDLE || state[2:0]!=DDR3_INITIAL )
//                state[2:0]<=INITIAL_DONE;
//        end 
        else
        begin
            state[2:0]  <=  next_state; 
        end
//    end
end
////////////////////////////////////////////////////////////////////////
always@*
begin
    case(state[2:0])
        IDLE:           begin
                            next_state[2:0] = DDR3_INITIAL;
                        end
        DDR3_INITIAL:   begin
                            if (ddr3_init_done==1'b1)
                            begin
                                next_state[2:0] = INITIAL_DONE;
                            end
                            else
                            begin
                                next_state[2:0] = DDR3_INITIAL;
                            end
                        end
        INITIAL_DONE:   begin
                            if (o_clk_good==1'b1 && ddr3_cmd_rdy==1'b1)
                            begin
                                next_state[2:0] = DDR3_CMD_RDY;
                            end
                            else
                            begin
                                next_state[2:0] = INITIAL_DONE;
                            end
                        end
        DDR3_CMD_RDY:   begin
                            if (i_ddr3_req==1'b1 && i_ddr3_data_length[11:0]!=12'd0)
                            begin
                                next_state[2:0] = CMD_ACCESAPT;
                            end
                            else
                            begin
                                next_state[2:0] = DDR3_CMD_RDY;
                            end
                        end
        CMD_ACCESAPT:   begin
                            if (ddr3_we_rdn==1'b1)        //write
                            begin
                                next_state[2:0] = DDR3_WRITE;
                            end
                            else                            //read
                            begin
                                next_state[2:0] = DDR3_READ;
                            end
                        end
        DDR3_WRITE:     begin
//                            if (last_operate_flag==1'b1)
                            if (ddr3_operate_done==1'b1)
                            begin
                                next_state[2:0] = DDR3_OPERATE_END;
                            end
                            else
                            begin
                                next_state[2:0] = DDR3_WRITE;
                            end
                        end
        DDR3_READ:      begin
//                            if (last_operate_flag==1'b1)
                            if (ddr3_operate_done==1'b1)
                            begin
                                next_state[2:0] = DDR3_OPERATE_END;
                            end
                            else
                            begin
                                next_state[2:0] = DDR3_READ;
                            end
                        end
        DDR3_OPERATE_END:   begin
                                next_state[2:0] = INITIAL_DONE;
//                                if (ddr3_cmd_rdy==1'b1)
//                                begin
//                                    next_state[2:0] = DDR3_CMD_RDY;
//                                end
//                                else
//                                begin
//                                    next_state[2:0] = DDR3_OPERATE_END;
//                                end
                            end
        default:            begin
                                next_state[2:0] = IDLE;
                            end                            
    endcase
end
//*************************************************************************************************
always@(negedge i_rst_n or posedge sclk)
begin
    if (i_rst_n==1'b0)
    begin
        ddr3_init_start<=1'b0;
        o_init_done<=1'b0;
    end
//    else
//    begin
//        if (i_soft_rst==1'b1)
//        begin
//            ddr3_init_start<=1'b0;
//            o_init_done<=1'b0;
//        end
        else
        begin
            if (ddr3_init_done==1'b1)
            begin
                ddr3_init_start<=1'b0;
            end
            else if (state[2:0]==DDR3_INITIAL)
            begin
                ddr3_init_start<=1'b1;
            end
            ///////////////////////////////////////////
            if (state[2:0]==INITIAL_DONE)
            begin
                o_init_done<=1'b1;
            end
        end
//    end
end
//*********************************************************************************************************************
wire        data_tail_numb = (i_ddr3_data_length[3:0]==4'd0)? 1'b1 : 1'b0;
wire[7:0]   tmp1_continual_numb = i_ddr3_data_length[11:4] - data_tail_numb;

reg[7:0]    fitst_operate_numb;
reg[ADDR_WIDTH-1:0]   ddr3_start_address;
always@(negedge i_rst_n or posedge sclk)
begin
    if (i_rst_n==1'b0)
    begin
        fitst_operate_numb[7:0]<=8'd0;
        ddr3_start_address[ADDR_WIDTH-1:0]<={ADDR_WIDTH{1'b0}};
    end
//    else
//    begin
//        if (i_soft_rst==1'b1)
//        begin
//            fitst_operate_numb[7:0]<=8'd0;
//            ddr3_start_address[ADDR_WIDTH-1:0] <= {ADDR_WIDTH{1'b0}};
//        end 
        else
        begin
            if (next_state[2:0]==CMD_ACCESAPT)
            begin
                fitst_operate_numb[7:0]<=tmp1_continual_numb[7:0];
                ddr3_start_address[ADDR_WIDTH-1:0]<=i_ddr3_start_addr[ADDR_WIDTH-1:0];
            end
        end
//    end
end
///////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////
wire[5:0]   burst_numb = (ddr3_burst_cnt[4:0]==5'd0)? 6'd32 : {1'b0,ddr3_burst_cnt[4:0]};
wire[7:0]   tmp2_continual_numb = continual_numb[7:0] - burst_numb[5:0];

always@(negedge i_rst_n or posedge sclk)
begin
    if (i_rst_n==1'b0)
    begin
        ddr3_addr[ADDR_WIDTH-1:0]<={ADDR_WIDTH{1'b0}};
        continual_numb[7:0]<=8'd0;
        continual_numb_c[7:0]<=8'd0;
    end
//    else
//    begin
//        if (i_soft_rst==1'b1)
//        begin
//            ddr3_addr[25:0]<=26'd0;
//            continual_numb[7:0]<=8'd0;
//            continual_numb_c[7:0]<=8'd0;
//        end
        else
        begin
            if (state[2:0]==CMD_ACCESAPT) 
            begin
                ddr3_addr[ADDR_WIDTH-1:0] <= ddr3_start_address[ADDR_WIDTH-1:0];
                continual_numb[7:0]<=fitst_operate_numb[7:0];
                continual_numb_c[7:0]<=fitst_operate_numb[7:0];
            end
            else if (state[2:0]==DDR3_READ || state[2:0]==DDR3_WRITE)
            begin
                if (ddr3_cmd_rdy==1'b1 && ddr3_cmd_vld==1'b1)
                begin
                    ddr3_addr[ADDR_WIDTH-1:0]<=ddr3_addr[ADDR_WIDTH-1:0] + {burst_numb[5:0],3'd0};
                    continual_numb[7:0]<=tmp2_continual_numb[7:0];
                    continual_numb_c[7:0]<=tmp2_continual_numb[7:0];
                end
            end
            else
            begin
                ddr3_addr[ADDR_WIDTH-1:0]<={ADDR_WIDTH{1'b0}};
                continual_numb[7:0]<=8'd0;
                continual_numb_c[7:0]<=8'd0;
            end
        end
//    end
end
assign last_operate_flag = (continual_numb_c[7:0]==8'd0 && ddr3_cmd_rdy==1'b1 && ddr3_cmd_vld==1'b1)? 1'b1 : 1'b0;
//***************************************************************************************************************************
always@(negedge i_rst_n or posedge sclk)
begin
    if (i_rst_n==1'b0)
    begin
        ddr3_cmd[3:0]<=CMD_IDLE;
        ddr3_burst_cnt[4:0]<=5'd0;
        ddr3_cmd_vld<=1'b0;
    end
//    else
//    begin
//        if (i_soft_rst==1'b1)
//        begin
//            ddr3_cmd[3:0]<=CMD_IDLE;
//            ddr3_burst_cnt[4:0]<=5'd0;
//            ddr3_cmd_vld<=1'b0;
//        end
        else
        begin 
            if (state[2:0]==CMD_ACCESAPT)
            begin
                ddr3_cmd_vld<=1'b1;
            end
            else if ((state[2:0]==DDR3_WRITE || state[2:0]==DDR3_READ) && last_operate_flag==1'b1)
            begin
                ddr3_cmd_vld<=1'b0;
            end
            /////////////////////////////////////////////////////////////////////////////////////////////
            case(state[2:0])                                                                        //first operate command
                CMD_ACCESAPT:   begin
                                    if (ddr3_we_rdn==1'b0)                                   // read
                                    begin
                                        if (fitst_operate_numb[7:0]==8'd0)       // just one read   
                                        begin
                                            ddr3_cmd[3:0]<=CMD_READA;
                                        end
                                        else
                                        begin
                                            ddr3_cmd[3:0]<=CMD_READ;
                                        end
                                    end
                                    else                                                      //write
                                    begin
                                        if (fitst_operate_numb[7:0]==8'd0)       // just one write   
                                        begin
                                            ddr3_cmd[3:0]<=CMD_WRITEA;
                                        end
                                        else
                                        begin
                                            ddr3_cmd[3:0]<=CMD_WRITE;
                                        end
                                    end
                                end
                DDR3_READ:      begin                                                               //read command
                                    if (ddr3_cmd_rdy==1'b1 && ddr3_cmd_vld==1'b1)
                                    begin
                                        if (tmp2_continual_numb[7:0]==8'd0)              //last read
                                        begin
                                            ddr3_cmd[3:0]<=CMD_READA;
                                        end
                                        else                                        //not last read
                                        begin
                                            ddr3_cmd[3:0]<=CMD_READ;
                                        end
                                    end
                                end  
                DDR3_WRITE:     begin                                                               //write command
                                    if (ddr3_cmd_rdy==1'b1 && ddr3_cmd_vld==1'b1)
                                    begin
                                        if (tmp2_continual_numb[7:0]==8'd0)              // last write
                                        begin
                                            ddr3_cmd[3:0]<=CMD_WRITEA;
                                        end
                                        else                                        //not last write
                                        begin
                                            ddr3_cmd[3:0]<=CMD_WRITE;
                                        end
                                    end
                                end
                default:        begin
                                    ddr3_cmd[3:0]<=CMD_IDLE;
                                end                                 
            endcase           
            //////////////////////////////////////////////////////////////////////////////////////////
            case(state[2:0])
                CMD_ACCESAPT:           begin           //first operate command
                                            if (fitst_operate_numb[7:5]!=2'd0)          // 32 times
                                            begin
                                                ddr3_burst_cnt[4:0]<=5'd0;
                                            end
                                            else if (fitst_operate_numb[4:0]==5'd0)     // last one 
                                            begin
                                                ddr3_burst_cnt[4:0]<=5'd1;
                                            end
                                            else
                                            begin
                                                ddr3_burst_cnt[4:0]<=fitst_operate_numb[4:0];
                                            end
                                        end
                DDR3_READ,DDR3_WRITE:   begin
                                            if (ddr3_cmd_rdy==1'b1 && ddr3_cmd_vld==1'b1)
                                            begin
                                                if (tmp2_continual_numb[7:5]!=2'd0)          // 32 times
                                                begin
                                                    ddr3_burst_cnt[4:0]<=5'd0;
                                                end
                                                else if (tmp2_continual_numb[4:0]==5'd0)     // last one 
                                                begin
                                                    ddr3_burst_cnt[4:0]<=5'd1;
                                                end
                                                else
                                                begin
                                                    ddr3_burst_cnt[4:0]<=tmp2_continual_numb[4:0];
                                                end 
                                            end
                                        end
                default:                begin
                                            ddr3_burst_cnt[4:0]<=5'd0;
                                        end 
            endcase        
        end 
//    end
end
//*****************************************************************************
ddr3_sdram_mem_top u_ddr3_sdram_mem_top (
       // Clock and reset
       .clk_in                  (i_clk_in),
       .rst_n                   (i_rst_n),
       .mem_rst_n               (1'b1),
    
       // Input signals from the User I/F  
       .init_start              (ddr3_init_start),  
       .cmd                     (ddr3_cmd[3:0]),
       .addr                    (ddr3_addr[ADDR_WIDTH-1:0]),  // 27bit address width in svr2930.
       .cmd_burst_cnt           (ddr3_burst_cnt[4:0]),
       .cmd_valid               (ddr3_cmd_vld),       
       .ofly_burst_len          (1'b0), 
       .write_data              (i_ddr3_wdata[DATA_WIDTH-1:0]),
       .data_mask               (16'h0000),
       .read_pulse_tap          (i_read_pulse_tap[11:0]),
    
       // Output signals to the User I/F
       .cmd_rdy                 (ddr3_cmd_rdy),
       .datain_rdy              (o_ddr3_wdata_rdy),
       .init_done               (ddr3_init_done),
       .wl_err                  (o_wr_error),
       .read_data               (o_ddt3_rdata[DATA_WIDTH-1:0]),
       .read_data_valid         (o_ddr3_rdata_vld),
    
       // Output to external use
       .sclk_out                (sclk),
       .clocking_good           (o_clk_good),
       // Memory side signals 
       .em_ddr_reset_n          (o_em_ddr_reset_n),
       .em_ddr_data             (io_em_ddr_data[31:0]),
       .em_ddr_dqs              (io_em_ddr_dqs[3:0]),
       .em_ddr_clk              (o_em_ddr_clk),
       .em_ddr_cke              (o_em_ddr_cke),
       .em_ddr_ras_n            (o_em_ddr_ras_n),
       .em_ddr_cas_n            (o_em_ddr_cas_n),
       .em_ddr_we_n             (o_em_ddr_we_n),
       .em_ddr_cs_n             (o_em_ddr_cs_n),
       .em_ddr_odt              (o_em_ddr_odt),
       .em_ddr_dm               (o_em_ddr_dm[3:0]),
       .em_ddr_ba               (o_em_ddr_ba[2:0]),
       .em_ddr_addr             (o_em_ddr_addr[ADDR_WIDTH-14:0])  // 14 bit row address width in svr2930.
);
//*********************************************************************************************************
always@(negedge i_rst_n or posedge sclk)
begin
    if (i_rst_n==1'b0)
    begin
        o_ddr3_busy<=1'b1; 
    end 
//    else
//    begin
//        if (i_soft_rst==1'b1)
//        begin
//            o_ddr3_busy<=1'b1;
//        end
        else
        begin
            if (next_state[2:0]==DDR3_CMD_RDY)
            begin
                o_ddr3_busy<=1'b0;
            end
            else
            begin
                o_ddr3_busy<=1'b1; 
            end
        end
//    end
end
//********************************************************************************
reg         wdata_rdy_d1,   wdata_rdy_d2;
always@(posedge sclk)
begin
    wdata_rdy_d1<=o_ddr3_wdata_rdy;
    wdata_rdy_d2<=wdata_rdy_d1;    
end
/////////////////////////////////////////////////////////////////////////////////////////
reg[8:0]    total_operate_numb;
reg[8:0]    operate_cnt;
assign        ddr3_operate_done = (operate_cnt[8:0]==total_operate_numb[8:0])? 1'b1 : 1'b0;

always@(negedge i_rst_n or posedge sclk)
begin
    if (i_rst_n==1'b0)
    begin
        total_operate_numb[8:0]<=9'd0;
        operate_cnt[8:0]<=9'd0;
        o_ddr3_operate_done<=1'b0;
    end
//    else
//    begin
//      if (i_soft_rst==1'b1)
//      begin
//          total_operate_numb[8:0]<=9'd0;
//            operate_cnt[8:0]<=9'd0;
//          o_ddr3_operate_done<=1'b0; 
//      end
        else
        begin
            if (state[2:0]==CMD_ACCESAPT)
            begin
                total_operate_numb[8:0]<={fitst_operate_numb[7:0],1'b1};
            end
            //////////////////////////////////////////////////////////
            if (ddr3_operate_done==1'b1)
            begin
                operate_cnt[8:0]<=9'd0;
            end
            else if (state[2:0]==DDR3_WRITE)
            begin
                if (wdata_rdy_d2==1'b1)
                begin
                    operate_cnt[8:0]<=operate_cnt[8:0] + 1'b1;      
                end
            end
            else if (state[2:0]==DDR3_READ)
            begin
                if (o_ddr3_rdata_vld==1'b1)
                begin
                    operate_cnt[8:0]<=operate_cnt[8:0] + 1'b1;    
                end 
            end
            else
            begin
                operate_cnt[8:0]<=9'd0;
            end
            //////////////////////////////////////////////
            if (state[2:0]==DDR3_CMD_RDY && i_ddr3_req==1'b1 && i_ddr3_data_length[11:0]==12'd0)
            begin
                o_ddr3_operate_done<=1'b1;
            end
            else if (state[2:0]==DDR3_WRITE || state[2:0]==DDR3_READ)
            begin
                o_ddr3_operate_done<=ddr3_operate_done;
            end
            else
            begin
                o_ddr3_operate_done<=1'b0; 
            end
        end
//    end
end
//**********************************************************************************
endmodule