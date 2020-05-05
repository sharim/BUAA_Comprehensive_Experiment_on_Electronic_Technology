// *集成电路扩展：八个4位全加器扩展成32位全加器

`include "Adder.v"

module Extension(
    input  [31:0] num1 ,
    input  [31:0] num2 ,
    input         C_in ,

    output [31:0] sum  ,
    output        C_out
);

    wire   [8:0] cio                 ;
    assign       cio   [0] = C_in    ;
    assign       C_out     = cio  [8];

    genvar i;
    generate
        for (i = 0; i < 31; i = i + 4) begin: GENERATE_ADDERS
            foul_bit_full_adder u_foul_bit_full_adder(
                .num1  (num1 [i + 3 : i]),
                .num2  (num2 [i + 3 : i]),
                .C_in  (cio  [i / 4    ]),

                .sum   (sum  [i + 3 : i]),
                .C_out (cio  [i / 4 + 1])
            );
        end
    endgenerate

endmodule // 32位全加器