`timescale 1ps/1ps
module gt_synchronizer (
	input wire init_clk,
	input wire rx_clk,
	input wire rst,
	input wire tx_good_tx_synced,
	input wire rx_good_rx_synced,
	output wire rst_init_synced,
	output wire rst_rx_synced,
	output wire tx_good_init_synced,
	output wire rx_good_init_synced
);
	reset_synchronizer rst_init_sync_inst(
		.clk_in(init_clk),
		.rst_in(rst),
		.rst_out(rst_init_synced)
	);
	reset_synchronizer rst_rx_sync_inst(
		.clk_in(rx_clk),
		.rst_in(rst),
		.rst_out(rst_rx_synced)
	);
	bit_synchronizer rx_good_init_sync_inst (
		.clk_in(init_clk),
		.i_in(tx_good_tx_synced),
		.o_out(tx_good_init_synced)
	);
	bit_synchronizer tx_good_init_sync_inst (
		.clk_in(init_clk),
		.i_in(rx_good_rx_synced),
		.o_out(rx_good_init_synced)
	);
endmodule
