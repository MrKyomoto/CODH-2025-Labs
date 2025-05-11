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

//TODO(这个CMP后要接一个MUX来选择npc的值,result就刚好可以作为MUX的选择逻辑,但是我现在认为MUX的sel信号应该是result && opType的结果)
//TODO(因为我写的逻辑里默认会去比较是否相等,而在一开始in1和in2赋高电平?maybe,或者如何如何,会让他一开始就是result = 1,想解决的话可能还是要在CMP里引入opType)
//TODO(二编,就得引入opType,因为CTRL里的pcMux就使用了opType和cmpResult的结果,所以这里确实得引入)
module CMP(
    //TODO(input [x:0] opType,用以生成pcMux)
input [31:0] in1,
input [31:0] in2,
input [2:0] sel, //根据sel来选择CMP模式(<,<=,>,>=,==以及是否为有符号数)
input [5:0] opType,
output reg result
    //TODO(output pcMux)
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
localparam J = 6; //JAL && JALR也可以并入
always @(*) begin
   case (sel)
    //MEMO(如果只是比较是否相等的话,其实用in还是用in_signed都是可以的,不过为了规范一点还是选择了用in_signed)
    BEQ:begin
        result = (in1_signed == in2_signed) && opType == 6'd31;
    end 
    BNE:begin
        result = in1_signed != in2_signed && opType == 6'd32;
    end
    BLT:begin
        result = in1_signed < in2_signed && opType == 6'd33;
    end
    BGE:begin
        result = in1_signed >= in2_signed && opType == 6'd34;
    end
    BLTU:begin
        result = in1 < in2 && opType == 6'd35;
    end
    BGEU:begin
        result = in1 >= in2 && opType == 6'd36;
    end
    J:begin
        result = 1 && (opType == 6'd29 || opType == 6'd30);
    end
    default: //FIXME(这个default最好也一起处理一下)
    begin
        result = 0;
    end
   endcase 
end
endmodule
