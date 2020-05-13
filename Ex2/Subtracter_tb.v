// testbench of Subtracter

`include "Subtracter.v"
`timescale 1ns/1ps

module Subtracter_tb();

    initial begin
        $dumpfile("Subtracter_tb.vcd");
        $dumpvars(0, Subtracter_tb);
    end

    // half_substracter Parameters
    parameter PERIOD = 10;

    // half_substracter Inputs
    reg        A   = 0;
    reg        B   = 0;
    reg        J0  = 0;
    reg [3:0]  A2  = 0;
    reg [3:0]  B2  = 0;
    reg        J01 = 0;

    // half_substracter Outputs
    wire       D      ;
    wire       J      ;
    wire       D1     ;
    wire       J1     ;
    wire [3:0] D2     ;
    wire       J2     ;

    reg clk = 0;
    initial begin
    forever #(PERIOD/2) clk = ~clk;
    end

    // initial begin
    //     #(PERIOD*2) rst_n = 1;
    // end

    half_subtracter  u_half_subtracter (
        .A  (A   ),
        .B  (B   ),

        .D  (D   ),
        .J  (J   )
    );

    full_subtracter u_full_subtracter (
        .A  (A  ),
        .B  (B  ),
        .J0 (J0 ),

        .D  (D1 ),
        .J  (J1 )
    );

    four_bit_full_subtracter  u_four_bit_full_subtracter (
        .A  (A2 ),
        .B  (B2 ),
        .J0 (J01),

        .D  (D2 ),
        .J  (J2 )
    );

    always @(posedge clk) begin
        {B, A, J0}    <= {$random} %   8;
        {B2, A2, J01} <= {$random} % 512;
    end

    initial begin
        #5110
        $finish;
    end

endmodule
