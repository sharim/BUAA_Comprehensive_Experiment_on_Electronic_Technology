`include "Gates.v"

module Ex1(input [3:0] in,
           output [5:0] out);
    // 与门
    andGate And1(.in(in[1:0]), .out(out[5]));
    // 或门
    orGate  Or1 (.in(in[1:0]), .out(out[4]));
    // 非门
    notGate Not1(.in(in[0]), .out(out[3]));
    // 与非门
    nandGate Nand1(.in(in[1:0]), .out(out[2]));
    // 与或非门
    aoiGate Aoi1(.in(in[3:0]), .out(out[1]));
    // 异或门
    xorGate Xor1(.in(in[1:0]), .out(out[0]));
endmodule // Ex1
