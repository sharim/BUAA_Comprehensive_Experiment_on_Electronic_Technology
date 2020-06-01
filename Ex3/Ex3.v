`include "flipFlop.v"
`include "Counter.v"
`include "Register.v"


module Ex3(
    input         clk       ,
    input         rst_n     ,
    input         set_n     ,
    input  [1:0]  JK        ,
    input         D         ,
    input         reEnable  ,
    input  [1:0]  S         ,
    input  [1:0]  shiftIn   ,
    input  [3:0]  data      ,

    output [1:0] out_RS     ,
    output [1:0] out_JK     ,
    output [1:0] out_D      ,
    output [3:0] out_sync   ,
    output [3:0] out_async  ,
    output [3:0] out_re     ,
    output [3:0] out_reg    ,
    output       out_seq    ,
    output       out_seq_fsm
);

    RS_flip_flop u_RS_flip_flop (
        .rst_n (rst_n    ),
        .set_n (set_n    ),

        .Q     (out_RS[1]),
        .Q_n   (out_RS[0])
    );
    JK_flip_flop u_JK_flip_flop (
        .clk   (clk      ),
        .rst_n (rst_n    ),
        .J     (JK[1]    ),
        .K     (JK[0]    ),

        .Q     (out_JK[1]),
        .Q_n   (out_JK[0])
    );
    D_flip_flop u_D_flip_flop (
        .clk   (clk     ),
        .rst_n (rst_n   ),
        .D     (D       ),

        .Q     (out_D[1]),
        .Q_n   (out_D[0])
    );

    sync_counter u_sync_counter (
        .clk   (clk     ),
        .rst_n (rst_n   ),

        .out   (out_sync)
    );
    async_counter u_async_counter (
        .clk   (clk      ),
        .rst_n (rst_n    ),

        .out   (out_async)
    );
    reversible_counter u_reversible_counter (
        .clk      (clk     ),
        .rst_n    (rst_n   ),
        .reEnable (reEnable),

        .out      (out_re  )
    );

    bi_shift_register u_bi_shift_register (
        .clk               (clk       ),
        .rst_n             (rst_n     ),
        .S                 (S         ),
        .rightShift_in     (shiftIn[1]),
        .leftShift_in      (shiftIn[0]),
        .parallel_data_in  (data      ),

        .parallel_data_out (out_reg   )
    );
    sequence_generator u_sequence_generator (
        .clk   (clk    ),
        .rst_n (rst_n  ),

        .out   (out_seq)
    );
    sequence_generator_fsm u_sequence_generator_fsm (
        .clk  (clk        ),
        .rst_n(rst_n      ),

        .out  (out_seq_fsm)
    );

endmodule