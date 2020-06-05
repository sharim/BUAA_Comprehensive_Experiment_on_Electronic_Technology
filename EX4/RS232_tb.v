// testbench of RS232
`timescale 1ns/1ps

module RS232_tb();
    initial begin
        $dumpfile("RS232_tb.vcd");
        $dumpvars(0, RS232_tb);
    end
    // RS232 Parameters
    parameter PERIOD  = 20; // 1 / (20 * 10^-9) = 50Mhz
    parameter CLK_FRE = 50; // Mhz

    // RS232 Inputs
    reg       clk       = 0;
    reg       rst_n     = 0;
    reg       tx_enable = 0;
    reg [7:0] tx_data   = 0;
    reg       rx_enable = 1;

    // RS232 Outputs _1
    wire       tx_done_1 ;
    wire       tx_pin_1  ;
    wire       rx_error_1;
    wire       rx_done_1 ;
    wire [7:0] rx_data_1 ;

    // RS232 Outputs _2
    wire       tx_done_2 ;
    wire       tx_pin_2  ;
    wire       rx_error_2;
    wire       rx_done_2 ;
    wire [6:0] rx_data_2 ;

    initial begin
    forever #(PERIOD/2) clk = ~clk;
    end

    initial begin
        #(PERIOD*2) rst_n = 1;
    end

    // 8/N/1/115200
    RS232 #(
        .CLK_FRE     (CLK_FRE   ),
        .BAUD_RATE   (115200    ),
        .DATA_WIDTH  (8         ),
        .PARITY_MODE ("even"    ),
        .STOP_WIDTH  (1         )
    ) u_RS232_1 (
        .clk         (clk       ),
        .rst_n       (rst_n     ),
        .tx_enable   (tx_enable ),
        .tx_data     (tx_data   ),
        .rx_enable   (rx_enable ),
        .rx_pin      (tx_pin_1  ),

        .tx_done     (tx_done_1 ),
        .tx_pin      (tx_pin_1  ),
        .rx_error    (rx_error_1),
        .rx_done     (rx_done_1 ),
        .rx_data     (rx_data_1 )
    );

    // 7/E/1.5/57600
    RS232 #(
        .CLK_FRE     (CLK_FRE     ),
        .BAUD_RATE   (57600       ),
        .DATA_WIDTH  (7           ),
        .PARITY_MODE ("even"      ),
        .STOP_WIDTH  (1.5         )
    ) u_RS232_2 (
        .clk         (clk         ),
        .rst_n       (rst_n       ),
        .tx_enable   (tx_enable   ),
        .tx_data     (tx_data[7:1]),
        .rx_enable   (rx_enable   ),
        .rx_pin      (tx_pin_2    ),

        .tx_done     (tx_done_2   ),
        .tx_pin      (tx_pin_2    ),
        .rx_error    (rx_error_2  ),
        .rx_done     (rx_done_2   ),
        .rx_data     (rx_data_2   )
    );

    always @(tx_done_1) begin
        if (tx_done_1) tx_data   = $random;
    end

    initial begin
        #90000;
        tx_enable = 1'b1; #180000
        rx_enable = 1'b0; #90000
        $finish;
    end

endmodule
