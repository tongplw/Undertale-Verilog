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

//    function reg is_in_a_heart(input [11:0] pos_x, pos_y, x, y);
//        integer r = 10;
//        is_in_a_heart = ((((x - pos_x)/r)**2 + ((y - pos_y)/r)**2 - 1)**3 - ((x - pos_x)/r)**2 * ((y - pos_y)/r)**3 < 0);
//    endfunction

    integer r = 7;
    integer size_out = 20;
    integer size_in = 18;
    
    always @(x or y) begin
        // display a red dot
        if (r ** 2 > (x - pos_x) ** 2 + (y - pos_y) ** 2)
            rgb <= 3'b110;
        // display boundaries
        else if (pos_x > 320 - size_out && pos_x < 320 + size_out && pos_y > 240 - size_out && pos_y < 240 + size_out &&
                pos_x < 320 - size_in && pos_x > 320 + size_in && pos_y < 240 + size_in && pos_y > 240 + size_in)
            rgb <= 3'b111;
        // display nothing
        else
            rgb <= 3'b000;
    end
    
        
    // move red dot
    integer speed = 2;
    always @(posedge clk) begin
        if (up) pos_y = pos_y - speed;
        if (down) pos_y = pos_y + speed;
        if (left) pos_x = pos_x - speed;
        if (right) pos_x = pos_x + speed;
    end

endmodule
