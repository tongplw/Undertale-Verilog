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
    input [5:0] player_hp, monster_hp,
    input [1:0] page_num,       // new
    input space,
    output wire move_enable,
    output wire [5:0] monster_damage,
    output wire monster_damage_enable,
    input move
    );
        
    wire fight_on, act_on, item_on, mercy_on;
    wire [2:0] fight_rgb, act_rgb, item_rgb, mercy_rgb;
    
    image #("fight_but.list", 95, 38)(x - 90, y - 400, fight_rgb, fight_on);
    image #("act_but.list", 95, 38)(x - 200, y - 400, act_rgb, act_on);
    image #("item_but.list", 95, 38)(x - 310, y - 400, item_rgb, item_on);
    image #("mercy_but.list", 95, 38)(x - 420, y - 400, mercy_rgb, mercy_on);
    
    wire [5:0] damage;
    wire in_tap;
    reg tap_set = 0;

    tap tap(tap_set, clk, space, x, y, move_enable, monster_damage, in_tap, on, monster_damage_enable, page_num, move);
    
    always @(x or y) begin
        // draw 4 buttons
        if (fight_on) rgb <= (selection == 0) ? 3'b101 : fight_rgb;
        else if (act_on) rgb <= (selection == 1) ? 3'b101 : act_rgb;
        else if (item_on) rgb <= (selection == 2) ? 3'b101 : item_rgb;
        else if (mercy_on) rgb <= (selection == 3) ? 3'b101 : mercy_rgb;
        
        // draw monster HP bar
        else if (x > 100 && x < 100+ (monster_hp * 10) && y > 350 && y < 360)
            rgb <= 3'b100; // GREEN

        // draw player HP bar
        else if (x > 100 && x < 100+ (player_hp * 10) && y > 370 && y < 375)
            rgb <= 3'b101; // YELLOW
        
        // tap guage
        else if (in_tap) 
            rgb <= 3'b111; // WHITE
        
        // draw nothing
        else rgb <= 3'b000; // BLACK
        

    end
    
    always @(posedge clk) begin
         
        if (on) begin
            if (left) selection = selection - 1;
            if (right) selection = selection + 1;
            tap_set = 0;
        end
        
        else
            tap_set = 1;
            
    end
endmodule
