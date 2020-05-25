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
    input clk,
    input [11:0] x, y, 
    output reg [2:0] rgb,
    input up, left, down, right, space,
    input [1:0] page_num,
    output game_over
    );
    
    parameter size_out = 60;
    parameter size_in = 57;
    parameter soul_width = 13;
    parameter soul_height = 12;
    parameter speed = 5;
    parameter bulletSpeed = 1;
    parameter bulletStart = 366;
    parameter bulletStart2  = 240 - size_in +1;
    parameter hitDamage = 5;
    
    reg [11:0] start_pos_x, start_pos_y;    
    reg [11:0] pos_x, pos_y;
    reg [5:0] player_hp = 20;
    reg [5:0] monster_hp = 20;
    reg bullet1_hit, bullet2_hit;
    
    integer bulletPos = 364;
    integer bulletPos2 = 240-size_in-1; 
    integer cnt = 0;
    
    
    wire soul_on;
    wire [2:0] soul_rgb;
    
    // init 
    initial begin
        start_pos_x = pos_x;
        start_pos_y = pos_y;
    end
    
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
        else if (x > 100 && x < 100 + monster_hp * 10 && y > 350 && y < 360)
            rgb <= 3'b100; // GREEN

        // draw player HP bar
        else if (x > 100 && x < 100 + player_hp * 10 && y > 370 && y < 375)
            rgb <= 3'b101; // YELLOW
        
        // draw nothing
        else rgb <= 3'b000; // BLACK    
        
        if (x>bulletPos && x<bulletPos+15 && y>240 && y<244 && ~bullet1_hit) begin
            rgb <= 3'b100;
        end
        if (x>305 && x<309 && y>bulletPos2 && y<bulletPos2+15 && ~bullet2_hit) begin
            rgb <= 3'b100;
        end
        
    end
    
//    always @(page_num) begin
//        pos_x = 320 - soul_width / 2;
//        pos_y = 240 - soul_height / 2;
//    end
        
    always @(posedge clk) begin

        // restart game 
        if (page_num < 2) begin
            bullet1_hit = 0;
            bullet2_hit = 0;
            pos_x = start_pos_x;
            pos_y = start_pos_y;
        end
        // move red dot
        if (up) pos_y = pos_y - speed;
        if (down) pos_y = pos_y + speed;
        if (left) pos_x = pos_x - speed;
        if (right) pos_x = pos_x + speed;

        cnt = cnt + 1;
        if (cnt == 1000000) begin
            cnt = 0;
            // bullets 
            bulletPos = (bulletPos < 320-size_in+1) ? bulletStart:bulletPos-bulletSpeed;
            bulletPos2 = (bulletPos2 > 240+size_in-16) ? bulletStart2:bulletPos2+bulletSpeed;  
        end
        
        // collision
        if (x>bulletPos && x<bulletPos+15 && y>240 && y<244 && ~bullet1_hit) begin
            if (soul_on && ~bullet1_hit) begin
                bullet1_hit = 1;
                player_hp = (player_hp <= 0) ? 0:player_hp - hitDamage;
            end
        end
        if (x>305 && x<309 && y>bulletPos2 && y<bulletPos2+15 && ~bullet2_hit) begin
            if (soul_on && ~bullet2_hit) begin
                bullet2_hit = 1;
                player_hp = (player_hp <= 0) ? 0:player_hp - hitDamage;
            end
        end
        
        // boundaries collision
        if (pos_x < 320 - size_in) pos_x = 320 - size_in + 1;
        if (pos_x > 320 + size_in - soul_width) pos_x = 320 + size_in - soul_width;
        if (pos_y < 240 - size_in) pos_y = 240 - size_in + 1;
        if (pos_y > 240 + size_in - soul_height) pos_y = 240 + size_in - soul_height; 
        
        // start over
        if (game_over&&page_num<2) begin
            player_hp = 20; // plus  for something lmao
        end 
    end

    // check game over
    assign game_over = (player_hp<=0) ? 1:0;
endmodule
