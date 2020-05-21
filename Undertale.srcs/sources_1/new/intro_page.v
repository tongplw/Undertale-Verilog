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
    input [11:0] x, y,
    output [2:0] rgb
    );
    
    integer i, j;
    parameter IMG_WIDTH = 480;
    parameter IMG_HEIGHT = 270;
    
    reg [2:0] mem [IMG_HEIGHT - 1:0][IMG_WIDTH - 1:0];
    reg [2:0] rom [IMG_HEIGHT * IMG_WIDTH - 1:0];

    initial 
    begin
        $readmemb("intro.list", rom);
        for(i = 0; i < IMG_HEIGHT; i = i + 1)
            for(j = 0; j < IMG_WIDTH; j = j + 1)
                mem[i][j] = rom[IMG_WIDTH * i + j];
    end
    
    assign rgb = mem[x][y];
    
endmodule
