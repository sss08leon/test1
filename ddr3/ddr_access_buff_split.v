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
//      Revision History
//
//==================================================================


module ddr_access_buff_split(
    input   wire                            i_ddr3_sclk         ,
    input   wire                            i_rst_n             ,
    input   wire                            i_ddr3_wr_rdn       ,
    input   wire    [127:0]                 i_ram_rd_data       ,
    input   wire                            i_ddr3_ack          ,
    input   wire                            i_ddr3_wr_data_rdy  ,
    input   wire                            i_ddr3_op_done      ,
    input   wire                            i_ddr3_rd_data_vld  ,
    input   wire    [127:0]                 i_ddr3_rd_data      ,
    output  wire                            o_ram_rd_en         ,
    output  wire    [127:0]                 o_ddr3_wr_data      ,
    output  wire                            o_ram_wr_data_vld   ,
    output  wire    [127:0]                 o_ram_wr_data      
);


//===================================DDR Write==================================//
localparam  IDLE    = 1'b0;
localparam  DATA_RD = 1'b1;

reg         current_state;
reg         next_state   ;
reg         fifo_reset   ;
wire        fifo_almost_full;

reg [31: 0] ram_rd_data_0_d1;
reg [31: 0] ram_rd_data_1_d1;
reg [31: 0] ram_rd_data_2_d1;
reg [31: 0] ram_rd_data_3_d1;
reg [31: 0] ram_rd_data_0_d2;
reg [31: 0] ram_rd_data_1_d2;
reg [31: 0] ram_rd_data_2_d2;
reg [31: 0] ram_rd_data_3_d2;

