`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/06 20:31:26
// Design Name: 
// Module Name: FU
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


module FU(
    input eWB, mWB,
    input [4:0] eRd, mRd,
    input [4:0] dRs1, dRs2,
    input [1:0] eWBMux,
    output reg [1:0] forwardMux1, //控制src1的mux 0 --> 不前递, 1-->前递eY, 2->前递mY
    output reg [1:0] forwardMux2 // 0 --> 不前递, 1-->前递eY, 2->前递mY
);
always @(*) begin
    //FIXME(这里可能有点问题,就是eWBMux的逻辑是否是 == 0的时候才判断发生前递,我不清楚是否存在将PC+4写入寄存器r中又立马用r里的值计算的代码)
    if(eWB && eWBMux == 0 && dRs1 == eRd && dRs1 != 5'b0)begin
        forwardMux1 = 2'd1; 
    end
    else if(mWB && dRs1 == mRd && dRs1 != 5'b0)begin
        forwardMux1 = 2'd2;
    end
    else begin
        forwardMux1 = 2'd0;
    end

    if(eWB && eWBMux == 0 && dRs2 == eRd && dRs2 != 5'b0)begin
        forwardMux2 = 2'd1; 
    end
    else if(mWB && dRs2 == mRd && dRs2 != 5'b0)begin
        forwardMux2 = 2'd2;
    end
    else begin
        forwardMux2 = 2'd0;
    end
end
endmodule
