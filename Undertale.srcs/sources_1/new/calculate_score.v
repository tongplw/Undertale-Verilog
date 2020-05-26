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
        if(x > 315 && x < 325) damage = 5;
        else if (x > 305 && x < 335) damage = 3;
        else if (x > 295 && x < 345) damage = 1;
        else damage = 0;
    end
endmodule