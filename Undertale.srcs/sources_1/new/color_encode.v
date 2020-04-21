`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2020 05:02:53 PM
// Design Name: 
// Module Name: color_encode
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


module color_encode(
    input [11:0] hex,
    output reg [2:0] code
    );
    
    reg [11:0] BLACK = 12'h000;
    reg [11:0] GREY = 12'h888;
//    reg [11:0] BLUE = 12'hxxx;
//    reg [11:0] LIGHT_BLUE = 12'hxxx;
//    reg [11:0] GREEN = 12'hxxx;
//    reg [11:0] YELLOW = 12'hxxx;
    reg [11:0] RED = 12'he12;
    reg [11:0] WHITE = 12'hfff;
    
    always @(hex)
    begin
        case(hex)
            BLACK : code = 3'b000;
            GREY : code = 3'b001;
//            BLUE : code = 3'b010;
//            LIGHT_BLUE : code = 3'b011;
//            GREEN : code = 3'b100;
//            YELLOW : code = 3'b101;
            RED : code = 3'b110;
            WHITE : code = 3'b111;
            default : code = 3'b111;
        endcase
    end
endmodule
