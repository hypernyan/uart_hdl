`timescale 1 ns / 1 ps

module uart_tb ();

localparam RX_CLK_PERIOD = 1000/4;
localparam TX_CLK_PERIOD = 1000/(125/31);

reg clk_rx = 0;
reg clk_tx = 0;
reg rst = 1;

logic       tx;
logic       rx;
logic       rdy;
logic       txv = 0;
logic [7:0] txd = 0;
logic [7:0] rxd;

initial begin
	rst <= 1;
#24300
	rst <= 0;
#20100	
	txv = 1;
	txd = 8'hff;
#(TX_CLK_PERIOD*2)
	 txv <= 0;
end

uart dut (
	.clk_rx (clk_rx),
	.clk_tx (clk_tx),
	.rst (rst),
	
	.rx        (rx),
	.tx        (tx),
	
	.txd       (txd),
	.txv       (txv),
	
	.rxd       (rxd),
	.rxv       (rxv),
	
	.rdy       (rdy),
	.tx_active ()
);

defparam dut.DATA_WIDTH      = 8;
defparam dut.STOP_BITS       = 1;
defparam dut.PARITY          = 1;
defparam dut.EVEN            = 0;
defparam dut.PRESCALER       = 25;
defparam dut.LATCH_TOLERANCE = 7;

assign rx = tx;


always #RX_CLK_PERIOD clk_rx <= !clk_rx;
always #TX_CLK_PERIOD clk_tx <= !clk_tx;

endmodule
