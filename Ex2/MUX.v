// * 四位选择器、八位选择器

module mux_4_1(
    input       S,
    input [3:0] D,
    input [1:0] A,

    output      Y
);

    assign Y = S? 0 : D[A];

endmodule

module mux_8_1_74LS151(
    input       S,
    input [7:0] D,
    input [2:0] A,

    output      Y,
    output      W
);

    assign {Y, W} = S? {1'b0, 1'b1} : {D[A], ~D[A]};

endmodule
