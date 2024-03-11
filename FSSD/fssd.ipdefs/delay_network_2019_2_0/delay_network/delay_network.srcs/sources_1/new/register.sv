`timescale 1ns / 1ps
//----------------------------
// This module implements a positive edge triggered sync reset register. The 
// data is captured on the positive edge of the clock when load_en is high. 
// dout can be read after the data is registered. 
//---------------------------

module register
#(
    parameter DATA_WIDTH = 16
)
(
    input logic clock_t, 
    input logic sync_rst,
    input logic [DATA_WIDTH-1:0] load_val,
    input logic load_en_n,

    output logic [DATA_WIDTH-1:0] data
);

    always_ff @(posedge clock_t) begin
        if(!sync_rst) begin
            data <= '0;
        end
        else if(load_en_n) begin
            data <= load_val;
        end
    end

endmodule