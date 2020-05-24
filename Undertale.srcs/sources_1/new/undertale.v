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
    
    wire [1:0] page_num;
    wire ena, de;
    wire up, left, down, right, space;
    wire [7:0] command;
    wire [11:0] x, y;
    wire [2:0] intro_rgb, game_rgb, faim_rgb, selected_rgb;
    wire [11:0] rgb;
    wire game_on, faim_on;
    wire [1:0] selection;
    
    // Read Image File
    intro_page intro_page(x, y, intro_rgb);
    menu_page menu_page(clk, page_num==1, x, y, faim_rgb, left, right, selection);
    game_page game_page(clk, page_num==2, x, y, game_rgb, up, left, down, right, space);
    color_decode color_decode(selected_rgb, rgb);
    
    assign selected_rgb = (page_num == 0) ? intro_rgb : (page_num == 1) ? faim_rgb : game_rgb;
    assign {vgaRed, vgaGreen, vgaBlue} = (de) ? rgb : 12'h000;

    // ---------------------------------------------------------------------------
    controller controller(clk, command, ena, de, selection, page_num, up, left, down, right, space);
    vga vga(clk, Hsync, Vsync, x, y, de);
    uart uart(clk, RsRx, RsTx, command, ena);
    
endmodule
