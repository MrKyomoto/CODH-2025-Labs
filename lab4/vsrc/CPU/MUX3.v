`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/05 20:49:20
// Design Name: 
// Module Name: MUX3
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


module MUX3(
    input [31:0] in1,
    input [31:0] in2,
    input [31:0] in3,
    input [1:0] sel,

    output reg [31:0] out
);
always @(*) begin
    case (sel)
        2'd0:begin
            out = in1;
        end 
        2'd1:begin
            out = in2;
        end
        2'd2:begin
            out = in3;
        end
        default: begin
            out = 32'b0;
        end
    endcase 
end
endmodule
