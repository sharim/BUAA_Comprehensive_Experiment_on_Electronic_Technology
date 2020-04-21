//~ `New testbench
`timescale  1ns / 1ps

module tb_Ex1();
    // initial
    //  begin
    //    $dumpfile("tb_Ex1.vcd");
    //    $dumpvars(0, tb_Ex1);
    //  end
    // Ex1 Parameters
    parameter PERIOD = 10;

    // Ex1 Inputs
    reg [3:0] in = 0 ;
    // Ex1 Outputs
    wire [5:0]  out;
    // Ex1 Clock
    reg clk = 1;

    initial
    begin
        forever #(PERIOD/2)  clk = ~clk;
    end

    Ex1  u_Ex1 (.in(in[3:0]),
    .out(out)
    );

    always @(posedge clk ) begin
        in <= in + 4'b1;
    end

    initial #160 $finish;
endmodule
