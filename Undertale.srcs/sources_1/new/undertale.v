`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2020 11:37:48 AM
// Design Name: 
// Module Name: Undertale
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


module undertale(
    input clk,
    input RsRx,
    output RsTx,
    output [3:0] vgaRed, vgaGreen, vgaBlue,
    output Hsync, Vsync
    );
    
//    reg clk = 0;
//    always #1 clk = ~clk;

    wire [11:0] x, y, rgb;
    
    vga vga(clk, Hsync, Vsync, {vgaRed, vgaGreen, vgaBlue}, x, y, rgb);
    screen screen(clk, _wr, _x, _y, _rgb, x, y, rgb);
    uart uart(clk, RsRx, RsTx);
    
endmodule
