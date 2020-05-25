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
    input clk, on,
    input [11:0] x, y,
    output reg [2:0] rgb,
    input up, left, down, right, space,
    output game_over, defeat_enemy,
    input end_fight, page_num,
    output move_enable
    );
    
    parameter size_out = 60;
    parameter size_in = 57;
    parameter soul_width = 13;
    parameter soul_height = 12;
    parameter speed = 2;
    parameter bulletSpeed = 1;
    parameter bulletStart = 366;
    parameter bulletStart2  = 240 - size_in +1;
    parameter hitDamage = 5;
    
    reg [11:0] pos_x = 320 - soul_width / 2;
    reg [11:0] pos_y = 240 - soul_height / 2;
    reg [5:0] player_hp = 20;
    reg [5:0] monster_hp = 20;
    reg bullet1_hit, bullet2_hit;
    reg monster_hit = 0;
    
    integer bulletPos = 364;
    integer bulletPos2 = 240-size_in-1; 
    integer cnt = 0;
    
    wire soul_on;
    wire [2:0] soul_rgb;
    
    wire [5:0] damage;
    wire in_tap;
    
    // read red_heart image
    image #("soul.list", soul_width, soul_height)(x - pos_x, y - pos_y, soul_rgb, soul_on);
    tap tap(clk, space, x, y, move_enable, damage, in_tap, on);
    always @(x or y) begin
        // draw a red heart
        if (soul_on)
            rgb <= soul_rgb;
        
        // draw white boundaries
        else if ((x > 320 - size_out && x < 320 + size_out && y > 240 - size_out && y < 240 + size_out) &&
                !(x > 320 - size_in && x < 320 + size_in && y > 240 - size_in && y < 240 + size_in))
            rgb <= 3'b111; // WHITE
        
        // draw monster HP bar
        else if (x > 100 && x < 100+ (monster_hp * 10) && y > 350 && y < 360)
            rgb <= 3'b100; // GREEN

        // draw player HP bar
        else if (x > 100 && x < 100+ (player_hp * 10) && y > 370 && y < 375)
            rgb <= 3'b101; // YELLOW
        
        // tap
        else if (in_tap) 
            rgb <= 3'b111; // WHITE
            
        // draw nothing
        else rgb <= 3'b000; // BLACK     
        
        // bullets 
        if (x>bulletPos && x<bulletPos+15 && y>280 && y<284 && ~bullet1_hit) begin
            rgb <= 3'b100;
        end
        if (x>305 && x<309 && y>bulletPos2 && y<bulletPos2+15 && ~bullet2_hit) begin
            rgb <= 3'b100;
        end   
    end
        
//    always @(posedge on) begin
//        pos_x <= 320 - soul_width / 2;
//        pos_y <= 240 - soul_height / 2;
//    end
    
    always @(posedge clk && on) begin
        if(move_enable)
        begin
            // move bullets
            cnt = cnt + 1;
            if (cnt == 1000000) begin
                cnt = 0;
                // bullets 
                bulletPos = (bulletPos < 320-size_in+1) ? bulletStart:bulletPos-bulletSpeed;
                bulletPos2 = (bulletPos2 > 240+size_in-16) ? bulletStart2:bulletPos2+bulletSpeed;  
            end
            
            // bullets collision
            if (x>bulletPos && x<bulletPos+15 && y>280 && y<284 && ~bullet1_hit) begin
                if (soul_on && ~bullet1_hit) begin
                    bullet1_hit = 1;
                    player_hp = (player_hp-hitDamage <= 0) ? 0:player_hp - hitDamage;
                end
            end
            if (x>305 && x<309 && y>bulletPos2 && y<bulletPos2+15 && ~bullet2_hit) begin
                if (soul_on && ~bullet2_hit) begin
                    bullet2_hit = 1;
                    player_hp = (player_hp-hitDamage <= 0) ? 0:player_hp - hitDamage;
                end
            end
        
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

        // start over
        if ((game_over||defeat_enemy)&&page_num<2) begin
            player_hp = 20; // regain full health
            monster_hp = 20;
            bullet1_hit = 0;
            bullet2_hit = 0;
            monster_hit = 0;
        end 
        
    end
    
//    always @(move_enable) begin
//        if(move_enable == 1)
//            if(damage <= monster_hp) monster_hp = monster_hp - damage;
//            else monster_hp = 0;
//    end
    
//    always @(posedge clk && !on) begin
//        // damage enemy when fight is over 
////        if (~monster_hit && end_fight==1) begin
////            monster_hp = (monster_hp-hitDamage <= 0) ? 0:monster_hp - hitDamage;        // future change
////            monster_hit = 1; 
////        end
//        // reset position
//        if (end_fight==1) begin
//            bullet1_hit = 0;
//            bullet2_hit = 0;
//            pos_x = 320 - soul_width / 2;
//            pos_y = 240 - soul_height / 2;
////            monster_hit = 0;
//            monster_hp = (monster_hp-hitDamage <= 0) ? 0:monster_hp - hitDamage;        // future change
//        end
//    end

    
    // game over and win condition check 
    assign game_over = (player_hp<=0) ? 1:0;
    assign defeat_enemy = (monster_hp<=0) ? 1:0;
endmodule
