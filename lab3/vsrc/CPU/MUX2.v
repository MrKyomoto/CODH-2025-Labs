`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/06 22:27:02
// Design Name: 
// Module Name: MUX2
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


module MUX2
#(parameter DATA_WIDTH = 32)
(
    input [DATA_WIDTH - 1: 0] in1,
    input [DATA_WIDTH - 1: 0] in2,
    input sel,

    output [DATA_WIDTH - 1: 0] out
);
assign out = (sel == 0) ? in1 : in2;
endmodule
