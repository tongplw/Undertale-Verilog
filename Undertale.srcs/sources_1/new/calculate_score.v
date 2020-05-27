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
        input clk,
        input [11:0] x,
        input move_enable,
        output reg [5:0] damage
    );
    always @(posedge clk) begin
        if (!move_enable) begin
            if(x > 315 && x < 325) begin damage <= 5; end
            else if (x > 305 && x < 335) begin damage <= 3; end
            else if (x > 295 && x < 345) begin damage <= 1; end
            else begin damage <= 0; end
        end
        else 
            damage <= 0;     // just in case, to prevent error
    end
endmodule