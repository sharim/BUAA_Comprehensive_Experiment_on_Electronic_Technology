//~ `New testbench
`timescale 1ns/1ps

module Ex1_tb();

    // initial
    //  begin
    //    $dumpfile("Ex1_tb.vcd");
    //    $dumpvars(0, Ex1_tb);
    //  end

    // Ex1 Parameters
    parameter PERIOD = 10;

    // Ex1 Inputs
    reg  [3:0] in    = 0;

    // Ex1 Outputs
    wire       and_out  ;
    wire       or_out   ;
    wire       not_out  ;
    wire       nand_out ;
    wire       aoi_out  ;
    wire       xor_out_1;
    wire       xor_out_2;

    reg clk = 0;
    initial begin
    forever #(PERIOD/2) clk = ~clk;
    end

    // initial begin
    //     #(PERIOD*2) rst_n = 1;
    // end

    Ex1  u_Ex1 (
        .in        (in        [3:0]),

        .and_out   (and_out        ),
        .or_out    (or_out         ),
        .not_out   (not_out        ),
        .nand_out  (nand_out       ),
        .aoi_out   (aoi_out        ),
        .xor_out_1 (xor_out_1      ),
        .xor_out_2 (xor_out_2      )
    );

    always @(posedge clk ) begin
        in <= in + 4'b1;
    end

    initial begin
        #160
        $finish;
    end

endmodule
