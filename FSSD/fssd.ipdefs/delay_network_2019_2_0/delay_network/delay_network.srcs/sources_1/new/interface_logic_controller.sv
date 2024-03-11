`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/06/2022 02:55:48 AM
// Design Name: 
// Module Name: interface_logic_controller
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


module interface_logic_controller (
    input                   clk,
    input                   sync_rst,
    
    input                   fifo_empty,
    input                   tready,
    input                   fifo_tlast,
    
    output logic tvalid,
    output logic fifo_pop,
    output logic pb_addr_reg_ld_en,
    output logic tdest_reg_ld_en,
    output logic size_reg_ld_en,
    output logic mode_reg_ld_en,
    output logic tid_reg_ld_en,
    output logic tdata_reg_ld_en
);
    

    localparam WAIT_STATE           = 0;
    localparam POP_COMMAND          = 1;
    localparam LOAD_COMMAND         = 2;
    localparam COMMAND              = 3;
    localparam POP_DATA             = 4;
    localparam LOAD_DATA            = 5;
    localparam DATA                 = 6;
    localparam DONE                 = 7;
    
    logic [3:0] state, state_n;
    
    always_ff @(posedge clk) begin
        if(~sync_rst)
            state <= WAIT_STATE;
        else
            state <= state_n;
    end

    // assign next state logic
    always_comb begin
        state_n = state;
        case(state)
            WAIT_STATE: begin
                if(fifo_empty)
                    state_n         = WAIT_STATE;
                else
                    state_n         = POP_COMMAND;
            end

            POP_COMMAND:
                state_n             = LOAD_COMMAND;
            
            LOAD_COMMAND:
                state_n             = COMMAND;

            COMMAND: begin
                if(fifo_tlast) begin
                    if(!tready)
                        state_n = COMMAND;
                    else
                        state_n = WAIT_STATE;
                end
                else
                    state_n     = COMMAND;
            end

            // Currently DATA states not used
            // POP_DATA:
            //     state_n             = LOAD_DATA;
            
            // LOAD_DATA:
            //     state_n         = DATA;
            
            // DATA: begin
            //     if(~tready)
            //         state_n         = DATA;
            //     else
            //         state_n         = DONE;
            // end

            // DONE: begin
            //     if (!tready)
            //         state_n         = DONE;
            //     else
            //         state_n         = WAIT_STATE;
            // end
        endcase
    end

    // assign current state control signals
    always_comb begin
        tvalid                  = 1'b0;
        fifo_pop                = 1'b0;
        pb_addr_reg_ld_en       = 1'b0;
        tdest_reg_ld_en         = 1'b0;
        size_reg_ld_en          = 1'b0;
        mode_reg_ld_en          = 1'b0;
        tid_reg_ld_en           = 1'b0;
        tdata_reg_ld_en         = 1'b0;

        case(state)
            WAIT_STATE:;

            POP_COMMAND:
                fifo_pop            = 1'b1;
            
            LOAD_COMMAND: begin
                pb_addr_reg_ld_en   = 1'b1;
                tdest_reg_ld_en     = 1'b1;
                size_reg_ld_en      = 1'b1;
                mode_reg_ld_en      = 1'b1;
                tid_reg_ld_en       = 1'b1;
                tdata_reg_ld_en     = 1'b1;
            end

            COMMAND: begin
                tvalid              = 1'b1;
            end
            
            default:;
        endcase
    end
endmodule
