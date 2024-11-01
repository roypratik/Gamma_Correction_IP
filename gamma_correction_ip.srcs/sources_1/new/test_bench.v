`timescale 1ns / 1ps

module test_bench;

    parameter DATA_WIDTH = 32;

    // Testbench signals
    reg axi_clk;
    reg axi_reset_n;
    reg s_axis_valid;
    reg [DATA_WIDTH-1:0] s_axis_data;
    wire s_axis_ready;

    wire m_axis_valid;
    wire [DATA_WIDTH-1:0] m_axis_data;
    reg m_axis_ready;

    // Instantiate the gamma_corrector module
    gamma_correction #(.DATA_WIDTH(DATA_WIDTH)) dut (
        .axi_clk(axi_clk),
        .axi_reset_n(axi_reset_n),
        .s_axis_valid(s_axis_valid),
        .s_axis_data(s_axis_data),
        .s_axis_ready(s_axis_ready),
        .m_axis_valid(m_axis_valid),
        .m_axis_data(m_axis_data),
        .m_axis_ready(m_axis_ready)
    );

    // Clock generation
    initial begin
        axi_clk = 0;
        forever #5 axi_clk = ~axi_clk; // 10ns clock period (100 MHz)
    end

    // Test procedure
    initial begin
        // Initialization
        axi_reset_n = 0;
        s_axis_valid = 0;
        s_axis_data = 0;
        m_axis_ready = 1;

        // Apply reset
        #20;
        axi_reset_n = 1;

        // Test data for gamma correction (example grayscale values)
        // Assume we use 4 pixels of 8-bit each to match DATA_WIDTH = 32
        #10;
        s_axis_data = {8'd21,8'd21,8'd21,8'd21};
        s_axis_valid = 1;

        // Wait for the module to process the data
        @(posedge axi_clk);
        while (!m_axis_valid) @(posedge axi_clk);

        // Capture and display output
        $display("Input Pixels:   %h", s_axis_data);
        $display("Output Pixels:  %h", m_axis_data);

        // Finish simulation
        #20;
        $finish;
    end

endmodule