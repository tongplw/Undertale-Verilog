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
    input page_num,
    input [11:0] x, y, 
    output reg [2:0] rgb,
    input up, left, down, right, space
    );
    
    reg [11:0] pos_x = 320;
    reg [11:0] pos_y = 240;


    function reg is_in_a_heart(input [9:0] pos_x, pos_y, x, y);
        integer r = 10; 
        is_in_a_heart = (((x - pos_x)/r)**2 + ((y - pos_y)/r)**2 - 1)**3 - ((x - pos_x)/r)**2 * ((y - pos_y)/r)**3 <= 0;
    endfunction
    
    // display red dot
    always @(x or y)
    if (is_in_heart(pos_x, pos_y, x, y))
        rgb <= 3'b110;
    else
        rgb <= 3'b000;
        
    // move red dot
    always @(posedge clk) begin
        if (up) pos_y = pos_y - 1;
        if (down) pos_y = pos_y + 1;
        if (left) pos_x = pos_x - 1;
        if (right) pos_x = pos_x + 1;
    end

endmodule
