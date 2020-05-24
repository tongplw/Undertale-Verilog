`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2020 02:49:41 PM
// Design Name: 
// Module Name: bullet
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


module bullet(
    input [11:0] x,y,
    output reg [2:0] rgbCode,
    output bulletOn
    );
    
    // bullet color 
    localparam BULLET_COLOR = 3'b011;
    
    // 1st bullet params
    localparam LENGHT = 10;
    localparam THICKNESS = 3;
    localparam V_START_POINT_1 = 240;
    
    
endmodule
