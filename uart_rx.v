
`timescale 1ns / 1ps

module uart_rx #
(
    parameter DATA_WIDTH = 8,      // actual data length 
    parameter STOP_BITS  = 1,      // number of stop bits ( can be any number )
    parameter PARITY     = 1,      // enable parity?
    parameter EVEN       = 1,      // '1' for even, '0' for odd
    parameter PRESCALER  = 15,     // prescaler. symbol frequency is calculated as clk/PRESCALER. can be any number >=4
    parameter LATCH_TOLERANCE = 1  // set +/- tolerance where line transitions are acceptable (measured in clk ticks)
)
(
    input wire clk,
    input wire rst,
	input wire rx,
	
	output reg [DATA_WIDTH-1:0] rxd,
	output reg                  rxv
);

parameter WIDTH = DATA_WIDTH+STOP_BITS+PARITY;

reg [$clog2(PRESCALER)-1:0] psk_ctr;

reg           rx_prev; 
reg           active;   // rx active signal
reg           rx_val;   // when high, RX level change is expected
reg [WIDTH:0] shiftreg; // the shift register where incoming data is loaded, including parity and stop bits
reg [7:0]     bit_ctr;
reg           start;     // 1 clock tick long signal corresponding to a start condition
reg           rx_sync;  // syncronyzed rx signal ( this is actually used ) ,
reg           parity_en;
reg           parity_bit;

// input synchronyzer

reg rx_sync1;
always @ (posedge clk) begin
	rx_sync1 <= rx;
	rx_sync  <= rx_sync1;
end

// previous rx line state
always @ (posedge clk) begin
	if (rst) rx_prev <= 0;
	else rx_prev <= rx_sync;
end

// latch data into shift reg
always @ (posedge clk) begin
	if (rst) begin 
		bit_ctr  <= 0;
		shiftreg <= 0;
	end
	else begin 
		if (active && (psk_ctr == LATCH_TOLERANCE)) begin // latch data when rx node should be stable
			shiftreg [WIDTH:0] <= {rx_sync, shiftreg[WIDTH:1]};
			bit_ctr <= bit_ctr + 1; // increment bit counter every write to shiftreg
		end
		if (!active) begin 
			bit_ctr  <= 0; // if by some reason active state is deasserted (end or error), reset the bit counter
			shiftreg <= 0;
		end
	end
end

// generate rx_val to set limits on where rx state transactions may occur
always @ (posedge clk) begin
	if (rst) begin 
		rx_val <= 1'b0;
	end
	else if (( psk_ctr == PRESCALER-LATCH_TOLERANCE-1)) begin // tolerance left of expected transaction time
		rx_val <= 1'b1;
	end
	else if   (psk_ctr == LATCH_TOLERANCE) begin // tolerance right of expected transaction time
		rx_val <= 1'b0;
	end
end

// parity is calculated for data only

always @ (posedge clk) begin
	if (rst) begin
		parity_en <= 1'b0;
	end
	else if (PARITY) begin
		if (bit_ctr == 1)              parity_en <= 1'b1;
		if (bit_ctr == DATA_WIDTH + 1) parity_en <= 1'b0;
	end
end


always @ (posedge clk) begin
	if (rst) begin
		parity_bit <= !EVEN;
	end
	else if (active && PARITY) begin
		if (psk_ctr == LATCH_TOLERANCE) parity_bit <= ( parity_en && rx_sync ) ? !parity_bit : parity_bit;
	end
	else parity_bit <= !EVEN;
end

// 'active' signal generation
wor error;
always @ (posedge clk) begin
	if (rst) active <= 0;
	else begin 
		if (start) active <= 1;                // set to '1' if start condition detected
		if (error) active <= 0;                // set to '0' in case of an error
		if (bit_ctr == WIDTH && psk_ctr == LATCH_TOLERANCE) active <= 0; // set to '0' when rx is done
	end
end

reg rx_negedge;
reg rx_posedge;

always @ (posedge clk) rx_posedge <= (!rx_prev && rx_sync);
always @ (posedge clk) rx_negedge <= (rx_prev && !rx_sync);

// if rx is active and rx line transaction was detected outside of rx_val range, it's considered as a line glitch
assign error = rx_negedge && !rx_val && active;
assign error = rx_posedge && !rx_val && active;

// start condition
always @ (posedge clk) start <= (rx_prev && !rx_sync && !active);

// final stage: latch data to data output reg ( checking that start, parity and stop bits are ok )
always @ (posedge clk) begin
	if (rst) begin
		rxd[7:0] <= 8'h00;
		rxv      <= 1'b0;
	end
	else if (
		(bit_ctr == WIDTH+1) &&                                           // bit counter reached endpoint
		(shiftreg[ 0 ] == 0) &&                                             // start bit was ok
		(&shiftreg [WIDTH:WIDTH-STOP_BITS+1] == 1) &&              // all stop bits are ok
		(PARITY ? (parity_bit == shiftreg[WIDTH-STOP_BITS]) : 1) && // parity was also ok
		!active) begin                                               
			rxd[7:0] <= shiftreg [8:1];
			rxv      <= 1'b1;
	end
	else rxv <= 1'b0;
end

// simple prescaler counter 
always @ (posedge clk) begin
	if (rst) begin
		psk_ctr <= 0;
	end
	else if (active) begin
		if (( psk_ctr == PRESCALER - 1) || start) begin
			psk_ctr <= 0;
		end
		else begin
			psk_ctr <= psk_ctr + 1;
		end
	end
	else psk_ctr <= 0;
end

endmodule