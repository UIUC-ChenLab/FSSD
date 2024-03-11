module lru #(
    parameter set_width = 10,
    parameter way_num = 32
)
(
    // general signals
    input   logic                   clk,
    input   logic                   rstn,
    // lru ways
    input   logic [way_num-1:0]     way_in, 
    input   logic [set_width-1:0]   set,
    input   logic                   lru_read,   // get lru and update from current lru
    input   logic                   lru_update, // update lru from the used way
    output  logic [way_num-1:0]     lru_way,
    output  logic                   lru_resp
);

logic [way_num-1:0] lru_array_out, lru_array_in;
logic lru_array_en, lru_array_write;

lru_blk_mem_gen lru_bram (
    .addra(set),
    .clka(clk),
    .dina(lru_array_in),
    .douta(lru_array_out),
    .ena(lru_array_en),
    .wea(lru_array_write), 
    .rsta(~rstn)
);

logic [way_num-1:0] next_lru_array, used_way;
logic used_way_ld;
logic next_lru_array_full;
assign lru_way = (~lru_array_out) & (lru_array_out + 1'b1);
assign next_lru_array = lru_array_out | used_way;
assign next_lru_array_full = &next_lru_array;

always_ff @(posedge clk) begin
    if (~rstn)
        used_way <= '0;
    else if (used_way_ld)
        used_way <= lru_read ? lru_way : way_in;
end

enum int {IDLE, LRU_READ, LRU_RESP, LRU_UPDATE_1, LRU_UPDATE_2} state, next_state;

always_ff @(posedge clk) begin
    if (~rstn)
        state <= IDLE;
    else
        state <= next_state;
end

always_comb begin
    next_state = state;
    case (state)
        IDLE: begin
            if (lru_read | lru_update)
                next_state = LRU_READ;
        end
        LRU_READ:
            next_state = LRU_RESP;
        LRU_RESP:
            next_state = LRU_UPDATE_1;
        LRU_UPDATE_1:
            next_state = LRU_UPDATE_2;
        LRU_UPDATE_2:
            next_state = IDLE;
    endcase
end

always_comb begin
    lru_array_en = 1'b0;
    lru_resp = 1'b0;
    used_way_ld = 1'b0;
    lru_array_write = 1'b0;
    lru_array_in = '0;
    case (state)
        IDLE: begin
            if (lru_read | lru_update) begin
                lru_array_en = 1'b1;
            end
        end
        LRU_READ: 
            lru_array_en = 1'b1;
        LRU_RESP: begin
            lru_resp = 1'b1;
            used_way_ld = 1'b1;
        end
        LRU_UPDATE_1: begin
            lru_array_en = 1'b1;
            lru_array_write = 1'b1;
            lru_array_in = next_lru_array_full ? '0 : next_lru_array;
        end
        LRU_UPDATE_2: begin
            lru_array_en = 1'b1;
            lru_array_write = 1'b1;
            lru_array_in = next_lru_array_full ? '0 : next_lru_array;
        end
    endcase
end

endmodule