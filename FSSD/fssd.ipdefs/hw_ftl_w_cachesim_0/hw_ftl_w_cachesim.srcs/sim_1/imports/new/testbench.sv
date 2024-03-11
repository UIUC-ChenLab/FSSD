`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2022 05:22:16 PM
// Design Name: 
// Module Name: testbench
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


module testbench();

localparam addr_width        = 32;
localparam page_size         = 4096;
localparam block_size        = 32;
localparam set_width         = 10;
localparam way_num           = 32;
localparam page_width = $clog2(page_size);
localparam tag_width = addr_width - page_width - set_width;     // default 10
localparam way_width = $clog2(way_num);
localparam set_num = 2**set_width;

localparam page_offset = $clog2(page_size);                         // default 12
localparam block_offset = $clog2(block_size);                       // default 5
localparam tag_offset = addr_width - block_offset - page_offset;    // default 15

parameter num = 10;


bit clk;
always begin
    #5 clk = clk === 1'b0;
end

default clocking tb_clk @ (posedge clk); endclocking

logic [addr_width-1:0]  mem_address;
logic                   addr_valid;
logic                   mem_rw;     // 0 for read, 1 for write
logic [addr_width-1:0]  mem_new_address;
logic                   addr_resp;
logic                   rstn;
logic                   cache_hit;

logic [tag_offset-1:0]   new_tag;
assign new_tag = mem_new_address[addr_width-1:addr_width-tag_offset];

hw_ftl_w_cachesim #(.addr_width(addr_width), .page_size(page_size), .block_size(block_size), .set_width(set_width), .way_num(way_num)) dut (.*);

task reset ();
    $display("Reset");
    rstn <= 1'b0;
    mem_address <= '0;
    addr_valid <= 1'b0;
    mem_rw <= 1'b0;
    ##(4);
    rstn <= 1'b1;
    ##(20);
endtask

logic [31:0] addr_arr [num];
logic [31:0] new_addr_arr [num];

task init_addr_arr();
    for (int i=0; i<num; i++) begin
        addr_arr[i] = $random() & 32'hfffe_0000;
        $display("addr_arr[%0d]: %h", i, addr_arr[i]);
    end
endtask

task read_test();
    $display("Start read_test: read from existing addresses");
    for (int i=0; i<num; i++) begin
        @tb_clk;
        mem_address <= addr_arr[i];
        addr_valid <= 1'b1;
        mem_rw <= 1'b0;
        @(tb_clk iff addr_resp);
        assert (mem_new_address == new_addr_arr[i]) else begin
            $display("ERROR %0d: %0t: expected: %h, detected: %h", `__LINE__, $time, new_addr_arr[i], mem_new_address);
            $finish();
        end
        addr_valid <= 1'b0;
        ##(4);
    end
    $display("Pass read_test");
endtask

task write_new();
    $display("Start write_new: write to existing addresses");
    for (int i=0; i<num; i++) begin
        @tb_clk;
        mem_address <= addr_arr[i];
        addr_valid <= 1'b1;
        mem_rw <= 1'b1;
        @(tb_clk iff addr_resp);
        new_addr_arr[i] <= mem_new_address;
        addr_valid <= 1'b0;
        ##(4);
    end
    $display("Pass write_new");
endtask

task read_new();
    $display("Start read_new: read from new addresses");
    for (int i=0; i<num; i++) begin
        @tb_clk;
        mem_address <= addr_arr[i];
        addr_valid <= 1'b1;
        mem_rw <= 1'b0;
        @(tb_clk iff addr_resp);
        new_addr_arr[i] <= mem_new_address;
        addr_valid <= 1'b0;
        ##(4);
    end
    $display("Pass read_new");
endtask

function set_addr(int addr, int tag);
    if (addr == 0)
        mem_address = {{tag[tag_width-1:0]}, {(addr_width-tag_width){1'b0}}};
    else
        mem_address = addr;
endfunction

task read_req();
    @tb_clk;
    addr_valid <= 1'b1;
    mem_rw <= 1'b0;
    @(addr_resp);
    @tb_clk;
    addr_valid <= 1'b0;
    ##(1);
endtask

task write_req();
    @tb_clk;
    addr_valid <= 1'b1;
    mem_rw <= 1'b1;
    @(addr_resp);
    @tb_clk;
    addr_valid <= 1'b0;
    ##(1);
endtask

initial begin
    // init_addr_arr();
    reset();
    
    // read_new();
    
    // read_test();
    // read_test();
    
    // write_new();
    // read_test();
    // read_test();

    set_addr(0, 80);
    read_req();
    read_req();
    write_req();
    read_req();

    for (int i=0; i<way_num; i++) begin
        set_addr(0, i);
        read_req();
        // ##(4);
    end

    set_addr(0, 80);
    write_req();
    read_req();
    read_req();
    write_req();
    read_req();

    ##(10);
    $finish();
end

initial begin
    ##(10000);
    $display("timeout triggered");
    $finish();
end

endmodule
