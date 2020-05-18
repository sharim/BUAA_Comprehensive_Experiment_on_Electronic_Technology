// TODO: RS触发器、JK触发器和D触发器

module RS_flip_flop(
    input       clk  ,
    input       rst_n,
    input       set_n,

    output reg  Q    ,
    output wire Q_n
);

    assign Q_n = ~Q;

    always @(posedge clk or negedge rst_n or negedge set_n) begin
        case({rst_n, set_n})
            2'b00: Q <= Q   ;
            2'b01: Q <= 1'b0;
            2'b10: Q <= 1'b1;
            2'b11: Q <= 1'bx;
        endcase
    end

endmodule // RS_flip_flop

module JK_flip_flop(
    input       clk  ,
    input       rst_n,
    input       J    ,
    input       K    ,

    output reg  Q    ,
    output wire Q_n
);

    assign Q_n = ~Q;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) Q <= 1'b0       ;
        else        Q <= J&~Q | ~K&Q;
    end

endmodule // JK_flip_flop

module D_flip_flop(
    input       clk  ,
    input       rst_n,
    input       D    ,

    output reg  Q    ,
    output wire Q_n
);

    assign Q_n = ~Q;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) Q <= 1'b0;
        else        Q <= D   ;
    end

endmodule // D_flip_flop