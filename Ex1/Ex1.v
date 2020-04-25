`include "Gates.v"

module  Ex1(
    input  [3:0] in,
    output       and_out,
    output       or_out,
    output       not_out,
    output       nand_out,
    output       aoi_out,
    output       xor_out_1,
    output       xor_out_2);

    // * (1) 实现非门、与门、或门、与非门、与或非门、异或门
    // 与门
    andGate  And1  (.in(in[1:0]), .out(and_out)  );
    // 或门
    orGate   Or1   (.in(in[1:0]), .out(or_out)   );
    // 非门
    notGate  Not1  (.in(in[0]  ), .out(not_out)  );
    // 与非门
    nandGate Nand1 (.in(in[1:0]), .out(nand_out) );
    // 与或非门
    aoiGate  Aoi1  (.in(in[3:0]), .out(aoi_out)  );
    // 异或门
    xorGate  Xor1  (.in(in[1:0]), .out(xor_out_1));

    // * (2) 模块例化与非门实现异或门
    wire tmp1, tmp2;
    nandGate Nand2 (.in({ in[1], ~in[0]}), .out(tmp1)     );
    nandGate Nand3 (.in({~in[1],  in[0]}), .out(tmp2)     );
    nandGate Nand4 (.in({  tmp1,   tmp2}), .out(xor_out_2));

endmodule // Ex1
