// testbench of MUX

`include "MUX.v"
`timescale 1ns/1ps

module MUX_tb();

    // mux_4_1 Parameters
    parameter PERIOD = 10;

    initial begin
        $dumpfile("MUX_tb.vcd");
        $dumpvars(0, MUX_tb);
    end

    // mux_4_1 Inputs
    reg        S = 0;
    reg  [3:0] D = 0;
    reg  [1:0] A = 0;
    reg        S1 = 0;
    reg  [7:0] D1 = 0;
    reg  [2:0] A1 = 0;

    // mux_4_1 Outputs
    wire       Y;
    wire       Y1;
    wire       W;
    reg clk = 0;
    initial begin
    forever #(PERIOD/2) clk = ~clk;
    end

    // initial begin
    //     #(PERIOD*2) rst_n = 1;
    // end

    mux_4_1  u_mux_4_1 (
        .S (S      ),
        .D (D [3:0]),
        .A (A [1:0]),

        .Y (Y      )
    );

    mux_8_1_74LS151 u_mux_8_1_74LS151 (
        .S(S1      ),
        .D(D1 [7:0]),
        .A(A1 [2:0]),

        .Y (Y1     ),
        .W (W      )
    );

    always @(posedge clk) begin
        {S , D , A } <= {$random} %  128;
        {S1, D1, A1} <= {$random} % 4096;
    end

    initial begin
        #200
        $finish;
    end

endmodule
