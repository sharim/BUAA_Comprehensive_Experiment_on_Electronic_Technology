// testbench of numComparator

`include "numComparator.v"
`timescale 1ns/1ps

module numComparator_tb();

    // foul_bit_numComparator Parameters
    parameter PERIOD = 10;

    initial begin
        $dumpfile("numComparator_tb.vcd");
        $dumpvars(0, numComparator_tb);
    end

    // foul_bit_numComparator Inputs
    reg  [3:0] A = 0;
    reg  [3:0] B = 0;

    // foul_bit_numComparator Outputs
    wire [2:0] Y;

    reg clk = 0;
    initial begin
    forever #(PERIOD/2) clk = ~clk;
    end

    // initial begin
    //     #(PERIOD*2) rst_n = 1;
    // end

    four_bit_numComparator  u_four_bit_numComparator (
        .A (A [3:0]),
        .B (B [3:0]),
        .I (3'b010 ),

        .Y (Y [2:0])
    );

    always @(posedge clk) begin
        A <= {$random} % 16;
        B <= {$random} % 16;
    end

    initial begin
        #200
        $finish;
    end

endmodule
