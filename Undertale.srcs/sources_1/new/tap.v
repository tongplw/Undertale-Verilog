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
        input clk,
        input space,
//        input tap_start,
        input [11:0] x, y,
        output reg move_enable,
        output [5:0] damage,
        output reg in_tap
    );
    
    parameter tap_width = 3; // width = 5
    parameter tap_height = 20;
    parameter tap_max = 370;
    parameter tap_min = 270;
    reg [11:0] tap_pos_x = tap_min;
    reg [20:0] counting = 0;
    reg tap_direction = 1;
    initial move_enable = 0;

    calculate_score calculate_score(tap_pos_x, damage);

//    always @(tap_start) begin
//        if(tap_start) move_enable = 1;
//    end

    always @(x or y) begin
        if (y > 60 && y < 80) begin
            if(x > 315 && x < 325)
                in_tap <= 1;
            else if (x == 305 || x == 335 || x == 295 || x == 345)
                in_tap <= 1;
            else
                in_tap <= 0;
        end
        else if (x > tap_pos_x - tap_width && x < tap_pos_x + tap_width && y > 85 && y < 85 + tap_height)
            in_tap <= 1;
        else in_tap <= 0;
    end
    
    always @(posedge clk && !move_enable) begin
        if(counting == 0) begin
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
        
        //stop tap
        if (space) begin
            move_enable = 1;
        end
        
        counting = counting + 1;
    end
endmodule
