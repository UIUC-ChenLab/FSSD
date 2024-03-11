`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/06/2022 03:36:20 AM
// Design Name: 
// Module Name: delay_network_tb
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


module delay_network_tb();

    parameter TEST                      = 6;
    parameter NUM_MESSAGES              = 6;
    
    parameter CLOCK_PERIOD              = 20;
    parameter NUM_WAIT_CYCLES           = 60;
    parameter DATA_WIDTH                = 64;
    parameter DATA_OUT_WIDTH            = 64;
    parameter ID_WIDTH                  = 4;
    parameter ADDR_WIDTH                = 32;
    parameter TUSER_WDITH               = 34;
    parameter TAG_HIGH_ADDR             = 37;
    parameter TAG_LOW_ADDR              = 34;
    parameter MODE_HIGH_ADDR            = 33;
    parameter MODE_LOW_ADDR             = 32;
    parameter ADDR_HIGH_ADDR            = 31;
    parameter ADDR_LOW_ADDR             = 0;
    parameter USER_WIDTH                = 2;
    
    /* Possible modes */
    localparam READ         = 0;
    localparam WRITE        = 1;
    localparam ERASE        = 2;
    
    integer                 i;
    wire                    received_all_messages;
    reg [NUM_MESSAGES-1:0]  received_id;
    reg [31:0]              counter;
    
    // Stores all of the data that we are planning on sending in for a given test
    reg [ADDR_WIDTH-1:0]    addresses [NUM_MESSAGES-1:0];

    reg [1:0]               config_bits [NUM_MESSAGES-1:0];
    reg [7:0]               dest_addr [NUM_MESSAGES-1:0];

    reg                     clk;
    reg                     arstn;
    reg                     m01_axis_tready;
    reg [DATA_WIDTH-1:0]    s01_axis_tdata;
    reg                     s01_axis_tvalid;
    reg                     s01_axis_tlast;
    wire [ID_WIDTH-1:0]     m01_axis_tid;

    wire                    m01_axis_tvalid;
    wire                    s01_axis_tready;
    wire [USER_WIDTH-1:0]   m01_axis_tuser;

    delay_network_wrapper #(
        .PB_HIT(2),
        .PB_MISS(5),
        .PB_WRITE(50),
        .PB_ERASE(400),
        .CHANNEL(16),
        .DIE_PER_CHANNEL(1),
        .PLANE_PER_DIE(1),
        .PAGE_BUFFER_SIZE(4096)
    ) dn(
        .clk(clk),
        .arstn(arstn),
        .s01_axis_tready(s01_axis_tready),
        .s01_axis_tvalid(s01_axis_tvalid),
        .s01_axis_tdata(s01_axis_tdata),
        .s01_axis_tlast(s01_axis_tlast),
        .m01_axis_tready(m01_axis_tready),
        .m01_axis_tvalid(m01_axis_tvalid),
        .m01_axis_tuser(m01_axis_tuser),
        .m01_axis_tid(m01_axis_tid)
    );

    assign received_all_messages = &received_id;
    
    always begin
        clk <= ~clk;
        #(CLOCK_PERIOD/2);
    end

    initial begin
    
        for(i = 0; i < NUM_MESSAGES; i++) begin
            received_id[i] = 0;
            if (i==0) begin
                config_bits[i]          = READ;
                addresses[i]            = 'h70008000;
                dest_addr[i]            = 'h01;
            end
            else if (i==1) begin
                config_bits[i]          = WRITE;
                addresses[i]            = 'h70000000;
                dest_addr[i]            = 'h00;
            end
            else if (i==2) begin
                config_bits[i]          = READ;
                addresses[i]            = 'h70002000;
                dest_addr[i]            = 'h10;
            end
            else if (i==3) begin
                config_bits[i]          = WRITE;
                addresses[i]            = 'h70001000;
                dest_addr[i]            = 'h20;
            end
            else if (i==4) begin
                config_bits[i]          = READ;
                addresses[i]            = 'h7000c000;
                dest_addr[i]            = 'h11;
            end
            else if (i==5) begin
                config_bits[i]          = READ;
                addresses[i]            = 'h70002000;
                dest_addr[i]            = 'h10;
            end
        end
        
        // Starting the testbench
        clk <= 0;
        arstn = 1'b0;
        #CLOCK_PERIOD;
        #CLOCK_PERIOD;
        #CLOCK_PERIOD;
        #CLOCK_PERIOD;
        #CLOCK_PERIOD;
        #CLOCK_PERIOD;
        #CLOCK_PERIOD;
        #CLOCK_PERIOD;
        #CLOCK_PERIOD;
        #CLOCK_PERIOD;
        #CLOCK_PERIOD;
        #CLOCK_PERIOD;
        #CLOCK_PERIOD;
        #CLOCK_PERIOD;
        #CLOCK_PERIOD;
        #CLOCK_PERIOD;
        arstn = 1'b1;
        
        @(clk iff received_all_messages == 1)
        $finish;
    end

    always@(posedge clk) begin
        if(arstn == 1'b0) begin
            s01_axis_tvalid     <= 1'b0;
            s01_axis_tdata      <= 128'd0;
            counter             <= 0;
        end
        else begin
            if(counter >= NUM_WAIT_CYCLES && counter < NUM_MESSAGES + NUM_WAIT_CYCLES) begin
                // Sending message
                s01_axis_tvalid                                 <= 1'b1;
                s01_axis_tlast                                  <= 1'b1;
                s01_axis_tdata[TAG_HIGH_ADDR:TAG_LOW_ADDR]      <= counter - NUM_WAIT_CYCLES;
                s01_axis_tdata[MODE_HIGH_ADDR:MODE_LOW_ADDR]    <= config_bits[counter - NUM_WAIT_CYCLES];
                //s01_axis_tdata[SIZE_HIGH_ADDR:SIZE_LOW_ADDR]    <= '0;
                s01_axis_tdata[ADDR_HIGH_ADDR:ADDR_LOW_ADDR]    <= addresses[counter - NUM_WAIT_CYCLES];
                // When receive ready, move onto next address
                if(s01_axis_tready == 1'b1) begin
                    counter <= counter + 1;
                end
                else begin
                    counter <= counter;
                end
            end
            else begin
                s01_axis_tvalid     <= 1'b0;
                s01_axis_tdata      <= 128'd0;
                counter             <= counter + 1;
                s01_axis_tlast      <= 1'b0;
            end
        end
    end
    
    // When receive valid from master port, set ready for one clock cycle
    always@(posedge clk) begin
        if(m01_axis_tvalid) begin
            m01_axis_tready <= 1'b1;
            received_id[m01_axis_tid] <= 1;
            //s01_axis_tlast <= 1'b1;
        end
        else begin
            m01_axis_tready <= 1'b0;
            //s01_axis_tlast <= 1'b0;
        end
    end

endmodule
