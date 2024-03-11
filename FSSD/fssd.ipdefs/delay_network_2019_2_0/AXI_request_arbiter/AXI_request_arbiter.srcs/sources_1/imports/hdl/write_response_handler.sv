`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2022 01:23:03 PM
// Design Name: 
// Module Name: write_response_handler
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


module write_response_handler #(
        // Parameters of Axi Master Bus Interface M00_AXI
		parameter integer C_M00_AXI_ID_WIDTH	= 4,
		parameter integer C_M00_AXI_BUSER_WIDTH	= 0,
		
		// Parameters of Axi Slave Bus Interface S01_AXI
		parameter integer C_S01_AXI_ID_WIDTH	= 4,
		parameter integer C_S01_AXI_BUSER_WIDTH	= 0
)
(
        // Ports of Axi Master Bus Interface M00_AXI
		input logic  m00_axi_aclk,
		input logic  m00_axi_aresetn,
		input logic [C_M00_AXI_ID_WIDTH-1 : 0] m00_axi_bid,
		input logic [1 : 0] m00_axi_bresp,
		input logic [C_M00_AXI_BUSER_WIDTH-1 : 0] m00_axi_buser,
		input logic  m00_axi_bvalid,
		output logic  m00_axi_bready,
		
		// Ports of Axi Master Bus Interface S01_AXI
        output logic [C_S01_AXI_ID_WIDTH-1 : 0] s01_axi_bid,
		output logic [1 : 0] s01_axi_bresp,
		output logic [C_S01_AXI_BUSER_WIDTH-1 : 0] s01_axi_buser,
		output logic  s01_axi_bvalid,
		input logic  s01_axi_bready,
		
		// Ports of FIFO Interface
		input logic [C_M00_AXI_ID_WIDTH-1 : 0] fifo_dout,
		input logic fifo_empty,
		output logic fifo_rd
		
    );
    
    // FIFO variable
    localparam ID_READY = 1, FIFO_EMPTY = 2, UNDEFINED = 0;
    logic [C_M00_AXI_ID_WIDTH-1 : 0] target_id;
    logic target_ready, target_refresh, target_load;
    logic [1:0] target_status;
    logic load_fifo_data;
    
    // M00_AXI variable
    logic [C_M00_AXI_ID_WIDTH-1 : 0] bid_buf;
	logic [1 : 0] bresp_buf;
	logic [C_M00_AXI_BUSER_WIDTH-1 : 0] buser_buf;
	logic buf_load;
    
    // CMP variable
    logic id_match;
    assign id_match = (target_status == ID_READY)? (bid_buf == target_id ? 1'b1 : 1'b0) : 1'b0;
    
    // main FSM
    enum int {halt, load_buf, load_fifo, cmp_id, send_resp, refresh_target} state, next_state;
    
    always_ff @(posedge m00_axi_aclk) begin
        if (~m00_axi_aresetn) begin
            state <= halt;
        end
        else begin
            state <= next_state;
        end
    end
    
    always_comb begin
        next_state = state;
        case (state)
            halt: begin
                if (m00_axi_bvalid) begin
                    next_state = load_buf;
                end
            end
            
            load_buf: begin
                if (target_ready)
                    next_state = cmp_id;
                else
                    next_state = load_fifo;
            end
            
            load_fifo: begin
                if (target_ready)
                    next_state = cmp_id;
            end 
               
            cmp_id: begin
                if (id_match) begin
                    next_state = send_resp;
                end
                else begin
                    next_state = halt;
                end
            end
            
            send_resp: begin
                if (s01_axi_bready) begin
                    next_state = refresh_target;
                end
            end
            
            refresh_target: begin
                next_state = halt;
            end
            
            default:;
        endcase
    end
    
    always_comb begin
        m00_axi_bready = '0;
        
        s01_axi_bid = '0;
		s01_axi_bresp = '0;
		s01_axi_buser = '0;
		s01_axi_bvalid = '0;
		
		target_load = '0;
		buf_load = '0;
		target_refresh = '0;
        
        case (state)
            load_buf: begin
                buf_load = 1'b1;
                m00_axi_bready = 1'b1;
            end
            
            load_fifo: begin
                target_load = 1'b1;
            end
        
            send_resp: begin
                s01_axi_bid = bid_buf;
                s01_axi_bresp = bresp_buf;
                s01_axi_buser = buser_buf;
                s01_axi_bvalid = 1'b1;
                
            end
        
            refresh_target: begin
                target_refresh = 1'b1;
            end
            
            default:;
        endcase
        
    end
    
    always_ff @(posedge m00_axi_aclk) begin
        if (~m00_axi_aresetn) begin
            bid_buf <= '0;
            bresp_buf <= '0;
            buser_buf <= '0;
        end
        else if (buf_load) begin
            bid_buf <= m00_axi_bid;
            bresp_buf <= m00_axi_bresp;
            buser_buf <= m00_axi_buser;
        end
    end
    
    // target id FSM
    enum int {idle, check_fifo, empty_status, read_fifo, ready_status } fifo_state, fifo_state_n;
    
    always_ff @(posedge m00_axi_aclk) begin
        if (~m00_axi_aresetn) begin
            fifo_state <= idle;
        end
        else begin
            fifo_state <= fifo_state_n;
        end
    end

    always_comb begin
        fifo_state_n = fifo_state;
        case(fifo_state)
            idle: begin
                if (target_load) begin
                    fifo_state_n = check_fifo;
                end
            end
            
            check_fifo: begin
                if (fifo_empty) begin
                    fifo_state_n = empty_status;
                end
                else begin
                    fifo_state_n = read_fifo;
                end
            end
            
            empty_status: begin
                if (!fifo_empty) begin
                    fifo_state_n = idle;
                end
            end
            
            read_fifo: begin
                fifo_state_n = ready_status;
            end
            
            ready_status: begin
                if (target_refresh) begin
                    fifo_state_n = check_fifo;
                end
            end
            
            default:;
        endcase
    end
    
    always_comb begin
        target_ready = '0;
        target_status = UNDEFINED;
        fifo_rd = '0;
        load_fifo_data = '0;
        case (fifo_state)
            check_fifo: begin
                fifo_rd = ~fifo_empty;
            end
            
            empty_status: begin
                target_status = FIFO_EMPTY;
                target_ready = 1'b1;
            end
            
            read_fifo: begin
                load_fifo_data = 1'b1;
            end
            
            ready_status: begin
                target_status = ID_READY;
                target_ready = 1'b1;
            end
        endcase
    end
    
    always_ff @(posedge m00_axi_aclk) begin
        if (~m00_axi_aresetn) begin
            target_id <= '0;
        end
        else if (load_fifo_data) begin
            target_id <= fifo_dout;
        end
    end
    
endmodule
