//~ `New testbench
`timescale 1ns/1ps

`include "Decoder.v"

module Decoder_tb();

    initial begin
        $dumpfile("Decoder_tb.vcd");
        $dumpvars(0, Decoder_tb);
    end

    // decoder__3_8 Parameters
    parameter PERIOD = 100;

    // decoder__3_8 Inputs
    reg        S1    = 0;
    reg        notS2 = 0;
    reg        notS3 = 0;
    reg  [2:0] A1    = 0;
    reg  [3:0] A2    = 0;

    // decoder__3_8 Outputs
    wire [7:0] notY ;
    wire [6:0]    Y ;

    reg clk = 0;
    initial begin
    forever #(PERIOD/2) clk = ~clk;
    end

    // initial begin
    //     #(PERIOD*2) rst_n = 1;
    // end

    decoder__3_8  u_decoder__3_8 (
        .S1    (S1         ),
        .notS2 (notS2      ),
        .notS3 (notS3      ),
        .A     (A1    [2:0]),

        .notY  (notY  [7:0])
    );

    decoder__BCD_SEVEN  u_decoder__BCD_SEVEN (
        .A     (A2        ),

        .Y     (Y         )
    );

    always @(posedge clk) begin
        A2 <= A2 + 1;
    end
    initial begin
        S1=0; #100
        S1=1; notS2=1; #100
        S1=1; notS2=0; notS3=0; A1=3'b110;#800
        $finish;
    end

endmodule
