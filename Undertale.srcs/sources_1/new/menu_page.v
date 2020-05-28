`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/25/2020 12:24:48 AM
// Design Name: 
// Module Name: menu_page
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


module menu_page(
    input clk, on,
    input [11:0] x, y, 
    output reg [2:0] rgb,
    input left, right,
    output reg [1:0] selection,
    input [5:0] player_hp, monster_hp 
    );
        
    wire fight_on, act_on, item_on, mercy_on, soul_on;
    wire [2:0] fight_rgb, act_rgb, item_rgb, mercy_rgb;
    wire [2:0] soul_rgb;

    reg [9:0] pos_x, pos_y;
    
    image #("fight_but.list", 95, 38)(x - 90, y - 400, fight_rgb, fight_on);
    image #("act_but.list", 95, 38)(x - 200, y - 400, act_rgb, act_on);
    image #("item_but.list", 95, 38)(x - 310, y - 400, item_rgb, item_on);
    image #("mercy_but.list", 95, 38)(x - 420, y - 400, mercy_rgb, mercy_on);

    image #("soul.list", 13, 12)(x - pos_x, y - pos_y, soul_rgb, soul_on);

    always @(posedge clk) begin
        if (selection == 0) begin pos_x = 95; pos_y = 413; end
        else if (selection == 1) begin pos_x = 205; pos_y = 413; end
        else if (selection == 2) begin pos_x = 320; pos_y = 413; end
        else if (selection == 3) begin pos_x = 425; pos_y = 413; end
    end

    always @(x or y) begin
        // draw red heart
        if (soul_on)
            rgb <= soul_rgb;

        // draw 4 buttons
        else if (fight_on) rgb <= (selection == 0) ? 3'b101 : fight_rgb;
        else if (act_on) rgb <= (selection == 1) ? 3'b101 : act_rgb;
        else if (item_on) rgb <= (selection == 2) ? 3'b101 : item_rgb;
        else if (mercy_on) rgb <= (selection == 3) ? 3'b101 : mercy_rgb;
        
        // draw monster HP bar
        else if (x > 100 && x < 100+ (monster_hp * 10) && y > 350 && y < 360)
            rgb <= 3'b100; // GREEN

        // draw player HP bar
        else if (x > 100 && x < 100+ (player_hp * 10) && y > 370 && y < 375)
            rgb <= 3'b101; // YELLOW
        
        // draw nothing
        else rgb <= 3'b000; // BLACK
        

    end
    
    always @(posedge clk && on) begin
        if (left) selection = selection - 1;
        if (right) selection = selection + 1;
    end
endmodule
