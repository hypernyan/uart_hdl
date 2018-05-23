
module uart_tx #
(
    parameter DATA_WIDTH = 8,
    parameter STOP_BITS  = 1,
    parameter PARITY     = 1,
    parameter EVEN       = 1,
    parameter PRESCALER  = 15,
	parameter WIDTH = DATA_WIDTH + STOP_BITS + PARITY
)
(
    input wire                clk,
    input wire                rst,
	output reg                tx,
	input wire [DATA_WIDTH:0] txd,
	input wire                txv,
	output reg                active
);
	
reg           busy;
reg [$clog2(PRESCALER)-1:0]     psk_ctr;
reg [7:0]     bit_ctr;
reg [WIDTH:0] shiftreg;
reg           parity_bit;
reg           parity_en;

// tx is normally loaded out of a shift register, except the parity bit

always @ ( posedge clk ) begin
	if ( rst ) tx <= 1'b0;
	else tx <= PARITY ? ( active ? ( ( bit_ctr == WIDTH - STOP_BITS ) ? parity_bit : shiftreg[0] ) : 1'b1 ) : ( active ? ( shiftreg[0] ) : 1'b1 );
end

// parity is calculated for data only
always @ ( posedge clk ) begin
	if ( rst ) begin
		parity_en <= 1'b0;
	end
	else if ( PARITY ) begin
		if ( bit_ctr == 1 )              parity_en <= 1'b1;
		if ( bit_ctr == DATA_WIDTH + 1 ) parity_en <= 1'b0;
	end
end

// parity bit calculation

always @ ( posedge clk ) begin
	if ( rst ) begin
		parity_bit <= !EVEN;
	end
	else if ( active && PARITY ) begin 
		if ( psk_ctr == PRESCALER - 1 ) parity_bit <= ( parity_en && tx ) ? !parity_bit : parity_bit;
	end
	else parity_bit <= !EVEN;
end

// shifting data out when prescaler counter reaches prescaler value
always @ ( posedge clk ) begin
	if ( rst ) begin
		shiftreg <= 0;
		bit_ctr  <= 0;
	end
	else begin
		if ( txv && !active ) begin // preload data to shiftreg
			shiftreg[0]                              <= 1'b0; // start bit
			shiftreg[WIDTH-STOP_BITS-PARITY:1] <= txd;
			shiftreg[WIDTH:WIDTH-STOP_BITS+1]  <= {STOP_BITS{1'b1}};
		end
		if ( active && psk_ctr == PRESCALER - 1 ) begin
			shiftreg <= shiftreg >> 1;
			bit_ctr  <= bit_ctr + 1;
		end
		if ( !active ) bit_ctr <= 0; // if by some reason active state is deasserted ( EOF or error ), reset the bit counter
	end
end

always @ ( posedge clk ) begin
	if ( rst ) begin
		active <= 1'b0;
	end
	else begin
		if ( txv && !active ) active <= 1'b1; // start 
		if ( bit_ctr == WIDTH && psk_ctr == PRESCALER - 1 ) active <= 1'b0; // stop
	end
end

always @ ( posedge clk ) begin
	if ( rst ) begin
		psk_ctr <= 0;
	end
	else if ( active ) begin
		if ( psk_ctr == PRESCALER - 1 ) begin
			psk_ctr <= 0;
		end
		else begin
			psk_ctr <= psk_ctr + 1;
		end
	end
	else psk_ctr <= 0;
end

endmodule