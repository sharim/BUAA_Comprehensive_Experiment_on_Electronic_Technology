// testbench of flipFlop

`include "flipFlop.v"
`timescale 1ns/1ps

module flipFlop_tb();

    initial begin
        $dumpfile("flipFlop_tb.vcd");
        $dumpvars(0, flipFlop_tb);
    end

    // flipFlop Parameters
    parameter PERIOD = 10;

    // flipFlop Inputs
    reg  clk   = 0;
    reg  rst_n = 0;
    reg  set_n = 0;
    reg  J     = 0;
    reg  K     = 0;
    reg  D     = 0;

    // flipFlop Outputs
    wire Q_RS     ;
    wire Q_n_RS   ;
    wire Q_JK     ;
    wire Q_n_jk   ;
    wire Q_D      ;
    wire Q_n_D    ;

    initial begin
    forever #(PERIOD/2) clk = ~clk;
    end

    initial begin
        #(PERIOD*2) rst_n = 1;
    end

    RS_flip_flop  u_RS_flip_flop (
        .clk   (clk   ),
        .rst_n (rst_n ),
        .set_n (set_n ),

        .Q     (Q_RS  ),
        .Q_n   (Q_n_RS)
    );

    JK_flip_flop  u_JK_flip_flop (
        .clk   (clk   ),
        .rst_n (rst_n ),
        .J     (J     ),
        .K     (K     ),

        .Q     (Q_JK  ),
        .Q_n   (Q_n_JK)
    );

    D_flip_flop  u_D_flip_flop (
        .clk   (clk  ),
        .rst_n (rst_n),
        .D     (D    ),

        .Q     (Q_D  ),
        .Q_n   (Q_n_D)
    );

    always @(posedge clk) begin
        {J, K} <= {J, K} + 1;
        D      <= D + 1     ;
    end

    initial begin
        {rst_n, set_n} = 2'b10; #80
        {rst_n, set_n} = 2'b00; #80
        {rst_n, set_n} = 2'b01; #10
        {rst_n, set_n} = 2'b11; #10
        $finish;
    end

endmodule
