`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/07 12:55:23
// Design Name: 
// Module Name: CTRL
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

//TODO(虽然CTRL写的烂了一点,但是无需大改,主要是cmpResult和pcMux不再需要了,其余的目前来看应该还是要保留的)
module CTRL(
    input [5:0] opType,

    output reg src1Mux, // 0 --> PC; 1--> rs1
    output reg src2Mux, // 0 --> rs2; 1--> imm32
    output reg [1:0] write2RfMux, // wirte to RF mux 0 --> aluOut; 1 --> dmOut; 2 --> pc+4
    // output reg isJump,
    output reg write2RfEn,
    output reg write2DMEn,
    output reg [3:0] aluSel
);
// R Type
localparam ADD = 0; localparam SUB = 1; localparam SLL = 2;
localparam SLT = 3; localparam XORR = 4;localparam SRL = 5;
localparam SRA = 6; localparam ORR = 7; localparam AND = 8;

//I Type
localparam ADDI = 9; localparam SLTI = 10; localparam SLTIU = 11;
localparam XORI = 13; localparam ORI = 14; localparam ANDI = 15;
localparam SLLI = 16; localparam SRLI = 17;localparam SRAI = 18;

//U Type
localparam LUI = 19; localparam AUIPC = 20;

//I 访存 Type
localparam LB = 21; localparam LH = 22; localparam LW = 23;
localparam LBU = 24; localparam LHU = 25;

//S Type
localparam SB = 26; localparam SH = 27; localparam SW = 28;

//J Type
localparam JAL = 29; localparam JALR = 30;


//B Type
localparam BEQ = 31; localparam BNE = 32; localparam BLT = 33;
localparam BGE = 34; localparam BLTU = 35;localparam BGEU = 36;

//HALT
localparam HALT = 37;

//R Type Addition
localparam SLTU = 38;

always @(*) begin
    case (opType)
        ADD:begin
            src1Mux = 1;
            src2Mux = 0;
            write2RfMux = 2'b0;
            write2RfEn = 1;
            write2DMEn = 0;
            aluSel = 0;

            // isJump = 0;
        end 
        SUB:begin
            src1Mux = 1;
            src2Mux = 0;
            write2RfMux = 2'b0;
            write2RfEn = 1;
            write2DMEn = 0;
            aluSel = 1;

            // isJump = 0;
        end
        SLL:begin
            src1Mux = 1;
            src2Mux = 0;
            write2RfMux = 2'b0;
            write2RfEn = 1;
            write2DMEn = 0;
            aluSel = 8;

            // isJump = 0;
        end
        SLT:begin
            src1Mux = 1;
            src2Mux = 0;
            write2RfMux = 2'b0;
            write2RfEn = 1;
            write2DMEn = 0;
            aluSel = 2;

            // isJump = 0;
        end
        SLTU:begin
            src1Mux = 1;
            src2Mux = 0;
            write2RfMux = 2'b0;
            write2RfEn = 1;
            write2DMEn = 0;
            aluSel = 3;

            // isJump = 0;
        end
        XORR:begin
            src1Mux = 1;
            src2Mux = 0;
            write2RfMux = 2'b0;
            write2RfEn = 1;
            write2DMEn = 0;
            aluSel = 7;

            // isJump = 0;
        end
        SRL:begin
            src1Mux = 1;
            src2Mux = 0;
            write2RfMux = 2'b0;
            write2RfEn = 1;
            write2DMEn = 0;
            aluSel = 9;

            // isJump = 0;
        end
        SRA:begin
            src1Mux = 1;
            src2Mux = 0;
            write2RfMux = 2'b0;
            write2RfEn = 1;
            write2DMEn = 0;
            aluSel = 10;

            // isJump = 0;
        end
        ORR:begin
            src1Mux = 1;
            src2Mux = 0;
            write2RfMux = 2'b0;
            write2RfEn = 1;
            write2DMEn = 0;
            aluSel = 5;

            // isJump = 0;
        end
        AND:begin
            src1Mux = 1;
            src2Mux = 0;
            write2RfMux = 2'b0;
            write2RfEn = 1;
            write2DMEn = 0;
            aluSel = 4;

            // isJump = 0;
        end
        ADDI:begin
            src1Mux = 1;
            src2Mux = 1;
            write2RfMux = 2'b0;
            write2RfEn = 1;
            write2DMEn = 0;
            aluSel = 0;

            // isJump = 0;
        end
        SLTI:begin
            src1Mux = 1;
            src2Mux = 1;
            write2RfMux = 2'b0;
            write2RfEn = 1;
            write2DMEn = 0;
            aluSel = 2;

            // isJump = 0;
        end
        SLTIU:begin
            src1Mux = 1;
            src2Mux = 1;
            write2RfMux = 2'b0;
            write2RfEn = 1;
            write2DMEn = 0;
            aluSel = 3;

            // isJump = 0;
        end
        XORI:begin
            src1Mux = 1;
            src2Mux = 1;
            write2RfMux = 2'b0;
            write2RfEn = 1;
            write2DMEn = 0;
            aluSel = 7; 

            // isJump = 0;
        end
        ORI:begin
            src1Mux = 1;
            src2Mux = 1;
            write2RfMux = 2'b0;
            write2RfEn = 1;
            write2DMEn = 0;
            aluSel = 5;

            // isJump = 0;
        end
        ANDI:begin
            src1Mux = 1;
            src2Mux = 1;
            write2RfMux = 2'b0;
            write2RfEn = 1;
            write2DMEn = 0;
            aluSel = 4;

            // isJump = 0;
        end
        SLLI:begin
            src1Mux = 1;
            src2Mux = 1;
            write2RfMux = 2'b0;
            write2RfEn = 1;
            write2DMEn = 0;
            aluSel = 8;
            
            // isJump = 0;
        end
        SRLI:begin
            src1Mux = 1;
            src2Mux = 1;
            write2RfMux = 2'b0;
            write2RfEn = 1;
            write2DMEn = 0;
            aluSel = 9;

            // isJump = 0;
        end
        SRAI:begin
            src1Mux = 1;
            src2Mux = 1;
            write2RfMux = 2'b0;
            write2RfEn = 1;
            write2DMEn = 0;
            aluSel = 10;

            // isJump = 0;
        end
        LUI:begin
            src1Mux = 1; //其实这里没有用到src1
            src2Mux = 1;
            write2RfMux = 2'b0;
            write2RfEn = 1;
            write2DMEn = 0;
            aluSel = 11;

            // isJump = 0;
        end
        AUIPC:begin
            src1Mux = 0; //choose PC
            src2Mux = 1;
            write2RfMux = 2'b0;
            write2RfEn = 1;
            write2DMEn = 0;
            aluSel = 0;

            // isJump = 0;
        end
        // === L家族的控制输出都是一样的 ===
        LB:begin
            src1Mux = 1;
            src2Mux = 1;
            write2RfMux = 2'b1;
            write2RfEn = 1;
            write2DMEn = 0;
            aluSel = 0;

            // isJump = 0;
        end
        LH:begin
            src1Mux = 1;
            src2Mux = 1;
            write2RfMux = 2'b1;
            write2RfEn = 1;
            write2DMEn = 0;
            aluSel = 0;

            // isJump = 0;
        end
        LW:begin
            src1Mux = 1;
            src2Mux = 1;
            write2RfMux = 2'b1;
            write2RfEn = 1;
            write2DMEn = 0;
            aluSel = 0;

            // isJump = 0;
        end
        LBU:begin
            src1Mux = 1;
            src2Mux = 1;
            write2RfMux = 2'b1;
            write2RfEn = 1;
            write2DMEn = 0;
            aluSel = 0;

            // isJump = 0;
        end
        LHU:begin
            src1Mux = 1;
            src2Mux = 1;
            write2RfMux = 2'b1;
            write2RfEn = 1;
            write2DMEn = 0;
            aluSel = 0;

            // isJump = 0;
        end
        //TODO(S型关于两种不同的内存选取有不同的实现,这里先暂时不谈)
        SB:begin
            src1Mux = 1;
            src2Mux = 1;
            write2RfMux = 2'b0;
            write2RfEn = 0;
            write2DMEn = 1;
            aluSel = 0;

            // isJump = 0;
        end
        SH:begin
            src1Mux = 1;
            src2Mux = 1;
            write2RfMux = 2'b0;
            write2RfEn = 0;
            write2DMEn = 1;
            aluSel = 0;

            // isJump = 0;
        end
        SW:begin
            src1Mux = 1;
            src2Mux = 1;
            write2RfMux = 2'b0;
            write2RfEn = 0;
            write2DMEn = 1;
            aluSel = 0;

            // isJump = 0;
        end

        JAL:begin
            src1Mux = 0;
            src2Mux = 1;
            write2RfMux = 2'd2;
            write2RfEn = 1;
            write2DMEn = 0;
            aluSel = 0;

            // isJump = 1;
        end        
        JALR:begin
            src1Mux = 1;
            src2Mux = 1;
            write2RfMux = 2'd2;
            write2RfEn = 1;
            write2DMEn = 0;
            aluSel = 0;

            // isJump = 1;
        end

        BEQ:begin
            src1Mux = 0;
            src2Mux = 1;
            write2RfMux = 2'b0;
            write2RfEn = 0;
            write2DMEn = 0;
            aluSel = 0;

            // isJump = 0;
        end
        BNE:begin
            src1Mux = 0;
            src2Mux = 1;
            write2RfMux = 2'b0;
            write2RfEn = 0;
            write2DMEn = 0;
            aluSel = 0;

            // isJump = 0;
        end
        BLT:begin
            src1Mux = 0;
            src2Mux = 1;
            write2RfMux = 2'b0;
            write2RfEn = 0;
            write2DMEn = 0;
            aluSel = 0;

            // isJump = 0;
        end
        BGE:begin
            src1Mux = 0;
            src2Mux = 1;
            write2RfMux = 2'b0;
            write2RfEn = 0;
            write2DMEn = 0;
            aluSel = 0;

            // isJump = 0;
        end
        BLTU:begin
            src1Mux = 0;
            src2Mux = 1;
            write2RfMux = 2'b0;
            write2RfEn = 0;
            write2DMEn = 0;
            aluSel = 0;

            // isJump = 0;
        end
        BGEU:begin
            src1Mux = 0;
            src2Mux = 1;
            write2RfMux = 2'b0;
            write2RfEn = 0;
            write2DMEn = 0;
            aluSel = 0;

            // isJump = 0;
        end
        HALT:begin
            src1Mux = 1;
            src2Mux = 0;
            write2RfMux = 2'b0;
            write2RfEn = 0;
            write2DMEn = 0;
            aluSel = 12;

            // isJump = 0;
        end
        default: begin
            src1Mux = 1;
            src2Mux = 0;
            write2RfMux = 2'b0;
            write2RfEn = 0;
            write2DMEn = 0;
            aluSel = 12;

            // isJump = 0;
        end
    endcase 
end
endmodule
