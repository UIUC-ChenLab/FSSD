`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/03/2022 10:46:53 PM
// Design Name: 
// Module Name: pagebuffer
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

module pagebuffer#(
    parameter PB_ADDR_WIDTH                 = 32,
    parameter MODE_WIDTH                    = 2,    
    parameter TXID_WIDTH                    = 4,
    //parameter TDATA_WIDTH                   = 128,
    parameter TUSER_WIDTH                   = 2,
    parameter DOWNCNT_WIDTH                 = 20,
    parameter PB_HIT        = 20,
    parameter PB_MISS       = 1000,
    parameter PB_WRITE      = 1000,
    parameter PB_ERASE      = 1000
)(
    input logic                         clock_t,
    input logic                         sync_rst,
    input logic                         addr_valid,
    input logic [PB_ADDR_WIDTH-1:0]     new_addr_in,
    input logic [MODE_WIDTH-1:0]        mode,
    input logic [TXID_WIDTH-1:0]        txid_in,
    //input logic [TDATA_WIDTH-1:0]       tdata_in,
    input logic                         master_ready,
    
    output logic [TXID_WIDTH-1:0]       txid_out,
    //output logic [TDATA_WIDTH-1:0]      tdata_out, // pass read request
    output logic [TUSER_WIDTH-1:0]      tuser_out,
    output logic                        tvalid,
    output logic                        tlast,
    output logic                        pb_ready
);

    // Containing the address in pagebuffer
    logic [PB_ADDR_WIDTH-1:0] prev_addr;
    
    // Wires coming out of FIFO
    logic [PB_ADDR_WIDTH-1:0]   out_fifo_addr;
    logic [TXID_WIDTH-1:0]      out_fifo_txid;
    //logic [TDATA_WIDTH-1:0]     out_fifo_tdata;
    logic [MODE_WIDTH-1:0]      out_fifo_mode;
    
    // Downcounter related signals
    logic dwcnt_done;
    logic dwcnt_wr_en;
    logic count_en;
    
    logic reg_load_en;
    logic pbfifo_rd_en;
    logic pbfifo_full;
    logic pbfifo_empty;
    logic [DOWNCNT_WIDTH-1:0] cnt_load_val;

    
    // Registers holding the latencies
    logic [11:0]  pb_hit = 'h013;
    logic [15:0]  pb_miss = 'h193e;
    logic [17:0]  pb_write = 'h227c; // TODO: change write and erase latency
    logic [19:0]  pb_erase = 'h493e;

    // Hooking up FIFO directly to AXI
    assign pb_ready = ~pbfifo_full;
    
    pb_pop_ctrl #(
        .DOWNCNT_WIDTH(DOWNCNT_WIDTH),
        .ADDR_WIDTH(PB_ADDR_WIDTH),
        .MODE_WIDTH(MODE_WIDTH),
        .PB_HIT(PB_HIT),
        .PB_MISS(PB_MISS),
        .PB_WRITE(PB_WRITE),
        .PB_ERASE(PB_ERASE)
    ) pop_ctrl(
        .clock_t(clock_t), 
        .sync_rst(sync_rst),
        .pbfifo_empty(pbfifo_empty),
        .dwcnt_done(dwcnt_done),
        .new_addr_in(out_fifo_addr),
        .prev_addr(prev_addr),
        .master_ready(master_ready),
        .mode(out_fifo_mode),
        .pbfifo_rd_en(pbfifo_rd_en),
        .dwcnt_wr_en(dwcnt_wr_en),
        .reg_load_en(reg_load_en),
        .count_en(count_en),
        .tvalid(tvalid),
        .tlast(tlast),
        .cnt_load_val(cnt_load_val)
    );
    
    register  #(
        .DATA_WIDTH(PB_ADDR_WIDTH)
    ) prevaddr (
        .clock_t(clock_t), 
        .sync_rst(sync_rst),
        .load_val(out_fifo_addr),
        .load_en_n(reg_load_en),
        .data(prev_addr)
    );
    
    register  #(
        .DATA_WIDTH(TXID_WIDTH)
    ) txid_reg (
        .clock_t(clock_t), 
        .sync_rst(sync_rst),
        .load_val(out_fifo_txid),
        .load_en_n(reg_load_en),
        .data(txid_out)
    );
    
    register  #(
        .DATA_WIDTH(TUSER_WIDTH)
    ) tdata_reg (
        .clock_t(clock_t), 
        .sync_rst(sync_rst),
        .load_val(out_fifo_mode),
        .load_en_n(reg_load_en),
        .data(tuser_out)
    );

    downcounter #(
        .DOWNCNT_WIDTH(DOWNCNT_WIDTH)
    ) downcounter_cnt (
        .clock_t(clock_t),
        .sync_rst(sync_rst),
        .load_val(cnt_load_val), 
        .load_en(dwcnt_wr_en),
        .done(dwcnt_done),
        .count_en(count_en)
    );

    fifo_generator_0 pbpbfifo (
      .clk(clock_t),
      .srst(~sync_rst),                 // Making the rst active low
      .din({mode, txid_in, new_addr_in}),
      .wr_en(addr_valid),
      .rd_en(pbfifo_rd_en),
      .dout({out_fifo_mode, out_fifo_txid, out_fifo_addr}),
      .full(pbfifo_full),
      .empty(pbfifo_empty)
    );


endmodule
