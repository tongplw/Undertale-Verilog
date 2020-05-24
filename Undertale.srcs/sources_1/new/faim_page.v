`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2020 09:30:19 PM
// Design Name: 
// Module Name: faim_page
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


module faim_page(
    input clk, faim_on,
    input [11:0] x, y, 
    output reg [2:0] rgb,
    input left, right
    );
    
    reg [1:0] selection = 0;
    
    wire fight_on, act_on, item_on, mercy_on;
    wire [2:0] fight_rgb, act_rgb, item_rgb, mercy_rgb;
    
    image #("fight_but.list", 95, 38)(x - 90, y - 400, fight_rgb, fight_on);
    image #("act_but.list", 95, 38)(x - 200, y - 400, act_rgb, act_on);
    image #("item_but.list", 95, 38)(x - 310, y - 400, item_rgb, item_on);
    image #("mercy_but.list", 95, 38)(x - 420, y - 400, mercy_rgb, mercy_on);

    always @(x or y) begin
        // draw 4 buttons
        if (fight_on) rgb <= (selection == 0) ? 3'b101 : fight_rgb;
        else if (act_on) rgb <= (selection == 1) ? 3'b101 : act_rgb;
        else if (item_on) rgb <= (selection == 2) ? 3'b101 : item_rgb;
        else if (mercy_on) rgb <= (selection == 3) ? 3'b101 : mercy_rgb;
        
        // draw nothing
        else rgb <= 3'b000; // BLACK
    end
    
//    always @(posedge faim_on) begin
//        selection = 0;
//    end
    
    always @(posedge clk) begin
        if (left) selection = selection - 1;
        if (right) selection = selection + 1;
    end
endmodule
