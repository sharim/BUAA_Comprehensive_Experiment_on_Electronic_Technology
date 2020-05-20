// testbench of Register

`include "Register.v"
`timescale 1ns/1ps

module Register_tb();

    initial begin
        $dumpfile("Register_tb.vcd");
        $dumpvars(0, Register_tb);
    end

    // Register Parameters
    parameter PERIOD = 10;

    // Register Inputs
    reg        clk               = 0;
    reg        rst_n             = 0;
    reg  [1:0] S                 = 0;
    reg        rightShift_in     = 0;
    reg        leftShift_in      = 0;
    reg  [3:0] parallel_data_in  = 0;

    // Register Outputs
    wire [3:0] parallel_data_out;
    wire       out              ;

    initial begin
    forever #(PERIOD/2) clk = ~clk;
    end

    initial begin
        rst_n = 1;
    end

    bi_shift_register  u_bi_shift_register (
        .clk               (clk                    ),
        .rst_n             (rst_n                  ),
        .S                 (S                 [1:0]),
        .rightShift_in     (rightShift_in          ),
        .leftShift_in      (leftShift_in           ),
        .parallel_data_in  (parallel_data_in  [3:0]),

        .parallel_data_out (parallel_data_out [3:0])
    );

    sequence_generator u_sequence_generator (
        .clk   (clk  ),
        .rst_n (rst_n),

        .out   (out  )
    );

    always @(posedge clk) begin
        {rightShift_in, leftShift_in, parallel_data_in} = {$random} % 63;
    end

    initial begin
        S = 2'b00; #20
        S = 2'b01; #50
        S = 2'b10; #50
        S = 2'b11; #20
        rst_n = 0; #20
        $finish;
    end

endmodule
