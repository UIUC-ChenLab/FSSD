module cache_sim #(
    parameter addr_width = 32,
    parameter page_size = 4096,     // 12 bits
    parameter set_width = 10,
    parameter way_num = 32,
    
    localparam page_width = $clog2(page_size),
    localparam tag_width = addr_width - page_width - set_width,     // default 10
    localparam way_width = $clog2(way_num),
    localparam set_num = 2**set_width
)
(
    // interface with burst ctrl
    input   logic [addr_width-1:0]  mem_address,
    input   logic                   addr_valid,
    output  logic                   addr_resp,
    output  logic                   cache_hit,
    // general signals
    input   logic                   clk,
    input   logic                   rstn
);

// cacheline valid bram
logic [way_num-1:0] cacheline_valid_in, cacheline_valid_out;
logic cacheline_valid_en, cacheline_valid_write;

valid_blk_mem_gen valid_bram (
    .addra(set),
    .clka(clk),
    .dina(cacheline_valid_in),
    .douta(cacheline_valid_out),
    .ena(cacheline_valid_en),
    .wea(cacheline_valid_write), 
    .rsta(~rstn)
);

// logic [way_num-1:0] valid_bram [set_num];
// always_ff @ (posedge clk) begin
//     if (~rstn) begin
//         for (int i=0; i<set_num; i++) begin
//             valid_bram[i] <= '0;
//         end
//         cacheline_valid_out <= '0;
//     end
//     else if (cacheline_valid_en) begin
//         if (cacheline_valid_write)
//             valid_bram[set] <= cacheline_valid_in;
//         else
//             cacheline_valid_out <= valid_bram[set];
//     end
// end

// logic cache_set_full;
// assign cache_set_full = &cacheline_valid_out;

logic [set_width-1:0] set;
assign set = mem_address[addr_width-page_width-1:addr_width-page_width-set_width];

// cacheline tag bram
logic [tag_width*way_num-1:0] cacheline_tag_in, cacheline_tag_out;  // default 320
logic cacheline_tag_en, cacheline_tag_write;

tag_blk_mem_gen tag_bram (
    .addra(set),
    .clka(clk),
    .dina(cacheline_tag_in),
    .douta(cacheline_tag_out),
    .ena(cacheline_tag_en),
    .wea(cacheline_tag_write), 
    .rsta(~rstn)
);

// logic [tag_width*way_num-1:0] tag_bram [set_num];
// always_ff @ (posedge clk) begin
//     if (~rstn) begin
//         for (int i=0; i<set_num; i++) begin
//             tag_bram[i] <= '0;
//         end
//         cacheline_tag_out <= '0;
//     end
//     else if (cacheline_tag_en) begin
//         if (cacheline_tag_write)
//             tag_bram[set] <= cacheline_tag_in;
//         else
//             cacheline_tag_out <= tag_bram[set];
//     end
// end

logic [way_num-1:0] cache_tag_match;
always_comb begin
    for (int i = 0; i < way_num; i++) begin
        if (mem_address[addr_width-1:addr_width-tag_width] == cacheline_tag_out[tag_width*way_num-(i+1)*tag_width +: tag_width])
            cache_tag_match[way_num-1-i] = 1'b1;
        else
            cache_tag_match[way_num-1-i] = 1'b0;
    end
end

// logic cache_hit;
assign cache_hit = |(cacheline_valid_out & cache_tag_match);
// assign cache_hit = &cache_tag_match;

// LRU instance
logic [way_num-1:0] lru_way_in, lru_way_out;
// logic [set_num-1:0] lru_set;
logic lru_read, lru_update, lru_resp;

// assign lru_set = mem_address[addr_width-page_width-1:addr_width-page_width-set_width];

lru #(.set_width(set_width), .way_num(way_num)) lru_ (
    .clk,
    .rstn,
    .way_in(lru_way_in),
    .set,
    .lru_read,
    .lru_update,
    .lru_way(lru_way_out),
    .lru_resp
);

