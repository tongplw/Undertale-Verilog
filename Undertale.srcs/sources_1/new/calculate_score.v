`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/25/2020 01:40:23 AM
// Design Name: 
// Module Name: calculate_score
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


module calculate_score(
        input [11:0] x,
        input move_enable,
        output reg [5:0] damage
    );
    always @(x) begin
        if(x > 165 && x < 175) damage = 5;
        else if (x > 155 && x < 185) damage = 3;
        else if (x > 145 && x < 195) damage = 1;
        else damage = 0;
    end
endmodule