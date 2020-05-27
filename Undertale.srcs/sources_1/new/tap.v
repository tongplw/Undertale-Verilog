`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/25/2020 02:12:09 AM
// Design Name: 
// Module Name: tap
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


module tap(
        input tap_set,
        input clk,
        input space,
        input [11:0] x, y,
        output reg move_enable,
        output reg [5:0] monster_damage,
        output reg in_tap,
        input on,
        output reg monster_damage_enable,
        input wire [1:0] page_num
    );

    parameter tap_width = 3; // width = 5
    parameter tap_height = 20;
    parameter tap_max = 220;
    parameter tap_min = 120;
    reg [11:0] tap_pos_x = tap_min;
    reg [20:0] counting = 0;
    reg tap_direction = 1;
    initial monster_damage_enable = 0;
    initial move_enable = 0;
    wire [5:0] damage;
    calculate_score calculate_score(clk, tap_pos_x, move_enable, damage);

//    always @(posedge on) begin
//        move_enable <= 0;
//        tap_pos_x <= tap_min;
//    end

    always @(x or y) begin
        if (y > 270 && y < 290) begin
            if(x > 165 && x < 175)
                in_tap <= 1;
            else if (x == 155 || x == 185 || x == 145 || x == 195)
                in_tap <= 1;
            else
                in_tap <= 0;
        end
        else if (x > tap_pos_x - tap_width && x < tap_pos_x + tap_width && y > 295 && y < 295 + tap_height)
            in_tap <= 1;
        else in_tap <= 0;
    end
    
//    always @(posedge tap_set) begin
//        monster_damage_enable = 0;
//        move_enable = 0;
//    end

    always @(posedge clk) begin
        // reset pos when not in fight phase
        if (page_num!=2) begin
            tap_pos_x = tap_min;
        end
        
        if(counting == 0 && !move_enable) begin
            if(tap_direction) begin
                if(tap_pos_x < tap_max) tap_pos_x = tap_pos_x + 1;
                else begin
                    tap_pos_x = tap_pos_x - 1;
                    tap_direction = 0;
                end
            end
            else if (!move_enable) begin
                if(tap_pos_x > tap_min) tap_pos_x = tap_pos_x - 1;
                else begin
                    tap_pos_x = tap_pos_x + 1;
                    tap_direction = 1;
                end
            end
        end
        monster_damage = 0;
        monster_damage_enable = 0;
        //stop tap
        if (space && !move_enable) begin
            move_enable = 1;
            monster_damage = damage;
            monster_damage_enable = 1;
        end
        
        if(tap_set) begin
            monster_damage_enable = 0;
            move_enable = 0;
        end

        counting = counting + 1;
    end
 
endmodule