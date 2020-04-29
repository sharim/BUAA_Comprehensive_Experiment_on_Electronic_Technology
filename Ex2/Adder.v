// * 半加器、全加器、四位全加器

module half_adder(
    input  X,
    input  Y,
    output S,
    output C
);

    assign S = X ^ Y;
    assign C = X & Y;

endmodule // 半加器

module full_adder(
    input  X,
    input  Y,
    input  C_0,
    output S,
    output C
);

    assign S = X ^ Y ^ C_0;
    assign C = | {X&Y, X&C_0, Y&C_0};

endmodule // 全加器

module foul_bit_full_adder(
    input  [3:0] num1,
    input  [3:0] num2,
    input        C_in,
    output [3:0] sum,
    output       C_out
);

    assign {C_out, sum} = num1 + num2 + C_in;

endmodule // 四位全加器
