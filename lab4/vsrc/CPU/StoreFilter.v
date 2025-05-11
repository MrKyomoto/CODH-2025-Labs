`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/07 21:18:32
// Design Name: 
// Module Name: StoreFilter
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


module StoreFilter(
    input [31:0] srcRf,
    input [31:0] srcDm,
    input [1:0] offset,
    input [5:0] opType,

    output reg [31:0] wdata,
    output reg we
);
//S Type
localparam SB = 26; localparam SH = 27; localparam SW = 28;

always @(*) begin
    case (opType)
        SB:begin
            case (offset)
                2'b00:begin
                    wdata  = {srcDm[31:8],srcRf[7:0]};
                end 
                2'b01:begin
                    wdata = {srcDm[31:16],srcRf[7:0],srcDm[7:0]};
                end
                2'b10:begin
                    wdata = {srcDm[31:24],srcRf[7:0],srcDm[15:0]};
                end
                2'b11:begin
                    wdata = {srcRf[7:0],srcDm[23:0]};
                end
                default:begin
                    wdata = 32'b0;
                end 
            endcase
            we = 1;
        end 
        SH:begin
            case (offset)
                2'b00:begin
                    wdata = {srcDm[31:16],srcRf[15:0]};
                end 
                2'b10:begin
                    wdata = {srcRf[15:0],srcDm[15:0]};
                end
                default:begin
                    wdata = 32'b0;
                end
            endcase
            we = 1;
        end
        SW:begin
            wdata = srcRf;
            we = 1;
        end
        default:begin
            wdata = 0;
            we = 0;
        end
    endcase 
end
endmodule
