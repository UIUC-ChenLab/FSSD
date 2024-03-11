`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/03/2022 10:46:53 PM
// Design Name: 
// Module Name: pb_pop_ctrl
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

module pb_pop_ctrl# (
    parameter DOWNCNT_WIDTH = 20, 
    parameter ADDR_WIDTH    = 32,
    parameter MODE_WIDTH    = 2,
    parameter PB_HIT        = 20,
    parameter PB_MISS       = 1000,
    parameter PB_WRITE      = 1000,
    parameter PB_ERASE      = 1000
)(
    input logic                         clock_t, 
    input logic                         sync_rst,
//    input logic [11:0]                  pb_hit,
//    input logic [15:0]                  pb_miss,
//    input logic [17:0]                  pb_write,
//    input logic [19:0]                  pb_erase,
    input logic                         pbfifo_empty,
    input logic                         dwcnt_done,
    input logic [ADDR_WIDTH-1:0]        new_addr_in,
    input logic [ADDR_WIDTH-1:0]        prev_addr, 
    input logic                         master_ready,
    input logic [MODE_WIDTH-1:0]        mode,
    
    output logic                        pbfifo_rd_en,
    output logic                        dwcnt_wr_en,
    output logic                        reg_load_en,
    output logic                        count_en,
    output logic                        tvalid,
    output logic                        tlast,
    output logic [DOWNCNT_WIDTH-1:0]    cnt_load_val
);

    localparam READ         = 0;
    localparam WRITE        = 1;
    localparam ERASE        = 2;

    enum logic [3:0] {WAIT_STATE, POP, LOADCNT, HIT, HIT_COUNT, MISS_COUNT, COUNT, RESP, COMMIT} state_p, state_n;
    
    always_ff @(posedge clock_t) begin
       if (!sync_rst) begin
           state_p <= WAIT_STATE;
       end
       else begin
           state_p <= state_n;
       end
    end

    always_comb begin
        state_n = state_p;
        case(state_p)
            WAIT_STATE: begin
                if (!pbfifo_empty) state_n = POP;
            end
            POP: 
                state_n = LOADCNT;
            LOADCNT: begin
                if (mode == READ) begin
                    if (new_addr_in == prev_addr)
                        state_n = HIT;
                    else 
                        state_n = MISS_COUNT;
                end
                else if (mode == WRITE || mode == ERASE) begin
                    state_n = COUNT;
                end 
            end
            HIT: 
                if (master_ready) state_n = HIT_COUNT;
            HIT_COUNT:
                if (dwcnt_done) state_n = COMMIT;
            MISS_COUNT:
                if (dwcnt_done) state_n = HIT;
            COUNT: 
                if (dwcnt_done) state_n = RESP;
            RESP:
                if (master_ready) state_n = COMMIT;
            COMMIT:
                if (master_ready) begin
                    if (!pbfifo_empty) 
                        state_n = POP;
                    else
                        state_n = WAIT_STATE;
                end
            default: ;
        endcase

        pbfifo_rd_en            = 0;
        dwcnt_wr_en             = 0;
        reg_load_en             = 0;
        count_en                = 0;
        tvalid                  = 0;
        tlast                   = 0;
        cnt_load_val            = 0;
        case(state_p)
            POP: begin
                pbfifo_rd_en    = 1;
            end
            LOADCNT: begin
                dwcnt_wr_en     = 1;
                reg_load_en     = 1;
                if (mode == READ) begin
                    if (new_addr_in == prev_addr)
                        cnt_load_val = PB_HIT;
                    else 
                        cnt_load_val = PB_MISS;
                end
                else if (mode == WRITE) begin
                    cnt_load_val = PB_WRITE;
                end 
                else if (mode == ERASE) begin
                    cnt_load_val = PB_ERASE;
                end 
            end
            HIT: begin
                dwcnt_wr_en     = 1;
                cnt_load_val    = PB_HIT;
                tvalid          = 1;
            end
            HIT_COUNT: begin
                count_en        = 1;
                tvalid          = 1; 
            end
            MISS_COUNT: begin
                count_en        = 1;
            end
            COUNT: begin
                count_en        = 1;
            end
            RESP: begin
                tvalid          = 1;
            end
            COMMIT: begin
                tvalid          = 1;
                tlast           = 1;
            end
            default: ;
        endcase
    end
    
endmodule