reg         fifo_wr_en_d1;
reg         fifo_wr_en_d2;
reg         fifo_wr_en_d3;
reg         fifo_wr_en_d4;
reg         fifo_reset_d1;
reg         fifo_reset_d2;
reg         fifo_reset_d3;
reg         fifo_reset_d4;
reg         ram_rd_en    ;
wire        s_fifo_wr_en = fifo_wr_en_d4;
wire        s_fifo_reset = fifo_reset_d4;
always @ (posedge i_ddr3_sclk or negedge i_rst_n)
begin
    if (i_rst_n == 1'b0) begin
        ram_rd_en <= 1'b0;
    end
    else begin
        ram_rd_en <= (~fifo_almost_full) && (current_state != IDLE);
    end
end

assign      o_ram_rd_en = ram_rd_en;

reg     r_ddr3_wr_rdn;
always @ (posedge i_ddr3_sclk)
begin
    r_ddr3_wr_rdn <= i_ddr3_wr_rdn;
end


always @ (posedge i_ddr3_sclk)
begin
    ram_rd_data_0_d1 <= i_ram_rd_data[127:96];
    ram_rd_data_1_d1 <= i_ram_rd_data[ 95:64];
    ram_rd_data_2_d1 <= i_ram_rd_data[ 63:32];
    ram_rd_data_3_d1 <= i_ram_rd_data[ 31: 0];
    ram_rd_data_0_d2 <= ram_rd_data_0_d1     ;
    ram_rd_data_1_d2 <= ram_rd_data_1_d1     ;
    ram_rd_data_2_d2 <= ram_rd_data_2_d1     ;
    ram_rd_data_3_d2 <= ram_rd_data_3_d1     ;
end

always @ (posedge i_ddr3_sclk)
begin
    fifo_wr_en_d1 <= o_ram_rd_en;
    fifo_wr_en_d2 <= fifo_wr_en_d1;
    fifo_wr_en_d3 <= fifo_wr_en_d2;
    fifo_wr_en_d4 <= fifo_wr_en_d3;
end

always @ (posedge i_ddr3_sclk or negedge i_rst_n)
begin
    if (i_rst_n == 1'b0) begin
        fifo_reset <= 1'b1;
    end
    else begin
        if (current_state == IDLE) begin
            fifo_reset <= 1'b1;
        end
        else begin
            fifo_reset <= 1'b0;
        end
    end
end

always @ (posedge i_ddr3_sclk)
begin
    fifo_reset_d1 <= fifo_reset;
    fifo_reset_d2 <= fifo_reset_d1;
    fifo_reset_d3 <= fifo_reset_d2;
    fifo_reset_d4 <= fifo_reset_d3;
end


always @ (posedge i_ddr3_sclk or negedge i_rst_n)
begin
    if (i_rst_n == 1'b0) begin
        current_state <= IDLE;
    end
    else begin
        current_state <= next_state;
    end
end

always @ (*)
begin
    case (current_state)
        IDLE    :   begin
                        // if (i_ddr3_ack == 1'b1 && i_ddr3_wr_rdn == 1'b1) begin
                        if (i_ddr3_ack == 1'b1 && r_ddr3_wr_rdn == 1'b1) begin
                            next_state <= DATA_RD;
                        end
                        else begin
                            next_state <= IDLE;
                        end
                    end
        DATA_RD :   begin
                        if (i_ddr3_op_done == 1'b1) begin
                            next_state <= IDLE;
                        end
                        else begin
                            next_state <= DATA_RD;
                        end
                    end
    endcase
end


mlabfifo_16x32_16x32_d2 ddr_access_buff_fifo_0 (
    .Data      (ram_rd_data_0_d2),
    .Clock     (i_ddr3_sclk),
    .WrEn      (s_fifo_wr_en), //fifo_wr_en_d4
    .RdEn      (i_ddr3_wr_data_rdy),
    .Reset     (s_fifo_reset),
    .Q         (o_ddr3_wr_data[127:96]),
    .Empty     (),
    .Full      (),
    .AlmostFull(fifo_almost_full)
    );

mlabfifo_16x32_16x32_d2 ddr_access_buff_fifo_1 (
    .Data      (ram_rd_data_1_d2),
    .Clock     (i_ddr3_sclk),
    .WrEn      (s_fifo_wr_en), //fifo_wr_en_d4
    .RdEn      (i_ddr3_wr_data_rdy),
    .Reset     (s_fifo_reset),
    .Q         (o_ddr3_wr_data[95:64]),
    .Empty     (),
    .Full      (),
    .AlmostFull()
    );

mlabfifo_16x32_16x32_d2 ddr_access_buff_fifo_2 (
    .Data      (ram_rd_data_2_d2),
    .Clock     (i_ddr3_sclk),
    .WrEn      (s_fifo_wr_en), //fifo_wr_en_d4
    .RdEn      (i_ddr3_wr_data_rdy),
    .Reset     (s_fifo_reset),
    .Q         (o_ddr3_wr_data[63:32]),
    .Empty     (),
    .Full      (),
    .AlmostFull()
    );

mlabfifo_16x32_16x32_d2 ddr_access_buff_fifo_3 (
    .Data      (ram_rd_data_3_d2),
    .Clock     (i_ddr3_sclk),
    .WrEn      (s_fifo_wr_en), //fifo_wr_en_d4
    .RdEn      (i_ddr3_wr_data_rdy),
    .Reset     (s_fifo_reset),
    .Q         (o_ddr3_wr_data[31:0]),
    .Empty     (),
    .Full      (),
    .AlmostFull()
    );



//===================================DDR Read==================================//
reg         ddr3_rd_data_vld_d1;
reg         ddr3_rd_data_vld_d2;
reg [ 31:0] ddr3_rd_data_0_d1    ;
reg [ 31:0] ddr3_rd_data_1_d1    ;
reg [ 31:0] ddr3_rd_data_2_d1    ;
reg [ 31:0] ddr3_rd_data_3_d1    ;
reg [ 31:0] ddr3_rd_data_0_d2    ;
reg [ 31:0] ddr3_rd_data_1_d2    ;
reg [ 31:0] ddr3_rd_data_2_d2    ;
reg [ 31:0] ddr3_rd_data_3_d2    ;

always @ (posedge i_ddr3_sclk or negedge i_rst_n)
begin
    if (i_rst_n == 1'b0) begin
        ddr3_rd_data_vld_d1 <= 1'b0;
        ddr3_rd_data_vld_d2 <= 1'b0;
    end
    else begin
        ddr3_rd_data_vld_d1 <= i_ddr3_rd_data_vld;
        ddr3_rd_data_vld_d2 <= ddr3_rd_data_vld_d1;
    end
end

always @ (posedge i_ddr3_sclk)
begin
    ddr3_rd_data_0_d1 <= i_ddr3_rd_data[127:96];
    ddr3_rd_data_1_d1 <= i_ddr3_rd_data[ 95:64];
    ddr3_rd_data_2_d1 <= i_ddr3_rd_data[ 63:32];
    ddr3_rd_data_3_d1 <= i_ddr3_rd_data[ 31: 0];
    ddr3_rd_data_0_d2 <= ddr3_rd_data_0_d1;
    ddr3_rd_data_1_d2 <= ddr3_rd_data_1_d1;
    ddr3_rd_data_2_d2 <= ddr3_rd_data_2_d1;
    ddr3_rd_data_3_d2 <= ddr3_rd_data_3_d1;
end
assign  o_ram_wr_data_vld = ddr3_rd_data_vld_d1;
assign  o_ram_wr_data     = {ddr3_rd_data_0_d1, ddr3_rd_data_1_d1, ddr3_rd_data_2_d1, ddr3_rd_data_3_d1};
endmodule