`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2020 01:51:40 PM
// Design Name: 
// Module Name: image
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


module image #(parameter FILE_NAME = "", WIDTH = 0, HEIGHT = 0)(
    input [11:0] x, y,
    output [2:0] rgb,
    output on
    );
    
    reg [2:0] rom [HEIGHT * WIDTH - 1:0];
    initial $readmemb(FILE_NAME, rom);
    
    assign rgb = (x < WIDTH && y < HEIGHT) ? rom[WIDTH * y + x] : 3'b000;
    assign on = (rgb != 3'b000);
 
endmodule
