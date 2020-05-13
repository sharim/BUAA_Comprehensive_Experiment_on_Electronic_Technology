//~ `New testbench
`timescale 1ns/1ps

`include "Decoder.v"

module Decoder_tb();

    initial begin
        $dumpfile("Decoder_tb.vcd");
        $dumpvars(0, Decoder_tb);
    end

    // decoder__3_8 Parameters
    parameter PERIOD = 10;

    // decoder__3_8 Inputs
    reg        S1    = 0;
    reg        S2    = 0;
    reg        S3    = 0;
    reg  [2:0] A1    = 0;
    reg  [3:0] A2    = 0;

    // decoder__3_8 Outputs
    wire [7:0]    Y1;
    wire [6:0]    Y2;

    reg clk = 0;
    initial begin
    forever #(PERIOD/2) clk = ~clk;
    end

    // initial begin
    //     #(PERIOD*2) rst_n = 1;
    // end

    decoder__3_8  u_decoder__3_8 (
        .S1    (S1         ),
        .S2    (S2         ),
        .S3    (S3         ),
        .A     (A1    [2:0]),

        .Y     (Y1    [7:0])
    );

    decoder__BCD_SEVEN  u_decoder__BCD_SEVEN (
        .A     (A2        ),

        .Y     (Y2        )
    );

    integer i = 0;
    always @(posedge clk) begin
        A1 <= A1 + 1;
        A2 <= A2 + 1;
    end
    initial begin
        S1=0; #10
        S1=1; S2=1; #10
        S1=1; S2=0; S3=0; #80
        $finish;
    end

endmodule
