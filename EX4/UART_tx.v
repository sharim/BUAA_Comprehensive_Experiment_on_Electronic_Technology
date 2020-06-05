module UART_tx
#(
    parameter CLK_FRE     = 50    , // clock frequency(Mhz)
	parameter BAUD_RATE   = 115200, // serial baud rate
    parameter DATA_WIDTH  = 8     , // width(5~8) of data to transmit
    parameter PARITY_MODE = "none", // none: no parity  even: even parity  odd: odd parity
    parameter STOP_WIDTH  = 1       // width(1 or 1.5 or 2) of stop bits
)
(
    input                       clk      , // clock input
    input                       rst_n    , // asynchronous reset input, low active
    input                       tx_enable, // enable transmitter
    input      [DATA_WIDTH-1:0] tx_data  , // data to transmit
    output reg                  tx_done  , // transmit done
    output                      tx_pin     // serial data output
);

    // calculates the clock cycle for baud rate
    localparam CYCLE = CLK_FRE * 100_0000 / BAUD_RATE;
    // state machine code
    localparam S_IDLE   = 5'b0_0001; // state: idle
    localparam S_START  = 5'b0_0010; // state: start bit
    localparam S_DATA   = 5'b0_0100; // state: data bits
    localparam S_PARITY = 5'b0_1000; // state: parity bit
    localparam S_STOP   = 5'b1_0000; // state: stop bits
    // // // width of counter regidter
    // // localparam CYCLE_CNT_WIDTH = width(CYCLE * STOP_WIDTH - 1);
    // // localparam BIT_CNT_WIDTH   = width(DATA_WIDTH - 1)        ;
    // state registers
    reg [4:0] state     ; // current state
    reg [4:0] next_state; // next state
    // counter register
    // // reg [CYCLE_CNT_WIDTH-1:0] cycle_cnt; // baud counter
    // // reg [BIT_CNT_WIDTH-1  :0] bit_cnt  ; // bit counter
    reg [15:0] cycle_cnt; // baud counter(max: 65535)
    reg [ 2:0] bit_cnt  ; // bit counter (max: 7)
    // data register
    reg                  tx_parity_bit; // parity bit to transmit
    reg [DATA_WIDTH-1:0] tx_data_latch; // latch data to transmit
    reg                  tx_reg       ; // serial data output

    assign tx_pin = tx_reg; // serial data output

    // ************************************************************ //
    // *                        FSM: START                        * //
    // ************************************************************ //

    // *------------------- STATE LOGIC: START -------------------* //
    always @(posedge clk or negedge rst_n) begin: FSM_STATE__STATE_TRANSITION
        if (!rst_n) state <= S_IDLE    ;
        else        state <= next_state;
    end

    always @(*) begin: FSM_STATE__NEXT_STATE_DECODE
        case (state)
        S_IDLE:
            if (tx_enable == 1'b1) next_state = S_START;
            else                   next_state = S_IDLE ;
        S_START:
            if (cycle_cnt == CYCLE - 1) next_state = S_DATA ;
            else                        next_state = S_START;
        S_DATA:
            if (cycle_cnt == CYCLE - 1 && bit_cnt == DATA_WIDTH - 1)
                if (PARITY_MODE == "none") next_state = S_STOP  ; // no parity
                else                       next_state = S_PARITY; // parity
            else
                next_state = S_DATA;
        S_PARITY:
            if (cycle_cnt == CYCLE - 1) next_state = S_STOP  ;
            else                        next_state = S_PARITY;
        S_STOP:
            if (cycle_cnt == CYCLE * STOP_WIDTH - 1) next_state = S_IDLE;
            else                                     next_state = S_STOP;
        default:
            next_state = S_IDLE;
        endcase
    end
    // *-------------------- STATE LOGIC: END --------------------* //

    // *------------------ COUNTER LOGIC: START ------------------* //
    always @(posedge clk or negedge rst_n) begin: FSM_COUNTER__CYCLE_COUNTER
        if (!rst_n) cycle_cnt <= 'b0;
        else if (next_state != state || (state == S_DATA && cycle_cnt == CYCLE - 1))
            cycle_cnt <= 0;
        else cycle_cnt <= cycle_cnt + 1;
    end

    always @(posedge clk or negedge rst_n) begin: FSM_COUNTER__BIT_COUNTER
        if (!rst_n) bit_cnt <= 0;
        else if (state == S_DATA)
            if (cycle_cnt == CYCLE - 1) bit_cnt <= bit_cnt + 1;
            else                        bit_cnt <= bit_cnt    ;
        else bit_cnt <= 0;
    end
    // *------------------- COUNTER LOGIC: END -------------------* //

    // *------------------- LATCH LOGIC: START -------------------* //
    always @(posedge clk or negedge rst_n) begin: FSM_LATCH__TX_DATA_LATCH
        if (!rst_n) tx_data_latch <= 0;
        else if (state == S_IDLE && tx_enable) tx_data_latch <= tx_data;
    end

    always @(posedge clk or negedge rst_n) begin: FSM_LATCH__TX_PARITY_BIT
        if (!rst_n) tx_parity_bit <= 1'd1;
        else
            case (PARITY_MODE)
                "even" : tx_parity_bit <= ^tx_data_latch   ;
                "odd"  : tx_parity_bit <= ~(^tx_data_latch);
                default: tx_parity_bit <= 1'd1           ;
            endcase
    end
    // *-------------------- LATCH LOGIC: END --------------------* //

    // *------------------ OUTPUT LOGIC: START -------------------* //
    always @(posedge clk or negedge rst_n) begin: FSM_OUTPUT__TX_DONE
        if (!rst_n) tx_done <= 1'b0;
        else if (state == S_IDLE)
            if (tx_enable) tx_done = 1'b0;
            else           tx_done = 1'b1;
        else if (state == S_STOP && cycle_cnt == CYCLE * STOP_WIDTH - 1)
            tx_done <= 1;
    end

    always @(posedge clk or rst_n) begin: FSM_OUTPUT__TX_REG
        if (!rst_n) tx_reg <= 1'b1;
        else
            case (state)
                S_IDLE  : tx_reg <= 1'b1                  ;
                S_START : tx_reg <= 1'b0                  ;
                S_DATA  : tx_reg <= tx_data_latch[bit_cnt];
                S_PARITY: tx_reg <= tx_parity_bit        ;
                S_STOP  : tx_reg <= 1'b1                  ;
            endcase
    end
    // *------------------- OUTPUT LOGIC: END --------------------* //

    // ************************************************************ //
    // *                         FSM: END                         * //
    // ************************************************************ //

    //* -------------------- FUNCTION: START --------------------- *//
    // // function integer width;
    // // input integer num;
    // //     begin
    // //         width = 0;
    // //         while (num >> width) width = width +1;
    // //     end
    // // endfunction
    //* -------------------- FUNCTION: START --------------------- *//

endmodule // UART_tx