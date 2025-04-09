`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/06 22:27:19
// Design Name: 
// Module Name: ADDER
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


module ADDER#(parameter DATA_WIDTH = 32)(
    input [DATA_WIDTH - 1: 0] in1, 
    input [DATA_WIDTH - 1: 0] in2, 
    output [DATA_WIDTH - 1: 0] out
);
assign out = in1 + in2;
endmodule
