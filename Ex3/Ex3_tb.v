// testbench of Ex3

`include "Ex3.v"
`timescale 1ns/1ps

module Ex3_tb();

    // Ex3 Parameters
    parameter PERIOD = 10;

    // Ex3 Inputs
    reg        clk         = 0;
    reg        rst_n       = 0;
    reg        set_n       = 0;
    reg  [1:0] JK          = 0;
    reg        D           = 0;
    reg        reEnable    = 0;
    reg  [1:0] S           = 0;
    reg  [1:0] shiftIn     = 0;
    reg  [3:0] data        = 0;

    // Ex3 Outputs
    wire [1:0] out_RS     ;
    wire [1:0] out_JK     ;
    wire [1:0] out_D      ;
    wire [3:0] out_sync   ;
    wire [3:0] out_async  ;
    wire [3:0] out_re     ;
    wire [3:0] out_reg    ;
    wire       out_seq    ;
    wire       out_seq_fsm;

    initial begin
    forever #(PERIOD/2) clk = ~clk;
    end

    Ex3  u_Ex3 (
        .clk         (clk              ),
        .rst_n       (rst_n            ),
        .set_n       (set_n            ),
        .JK          (JK          [1:0]),
        .D           (D                ),
        .reEnable    (reEnable         ),
        .S           (S           [1:0]),
        .shiftIn     (shiftIn     [1:0]),
        .data        (data        [3:0]),

        .out_RS      (out_RS      [1:0]),
        .out_JK      (out_JK      [1:0]),
        .out_D       (out_D       [1:0]),
        .out_sync    (out_sync    [3:0]),
        .out_async   (out_async   [3:0]),
        .out_re      (out_re      [3:0]),
        .out_reg     (out_reg     [3:0]),
        .out_seq     (out_seq          ),
        .out_seq_fsm (out_seq_fsm      )
    );

    always @(negedge clk) begin
        JK = JK + 1;
        D  =  D + 1;
        {shiftIn, data} = {$random} % 63;
    end

    initial begin
        {rst_n, set_n} = 2'b01; #10
        {rst_n, set_n} = 2'b11; #10
        {rst_n, set_n} = 2'b10;
        S              = 2'b00; #20
        S              = 2'b01; #50
        S              = 2'b10; #50
        S              = 2'b11; #20
        reEnable       = 1    ; #110
        {rst_n, set_n} = 2'b00; #80
        $finish;
    end

endmodule
