module Parity
#(
    parameter DATA_WIDTH  = 8, // rx/tx data width
    parameter PARITY_MODE = 1  // 1: even parity  2: odd parity
)
(
    input      [DATA_WIDTH-1:0] data      ,
    output reg                  parity_bit
);

    wire even_parity_bit = ^data           ;
    wire odd_parity_bit  = ~even_parity_bit;

    always @(*) begin
        if (PARITY_MODE == 1) parity_bit = even_parity_bit;
        else                  parity_bit = odd_parity_bit ;
    end

endmodule // Parity