`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/06 22:26:44
// Design Name: 
// Module Name: PC
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


module PC#(parameter DEFAULT_INIT_ADDR = 32'h00400000)(
    input clk,
    input rst,
    input en, //当 en 为高电平时，PC 才会更新，CPU 才会执行指令
    input [31:0] pcIn,
    output reg [31:0] pcOut
);
always @(posedge clk ) begin
    if(rst)begin
        pcOut <= DEFAULT_INIT_ADDR;//FIXME(目前不知道这样是否是正确的) 
    end 
    else if(en == 0)begin
        //TODO do what bro?
        pcOut <= pcOut;
    end
    else begin
        pcOut <= pcIn;
    end   
end
endmodule
