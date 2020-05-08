// * 半减器、全减器、四位全减器

module half_subtracter(
    input  A,
    input  B,

    output D,
    output J
);

    assign {D, J} = {A^B, ~A&B};

endmodule

module full_subtracter(
    input  A ,
    input  B ,
    input  J0,

    output D ,
    output J
);

    assign {J, D} = A - B -J0;

endmodule

module four_bit_full_subtracter(
    input  [3:0] A ,
    input  [3:0] B ,
    input        J0,

    output [3:0] D ,
    output       J
);

    assign {J, D} = A - B - J0;

endmodule
