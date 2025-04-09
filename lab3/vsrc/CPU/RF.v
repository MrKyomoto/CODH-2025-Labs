`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/06 22:27:34
// Design Name: 
// Module Name: RF
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module  RF (
    input   [0 : 0]         clk     ,       // 时钟
    input   [4 : 0]         ra0, ra1,       // 读地址
    output  [31: 0]         rd0, rd1,       // 读数据
    input   [4 : 0]         wa      ,       // 写地址
    input   [31: 0]         wd      ,       // 写数据
    input   [0 : 0]         we      ,       // 写使能

    input [4:0] debug_ra,
    output [31:0] debug_rd
);
reg [31:0] r[0:31];     // 寄存器堆

initial begin
    r[0] = 0;
end
//读优先
assign rd0 = r[ra0];    // 读操作
assign rd1 = r[ra1];
assign debug_rd = r[debug_ra];

always  @(posedge clk)begin
    if (we) begin
        if(wa == 0)begin
            r[0] <= 0;
        end
        else begin
            r[wa] <= wd;
        end
    end  
    else begin
        r[0] <= 0;
    end
end

endmodule
