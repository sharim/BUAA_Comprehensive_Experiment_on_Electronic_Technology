// * 数值比较器

module four_bit_numComparator(
    input  [3:0] A,
    input  [3:0] B,
    input  [2:0] I,

    output [2:0] Y
);

    assign Y = A<=B? A==B? I:3'b100 :3'b001;

endmodule
