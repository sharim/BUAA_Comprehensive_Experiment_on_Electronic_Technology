module UART_rx
#(
    parameter CLK_FRE     = 50    , // clock frequency(Mhz)
	parameter BAUD_RATE   = 115200, // serial baud rate
    parameter DATA_WIDTH  = 8     , // width(<=16) of data to transmit
    parameter PARITY_MODE = "none", // none: no parity  even: even parity  odd: odd parity
    parameter STOP_WIDTH  = 1       // width(1 or 1.5 or 2) of stop bits
)
(
    input                       clk      , // clock input
    input                       rst_n    , // asynchronous reset input, low active
    input                       rx_enable, // enable receiver
    input                       rx_pin   , // serial data input
    output reg                  rx_error , // received serial data is error(1: error, o: no error or none parity)
    output reg                  rx_done  , // received serial data is vaild
    output reg [DATA_WIDTH-1:0] rx_data    // received serial data
);

    // calculates the clock cycle for baud rate
    localparam CYCLE = CLK_FRE * 100_0000 / BAUD_RATE;
    // state machine code
    localparam S_IDLE   = 5'b0_0001; // idle
    localparam S_START  = 5'b0_0010; // start bit
    localparam S_DATA   = 5'b0_0100; // data bits
    localparam S_PARITY = 5'b0_1000; // parity bit
    localparam S_STOP   = 5'b1_0000; // stop bits
    // width of counter regidter
    localparam CYCLE_CNT_WIDTH = width(CYCLE * STOP_WIDTH - 1);
    localparam BIT_CNT_WIDTH   = width(DATA_WIDTH - 1)        ;
    // state registers
    reg [4:0] state     ; // current state
    reg [4:0] next_state; // next state
    // counter register
    reg [CYCLE_CNT_WIDTH-1:0] cycle_cnt; // baud counter
    reg [BIT_CNT_WIDTH-1  :0] bit_cnt  ; // bit counter
    // data register
    reg                  rx_parity_bit ; // parity bit received
    reg [DATA_WIDTH-1:0] rx_data_latch ; // latch data to output
    // rx_pin edge register
    reg  rx_delay_1; // delay 1 clock for rx_pin
    reg  rx_delay_2; // delay 1 clock for rx_delay_1
    wire rx_negedge = &{~rx_delay_1, rx_delay_2}; // negedge of rx_pin
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) {rx_delay_1, rx_delay_2} <= 2'b0;
        else {rx_delay_1, rx_delay_2} <= {rx_pin, rx_delay_1};
    end

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
            if (rx_negedge && rx_enable) next_state = S_START;
            else                         next_state = S_IDLE ;
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
            if (cycle_cnt == (CYCLE * STOP_WIDTH) / 2 - 1) next_state = S_IDLE;
            else                                           next_state = S_STOP;
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
    always @(posedge clk or negedge rst_n) begin: FSM_LATCH__RX_DATA_LATCH
        if (!rst_n) rx_data_latch <= 0;
        else if (state == S_DATA && cycle_cnt == CYCLE / 2 - 1)
            rx_data_latch[bit_cnt] <= rx_pin;
        else rx_data_latch <= rx_data_latch;
    end

    always @(posedge clk or negedge rst_n) begin: FSM_LATCH__RX_PARITY_BIT
        if (!rst_n) rx_parity_bit <= 1'b1;
        else
            case (PARITY_MODE)
                "even", "odd": rx_parity_bit <= rx_pin;
                default      : rx_parity_bit <= 1'b1  ;
            endcase
    end
    // *-------------------- LATCH LOGIC: END --------------------* //

    // *------------------- OUTPUT LOGIC: START ------------------* //
    always @(posedge clk or negedge rst_n) begin: FSM_OUTPUT__RX_DONE
        if (!rst_n) rx_done <= 1'b0;
        else if (state == S_IDLE)
            if (rx_enable && rx_negedge) rx_done <= 1'b0;
            else                         rx_done <= 1'b1;
        else if (state == S_STOP && next_state != state)
            rx_done <= 1'b1;
    end

    always @(posedge clk or negedge rst_n) begin: FSM_OUTPUT__RX_ERROR
        if (!rst_n) rx_error <= 1'b0;
        else if (state == S_IDLE)
            if (rx_enable && rx_negedge) rx_error <= 1'b0;
            else rx_error <= parity(PARITY_MODE, rx_data_latch, rx_parity_bit);
        else if (state == S_STOP && next_state != state)
            rx_error <= parity(PARITY_MODE, rx_data_latch, rx_parity_bit);
    end

    always @(posedge clk or negedge rst_n) begin: FSM_OUTPUT__RX_DATA
        if (!rst_n) rx_data <= 'b0;
        else if (state == S_STOP && next_state != state)
            rx_data <= rx_data_latch;
    end
    // *------------------- OUTPUT LOGIC: END --------------------* //

    //* -------------------- FUNCTION: START --------------------- *//
    function integer width;
        input integer num;
        begin
            width = 0;
            while (num >> width) width = width +1;
        end
    endfunction

    function reg parity;
        input [4*8-1       :0] parity_mode;
        input [DATA_WIDTH-1:0] data       ;
        input                  parity_bit ;
        begin
            case (parity_mode)
                "even" : parity = ~(^{data, parity_bit});
                "odd"  : parity = ^{data, parity_bit}   ;
                default: parity = 1'b0                  ;
            endcase
        end
    endfunction
    //* -------------------- FUNCTION: START --------------------- *//

endmodule // UART_rx