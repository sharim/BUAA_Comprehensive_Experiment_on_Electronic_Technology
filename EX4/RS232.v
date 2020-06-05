module RS232
#(
    parameter CLK_FRE     = 50    , // clock frequency(Mhz)
	parameter BAUD_RATE   = 115200, // serial baud rate
    parameter DATA_WIDTH  = 8     , // width(5~8) of data to transmit
    parameter PARITY_MODE = "none", // none: no parity  even: even parity  odd: odd parity
    parameter STOP_WIDTH  = 1       // width(1 or 1.5 or 2) of stop bits
)
(
    // cloclk & reset
    input                   clk      , // clock input
    input                   rst_n    , // asynchronous reset input, low active
    // ports of transmitier
    input                   tx_enable, // enable transmitter
    input  [DATA_WIDTH-1:0] tx_data  , // data to transmit
    output                  tx_done  , // transmit done
    output                  tx_pin   , // serial data output
    // ports of receiver
    input                   rx_enable, // enable receiver
    input                   rx_pin   , // serial data input
    output                  rx_error , // received serial data is error(1: error, o: no error or none parity)
    output                  rx_done  , // received serial data is vaild
    output [DATA_WIDTH-1:0] rx_data    // received serial data
);

    UART_tx #(
        .CLK_FRE     (CLK_FRE    ),
        .BAUD_RATE   (BAUD_RATE  ),
        .DATA_WIDTH  (DATA_WIDTH ),
        .PARITY_MODE (PARITY_MODE),
        .STOP_WIDTH  (STOP_WIDTH )
    ) transmitter (
        .clk         (clk        ),
        .rst_n       (rst_n      ),

        .tx_enable   (tx_enable  ),
        .tx_data     (tx_data    ),

        .tx_done     (tx_done    ),
        .tx_pin      (tx_pin     )
    );

    UART_rx #(
        .CLK_FRE     (CLK_FRE    ),
        .BAUD_RATE   (BAUD_RATE  ),
        .DATA_WIDTH  (DATA_WIDTH ),
        .PARITY_MODE (PARITY_MODE),
        .STOP_WIDTH  (STOP_WIDTH )
    ) receiver (
        .clk         (clk        ),
        .rst_n       (rst_n      ),

        .rx_enable   (rx_enable  ),
        .rx_pin      (rx_pin     ),

        .rx_error    (rx_error   ),
        .rx_done     (rx_done    ),
        .rx_data     (rx_data    )
    );

endmodule // RS232