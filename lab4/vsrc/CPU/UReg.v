`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/23 16:34:37
// Design Name: 
// Module Name: UReg
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

//TODO(这个UReg肯定还要改,因为CTRL的输出不仅仅只有三个)
//TODO(以及,记得CTRL不再需要接入cmpResult了,因为不在这里输出跳转结果)
//TODO(需要在EX阶段加一个MUX用以选择PC的值)
module UReg(
    input clk,
    input rstn,
    input en,
    input stall,
    input flush,

    input [31:0] IR,
    input [31:0] PC,

    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,

    input [31:0] MDW, //mem data write 
    input [31:0] MDR, //mem data read

    input WB,//是否写回
    input [1:0] WBMux, /// 0 --> aluOut; 1 --> mem data; 2 --> pc + 4
    input MW,//是否写内存

    input [3:0] EX,//执行何种alu操作

    input [31:0] Y,

    input [31:0] A, //rf data 1
    input [31:0] B, //rf data 2

    input src1Mux, src2Mux,
    input [31:0] imm32,
    input [5:0] opType,
    input [2:0] sel_branch,
    //=========================================

    output reg [31:0] IRout,
    output reg [31:0] PCout,

    output reg [4:0] rs1out,
    output reg [4:0] rs2out,
    output reg [4:0] rdout,

    output reg [31:0] MDWout,
    output reg [31:0] MDRout,

    output reg WBout,
    output reg [1:0] WBMuxout,
    output reg MWout,

    output reg [3:0] EXout,

    output reg [31:0] Aout,
    output reg [31:0] Bout,
    output reg [31:0] YW,

    output reg src1Muxout, src2Muxout,
    output reg [31:0] imm32out,

    output reg [5:0] opTypeOut,
    output reg [2:0] sel_branch_out,

    // =========================
    input commit, isHalt,
    output reg commitOut, isHaltOut,

    input storeFilteredEn,
    output reg storeFilteredEnOut,

    input [31:0] storeDataFiltered,
    output reg [31:0] storeDataFilteredOut
);
parameter DEFAULT_IR = 32'b0;
parameter DEFAULT_PC = 32'b0;
always @(posedge clk) begin
    if (~rstn) begin
        // rst 操作的逻辑。如果你使用的是 rstn，请注意替换条件
        IRout <= DEFAULT_IR;
        PCout <= DEFAULT_PC;
        rs1out <= 5'b0;
        rs2out <= 5'b0;
        rdout <= 5'b0;

        MDWout <= 32'b0;
        MDRout <= 32'b0;

        WBout <= 1'b0;
        WBMuxout <= 2'b0;
        MWout <= 1'b0;

        EXout <= 4'b0;

        Aout <= 32'b0;
        Bout <= 32'b0;
        YW <= 32'b0;

        src1Muxout <= 1'b0;
        src2Muxout <= 1'b0;

        imm32out <= 32'b0;
        opTypeOut <= 6'b0;
        sel_branch_out <= 3'b0;

        commitOut <= 1'b0;
        isHaltOut <= 1'b0;

        storeFilteredEnOut <= 1'b0;
        storeDataFilteredOut <= 32'b0;

    end
    else if (en) begin
        // flush 和 stall 操作的逻辑, flush 的优先级更高
        if(flush)begin
            IRout <= DEFAULT_IR;
            PCout <= DEFAULT_PC;
            rs1out <= 5'b0;
            rs2out <= 5'b0;
            rdout <= 5'b0;

            MDWout <= 32'b0;
            MDRout <= 32'b0;

            WBout <= 1'b0;
            WBMuxout <= 2'b0;
            MWout <= 1'b0;
            EXout <= 4'b0;

            Aout <= 32'b0;
            Bout <= 32'b0;
            YW <= 32'b0;

            src1Muxout <= 1'b0;
            src2Muxout <= 1'b0;

            imm32out <= 32'b0;
            opTypeOut <= 6'b0;
            sel_branch_out <= 3'b0;

            commitOut <= 1'b0;
            isHaltOut <= 1'b0;

            storeFilteredEnOut <= 1'b0;
            storeDataFilteredOut <= 32'b0;
        end
        else if(stall)begin
           IRout <= IRout; 
           PCout <= PCout;
           rs1out <= rs1out;
           rs2out <= rs2out;
           rdout <= rdout;

           MDWout <= MDWout;
           MDRout <= MDRout;

           WBout <= WBout;
           WBMuxout <= WBMuxout;
           MWout <= MWout;

           EXout <= EXout;

           Aout <= Aout;
           Bout <= Bout;
           YW <= YW;

            src1Muxout <= src1Muxout;
            src2Muxout <= src2Muxout;

            imm32out <= imm32out;
            opTypeOut <= opTypeOut;
            sel_branch_out <= sel_branch_out;

            commitOut <= commitOut;
            isHaltOut <= isHaltOut;

            storeFilteredEnOut <= storeFilteredEnOut;
            storeDataFilteredOut <= storeDataFilteredOut;
        end
        else begin
           IRout <= IR; 
           PCout <= PC;
           rs1out <= rs1;
           rs2out <= rs2;
           rdout <= rd;

           MDWout <= MDW;
           MDRout <= MDR;

           WBout <= WB;
           WBMuxout <= WBMux;
           MWout <= MW;

           EXout <= EX;

           Aout <= A;
           Bout <= B;
           YW <= Y;

            src1Muxout <= src1Mux;
            src2Muxout <= src2Mux;

            imm32out <= imm32;
            opTypeOut <= opType;
            sel_branch_out <= sel_branch;

            commitOut <= commit;
            isHaltOut <= isHalt;

            storeFilteredEnOut <= storeFilteredEn;
            storeDataFilteredOut <= storeDataFiltered;
        end
    end
end
endmodule
