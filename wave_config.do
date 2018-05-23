
onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -noupdate -divider -height 40 {TESTBENCH INTERFACE}

if [regexp {uart_tb/rst} [find signals uart_tb/rst]]                     {add wave -noupdate -format Logic -radix hexadecimal uart_tb/rst}
if [regexp {uart_tb/clk} [find signals uart_tb/clk]]                     {add wave -noupdate -format Logic -radix hexadecimal uart_tb/clk}

add wave -noupdate -divider -height 40 {TX INTERFACE}

if [regexp {uart_tb/txd} [find signals uart_tb/txd]] {add wave -noupdate -format Logic -radix hexadecimal uart_tb/txd}
if [regexp {uart_tb/txv} [find signals uart_tb/txv]] {add wave -noupdate -format Logic -radix hexadecimal uart_tb/txv}

add wave -noupdate -divider -height 40 {RX INTERFACE}

if [regexp {uart_tb/rxd} [find signals uart_tb/rxd]] {add wave -noupdate -format Logic -radix hexadecimal uart_tb/rxd}
if [regexp {uart_tb/rxv} [find signals uart_tb/rxv]] {add wave -noupdate -format Logic -radix hexadecimal uart_tb/rxv}

add wave -noupdate -divider -height 40 {SERIAL}

if [regexp {uart_tb/tx} [find signals uart_tb/tx]] {add wave -noupdate -format Logic -radix hexadecimal uart_tb/tx}
if [regexp {uart_tb/rx} [find signals uart_tb/rx]] {add wave -noupdate -format Logic -radix hexadecimal uart_tb/rx}

add wave -noupdate -divider -height 40 {UART RX LOGIC}

if [regexp {uart_tb/dut/uart_rx_inst/rx_val} [find signals uart_tb/dut/uart_rx_inst/rx_val]] {add wave -noupdate -format Logic -radix hexadecimal uart_tb/dut/uart_rx_inst/rx_val}
if [regexp {uart_tb/dut/uart_rx_inst/active} [find signals uart_tb/dut/uart_rx_inst/active]] {add wave -noupdate -format Logic -radix hexadecimal uart_tb/dut/uart_rx_inst/active}
if [regexp {uart_tb/dut/uart_rx_inst/rx_sync} [find signals uart_tb/dut/uart_rx_inst/rx_sync]] {add wave -noupdate -format Logic -radix hexadecimal uart_tb/dut/uart_rx_inst/rx_sync}
if [regexp {uart_tb/dut/uart_rx_inst/start} [find signals uart_tb/dut/uart_rx_inst/start]] {add wave -noupdate -format Logic -radix hexadecimal uart_tb/dut/uart_rx_inst/start}
if [regexp {uart_tb/dut/uart_rx_inst/rx_posedge} [find signals uart_tb/dut/uart_rx_inst/rx_posedge]] {add wave -noupdate -format Logic -radix hexadecimal uart_tb/dut/uart_rx_inst/rx_posedge}
if [regexp {uart_tb/dut/uart_rx_inst/rx_negedge} [find signals uart_tb/dut/uart_rx_inst/rx_negedge]] {add wave -noupdate -format Logic -radix hexadecimal uart_tb/dut/uart_rx_inst/rx_negedge}

add wave -noupdate -divider -height 40 {ARBITER INTERFACE}

if [regexp {uart_tb/dut/fifo_iv} [find signals uart_tb/dut/fifo_iv]] {add wave -noupdate -format Logic -radix hexadecimal uart_tb/dut/fifo_iv}
if [regexp {uart_tb/dut/fifo_i}  [find signals uart_tb/dut/fifo_i]]  {add wave -noupdate -format Logic -radix hexadecimal uart_tb/dut/fifo_i}
if [regexp {uart_tb/dut/fifo_r}  [find signals uart_tb/dut/fifo_r]]  {add wave -noupdate -format Logic -radix hexadecimal uart_tb/dut/fifo_r}
if [regexp {uart_tb/dut/fifo_o}  [find signals uart_tb/dut/fifo_o]]  {add wave -noupdate -format Logic -radix hexadecimal uart_tb/dut/fifo_o}
if [regexp {uart_tb/dut/fifo_f}  [find signals uart_tb/dut/fifo_f]]  {add wave -noupdate -format Logic -radix hexadecimal uart_tb/dut/fifo_f}
if [regexp {uart_tb/dut/fifo_e}  [find signals uart_tb/dut/fifo_e]]  {add wave -noupdate -format Logic -radix hexadecimal uart_tb/dut/fifo_e}

add wave -noupdate -divider -height 40 {MEMORY ARBITER INTERFACE}

if [regexp {uart_tb/dut/r_nw}   [find signals uart_tb/dut/r_nw]]  {add wave -noupdate -format Logic -radix hexadecimal uart_tb/dut/r_nw}
if [regexp {uart_tb/dut/v_i}    [find signals uart_tb/dut/v_i]]   {add wave -noupdate -format Logic -radix hexadecimal uart_tb/dut/v_i}
if [regexp {uart_tb/dut/a_i}    [find signals uart_tb/dut/a_i]]   {add wave -noupdate -format Logic -radix hexadecimal uart_tb/dut/a_i}
if [regexp {uart_tb/dut/d_i}    [find signals uart_tb/dut/d_i]]   {add wave -noupdate -format Logic -radix hexadecimal uart_tb/dut/d_i}
if [regexp {uart_tb/dut/v_o}    [find signals uart_tb/dut/v_o]]   {add wave -noupdate -format Logic -radix hexadecimal uart_tb/dut/v_o}
if [regexp {uart_tb/dut/a_o}    [find signals uart_tb/dut/a_o]]   {add wave -noupdate -format Logic -radix hexadecimal uart_tb/dut/a_o}
if [regexp {uart_tb/dut/d_o}    [find signals uart_tb/dut/d_o]]   {add wave -noupdate -format Logic -radix hexadecimal uart_tb/dut/d_o}

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
configure wave -namecolwidth 201
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
update
WaveRestoreZoom {0 ps} {20 us}
