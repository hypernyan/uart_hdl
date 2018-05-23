module uart_half_duplex (
	output logic uart_rx, // Принятые данные
	input  logic uart_tx, // Данные на передачу
	input  logic uart_tx_active, // UART передаёт данные]
	
	output logic rs485_txon,    // Сигнал TXON для драйвера
	inout  wire  rs485_txrx      // Данные к/от драйвера. полудуплексный режим
);

 
endmodule
