module hw_ftl_w_cachesim #(
    parameter addr_width        = 32,
    parameter page_size         = 4096,
    parameter block_size        = 32, 
    parameter set_width         = 10,
    parameter way_num           = 32
)
(
    // interface with burst ctrl
    input   logic [addr_width-1:0]  mem_address,
    input   logic                   addr_valid,
    input   logic                   mem_rw,     // 0 for read, 1 for write
    output  logic [addr_width-1:0]  mem_new_address,
    output  logic                   addr_resp,
    output  logic                   cache_hit,
    // general signals
    input   logic                   clk,
    input   logic                   rstn
);

localparam page_offset = $clog2(page_size);                         // default 12
localparam block_offset = $clog2(block_size);                       // default 5
localparam tag_offset = addr_width - block_offset - page_offset;    // default 15

// addr_translation_bram IO and instance
// default BRAM depth 32768
logic addr_translation_bram_en, addr_translation_bram_write;
// [tag_offset] is valid bit
logic [tag_offset:0] assigned_tag_in, assigned_tag_out;

blk_mem_gen_0 addr_translation_bram (
    .addra(mem_address[addr_width-1:block_offset+page_offset]),
    .clka(clk),
    .dina(assigned_tag_in),
    .douta(assigned_tag_out),
    .ena(addr_translation_bram_en),
    // .ena(1'b1),
    .wea(addr_translation_bram_write)
);

// metadata BRAM IO and instance
logic metadata_valid_dina, metadata_valid_douta;
logic metadata_valid_ena, metadata_valid_wea;
logic metadata_valid_dinb, metadata_valid_doutb;
logic metadata_valid_enb, metadata_valid_web;
logic [tag_offset-1:0] metadata_valid_addra, metadata_valid_addrb;

assign metadata_valid_web = 1'b0;
assign metadata_valid_dinb = '0;

blk_mem_gen_1 metadata_valid (
    // addr translation uses port a
    .addra(metadata_valid_addra),
    .clka(clk),
    .dina(metadata_valid_dina),
    .douta(metadata_valid_douta),
    .ena(metadata_valid_ena),
    .wea(metadata_valid_wea),
    // counter incr uses port b
    .addrb(metadata_valid_addrb),
    .clkb(clk),
    .dinb(metadata_valid_dinb),
    .doutb(metadata_valid_doutb),
    .enb(metadata_valid_enb),
    .web(metadata_valid_web)
);

// next valid FIFO
logic next_valid_fifo_full, next_valid_fifo_empty;
logic next_valid_fifo_wr_en, next_valid_fifo_rd_en;
logic [tag_offset-1:0] next_valid_fifo_din, next_valid_fifo_dout;

fifo_generator_0 next_valid_fifo (
    .prog_full (next_valid_fifo_full),
    .din (next_valid_fifo_din),
    .wr_en (next_valid_fifo_wr_en),
    .empty (next_valid_fifo_empty), 
    .dout (next_valid_fifo_dout), 
    .rd_en (next_valid_fifo_rd_en),
    .clk (clk),
    .srst (~rstn)
);

// 2 counters tracking the next available new addr slot
logic [tag_offset-1:0] counter;
logic counter_incr;

always_ff @ (posedge clk) begin
    if (~rstn)
        counter <= '0;
    else if (counter_incr)
        counter <= counter + 1'b1;
end

enum int {counter_idle, counter_search_0, counter_search_1, counter_search_2} search_state, search_next_state;

always_ff @ (posedge clk) begin
    if (~rstn)
        search_state <= counter_idle;
    else 
        search_state <= search_next_state;
end

always_comb begin
    search_next_state = search_state;
    case (search_state)
        counter_idle: begin
            if (~next_valid_fifo_full)
                search_next_state = counter_search_0;
        end
        counter_search_0:
            search_next_state = counter_search_1;
        counter_search_1:
            search_next_state = counter_search_2;
        counter_search_2:
            if (metadata_valid_doutb)
                search_next_state = counter_search_1;
            else
                search_next_state = counter_idle;
    endcase
end

always_comb begin
    metadata_valid_addrb = '0;
    metadata_valid_enb = 1'b0;
    next_valid_fifo_din = '0;
    counter_incr = 1'b0;
    next_valid_fifo_wr_en = 1'b0;
    case (search_state)
        counter_idle:;
        counter_search_0: begin
            metadata_valid_addrb = counter + 1'b1;
            metadata_valid_enb = 1'b1;
            // counter_incr = 1'b1;
        end
        counter_search_1: begin
            metadata_valid_addrb = counter + 1'b1;
            metadata_valid_enb = 1'b1;
            counter_incr = 1'b1;
        end
        counter_search_2: begin
            if (metadata_valid_doutb) begin
                metadata_valid_addrb = counter + 1'b1;
                metadata_valid_enb = 1'b1;
                // counter_incr = 1'b1;
            end
            else begin
                next_valid_fifo_din = counter;
                next_valid_fifo_wr_en = 1'b1;
            end
        end
    endcase
end

