// TODO: FPGA组合电路模块设计

`include "Decoder.v"
`include "Encoder.v"
`include "MUX.v"
`include "numComparator.v"
`include "Subtracter.v"
`include "Extension.v"


module Ex2(
    input  [ 1:0] in_2            ,
    input  [ 2:0] in_3            ,
    input  [ 3:0] in_4            ,
    input  [ 5:0] in_6            ,
    input  [ 6:0] in_7            ,
    input  [ 7:0] in_8            ,
    input  [ 8:0] in_9            ,
    input  [10:0] in_11           ,
    input  [11:0] in_12           ,

    input  [31:0] num1            ,
    input  [31:0] num2            ,
    input         C_in            ,

    output [ 8:0] encoderOut      ,
    output        encoderYEX      ,
    output        encoderYS       ,

    output [14:0] decoderOut      ,

    output [ 1:0] muxOut          ,
    output        muxW            ,

    output [ 2:0] numComparatorOut,

    output [ 5:0] adderOutS       ,
    output [ 2:0] adderOutC       ,

    output [ 5:0] subtracterOut   ,
    output [ 2:0] subtracterJ     ,

    output [31:0] adderOutS_32bit ,
    output        adderOutC_32bit
);

    // * Encoder(编码器)
    encoder__8_to_3 u_encoder__8_to_3(
        .in  (in_8           ),

        .out (encoderOut[8:6])
    );
    priorityEncoder__8_3 u_priorityEncoder__8_3(
        .in  (in_8           ),

        .out (encoderOut[5:3])
    );
    priorityEncoder_74xx148 u_priorityEncoder_74xx148(
        .ST  (in_9[  8]      ),
        .in  (in_9[7:0]      ),

        .out (encoderOut[2:0]),
        .YEX (encoderYEX     ),
        .YS  (encoderYS      )
    );

    // * Decoder(译码器)
    decoder__3_8 u_decoder__3_8(
        .S1    (in_6[  5]       ),
        .notS2 (in_6[  4]       ),
        .notS3 (in_6[  3]       ),
        .A     (in_6[2:0]       ),

        .notY  (decoderOut[14:7])
    );
    decoder__BCD_SEVEN u_decoder__BCD_SEVEN(
        .A     (in_4            ),

        .Y     (decoderOut[6:0] )
    );

    // * MUX(数据选择器)
    mux_4_1 u_mux_4_1(
        .S (in_7[  6]  ),
        .D (in_7[5:2]  ),
        .A (in_7[1:0]  ),

        .Y (muxOut[1]  )
    );
    mux_8_1_74LS151 u_mux_8_1_74LS151(
        .S (in_12[  11]),
        .D (in_12[10:3]),
        .A (in_12[ 2:0]),

        .Y (muxOut[0]  ),
        .W (muxW       )
    );

    // * numComaparator(数值比较器)
    four_bit_numComparator u_four_bit_numComparator(
        .I (in_11[10:8]     ),
        .A (in_11[ 7:4]     ),
        .B (in_11[ 3:0]     ),

        .Y (numComparatorOut)
    );

    // * Adder(加法器)
    half_adder u_half_adder(
        .X     (in_2[1]       ),
        .Y     (in_2[0]       ),

        .S     (adderOutS[5]  ),
        .C     (adderOutC[2]  )
    );
    full_adder u_full_adder(
        .X     (in_3[2]       ),
        .Y     (in_3[1]       ),
        .C_0   (in_3[0]       ),

        .S     (adderOutS[4]  ),
        .C     (adderOutC[1]  )
    );
    four_bit_full_adder u_four_bit_full_adder(
        .num1  (in_9[8:5]     ),
        .num2  (in_9[4:1]     ),
        .C_in  (in_9[  0]     ),

        .sum   (adderOutS[3:0]),
        .C_out (adderOutC[  0])
    );

    // * Subtracter(减法器)
    half_subtracter u_half_subtracter(
        .A  (in_2[1]           ),
        .B  (in_2[0]           ),

        .D  (subtracterOut[5]  ),
        .J  (subtracterJ  [2]  )
    );
    full_subtracter u_full_subtracter(
        .A  (in_3[2]           ),
        .B  (in_3[1]           ),
        .J0 (in_3[0]           ),

        .D  (subtracterOut[4]  ),
        .J  (subtracterJ  [1]  )
    );
    four_bit_full_subtracter u_foul_bit_full_subtracter(
        .A  (in_9[8:5]         ),
        .B  (in_9[4:1]         ),
        .J0 (in_9[  0]         ),

        .D  (subtracterOut[3:0]),
        .J  (subtracterJ  [  0])
    );

    // * Extension(扩展)
    Extension thirty_two_bit_full_adder(
        .num1  (num1           ),
        .num2  (num2           ),
        .C_in  (C_in           ),

        .sum   (adderOutS_32bit),
        .C_out (adderOutC_32bit)
    );

endmodule // Ex2

