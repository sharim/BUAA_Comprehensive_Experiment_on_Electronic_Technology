// testbench of Ex2

`timescale 1ns/1ps

module Ex2_tb();

    // Ex2 Parameters
    parameter PERIOD = 10;

    initial begin
        $dumpfile("Ex2_tb.vcd");
        $dumpvars(0, Ex2_tb);
    end

    // Ex2 Inputs
    reg  [ 1:0] in_2          = 0;
    reg  [ 2:0] in_3          = 0;
    reg  [ 3:0] in_4          = 0;
    reg  [ 5:0] in_6          = 0;
    reg  [ 6:0] in_7          = 0;
    reg  [ 7:0] in_8          = 0;
    reg  [ 8:0] in_9          = 0;
    reg  [10:0] in_11         = 0;
    reg  [11:0] in_12         = 0;
    reg  [31:0] num1          = 0;
    reg  [31:0] num2          = 0;
    reg         C_in          = 0;

    // check Ex2 thirty_two_bit_full_adder
    reg         adder32_check = 0;

    // Ex2 Outputs
    wire [ 8:0] encoderOut       ;
    wire        encoderYEX       ;
    wire        encoderYS        ;
    wire [14:0] decoderOut       ;
    wire [ 1:0] muxOut           ;
    wire        muxW             ;
    wire [ 2:0] numComparatorOut ;
    wire [ 5:0] adderOutS        ;
    wire [ 2:0] adderOutC        ;
    wire [ 5:0] subtracterOut    ;
    wire [ 2:0] subtracterJ      ;
    wire [31:0] adderOutS_32bit  ;
    wire        adderOutC_32bit  ;

    reg clk = 0;
    initial begin
    forever #(PERIOD/2) clk = ~clk;
    end

    Ex2  u_Ex2 (
        .in_2             (in_2             [ 1:0]),
        .in_3             (in_3             [ 2:0]),
        .in_4             (in_4             [ 3:0]),
        .in_6             (in_6             [ 5:0]),
        .in_7             (in_7             [ 6:0]),
        .in_8             (in_8             [ 7:0]),
        .in_9             (in_9             [ 8:0]),
        .in_11            (in_11            [10:0]),
        .in_12            (in_12            [11:0]),
        .num1             (num1             [31:0]),
        .num2             (num2             [31:0]),
        .C_in             (C_in                   ),

        .encoderOut       (encoderOut       [ 8:0]),
        .encoderYEX       (encoderYEX             ),
        .encoderYS        (encoderYS              ),
        .decoderOut       (decoderOut       [14:0]),
        .muxOut           (muxOut           [ 1:0]),
        .muxW             (muxW                   ),
        .numComparatorOut (numComparatorOut [ 2:0]),
        .adderOutS        (adderOutS        [ 5:0]),
        .adderOutC        (adderOutC        [ 2:0]),
        .subtracterOut    (subtracterOut    [ 5:0]),
        .subtracterJ      (subtracterJ      [ 2:0]),
        .adderOutS_32bit  (adderOutS_32bit  [31:0]),
        .adderOutC_32bit  (adderOutC_32bit        )
    );

    always @(posedge clk) begin
        in_2  <= in_2  + 1;
        in_3  <= in_3  + 1;
        in_4  <= in_4  + 1;
        in_6  <= in_6  + 1;
        in_7  <= in_7  + 1;
        in_8  <= in_8  + 1;
        in_9  <= in_9  + 1;
        in_11 <= in_11 + 1;
        in_12 <= in_12 + 1;

        num1    <= num1 << 1    ;
        num2    <= num2 << 1    ;
        num1[0] <= {$random} % 2;
        num2[0] <= {$random} % 2;
        C_in    <= {$random} % 2;
    end

    always @(num1 or num2 or C_in or adderOutS_32bit or adderOutC_32bit) begin
        if ({adderOutC_32bit, adderOutS_32bit} == num1 + num2 + C_in)
            adder32_check = 1;
        else
            adder32_check = 0;
    end

    initial begin
        #40950
        $finish;
    end

endmodule
