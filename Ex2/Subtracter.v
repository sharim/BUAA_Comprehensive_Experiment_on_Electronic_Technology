// TODO: testbench and debug

module half_substracter(
    input  A,
    input  B,

    output D,
    output J
);

    assign {D, J} = {A^B, ~A&B};

endmodule

module full_substracter(
    input  A,
    input  B,
    input  J0,

    output D,
    output J
);

    assign {D, J} = {^{A, B, J0}, |{~A&J0, ~A&B, B&J0}};

endmodule

module foul_bit_full_substracter(
    input  [3:0] A,
    input  [3:0] B,
    input        J0,

    output [3:0] D,
    output       J
);

    assign {J, D} = A + ~B + 5'b1_0001;

endmodule
