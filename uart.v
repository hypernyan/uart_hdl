
`timescale 1ns / 1ps

module uart #
(                            
    parameter DATA_WIDTH      = 8,
    parameter STOP_BITS       = 1,
    parameter PARITY          = 0,
    parameter EVEN            = 1,
    parameter PRESCALER       = 16,
    parameter LATCH_TOLERANCE = 1
)
(
    input  wire       clk,
    input  wire       rst,

	input  wire       rx,
	output wire       tx,

	input  wire [7:0] txd,
	input  wire       txv,
	
	output wire [7:0] rxd,
	output wire       rxv,
	
	output wire       rdy,
	output wire       tx_active

);

assign rdy = ( ~tx_active && ~txv );

uart_rx #(
	.DATA_WIDTH      ( DATA_WIDTH  ),
	.STOP_BITS       ( STOP_BITS   ),
	.PARITY          ( PARITY      ),
	.EVEN            ( EVEN        ),
	.PRESCALER       ( PRESCALER   ),
	.LATCH_TOLERANCE ( LATCH_TOLERANCE ) )
uart_rx_inst (
	.clk      ( clk ),
	.rst      ( rst ),
	.rx       ( rx  ),
	.rxd      ( rxd ),
	.rxv      ( rxv )
);

uart_tx #(
	.DATA_WIDTH ( DATA_WIDTH  ),
	.STOP_BITS  ( STOP_BITS   ),
	.PARITY     ( PARITY      ),
	.EVEN       ( EVEN        ),
	.PRESCALER  ( PRESCALER   ) )
uart_tx_inst (
	.clk      ( clk ),
	.rst      ( rst ),
	.tx       ( tx  ),
	.txd      ( txd ),
	.txv      ( txv ),
	.active   ( tx_active )
);

endmodule
