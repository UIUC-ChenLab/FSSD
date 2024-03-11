`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2022 04:01:07 PM
// Design Name: 
// Module Name: cam
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


module cam #(
    parameter key_width = 4,
    parameter val_width = 128,
    parameter depth = 16
)
(
    input logic clk,
    input logic arstn,
    input logic read,
    input logic write,
    input logic [key_width-1:0] key_r,
    input logic [key_width-1:0] key_w,
    input logic [val_width-1:0] val_i,
    output logic [val_width-1:0] val_o,
    output logic valid_o,
    output logic cam_full
    );

logic [val_width-1:0] val_buffer[depth-1:0] = '{default: '0};
logic [key_width-1:0] key_buffer[depth-1:0] = '{default: '0};

logic [depth-1:0] status = '0;
logic [depth-1:0] hits;

logic hit;
assign hit = |hits;

logic [$clog2(depth)-1:0] hit_idx, write_idx;

assign cam_full = &status;

genvar i;
generate 
    for (i=0; i<depth; i++) begin
        assign hits[i] = read & (key_buffer[i] == key_r);
    end
endgenerate

always_comb begin
    write_idx = 0;
    for (int i=0; i<depth; i++) begin
        if (status[i] == 0) begin
            write_idx = i;
            break;
        end
    end
end

always_comb begin
    hit_idx = 0;
    for (int i=0; i<depth; i++) begin
        if (read && (key_buffer[i] == key_r)) begin
            hit_idx = i;
            break;
        end
    end
end

always_ff @(posedge clk) begin
    if(~arstn) begin
        val_buffer <= '{default:'0};
        key_buffer <= '{default:'1};
        status <= '0;
        valid_o <= '0;
    end
    else if(read | write) begin
        if (write) begin
            key_buffer[write_idx] <= key_w;
            val_buffer[write_idx] <= val_i;
            status[write_idx] <= 1;
        end
        if (read) begin
            if (hit) begin
                val_o <= val_buffer[hit_idx];
                valid_o <= 1;
                status[hit_idx] <= 0;
                key_buffer[hit_idx] <= '1;
                val_buffer[hit_idx] <= '0;
            end
        end
    end 
    else begin
        val_o <= '0;
        valid_o <= '0;
    end
end  
    
endmodule
