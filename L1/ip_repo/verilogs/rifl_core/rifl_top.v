`timescale 1ns / 1ps

module rifl #
(
	parameter ENABLE_GT_LOOPBACK = 0
)
(
//clk and rst
	input wire gt_ref_clk_p,
	input wire gt_ref_clk_n,
	input wire init_clk,
	input wire gt_rst,
	input wire rifl_rst,
//gt input pins
	input wire gt_rxp_in,
	input wire gt_rxn_in,
//optional gt loopback port (not recommend)
	input wire [2:0] gt_loopback_in,
//tx AXI4-Stream interface
	input wire [111:0] s_axis_tdata,
	input wire [13:0] s_axis_tkeep,
	input wire s_axis_tlast,
	input wire s_axis_tvalid,
	output wire s_axis_tready,
//rx AXI4-Stream interface
	output wire [111:0] m_axis_tdata,
	output wire [13:0] m_axis_tkeep,
	output wire m_axis_tlast,
	output wire m_axis_tvalid,
//stats ports
	output wire tx_up,
	output wire rx_up,
	output wire rx_misalign_captured,
	output wire rx_misalign_corrected,
	output wire rx_error_captured,
	output wire rx_error_corrected,
	output wire [31:0] rx_misalign_captured_cnt,
	output wire [31:0] rx_misalign_corrected_cnt,
	output wire [31:0] rx_error_captured_cnt,
	output wire [31:0] rx_error_corrected_cnt,
//output clks
	output wire tx_clk,
	output wire rx_clk,
//output rsts
	output wire tx_rst,
	output wire rx_rst,
//gt output pins
	output wire gt_txp_out,
	output wire gt_txn_out
);

//rsts
	wire rifl_rst_init_synced;
	wire rifl_rst_tx_synced;
	wire rifl_rst_rx_synced;

//data 
	wire [127:0] tx_data_gt;
	wire [127:0] rx_data_gt;
	wire [115:0] tx_int_data;
	wire [115:0] rx_int_data;

//control and status
	wire [2:0] gt_loopback_int;
	//init clk domain
	wire tx_up_init_synced;
	wire rx_aligned_rx_synced;
	wire rx_up_init_synced;
	wire rx_error_init_synced;
	//tx clk domain
	wire tx_up_tx_synced;
	wire rx_up_tx_synced;
	wire rx_error_tx_synced;
	wire remote_pause_req_tx_synced;
	wire remote_retrans_req_tx_synced;
	//rx clk domain
	wire rx_up_rx_synced;
	wire rx_error_rx_synced;
	wire remote_pause_req_rx_synced;
	wire remote_retrans_req_rx_synced;
	wire rx_int_valid;

	rifl_synchronizer rifl_synchronizer_inst (
		.init_clk(init_clk),
		.tx_clk(tx_clk),
		.rx_clk(rx_clk),
		.rifl_rst(rifl_rst),
		.rx_up_rx_synced(rx_up_rx_synced),
		.tx_up_tx_synced(tx_up_tx_synced),
		.rx_error_rx_synced(rx_error_rx_synced),
		.remote_pause_req_rx_synced(remote_pause_req_rx_synced),
		.remote_retrans_req_rx_synced(remote_retrans_req_rx_synced),
		.rifl_rst_init_synced(rifl_rst_init_synced),
		.rifl_rst_tx_synced(rifl_rst_tx_synced),
		.rifl_rst_rx_synced(rifl_rst_rx_synced),
		.tx_up_init_synced(tx_up_init_synced),
		.rx_up_init_synced(rx_up_init_synced),
		.rx_error_init_synced(rx_error_init_synced),
		.rx_up_tx_synced(rx_up_tx_synced),
		.rx_error_tx_synced(rx_error_tx_synced),
		.remote_pause_req_tx_synced(remote_pause_req_tx_synced),
		.remote_retrans_req_tx_synced(remote_retrans_req_tx_synced)
	);

	tx_axis_helper tx_axis_helper_inst (
		.tx_tdata(s_axis_tdata),
		.tx_tkeep(s_axis_tkeep),
		.tx_tlast(s_axis_tlast),
		.tx_int_data(tx_int_data)
	);

	rifl_tx rifl_tx_inst (
		.clk(tx_clk),
		.rst(rifl_rst_tx_synced),
		.data_in(tx_int_data),
		.valid_in(s_axis_tvalid),
		.rx_error(rx_error_tx_synced),
		.rx_up(rx_up_tx_synced),
		.remote_pause_req(remote_pause_req_tx_synced),
		.remote_retrans_req(remote_retrans_req_tx_synced),
		.tx_up(tx_up_tx_synced),
		.tx_ready(s_axis_tready),
		.data_out(tx_data_gt)
	);

	rx_axis_helper rx_axis_helper (
		.rx_int_data(rx_int_data),
		.rx_int_valid(rx_int_valid),
		.rx_tdata(m_axis_tdata),
		.rx_tkeep(m_axis_tkeep),
		.rx_tlast(m_axis_tlast),
		.rx_valid(m_axis_tvalid)
	);

	rifl_rx rifl_rx_inst (
		.clk(rx_clk),
		.rst(rifl_rst_rx_synced),
		.data_in(rx_data_gt),
		.rx_aligned(rx_aligned_rx_synced),
		.rx_up(rx_up_rx_synced),
		.rx_error(rx_error_rx_synced),
		.remote_pause_req(remote_pause_req_rx_synced),
		.remote_retrans_req(remote_retrans_req_rx_synced),
		.data_out(rx_int_data),
		.valid_out(rx_int_valid)
	);

	rifl_stats rifl_stats_inst (
		.clk(init_clk),
		.rst(rifl_rst_init_synced),
		.rx_up(rx_up_init_synced),
		.rx_error(rx_error_init_synced),
		.rx_misalign_captured(rx_misalign_captured),
		.rx_misalign_corrected(rx_misalign_corrected),
		.rx_error_captured(rx_error_captured),
		.rx_error_corrected(rx_error_corrected),
		.rx_misalign_captured_cnt(rx_misalign_captured_cnt),
		.rx_misalign_corrected_cnt(rx_misalign_corrected_cnt),
		.rx_error_captured_cnt(rx_error_captured_cnt),
		.rx_error_corrected_cnt(rx_error_corrected_cnt)
	);

	gt_wrapper gt_wrapper (
		.gt_ref_clk_p(gt_ref_clk_p),
		.gt_ref_clk_n(gt_ref_clk_n),
		.init_clk(init_clk),
		.rst(gt_rst),
		.gt_rxp_in(gt_rxp_in),
		.gt_rxn_in(gt_rxn_in),
		.gt_loopback_in(gt_loopback_int),
		.tx_data(tx_data_gt),
		.rx_data(rx_data_gt),
		.rx_aligned(rx_aligned_rx_synced),
		.rx_up(rx_up_rx_synced),
		.tx_clk(tx_clk),
		.rx_clk(rx_clk),
		.gt_txp_out(gt_txp_out),
		.gt_txn_out(gt_txn_out)
	);
	assign tx_up = tx_up_init_synced;
	assign rx_up = rx_up_init_synced;
	assign tx_rst = rifl_rst_tx_synced;
	assign rx_rst = rifl_rst_rx_synced;
	if (ENABLE_GT_LOOPBACK)
		assign gt_loopback_int = gt_loopback_in;
	else
		assign gt_loopback_int = 3'b000;

endmodule
