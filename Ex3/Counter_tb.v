// testbench of Counter

`include "Counter.v"
`timescale 1ns/1ps

module Counter_tb();

    initial begin
        $dumpfile("Counter_tb.vcd");
        $dumpvars(0, Counter_tb);
    end

    // Counter Parameters
    parameter PERIOD = 10;

    // Counter Inputs
    reg        clk      = 0;
    reg        rst_n    = 0;
    reg        reEnable = 0;

    // Counter Outputs
    wire [3:0] out1;
    wire [3:0] out2;
    wire [3:0] out3;

    initial begin
    forever #(PERIOD/2) clk = ~clk;
    end

    initial begin
        #(PERIOD*2) rst_n = 1;
    end

    sync_counter  u_sync_counter (
        .clk   (clk       ),
        .rst_n (rst_n     ),

        .out   (out1 [3:0])
    );

    async_counter  u_async_counter (
        .clk   (clk       ),
        .rst_n (rst_n     ),

        .out   (out2 [3:0])
    );

    reversible_counter u_reversible_counter (
        .clk     (clk       ),
        .rst_n   (rst_n     ),
        .reEnable(reEnable  ),

        .out     (out3 [3:0])
    );

    initial begin
        #130
        reEnable = 1; #110
        rst_n    = 0; #30
        $finish;
    end

endmodule
