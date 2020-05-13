// testbench of Extension

`timescale 1ns/1ps

module Extension_tb();

    initial begin
        $dumpfile("Extension_tb.vcd");
        $dumpvars(0, Extension_tb);
    end

    // Extension Parameters
    parameter PERIOD = 10;

    // Extension Inputs
    reg  [31:0] num1  = 0;
    reg  [31:0] num2  = 0;
    reg         C_in  = 0;

    // Extension Outputs
    wire [31:0] sum  ;
    wire        C_out;

    reg clk = 0;
    initial begin
    forever #(PERIOD/2) clk = ~clk;
    end

    // initial begin
    //     #(PERIOD*2) rst_n = 1;
    // end

    Extension  u_Extension (
        .num1  (num1  [31:0]),
        .num2  (num2  [31:0]),
        .C_in  (C_in        ),

        .sum   (sum   [31:0]),
        .C_out (C_out       )
    );

    always @(posedge clk) begin
        C_in = {$random} % 2;
        num1 = $random      ;
        num2 = $random      ;
    end

    initial begin
        #200
        $finish;
    end

endmodule
