`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/06 22:24:53
// Design Name: 
// Module Name: SE
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


module SE(
    input se_type,
    input [5:0] opType,
    input [11:0] imm12,
    input [19:0] imm20,

    output reg [31:0] imm32
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

//extend imm type
localparam SE32 = 0;//extend as signed
localparam UE32 = 1;//extend as unsigned
reg [12:0] imm12_temp;
reg [20:0] imm20_temp;
always @(*) begin
    imm12_temp = imm12 << 1; 
    imm20_temp = imm20 << 1;
end
always @(*) begin
    case (se_type)
        SE32:begin
            if(opType == ADDI || opType == SLTI || opType == ORI || opType == XORI ||opType == ANDI)begin
                imm32 = {{20{imm12[11]}},imm12[11:0]};
            end 
            else if(opType == LB || opType == LH || opType == LW || opType == LBU || opType == LHU)begin
                imm32 = {{20{imm12[11]}},imm12[11:0]};
            end
            else if(opType == SB || opType == SH || opType == SW)begin
                imm32 = {{20{imm12[11]}},imm12[11:0]};
            end
            else if(opType == JAL)begin
                //SE32(offset20 * 2)
                imm32 = {{12{imm20_temp[20]}},imm20_temp[19:0]};
            end
            else if(opType == JALR)begin
                imm32 = {{20{imm12[11]}},imm12[11:0]};
            end
            else if(opType == BEQ || opType == BNE || opType == BLT || opType == BGE || opType == BLTU || opType == BGEU)begin
                imm32 = {{20{imm12_temp[12]}},imm12_temp[11:0]};
            end
            else if(opType == SLTIU)begin
                imm32 = {{20{imm12[11]}},imm12[11:0]}; 
            end
            else begin
                //do nothing
                imm32 = 32'b0;
            end
        end 
        UE32:begin
            // if(opType == SLTIU)begin
            //     imm32 = {{20{1'b0}},imm12[11:0]}; 
            // end
            if(opType == SLLI || opType == SRLI || opType == SRAI)begin
                imm32 = {{27{1'b0}},imm12[4:0]};
            end
            else if(opType == LUI || opType == AUIPC)begin
                imm32 = {imm20[19:0],{12{1'b0}}};
            end
            else begin
                //do nothing
                imm32 = 32'b0;
            end
        end
        default:begin
            imm32 = 32'b0;
        end
    endcase 
end

endmodule
