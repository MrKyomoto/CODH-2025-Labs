`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/06 21:23:40
// Design Name: 
// Module Name: LUHazard
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


module LUHazard(
    input [5:0] dOptype,
    input [4:0] dRd,
    input [4:0] fRs1, fRs2,

    output reg pcStall, fStall, dFlush
);
//I 访存 Type
localparam LB = 21; localparam LH = 22; localparam LW = 23;
localparam LBU = 24; localparam LHU = 25;

always @(*) begin
    if(dOptype == LB || dOptype == LH || dOptype == LW || dOptype == LBU || dOptype == LHU)begin
        if(dRd != 5'b0)begin
            if(dRd == fRs1 || dRd == fRs2)begin
                pcStall = 1;
                fStall = 1;
                dFlush = 1; 
            end
            else begin
                pcStall = 0;
                fStall = 0;
                dFlush = 0; 
            end
        end
        else begin
            pcStall = 0;
            fStall = 0;
            dFlush = 0; 
        end
    end
    else begin
        pcStall = 0;
        fStall = 0;
        dFlush = 0; 
    end
end
endmodule
