`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/21/2020 02:30:27 PM
// Design Name: 
// Module Name: intro_page
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


module intro_page(
    input page_num,
    input [11:0] x, y,
    output [2:0] rgb,
    output intro_on
    );
    
    integer i, j;
    parameter IMG_WIDTH = 640;
    parameter IMG_HEIGHT = 480;
  
    reg [2:0] rom [IMG_HEIGHT * IMG_WIDTH - 1:0];
    initial $readmemb("intro.list", rom);
    assign rgb = rom[IMG_WIDTH * y + x];
    assign intro_on = (page_num) ? 0:1;
    
endmodule
