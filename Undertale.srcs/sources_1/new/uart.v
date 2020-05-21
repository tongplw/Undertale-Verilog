`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2020 03:34:26 PM
// Design Name: 
// Module Name: uart
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


module uart(
    input clk,
    input RsRx,
    output RsTx,
    output reg [7:0] data_in,
    output reg ena
    );
    
    reg last_rec;
    wire [7:0] data_out;
    wire sent, received, baud;
    
    
    baudrate_gen baudrate_gen(clk, baud);
    receiver receiver(baud, RsRx, received, data_out);
    transmitter transmitter(baud, data_in, ena, sent, RsTx);

    always @(posedge baud)
    begin
        if (ena == 1) ena = 0;
        
        if (~last_rec & received) begin
            data_in = data_out;
            ena = 1;
        end
        last_rec = received;
    end
   
endmodule

module transmitter(
    input clk,
    input [7:0] data_transmit,
    input ena,
    output reg sent,
    output reg bit_out
);
    reg last_ena;
    reg sending = 0;
    reg [7:0] count;
    reg [7:0] temp;
    
    always@(posedge clk) 
    begin
        if (~sending & ~last_ena & ena) 
        begin
            temp <= data_transmit;
            sending <= 1;
            sent <= 0;
            count <= 0;
        end
        
        last_ena <= ena;
        
        if (sending) count <= count + 1;
        else begin count <= 0; bit_out <= 1; end
        
        case (count)
            8'd8: bit_out <= 0;
            8'd24: bit_out <= temp[0];  
            8'd40: bit_out <= temp[1];
            8'd56: bit_out <= temp[2];
            8'd72: bit_out <= temp[3];
            8'd88: bit_out <= temp[4];
            8'd104: bit_out <= temp[5];
            8'd120: bit_out <= temp[6];
            8'd136: bit_out <= temp[7];
            8'd152: begin sent <= 1; sending <= 0; end
        endcase
    end
endmodule

module receiver(
    input clk,
    input bit_in,
    output reg received,
    output reg [7:0] data_out
    );
    
    reg last_bit;
    reg receiving = 0;
    reg [7:0] count;
    
    always@(posedge clk) begin
        if (~receiving & last_bit & ~bit_in) 
        begin
            receiving <= 1;
            received <= 0;
            count <= 0;
        end

        last_bit <= bit_in;
      
        if (receiving) count <= count + 1;
        else count <= 0;
        
        case (count)
            8'd24: data_out[0] <= bit_in;
            8'd40: data_out[1] <= bit_in;
            8'd56: data_out[2] <= bit_in;
            8'd72: data_out[3] <= bit_in;
            8'd88: data_out[4] <= bit_in;
            8'd104: data_out[5] <= bit_in;
            8'd120: data_out[6] <= bit_in;
            8'd136: data_out[7] <= bit_in;
            8'd152: begin received <= 1; receiving <= 0; end
        endcase
    end
endmodule

module baudrate_gen(
    input clk,
    output reg baud
    );
    
    integer counter;
    always @(posedge clk)
    begin
        counter = counter + 1;
        if (counter == 325) begin counter = 0; baud = ~baud; end
    end
endmodule