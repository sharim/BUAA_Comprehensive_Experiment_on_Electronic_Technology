// * 8-3编码器、 优先编码器

module encoder__8_to_3(
    input  [7:0] in,
    output [2:0] out
);

    assign out = {| in[7:4], | {in[7:6], in[3:2]}, | {in[7], in[5], in[3], in[1]}};

endmodule // 8-3线二进制编码器

module priorityEncoder__8_3(
    input      [7:0] in,
    output reg [2:0] out
);

    integer i;
    always @(in) begin: loop
        for (i = 7; i >= 0; i = i - 1) begin
            if (in[i] == 1) begin
                out = i;
                disable loop;
            end
        end
    end

endmodule // 8-3二进制优先编码器，优先级： in[7] -> in[0]

module priorityEncoder_74xx148(
    input            ST, // 使能输入
    input      [7:0] in, // 输入信号

    output reg [2:0] out, // 输出信号
    output reg       YEX, // 扩展端：“电路工作，有编码输入”
    output reg       YS   // 使能输出：“电路工作，但无编码输入”
);

    integer i;
    always @(ST or in) begin
        if (!ST) begin
            if(&in) begin
                {out, YEX, YS} = 5'b1_1110;
            end else begin: loop
                for (i = 0; i < 8; i = i + 1) begin
                    if (in[i] == 0) begin
                        {out, YEX, YS} = {i, 1'b0, 1'b1};
                        disable loop;
                    end
                end
            end
        end else begin
            {out, YEX, YS} = 5'b1_1111;
        end
    end

endmodule // 集成优先编码器：74xx148
