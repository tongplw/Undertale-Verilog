`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/21/2020 04:09:31 PM
// Design Name: 
// Module Name: controller
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


module controller(
    input clk,
    input [7:0] command,
    input ena, de,
    output reg page_num,
    output reg up, left, down, right, space
    );
    
    reg change_page = 0;
    reg push = 0;
    initial page_num = 0;
    
    always @(posedge clk) begin
        if (ena == 1 && push == 0) begin
            push = 1;
            case(command)
                8'h0D : change_page = 1;        // ENTER_KEY
                8'h20 : space = 1;              // SPACE_KEY
                8'h77 : up = 1;                 // W_KEY
                8'h61 : left = 1;               // A_KEY
                8'h73 : down = 1;               // S_KEY
                8'h64 : right = 1;              // D_KEY          
            endcase
        end
        else if (ena == 1 && push == 1) begin
            up = 0;
            left = 0;
            down = 0;
            right = 0;
            space = 0;
        end
        else begin
            push = 0;
            
            // change page only when displaying nothing
            if (~de && change_page) begin
                change_page = 0;
                page_num = ~page_num;
            end
        end

    end
    
endmodule
