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
//      1.0                2016.11.18         gzd
//
//      Revision History
//
//
//==================================================================
// synopsys translate_off
`timescale 1ns/1ps
// synopsys translate_on


module vpo_ram_control_mul_rd#(
    parameter   DATA_WIDTH = 128,
    parameter   ADDR_WIDTH = 27
)
(
    input   wire                        i_rst_n             ,
    input   wire                        i_soft_rst          ,

    input   wire                        i_pix_clk           ,
    input   wire                        i_vs                ,
    input   wire                        i_de                ,
    input   wire                        i_data_en           ,
    input   wire                        i_ram_rd_addr_clear ,
    input   wire    [11:0]              i_ram_rd_start_addr ,
    output  wire    [15:0]              o_pix_data          ,

    input   wire                        i_ddr_clk           ,
    input   wire                        i_ddr_vpo_ack       ,  // pulse
    input   wire                        i_ram_wr_en         ,
    input   wire    [7:0]               i_ram_wr_addr       ,
    input   wire    [DATA_WIDTH-1:0]    i_ram_wr_data       ,
    output  wire                        o_ddr_req             // 3 pixel clock width;
);


reg         vs_d1, vs_d2 ;
reg         de_d1, de_d2 ;
reg         pos_vs_d1    ;
reg         pos_vs_d2    ;
reg         pos_de_d1    ;
reg         pos_de_d2    ;
reg         ram_wr_sel   ;
reg         ram_rd_sel   ;
reg [11:0]  ram_rd_addr  ;
wire        pos_vs    =   (vs_d1 == 1'b1) && (vs_d2 == 1'b0);
wire        neg_vs    =   (vs_d1 == 1'b0) && (vs_d2 == 1'b1);
wire        pos_de    =   (de_d1 == 1'b1) && (de_d2 == 1'b0);
wire        neg_de    =   (de_d1 == 1'b0) && (de_d2 == 1'b1);

reg         vpo_pix_clk_ddr_req;
reg         vpo_pix_clk_ddr_req_d1;
always @ (posedge i_pix_clk or negedge i_rst_n)
begin
    if (i_rst_n == 1'b0) begin
      vpo_pix_clk_ddr_req    <= 1'b0;
      vpo_pix_clk_ddr_req_d1 <= 1'b0;
    end
    else begin
      vpo_pix_clk_ddr_req    <= (pos_de || pos_de_d1 || pos_de_d2) || (pos_vs || pos_vs_d1 || pos_vs_d2);
      vpo_pix_clk_ddr_req_d1 <= vpo_pix_clk_ddr_req;
    end
end
assign  o_ddr_req = vpo_pix_clk_ddr_req_d1;

always @ (posedge i_pix_clk or negedge i_rst_n)
begin
    if (i_rst_n == 1'b0) begin
        vs_d1   <=  1'b0;
        vs_d2   <=  1'b0;
        de_d1   <=  1'b0;
        de_d2   <=  1'b0;
    end
    else begin
        if (i_soft_rst == 1'b1) begin
            vs_d1   <=  1'b0;
            vs_d2   <=  1'b0;
            de_d1   <=  1'b0;
            de_d2   <=  1'b0;
        end
        else begin
            vs_d1   <=  i_vs ;
            vs_d2   <=  vs_d1;
            de_d1   <=  i_de ;
            de_d2   <=  de_d1;
        end
    end
end

always @ (posedge i_pix_clk or negedge i_rst_n)
begin
    if (i_rst_n == 1'b0) begin
        pos_vs_d1   <=  1'b0;
        pos_vs_d2   <=  1'b0;
        pos_de_d1   <=  1'b0;
        pos_de_d2   <=  1'b0;
    end
    else begin
        if (i_soft_rst == 1'b1) begin
            pos_vs_d1   <=  1'b0;
            pos_vs_d2   <=  1'b0;
            pos_de_d1   <=  1'b0;
            pos_de_d2   <=  1'b0;
        end
        else begin
            pos_vs_d1   <=  pos_vs    ;
            pos_vs_d2   <=  pos_vs_d1 ;
            pos_de_d1   <=  pos_de    ;
            pos_de_d2   <=  pos_de_d1 ;
        end
    end
end

//-------------------------------ram_rd_sel------------------------//
always@(posedge i_pix_clk or negedge i_rst_n)
begin
    if (i_rst_n == 1'd0) begin
        ram_rd_sel    <=  1'd0    ;
    end
    else begin
        if (i_soft_rst == 1'd1) begin
            ram_rd_sel    <=  1'd0    ;
        end
        else begin
            if ( pos_vs == 1'd1) begin
                ram_rd_sel    <=  1'd0    ;
            end
            else begin
               if (neg_de  ==  1'd1) begin
                   ram_rd_sel    <=  ~ram_rd_sel   ;
               end
            end
        end
    end
end

//-------------------------------ram_wr_sel------------------------//
always@(posedge i_ddr_clk or negedge i_rst_n)
begin
    if (i_rst_n == 1'd0) begin
        ram_wr_sel    <=  1'd1    ;
    end
    else begin
        if (i_soft_rst == 1'd1) begin
            ram_wr_sel    <=  1'd1    ;
        end
        else begin
            if ( pos_vs == 1'd1) begin
                ram_wr_sel    <=  1'd1    ;
            end
            else begin
               if (i_ddr_vpo_ack  ==  1'd1) begin
                   ram_wr_sel     <=  ~ram_wr_sel   ;
               end
            end
        end
    end
end

//------------------------------ram_rd_addr--------------------------------------//
always@(posedge i_pix_clk or negedge i_rst_n)
begin
    if (i_rst_n == 1'd0) begin
        ram_rd_addr[11:0] <=  12'd0   ;
    end
    else  begin
        if (i_soft_rst == 1'd1) begin
            ram_rd_addr[11:0] <=  12'd0   ;
        end
        else begin
            if ( pos_vs  ==  1'd1) begin
                ram_rd_addr[11:0] <=  12'd0   ;
            end
            else begin
                if (neg_de  ==  1'd1) begin
                    ram_rd_addr[11:0] <=  12'd0   ;
                end
                else begin
                    if (i_de == 1'b1 && i_data_en   ==  1'd1) begin
                        if (i_ram_rd_addr_clear == 1'b1) begin
                            ram_rd_addr[11:0] <=  i_ram_rd_start_addr[11:0]   ;
                        end
                        else begin
                            ram_rd_addr[11:0] <=  ram_rd_addr[11:0] +   13'd1   ;
                        end
                    end
                end
            end
        end
    end
end

//i_ram_rd_sel
wire    [15:0]     ram_rd_data_0;
wire    [15:0]     ram_rd_data_1;
// assign o_ram_rd_data = (ram_wr_sel == 1'b1) ? ram_rd_data_0 : ram_rd_data_1;
assign o_pix_data = (ram_rd_sel == 1'b0) ? ram_rd_data_0 : ram_rd_data_1;

ram_256x128_2048x16_d1_wrap  ram_256x128_2048x16_d1_wrap_0(
    .i_rst_n          ( i_rst_n                         ),
    .i_ram_we         ((~ram_wr_sel && i_ram_wr_en)     ), // ram_rd_addr[12]
    .i_ram_wr_clk     ( i_ddr_clk                       ),
    .i_ram_wr_addr    ( i_ram_wr_addr[7:0]              ),
    .i_ram_wr_data    ( i_ram_wr_data[DATA_WIDTH-1:0]   ),
    .i_ram_rd_clk     ( i_pix_clk                       ),
    .i_ram_rd_addr    ( ram_rd_addr[10:0]               ),
    .o_ram_rd_data    ( ram_rd_data_0[15:0]             )
);


ram_256x128_2048x16_d1_wrap  ram_256x128_2048x16_d1_wrap_1(
    .i_rst_n          ( i_rst_n                         ),
    .i_ram_we         ((ram_wr_sel  &&  i_ram_wr_en)    ), // ram_rd_addr[12]
    .i_ram_wr_clk     ( i_ddr_clk                       ),
    .i_ram_wr_addr    ( i_ram_wr_addr[7:0]              ),
    .i_ram_wr_data    ( i_ram_wr_data[DATA_WIDTH-1:0]   ),
    .i_ram_rd_clk     ( i_pix_clk                       ),
    .i_ram_rd_addr    ( ram_rd_addr[10:0]               ),
    .o_ram_rd_data    ( ram_rd_data_1[15:0]             )
);






endmodule
