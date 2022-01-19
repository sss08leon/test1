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


module vpi_ram_control#(
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
    input   wire    [15:0]              i_pix_data          ,

    input   wire                        i_ddr_clk           ,
    input   wire                        i_ddr_vpi_ack       ,
    input   wire                        i_ddr_wr_done       ,  // pulse
    input   wire    [7:0]               i_ram_rd_addr       ,
    output  wire    [DATA_WIDTH-1:0]    o_ram_rd_data       ,
    output  wire                        o_ddr_req             // 3 pixel clock width;
);


reg         vs_d1, vs_d2 ;
reg         de_d1, de_d2 ;
reg         neg_de_d1    ;
reg         neg_de_d2    ;
reg         ram_wr_sel   ;
reg         ram_rd_sel   ;
reg [12:0]  ram_wr_addr  ;
wire        pos_vs    =   (vs_d1 == 1'b1) && (vs_d2 == 1'b0);
wire        neg_de    =   (de_d1 == 1'b0) && (de_d2 == 1'b1);

reg         vpi_pix_clk_ddr_req;
reg         vpi_pix_clk_ddr_req_d1;
always @ (posedge i_pix_clk or negedge i_rst_n)
begin
    if (i_rst_n == 1'b0) begin
      vpi_pix_clk_ddr_req    <= 1'b0;
      vpi_pix_clk_ddr_req_d1 <= 1'b0;
    end
    else begin
      vpi_pix_clk_ddr_req    <= neg_de || neg_de_d1 || neg_de_d2 ;
      vpi_pix_clk_ddr_req_d1 <= vpi_pix_clk_ddr_req;
    end
end
assign  o_ddr_req = vpi_pix_clk_ddr_req_d1;

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
        neg_de_d1   <=  1'b0;
        neg_de_d2   <=  1'b0;
    end
    else begin
        if (i_soft_rst == 1'b1) begin
            neg_de_d1   <=  1'b0;
            neg_de_d2   <=  1'b0;
        end
        else begin
            neg_de_d1   <=  neg_de ;
            neg_de_d2   <=  neg_de_d1 ;
        end
    end
end

//-------------------------------ram_wr_sel------------------------//
always@(posedge i_pix_clk or negedge i_rst_n)
begin
    if (i_rst_n == 1'd0) begin
        ram_wr_sel    <=  1'd0    ;
    end
    else begin
        if (i_soft_rst == 1'd1) begin
            ram_wr_sel    <=  1'd0    ;
        end
        else begin
            if (pos_vs == 1'd1) begin
                ram_wr_sel    <=  1'd0    ;
            end
            else begin
                if (neg_de  ==  1'd1) begin
                    ram_wr_sel    <=  ~ram_wr_sel   ;
                end
            end
        end
    end
end

//-------------------------------ram_rd_sel------------------------//
reg     ram_wr_sel_d1, ram_wr_sel_d2;

always@(posedge i_ddr_clk or negedge i_rst_n)
begin
    if (i_rst_n == 1'd0) begin
        ram_wr_sel_d1    <=  1'd0    ;
        ram_wr_sel_d2    <=  1'd0    ;
    end
    else begin
        if (i_soft_rst == 1'd1) begin
            ram_wr_sel_d1    <=  1'd0    ;
            ram_wr_sel_d2    <=  1'd0    ;
        end
        else begin
            ram_wr_sel_d1    <=  ram_wr_sel ;
            ram_wr_sel_d2    <=  ram_wr_sel_d1;
        end
    end
end

always@(posedge i_ddr_clk or negedge i_rst_n)
begin
    if (i_rst_n == 1'd0) begin
        ram_rd_sel    <=  1'd0    ;
    end
    else begin
        if (i_soft_rst == 1'd1) begin
            ram_rd_sel    <=  1'd0    ;
        end
        else begin
            if (i_ddr_vpi_ack == 1'd1) begin
                ram_rd_sel    <= ~ram_wr_sel_d2    ;
            end
        end
    end
end

/*
always@(posedge i_ddr_clk or negedge i_rst_n)
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
                if (i_ddr_wr_done  ==  1'd1) begin
                    ram_rd_sel     <=  ~ram_rd_sel   ;
                end
            end
        end
    end
end
*/
//------------------------------o_wraddr--------------------------------------//
always@(posedge i_pix_clk or negedge i_rst_n)
begin
    if (i_rst_n == 1'd0) begin
        ram_wr_addr[12:0] <=  13'd0   ;
    end
    else  begin
        if (i_soft_rst == 1'd1) begin
            ram_wr_addr[12:0] <=  13'd0   ;
        end
        else begin
            if ( pos_vs  ==  1'd1) begin
                ram_wr_addr[12:0] <=  13'd0   ;
            end
            else begin
                if (neg_de  ==  1'd1) begin
                    ram_wr_addr[12:0] <=  13'd0   ;
                end
                else begin
                    if (i_de == 1'b1 && i_data_en   ==  1'd1) begin
                        ram_wr_addr[12:0] <=  ram_wr_addr[12:0] +   13'd1   ;
                    end
                end
            end
        end
    end
end

wire    [DATA_WIDTH-1:0]     ram_rd_data_0;
wire    [DATA_WIDTH-1:0]     ram_rd_data_1;
assign                       o_ram_rd_data = (ram_rd_sel == 1'b0) ? ram_rd_data_0 : ram_rd_data_1;

ram_2048x16_256x128_d1_wrap  ram_2048x16_256x128_d1_wrap_0(
    .i_rst_n          ( i_rst_n                       ),
    .i_ram_we         (~ram_wr_sel                    ), // ram_wr_addr[12]
    .i_ram_wr_clk     ( i_pix_clk                     ),
    .i_ram_wr_addr    ( ram_wr_addr[10:0]             ),
    .i_ram_wr_data    ( i_pix_data[15:0]              ),
    .i_ram_rd_clk     ( i_ddr_clk                     ),
    .i_ram_rd_addr    ( i_ram_rd_addr[7:0]            ),
    .o_ram_rd_data    ( ram_rd_data_0[DATA_WIDTH-1:0] )
);

ram_2048x16_256x128_d1_wrap  ram_2048x16_256x128_d1_wrap_1(
    .i_rst_n          ( i_rst_n                       ),
    .i_ram_we         ( ram_wr_sel                    ), // ram_wr_addr[12]
    .i_ram_wr_clk     ( i_pix_clk                     ),
    .i_ram_wr_addr    ( ram_wr_addr[10:0]             ),
    .i_ram_wr_data    ( i_pix_data[15:0]              ),
    .i_ram_rd_clk     ( i_ddr_clk                     ),
    .i_ram_rd_addr    ( i_ram_rd_addr[7:0]            ),
    .o_ram_rd_data    ( ram_rd_data_1[DATA_WIDTH-1:0] )
);





endmodule
