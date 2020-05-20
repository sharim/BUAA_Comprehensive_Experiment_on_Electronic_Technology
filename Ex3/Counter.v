// * 同步计数器、异步计数器、可逆计数器

module sync_counter(
    input            clk  ,
    input            rst_n,

    output reg [3:0] out
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) out <= 0      ;
        else        out <= out + 1;
    end

endmodule // 16进制同步计数器

module async_counter(
    input            clk  ,
    input            rst_n,

    output reg [3:0] out
);

    reg div2, div4, div8, div16;

    always @(negedge rst_n)
        {div2, div4, div8, div16, out} <= 0;

    always @(negedge clk  ) div2  <= rst_n? ~div2 :0;
    always @(negedge div2 ) div4  <= rst_n? ~div4 :0;
    always @(negedge div4 ) div8  <= rst_n? ~div8 :0;
    always @(negedge div8 ) div16 <= rst_n? ~div16:0;

    always @(*) out = {div16, div8, div4, div2};

endmodule // 16进制异步计数器

module reversible_counter(
    input            clk     ,
    input            rst_n   ,
    input            reEnable,

    output reg [3:0] out
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) out <= 0      ;
        else begin
            if (reEnable) out <= out? out-1:4'b1001;
            else          out <= (out == 4'b1001)? 0:out+1;
        end
    end

endmodule // 10进制可逆计数器
