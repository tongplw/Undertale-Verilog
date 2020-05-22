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
    
    wire page_num, ena, de;
    wire up, left, down, right, space;
    wire [7:0] command;
    wire [11:0] x, y;
    wire [2:0] intro_rgb, game_rgb, selected_rgb;
    wire [11:0] rgb;
    
    // Read Image File
    intro_page intro_page(page_num, x, y, intro_rgb);
    game_page game_page(clk, page_num, x, y, game_rgb, up, left, down, right, space);
//    color_decode color_decode(selected_rgb, rgb);
    
    assign selected_rgb = (page_num == 0) ? intro_rgb : game_rgb;
    assign {vgaRed, vgaGreen, vgaBlue} = rgb;
    assign rgb = (de) ? 12'h0f0 : 12'h000;
    
    // ---------------------------------------------------------------------------
    controller controller(clk, command, ena, page_num, up, down, left, right, space);
    vga vga(clk, Hsync, Vsync, x, y, de);
    uart uart(clk, RsRx, RsTx, command, ena);
    
endmodule
