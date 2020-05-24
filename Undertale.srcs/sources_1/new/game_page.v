`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/21/2020 04:19:43 PM
// Design Name: 
// Module Name: game_page
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

module game_page(
    input clk, game_on,
    input [11:0] x, y, 
    output reg [2:0] rgb,
    input up, left, down, right, space
    );
    
    parameter size_out = 60;
    parameter size_in = 57;
    parameter soul_width = 13;
    parameter soul_height = 12;
    parameter speed = 2;
    
    reg [11:0] pos_x, pos_y;
    reg [5:0] player_hp = 20;
    reg [5:0] monster_hp = 20;
    
    wire soul_on;
    wire [2:0] soul_rgb;
    
    // read red_heart image
    image #("soul.list", soul_width, soul_height)(x - pos_x, y - pos_y, soul_rgb, soul_on);

    always @(x or y) begin
        // draw a red heart
        if (soul_on)
            rgb <= soul_rgb;
        
        // draw white boundaries
        else if ((x > 320 - size_out && x < 320 + size_out && y > 240 - size_out && y < 240 + size_out) &&
                !(x > 320 - size_in && x < 320 + size_in && y > 240 - size_in && y < 240 + size_in))
            rgb <= 3'b111; // WHITE
        
        // draw monster HP bar
        else if (x > 100 && x < monster_hp * 15 && y > 350 && y < 360)
            rgb <= 3'b100; // GREEN

        // draw player HP bar
        else if (x > 100 && x < player_hp * 15 && y > 370 && y < 375)
            rgb <= 3'b101; // YELLOW
            
        // draw nothing
        else rgb <= 3'b000; // BLACK        
    end
    
//    always @(posedge game_on) begin
//        pos_x = 320 - soul_width / 2;
//        pos_y = 240 - soul_height / 2;
//    end
        
    always @(posedge clk) begin
        // move red dot
        if (up) pos_y = pos_y - speed;
        if (down) pos_y = pos_y + speed;
        if (left) pos_x = pos_x - speed;
        if (right) pos_x = pos_x + speed;
        
        // boundaries collision
        if (pos_x < 320 - size_in) pos_x = 320 - size_in + 1;
        if (pos_x > 320 + size_in - soul_width) pos_x = 320 + size_in - soul_width;
        if (pos_y < 240 - size_in) pos_y = 240 - size_in + 1;
        if (pos_y > 240 + size_in - soul_height) pos_y = 240 + size_in - soul_height; 
    end

endmodule
