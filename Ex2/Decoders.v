// TODO: BCD-七段显示译码器

module decoder__3_8(
    input               S1,
    input            notS2,
    input            notS3,
    input      [2:0]     A,

    output reg [7:0]  notY
);

    always @(S1 or notS2 or notS3 or A) begin
        notY <= 8'b1111_1111;
        if (~(|{~S1, notS2, notS3})) notY[A] <= 1'b0;
    end

endmodule // 3-8线译码器

module decoder__BCD_SEVEN(
    input      [3:0] A,

    output reg [6:0] Y
);

    always @(A) begin
        case(A)
            4'b0000: Y <= 7'b000_0001;
            4'b0001: Y <= 7'b100_1111;
            4'b0010: Y <= 7'b001_0010;
            4'b0011: Y <= 7'b000_0110;
            4'b0100: Y <= 7'b100_1100;
            4'b0101: Y <= 7'b010_0100;
            4'b0110: Y <= 7'b010_0000;
            4'b0111: Y <= 7'b000_1111;
            4'b1000: Y <= 7'b000_0000;
            4'b1001: Y <= 7'b000_0100;
        endcase
    end

endmodule // BCD七段显示译码器
