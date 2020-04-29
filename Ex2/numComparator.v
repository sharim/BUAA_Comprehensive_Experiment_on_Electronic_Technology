// * 数值比较器

module foul_bit_numComparator(
    input  [3:0] A,
    input  [3:0] B,

    output [2:0] Y
);

    assign Y = A<=B? A==B?3'b010:3'b100 :3'b001;

endmodule
