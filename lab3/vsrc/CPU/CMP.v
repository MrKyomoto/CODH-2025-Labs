`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/06 22:25:23
// Design Name: 
// Module Name: CMP
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


module CMP(
input [31:0] in1,
input [31:0] in2,
input [2:0] sel, //根据sel来选择CMP模式(<,<=,>,>=,==以及是否为有符号数)
output reg result
// output reg valid //MEMO(目前为止我认为这个valid还是有必要的,二编,我现在觉得没必要了,因为这是组合逻辑而非时序逻辑)
);
wire signed [31:0] in1_signed;
wire signed [31:0] in2_signed;
assign in1_signed = in1;
assign in2_signed = in2;
localparam BEQ = 0;
localparam BNE = 1;
localparam BLT = 2;
localparam BGE = 3;
localparam BLTU = 4;
localparam BGEU = 5;
always @(*) begin
   case (sel)
    //MEMO(如果只是比较是否相等的话,其实用in还是用in_signed都是可以的,不过为了规范一点还是选择了用in_signed)
    BEQ:begin
        result = in1_signed == in2_signed;
    end 
    BNE:begin
        result = in1_signed != in2_signed;
    end
    BLT:begin
        result = in1_signed < in2_signed;
    end
    BGE:begin
        result = in1_signed >= in2_signed;
    end
    BLTU:begin
        result = in1 < in2;
    end
    BGEU:begin
        result = in1 >= in2;
    end
    default: //FIXME(这个default最好也一起处理一下)
    begin
        result = 0;
    end
   endcase 
end
endmodule
