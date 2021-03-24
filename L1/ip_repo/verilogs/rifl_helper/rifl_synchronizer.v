`timescale 1ps/1ps
module rifl_synchronizer (
	input wire init_clk,
	input wire tx_clk,
	input wire rx_clk,
	input wire rifl_rst,
	input wire rx_up_rx_synced,
	input wire tx_up_tx_synced,
	input wire rx_error_rx_synced,
	input wire remote_pause_req_rx_synced,
	input wire remote_retrans_req_rx_synced,
	output wire rifl_rst_init_synced,
	output wire rifl_rst_tx_synced,
	output wire rifl_rst_rx_synced,
	output wire rx_up_init_synced,
	output wire tx_up_init_synced,
	output wire rx_error_init_synced,
	output wire rx_up_tx_synced,
	output wire rx_error_tx_synced,
	output wire remote_pause_req_tx_synced,
	output wire remote_retrans_req_tx_synced
);

	reset_synchronizer rifl_rst_init_sync_inst(
		.clk_in(init_clk),
		.rst_in(rifl_rst),
		.rst_out(rifl_rst_init_synced)
	);
	reset_synchronizer rifl_rst_tx_sync_inst(
		.clk_in(tx_clk),
		.rst_in(rifl_rst),
		.rst_out(rifl_rst_tx_synced)
	);
	reset_synchronizer rifl_rst_rx_sync_inst(
		.clk_in(rx_clk),
		.rst_in(rifl_rst),
		.rst_out(rifl_rst_rx_synced)
	);

	bit_synchronizer rx_up_init_sync_inst (
		.clk_in(init_clk),
		.i_in(rx_up_rx_synced),
		.o_out(rx_up_init_synced)
	);
	bit_synchronizer tx_up_init_sync_inst (
		.clk_in(init_clk),
		.i_in(tx_up_tx_synced),
		.o_out(tx_up_init_synced)
	);
	bit_synchronizer rx_error_init_sync_inst (
		.clk_in(init_clk),
		.i_in(rx_error_rx_synced),
		.o_out(rx_error_init_synced)
	);
	bit_synchronizer rx_up_tx_sync_inst (
		.clk_in(tx_clk),
		.i_in(rx_up_rx_synced),
		.o_out(rx_up_tx_synced)
	);
	bit_synchronizer rx_error_tx_sync_inst (
		.clk_in(tx_clk),
		.i_in(rx_error_rx_synced),
		.o_out(rx_error_tx_synced)
	);
	bit_synchronizer pause_tx_sync_inst (
		.clk_in(tx_clk),
		.i_in(remote_pause_req_rx_synced),
		.o_out(remote_pause_req_tx_synced)
	);
	bit_synchronizer retrans_tx_sync_inst (
		.clk_in(tx_clk),
		.i_in(remote_retrans_req_rx_synced),
		.o_out(remote_retrans_req_tx_synced)
	);

endmodule
