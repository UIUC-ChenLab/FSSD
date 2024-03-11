`timescale 1ns / 1ps
//----------------------------
// This module implements a positive edge triggered sync reset down counter with a 
// constant load value. The load_val is captured in the pos edge of the load_en_n signal.
// The down counting starts in the cycle of load_en_n being low. When the value of the 
// counter reaches DELAY_PB_HIT, the miss_done signal triggers to let the other elements
// know that the time it takes move the page from the flash array to the pagebuffer is 
// complete and that a burst must begin. Once the burst begins, count_en will be set
// high and the downcounter will downcount until it reaches 1 in which the done signal
// will trigger. This will let the other elements know that the burst is over. It will
// then wait until a new value is loaded to the counter.
//----------------------------


module downcounter
#(
    parameter DOWNCNT_WIDTH = 16
)
(

    input logic clock_t, 
    input logic sync_rst,
    input logic [DOWNCNT_WIDTH-1:0] load_val,
    input logic load_en,
    input logic count_en,

    output logic done
);
    
    logic [DOWNCNT_WIDTH-1:0] count_val, count_next;

    always_ff @(posedge clock_t) begin
        if (!sync_rst || done) begin
            count_val <= '1;
        end
        else if (load_en) begin
            count_val <= load_val;
        end
        else begin
            count_val <= count_next;
        end
    end

    always_comb begin
        count_next = count_val;
        if (count_en) 
            count_next = count_val - 1;        
    end

    assign done = (count_val == '0) ? 1 : 0;

endmodule