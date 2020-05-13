//~ testbench of Encoder.v
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
    reg  [7:0] in1  = 1;
    reg  [7:0] in2  = 0;
    reg  [7:0] in3  = 0;
    reg        ST   = 0;

    // encoder__8_to_3 Outputs
    wire [2:0] out1;
    wire [2:0] out2;
    wire [2:0] out3;
    wire       YEX ;
    wire       YS  ;

    reg clk = 0;
    initial begin
    forever #(PERIOD/2) clk = ~clk;
    end

    // initial begin
    //     #(PERIOD*2) rst_n = 1;
    // end

    encoder__8_to_3  u_encoder__8_to_3 (
        .in  (in1  [7:0]),

        .out (out1 [2:0])
    );

    priorityEncoder__8_3 u_priorityEncoder__8_3 (
        .in  (in2  [7:0]),

        .out (out2 [2:0])
    );

    priorityEncoder_74xx148 u_priorityEncoder_74xx148 (
        .ST  (ST       ),
        .in  (in3 [7:0]),

        .out (out3 [2:0]),
        .YEX (YEX       ),
        .YS  (YS        )
    );

    integer i = 0;
    always @(posedge clk) begin
        i  = i==0 ? 1:0;
        ST = ~ST;
        if (!i) begin
            in1 <= {in1[0], in1[7:1]};
            in2 <= {$random} % 256;
            in3 <= in2;
        end
    end

    initial begin
        #160
        $finish;
    end

endmodule
