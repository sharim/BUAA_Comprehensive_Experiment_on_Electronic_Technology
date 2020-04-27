// testbench of Adder

`include "Adder.v"
`timescale 1ns/1ps

module Adder_tb();

        initial begin
            $dumpfile("Adder_tb.vcd");
            $dumpvars(0, Adder_tb);
        end

    // Adder Parameters
    parameter PERIOD = 10;

    // Adder Inputs
    reg        X    = 0;
    reg        Y    = 0;
    reg        C_0  = 0;
    reg  [3:0] num1 = 0;
    reg  [3:0] num2 = 0;
    reg        C_in = 0;

    // Adder Outputs
    wire       S_1     ;
    wire       C_1     ;
    wire       S_2     ;
    wire       C_2     ;
    wire [3:0] sum     ;
    wire       C_out   ;

    reg clk = 0;
    initial begin
    forever #(PERIOD/2) clk = ~clk;
    end

    // initial begin
    //     #(PERIOD*2) rst_n = 1;
    // end

    half_adder  u_half_adder (
        .X     (X    ),
        .Y     (Y    ),

        .S     (S_1  ),
        .C     (C_1  )
    );

    full_adder u_full_adder (
        .X     (X    ),
        .Y     (Y    ),
        .C_0   (C_0  ),

        .S     (S_2  ),
        .C     (C_2  )
    );

    foul_bit_full_adder u_foul_bit_full_adder(
        .num1  (num1 ),
        .num2  (num2 ),
        .C_in  (C_in ),

        .sum   (sum  ),
        .C_out (C_out)
    );

    always @(posedge clk) begin
        {X, Y, C_0}        <= {X, Y, C_0} + 1;
        {num1, num2, C_in} <= {num1, num2, C_in} + 1;
    end

    initial begin
        #10230
        $finish;
    end

endmodule
