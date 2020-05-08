//~ `New testbench
`timescale 1ns/1ps

`include "Encoder.v"

module Encoder_tb();

    initial begin
        $dumpfile("Encoder_tb.vcd");
        $dumpvars(0, Encoder_tb);
    end

    // encoder__8_to_3 Parameters
    parameter PERIOD = 10;

    // encoder__8_to_3 Inputs
    reg  [7:0] in1  = 0;
    reg  [7:0] in2 = 0;
    reg        ST  = 0;

    // encoder__8_to_3 Outputs
    wire [2:0] out1;
    wire [2:0] out2;
    wire [2:0] out3;
    wire       YEX;
    wire       YS;

    // initial begin
    // forever #(PERIOD/2) clk = ~clk;
    // end

    // initial begin
    //     #(PERIOD*2) rst_n = 1;
    // end

    encoder__8_to_3  u_encoder__8_to_3 (
        .in  (in1  [7:0]),

        .out (out1 [2:0])
    );

    priorityEncoder__8_3 u_priorityEncoder__8_3 (
        .in  (in1  [7:0]),

        .out (out2 [2:0])
    );

    priorityEncoder_74xx148 u_priorityEncoder_74xx148 (
        .ST  (ST       ),
        .in  (in2 [7:0]),

        .out (out3 [2:0]),
        .YEX (YEX      ),
        .YS  (YS       )
    );

    initial begin
        in1 = 8'b0000_0001;
        in2 = 8'b1111_1110;
        #100
        in1 = 8'b0000_0010;
        in2 = 8'b1111_1101;
        #100
        in1 = 8'b0000_0100;
        in2 = 8'b1111_1011;
        #100
        in1 = 8'b0000_1000;
        in2 = 8'b1111_0111;
        #100
        in1 = 8'b0001_0000;
        in2 = 8'b1110_1111;
        #100
        in1 = 8'b0010_0000;
        in2 = 8'b1101_1111;
        #100
        in1 = 8'b0100_0000;
        in2 = 8'b1011_1111;
        #100
        in1 = 8'b1000_0000;
        in2 = 8'b0111_1111;
        #100
        // in1 = 8'b1000_0001;
        // in2 = 8'b1111_1110;
        // #100
        // in1 = 8'b0100_0010;
        // in2 = 8'b1111_1101;
        // #100
        // in1 = 8'b0010_0100;
        // in2 = 8'b1111_1011;
        // #100
        // in1 = 8'b0001_1000;
        // in2 = 8'b1111_0111;
        // #100
        // in1 = 8'b0001_0000;
        // in2 = 8'b1110_0111;
        // #100
        // in1 = 8'b0010_0000;
        // in2 = 8'b1101_1011;
        // #100
        // in1 = 8'b0100_0000;
        // in2 = 8'b1011_1101;
        // #100
        // in1 = 8'b1000_0000;
        // in2 = 8'b0111_1110;
        // #100
        // in1 = 8'b0100_0000;
        // in2 = 8'b1111_1111;
        // #100
        // ST  = 1;
        // in1 = 8'b1000_0000;
        // in2 = 8'b0111_1110;
        // #100
        $finish;
    end

endmodule
