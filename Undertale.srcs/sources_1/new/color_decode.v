`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2020 04:59:13 PM
// Design Name: 
// Module Name: color_decode
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


module color_decode(
    input [2:0] code,
    output reg [11:0] hex
    );
    
    reg [11:0] BLACK = 12'h000;
    reg [11:0] GREY = 12'h888;
//    reg [11:0] BLUE = 12'hxxx;
//    reg [11:0] LIGHT_BLUE = 12'hxxx;
//    reg [11:0] GREEN = 12'hxxx;
//    reg [11:0] YELLOW = 12'hxxx;
    reg [11:0] RED = 12'he12;
    reg [11:0] WHITE = 12'hfff;
    
    always @(code)
    begin
        case(code)
            3'b000 : hex = BLACK;
            3'b001 : hex = GREY;
//            3'b010 : hex = BLUE;
//            3'b011 : hex = LIGHT_BLUE;
//            3'b100 : hex = GREEN;
//            3'b101 : hex = YELLOW;
            3'b110 : hex = RED;
            3'b111 : hex = WHITE;
            default : hex = WHITE;
        endcase
    end
    
endmodule
