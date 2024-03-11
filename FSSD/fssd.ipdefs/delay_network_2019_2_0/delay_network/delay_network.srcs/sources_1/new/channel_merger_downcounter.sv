`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/04/2022 07:39:32 AM
// Design Name: 
// Module Name: channel_merger_downcounter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Implements the downcounter for the channel merger. This is 
// here to have a programmable amount of channel contention
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module channel_merger_downcounter
#(
    parameter DOWNCNT_WIDTH = 16
)(
    input logic                         clock_t,
    input logic                         sync_rst,
    input logic                         load_en_n,
    input logic                         count_en,
    input logic [DOWNCNT_WIDTH-1:0]     load_val,

    output logic                        done,
    output logic [DOWNCNT_WIDTH-1:0]    count
);
    
    logic [DOWNCNT_WIDTH-1:0] count_p;

    // Combinatorial logic of downcounting
    always_comb begin
        if (count_en) begin
            count_p = count - 1; 
        end
        else begin 
            count_p = count;
        end
    end 

    /* Sequential logic of either loading a 
    new count value or updating the register
    with the new count */
    always_ff @(posedge clock_t) begin
        if(!sync_rst) begin
            count <= '0; 
        end 
        else if(load_en_n) begin
            count <= load_val;
        end
        else begin
            count <= count_p;
        end 
    end 

    /* Sequential logic of outputting when
    the entire delay is done */
    always_ff @(posedge clock_t) begin
       if(!sync_rst) begin
            done <= 0;
       end
       else if(count == 1) begin
            done <= 1;
       end
       else begin
            done <= 0;
       end
    end
endmodule
