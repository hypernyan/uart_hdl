`timescale 1 ns / 1 ps

module uart_tb ();

reg clk = 0;
reg rst = 1;

logic       tx;
logic       rx;
logic       rdy;
logic       txv = 0;
logic [7:0] txd = 0;
logic [7:0] rxd;

initial begin
	rst <= 1;
#243
	rst <= 0;
#201	
	txv = 1;
	txd = 8'h3a;
#10 
	 txv <= 0;
end

uart dut (
	.clk (clk),
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
defparam dut.PRESCALER       = 16;
defparam dut.LATCH_TOLERANCE = 2;

assign rx = tx;


always #5 clk <= !clk;

endmodule
