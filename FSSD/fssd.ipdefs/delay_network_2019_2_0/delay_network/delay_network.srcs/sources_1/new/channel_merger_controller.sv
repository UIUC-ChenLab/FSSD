`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/04/2022 07:37:49 AM
// Design Name: 
// Module Name: channel_merger_controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: This module implements the FSM used to control the channel merger
// The FSM is implemented as a synchronous Mealy FSM.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module channel_merger_controller (
    input   logic                       clk,
    input   logic                       rst,
    input   logic                       fifo_empty,
    input   logic                       dwcnt_done,
    output  logic                       fifo_rd_en,
    output  logic                       dwcnt_ld_en,
    output  logic                       tvalid,
    output  logic                       tlast
);

    localparam WAIT_STATE   = 0;
    localparam POP          = 1;
    localparam COUNT        = 2;
    localparam END_COUNT    = 3;             

    // Next values in FSM
    logic fifo_rd_en_n;
    logic dwcnt_ld_en_n;
    logic tvalid_n;
    logic tlast_n;
    
    logic [1:0] state_p, state_n;
    
    /* State transitions are combinational.
    Present values will get udpated on the next 
    clock cycle. */
    always_comb begin
        case(state_p)
            
            WAIT_STATE: begin
                if (fifo_empty) begin
                    fifo_rd_en_n        = 0;
                    dwcnt_ld_en_n       = 0;
                    tvalid_n            = 0;
                    tlast_n             = 0;
                    state_n             = WAIT_STATE;
                end
                else begin
                    fifo_rd_en_n    = 1;
                    dwcnt_ld_en_n   = 0;
                    tvalid_n        = 0;
                    tlast_n         = 0;
                    state_n         = POP;
                end
            end
            
            POP: begin
                fifo_rd_en_n    = 0;
                dwcnt_ld_en_n   = 1;
                tvalid_n        = 0;
                tlast_n         = 0;
                state_n         = COUNT;
            end
            
            /* If mode == 2'b10 then it is a 
            channel contention programming command
            which will be flopped in the top-module. */
            COUNT: begin
                dwcnt_ld_en_n   = 0;
                if (dwcnt_done & fifo_empty) begin
                    tvalid_n        = 1;
                    tlast_n         = 1;
                    fifo_rd_en_n    = 0;
                    state_n         = WAIT_STATE;
                end
                else if (dwcnt_done & ~fifo_empty) begin
                    tvalid_n        = 1;
                    tlast_n         = 1;
                    fifo_rd_en_n    = 1;
                    state_n         = POP;
                end
                else begin
                    tvalid_n        = 1;
                    tlast_n         = 0;
                    fifo_rd_en_n    = 0;
                    state_n         = COUNT;
                end
            end
            
            default: begin
                fifo_rd_en_n    = 0;
                dwcnt_ld_en_n   = 0;
                tvalid_n        = 0;
                tlast_n         = 0;
                state_n         = WAIT_STATE;
            end
        
        endcase
    
    end
    
    // Synchronous logic for FSM
    always_ff @(posedge clk) begin
        if (~rst) begin
            fifo_rd_en      <= 0;
            dwcnt_ld_en     <= 0;
            tvalid          <= 0;
            tlast           <= 0;
            state_p         <= WAIT_STATE;
        end
        else begin
            fifo_rd_en      <= fifo_rd_en_n;
            dwcnt_ld_en     <= dwcnt_ld_en_n;
            tvalid          <= tvalid_n;
            tlast           <= tlast_n;
            state_p         <= state_n;
        end
    end
    
    
    
endmodule