genvar i;
generate
    for (i = 0; i < way_num; i++) begin
        assign cacheline_tag_in[tag_width*(i+1)-1:tag_width*i] = lru_way_out[i] ? mem_address[addr_width-1:addr_width-tag_width] : cacheline_tag_out[tag_width*(i+1)-1:tag_width*i];
//        assign cacheline_tag_in[tag_width-1:tag_width] = lru_way_out[0] ? mem_address[addr_width-1:addr_width-tag_width] : cacheline_tag_out[tag_width-1:tag_width];
        assign cacheline_valid_in[i] = lru_way_out[i] ? 1'b1 : cacheline_valid_out[i];
    end
endgenerate

enum int {IDLE, CACHE_CHECK, UPDATE_LRU, UPDATE_TAG_1, UPDATE_TAG_2, CACHE_RESP} state, next_state;

always_ff @ (posedge clk) begin
    if (~rstn)
        state <= IDLE;
    else
        state <= next_state;
end

always_comb begin : next_state_comb
    next_state = state;
    case (state)
        IDLE:
            if (addr_valid)
                next_state = CACHE_CHECK;
        CACHE_CHECK: 
            next_state = UPDATE_LRU;
        UPDATE_LRU: begin
            if (lru_resp) begin
                if (cache_hit)
                    next_state = CACHE_RESP;
                else
                    next_state = UPDATE_TAG_1;
            end
        end
        UPDATE_TAG_1:
            next_state = UPDATE_TAG_2;
        UPDATE_TAG_2:
            next_state = CACHE_RESP;
        CACHE_RESP:
            next_state = IDLE;
    endcase
end

always_comb begin
    cacheline_valid_en = 1'b0;
    cacheline_tag_en = 1'b0;
    lru_way_in = '0;
    lru_update = 1'b0;
    lru_read = 1'b0;
    // cacheline_tag_in = '0;
    cacheline_tag_write = 1'b0;
    cacheline_valid_write = 1'b0;
    addr_resp = 1'b0;
    case (state)
        IDLE: begin
            if (addr_valid) begin
                cacheline_valid_en = 1'b1;
                cacheline_tag_en = 1'b1;
            end
        end
        CACHE_CHECK: begin
            cacheline_valid_en = 1'b1;
            cacheline_tag_en = 1'b1;
        end
        UPDATE_LRU: begin
            if (cache_hit) begin
                lru_way_in = cache_tag_match;
                lru_update = 1'b1;
            end
            else
                lru_read = 1'b1;
        end
        UPDATE_TAG_1: begin
            // cacheline_valid_in = cacheline_valid_out | lru_way_out;
            // for (int i = 0; i < way_num; i++) begin
            //     if (lru_way_out[i])
            //         cacheline_tag_in[tag_width*(i+1)-1:tag_width*i] = mem_address[addr_width-1:addr_width-tag_width];
            //     else
            //         cacheline_tag_in[tag_width*(i+1)-1:tag_width*i] = cacheline_tag_out[tag_width*(i+1)-1:tag_width*i];
            // end
            cacheline_tag_en = 1'b1;
            cacheline_tag_write = 1'b1;
            cacheline_valid_en = 1'b1;
            cacheline_valid_write = 1'b1;
        end
        UPDATE_TAG_2: begin
            // cacheline_valid_in = cacheline_valid_out | lru_way_out;
            // for (int i = 0; i < way_num; i++) begin
            //     if (lru_way_out[i])
            //         cacheline_tag_in[tag_width*(i+1)-1:tag_width*i] = mem_address[addr_width-1:addr_width-tag_width];
            //     else
            //         cacheline_tag_in[tag_width*(i+1)-1:tag_width*i] = cacheline_tag_out[tag_width*(i+1)-1:tag_width*i];
            // end
            cacheline_tag_en = 1'b1;
            cacheline_tag_write = 1'b1;
            cacheline_valid_en = 1'b1;
            cacheline_valid_write = 1'b1;
        end
        CACHE_RESP:
            addr_resp = 1'b1;
    endcase
end

endmodule