// cache simulator
logic [addr_width-1:0] cachesim_mem_address;
logic cachesim_addr_valid, cachesim_resp, cachesim_cache_hit;
assign cachesim_mem_address = mem_address;

cache_sim #(.addr_width(addr_width), .page_size(page_size), .set_width(set_width), .way_num(way_num)) cache_sim_ (
    .mem_address(cachesim_mem_address),
    .addr_valid(cachesim_addr_valid),
    .addr_resp(cachesim_resp),
    .cache_hit(cachesim_cache_hit),
    .clk,
    .rstn
);

// logic cache_hit;
always_ff @ (posedge clk) begin
    if (~rstn)
        cache_hit <= 1'b0;
    else if (cachesim_resp)
        cache_hit <= cachesim_cache_hit;
end

enum int {IDLE, ADDR_CHECK_1, ADDR_CHECK_2, ADDR_CLEAR_1, ADDR_CLEAR_2, ADDR_TRANS_1, ADDR_TRANS_2, ADDR_TRANS_3, ADDR_RESP} state, next_state;

always_ff @ (posedge clk) begin
    if (~rstn)
        state <= IDLE;
    else 
        state <= next_state;
end

always_comb begin
    next_state = state;
    case (state)
        IDLE: begin
            if (addr_valid)
                next_state = ADDR_CHECK_1;
        end
        ADDR_CHECK_1:
            if (cachesim_resp)
                next_state = ADDR_CHECK_2;
        ADDR_CHECK_2: begin
            if (cache_hit)
                next_state = ADDR_RESP;
            else begin
                if (assigned_tag_out[tag_offset]) begin
                    if (mem_rw)
                        next_state = ADDR_CLEAR_1;
                    else
                        next_state = ADDR_RESP;
                end
                else
                    next_state = ADDR_TRANS_1;
            end
        end
        ADDR_CLEAR_1:
            next_state = ADDR_CLEAR_2;
        ADDR_CLEAR_2:
            next_state = ADDR_TRANS_1;
        ADDR_TRANS_1:
            if (~next_valid_fifo_empty)
                next_state = ADDR_TRANS_2;
        ADDR_TRANS_2:
            next_state = ADDR_TRANS_3;
        ADDR_TRANS_3:
                next_state = ADDR_RESP;
        ADDR_RESP: begin
            // if (~addr_valid)
            next_state = IDLE;
        end
    endcase
end

always_comb begin
    cachesim_addr_valid = 1'b0;
    metadata_valid_addra = '0;
    metadata_valid_dina = 1'b0;
    metadata_valid_ena = 1'b0;
    metadata_valid_wea = 1'b0;
    addr_translation_bram_en = 1'b0;
    addr_translation_bram_write = 1'b0;
    assigned_tag_in = '0;
    next_valid_fifo_rd_en = 1'b0;
    mem_new_address = '0;
    addr_resp = 1'b0;
    // counter_flip = 1'b0;
    case (state)
        IDLE: begin
            if (addr_valid) begin
                addr_translation_bram_en = 1'b1;
                cachesim_addr_valid = 1'b1;
            end
        end
        ADDR_CHECK_1:
            addr_translation_bram_en = 1'b1;
        ADDR_CHECK_2:;
        ADDR_CLEAR_1: begin
            metadata_valid_addra = assigned_tag_out[tag_offset-1:0];
            metadata_valid_dina = 1'b0;
            metadata_valid_ena = 1'b1;
            metadata_valid_wea = 1'b1;
        end
        ADDR_CLEAR_2: begin
            metadata_valid_addra = assigned_tag_out[tag_offset-1:0];
            metadata_valid_dina = 1'b0;
            metadata_valid_ena = 1'b1;
            metadata_valid_wea = 1'b1;
        end
        ADDR_TRANS_1: begin
            if (~next_valid_fifo_empty) begin
                // add new translated addr to addr translation bram
                addr_translation_bram_en = 1'b1;
                addr_translation_bram_write = 1'b1;
                assigned_tag_in = {1'b1, next_valid_fifo_dout};
                // add valid bit to new translated address
                metadata_valid_addra = next_valid_fifo_dout;
                metadata_valid_dina = 1'b1;
                metadata_valid_ena = 1'b1;
                metadata_valid_wea = 1'b1;
            end
        end
        ADDR_TRANS_2: begin
            // add new translated addr to addr translation bram
            addr_translation_bram_en = 1'b1;
            addr_translation_bram_write = 1'b1;
            assigned_tag_in = {1'b1, next_valid_fifo_dout};
            next_valid_fifo_rd_en = 1'b1;
            // add valid bit to new translated address
            metadata_valid_addra = next_valid_fifo_dout;
            metadata_valid_dina = 1'b1;
            metadata_valid_ena = 1'b1;
            metadata_valid_wea = 1'b1;
        end
        ADDR_TRANS_3:;
        ADDR_RESP: begin
            mem_new_address = {assigned_tag_out[tag_offset-1:0], mem_address[page_offset+block_offset-1:0]};
            addr_resp = 1'b1;
            // addr_translation_bram_en = 1'b1;
        end
    endcase 
end

endmodule