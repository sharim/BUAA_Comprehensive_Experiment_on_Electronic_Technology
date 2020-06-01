// * 双向移位寄存器、序列信号发生器

module bi_shift_register(
    input            clk              ,
    input            rst_n            ,
    input      [1:0] S                ,
    input            rightShift_in    ,
    input            leftShift_in     ,
    input      [3:0] parallel_data_in ,

    output reg [3:0] parallel_data_out
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) parallel_data_out = 0;
        else begin
            case (S)
                2'b00: parallel_data_out <= parallel_data_out                      ; // 保持
                2'b01: parallel_data_out <= {rightShift_in, parallel_data_out[3:1]}; // 右移
                2'b10: parallel_data_out <= {parallel_data_out[2:0], leftShift_in }; // 左移
                2'b11: parallel_data_out <= parallel_data_in                       ; // 并行输入
            endcase
        end
    end

endmodule // 双向移位寄存器

module sequence_generator(
    input      clk  ,
    input      rst_n,

    output reg out
);
    reg [5:0] seq = 6'b010011;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) seq <= 6'b010011;
        else seq <= {seq[4:0], seq[5]};
    end

    always @(seq) out = seq[5];

endmodule // sequence_generator

module sequence_generator_fsm(
    input      clk  ,
    input      rst_n,

    output reg out
);

    parameter S0 = 6'b00_0001;
    parameter S1 = 6'b00_0010;
    parameter S2 = 6'b00_0100;
    parameter S3 = 6'b00_1000;
    parameter S4 = 6'b01_0000;
    parameter S5 = 6'b10_0000;

    reg [5:0] state     ;
    reg [5:0] next_state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) state <= S0;
        else        state <= next_state;
    end

    always @(*) begin
        if (!rst_n) next_state = S0;
        else begin
            case (state)
                S0     : next_state = S1;
                S1     : next_state = S2;
                S2     : next_state = S3;
                S3     : next_state = S4;
                S4     : next_state = S5;
                S5     : next_state = S0;
                default: next_state = S0;
            endcase
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) out <= 0;
        else begin
            case (state)
                S0: out <= 1'b0;
                S1: out <= 1'b1;
                S2: out <= 1'b0;
                S3: out <= 1'b0;
                S4: out <= 1'b1;
                S5: out <= 1'b1;
            endcase
        end
    end

endmodule // sequence_generator
