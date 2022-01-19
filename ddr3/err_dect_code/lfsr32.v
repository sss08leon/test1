`timescale 1 ns / 100 ps
module lfsr32 
    (clk,
    resetn,
    clear,
    enable,
    load,
    din,
    q);
    
input               clk;
input               resetn;
input               clear;
input               enable;
input               load;
input   [31:0]      din;
output  [31:0]      q;  

reg     [31:0]      q;

always @ (posedge clk or negedge resetn) begin
    if (resetn==0) begin
        q[31:0] <= 32'h9acedfba;
    end
    else begin
        if (clear == 1)         
            q[31:0] <= 32'h9acedfba;
        else if (load == 1)
            q[31:0] <= din;
        else if (enable == 1)
        begin
            q[0] <= q[1] ^ q[4] ^ 1 ;
            q[1] <= q[2] ^ q[5] ^ 1 ;
            q[2] <= q[3] ^ q[6] ^ 1 ;
            q[3] <= q[4] ^ q[7] ^ 1 ;
            q[4] <= q[5] ^ q[8] ^ 1 ;
            q[5] <= q[6] ^ q[9] ^ 1 ;
            q[6] <= q[7] ^ q[10] ^ 1 ;
            q[7] <= q[8] ^ q[11] ^ 1 ;
            q[8] <= q[9] ^ q[12] ^ 1 ;
            q[9] <= q[10] ^ q[13] ^ 1 ;
            q[10] <= q[11] ^ q[14] ^ 1 ;
            q[11] <= q[12] ^ q[15] ^ 1 ;
            q[12] <= q[13] ^ q[16] ^ 1 ;
            q[13] <= q[14] ^ q[17] ^ 1 ;
            q[14] <= q[15] ^ q[18] ^ 1 ;
            q[15] <= q[16] ^ q[19] ^ 1 ;
            q[16] <= q[17] ^ q[20] ^ 1 ;
            q[17] <= q[18] ^ q[21] ^ 1 ;
            q[18] <= q[19] ^ q[22] ^ 1 ;
            q[19] <= q[20] ^ q[23] ^ 1 ;
            q[20] <= q[21] ^ q[24] ^ 1 ;
            q[21] <= q[22] ^ q[25] ^ 1 ;
            q[22] <= q[23] ^ q[26] ^ 1 ;
            q[23] <= q[24] ^ q[27] ^ 1 ;
            q[24] <= q[25] ^ q[28] ^ 1 ;
            q[25] <= q[26] ^ q[29] ^ 1 ;
            q[26] <= q[27] ^ q[30] ^ 1 ;
            q[27] <= q[28] ^ q[31] ^ 1 ;
            q[28] <= q[1] ^ q[4] ^ q[29] ^ 1 ;
            q[29] <= q[2] ^ q[5] ^ q[30] ^ 1 ;
            q[30] <= q[3] ^ q[6] ^ q[31] ^ 1 ;
            q[31] <= q[1] ^ q[7] ^ 1 ;
        end
    end
end

endmodule
