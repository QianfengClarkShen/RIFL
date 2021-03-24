`timescale 1ns / 1ps

module gt_wrapper (
//clk and rst
	input wire gt_ref_clk_p,
	input wire gt_ref_clk_n,
	input wire init_clk,
	input wire rst,
//gt input pins
	input wire gt_rxp_in,
	input wire gt_rxn_in,
//gt loopback port
	input wire [2:0] gt_loopback_in,
//tx data interface
	input wire [127:0] tx_data,
//rx data interface
	output wire [127:0] rx_data,
//stats ports
	output wire rx_aligned,
	output wire rx_up,
//output clks
	output wire tx_clk,
	output wire rx_clk,
//gt output pins
	output wire gt_txp_out,
	output wire gt_txn_out
);

//clks
	wire gt_ref_clk;
	wire tx_gt_src_clk;
	wire tx_usr_clk_active;
	wire tx_usr_clk;
	wire rx_gt_src_clk;
	wire rx_usr_clk_active;
	wire rx_usr_clk;

//rsts
	wire bypass_tx_reset_gt;
	wire bypass_rx_reset_gt;
	wire rst_all_gt;
	wire rst_rx_datapath_gt;
	wire rst_tx_done_gt;
	wire rst_rx_done_gt;
	wire bypass_tx_done_gt;
	wire bypass_rx_done_gt;
	wire txpmaresetdone_out;
	wire txprgdivresetdone_out;
	wire rxpmaresetdone_out;
	wire tx_rst_gt;
	wire rx_rst_gt;
	wire rst_init_synced;
	wire rst_rx_synced;

//data
	wire [127:0] tx_data_gt;
	wire [127:0] rx_data_gt;
	wire [127:0] rx_data_aligned;

//control and status
	wire tx_good_tx_synced;
	wire rx_good_rx_synced;
	wire tx_good_init_synced;
	wire rx_good_init_synced;

//external clock buffer
	IBUFDS_GTE4 #(
		.REFCLK_EN_TX_PATH  (1'b0),
		.REFCLK_HROW_CK_SEL (2'b00),
		.REFCLK_ICNTL_RX	(2'b00)
	) gt_ref_inst (
		.I (gt_ref_clk_p),
		.IB (gt_ref_clk_n),
		.CEB (1'b0),
		.O (gt_ref_clk),
		.ODIV2 ()
	);

//internal clk buffer
	clock_buffer tx_clock_buffer (
		.src_clk(tx_gt_src_clk),
		.rst(tx_rst_gt),
		.usrclk(tx_usr_clk),
		.usrclk2(tx_clk),
		.usrclk_active(tx_usr_clk_active)
	);
	clock_buffer rx_clock_buffer (
		.src_clk(rx_gt_src_clk),
		.rst(rx_rst_gt),
		.usrclk(rx_usr_clk),
		.usrclk2(rx_clk),
		.usrclk_active(rx_usr_clk_active)
	);

//synchronizer
	gt_synchronizer gt_synchronizer_inst (
		.init_clk(init_clk),
		.rx_clk(rx_clk),
		.rst(rst),
		.tx_good_tx_synced(tx_good_tx_synced),
		.rx_good_rx_synced(rx_good_rx_synced),
		.tx_good_init_synced(tx_good_init_synced),
		.rx_good_init_synced(rx_good_init_synced),
		.rst_init_synced(rst_init_synced),
		.rst_rx_synced(rst_rx_synced)
	);

//datapath resets
	datapath_reset # (
		.COUNTER_WIDTH(20)
	) gt_all_reset_inst (
		.clk(init_clk),
		.rst(rst_init_synced),
		.channel_good(tx_good_init_synced),
		.rst_out(rst_all_gt)
	);

	datapath_reset # (
		.COUNTER_WIDTH(23)
	) rx_datapath_reset_inst (
		.clk(init_clk),
		.rst(rst_init_synced),
		.channel_good(rx_good_init_synced),
		.rst_out(rst_rx_datapath_gt)
	);

//rx aligner
	rx_aligner rx_aligner_inst (
		.clk(rx_clk),
		.rst(rst_rx_synced),
		.rxdata_unaligned_in(rx_data_gt),
		.rxdata_aligned_out(rx_data_aligned),
		.rx_aligned(rx_aligned),
		.rx_up(rx_up)
	);

	gtwizard_ultrascale gtwizard_ultrascale_inst (
		.gtyrxn_in								(gt_rxn_in),
		.gtyrxp_in								(gt_rxp_in),
		.gtytxn_out								(gt_txn_out),
		.gtytxp_out								(gt_txp_out),
		.gtwiz_buffbypass_tx_reset_in			(bypass_tx_reset_gt),
		.gtwiz_buffbypass_tx_start_user_in		(1'b0),
		.gtwiz_buffbypass_tx_done_out			(bypass_tx_done_gt),
		.gtwiz_buffbypass_tx_error_out			(),
		.gtwiz_buffbypass_rx_reset_in			(bypass_rx_reset_gt),
		.gtwiz_buffbypass_rx_start_user_in		(1'b0),
		.gtwiz_buffbypass_rx_done_out			(bypass_rx_done_gt),
		.gtwiz_buffbypass_rx_error_out			(),
		.gtwiz_reset_clk_freerun_in				(init_clk),
		.gtwiz_reset_all_in						(rst_init_synced | rst_all_gt),
		.gtwiz_reset_tx_pll_and_datapath_in		(1'b0),
		.gtwiz_reset_tx_datapath_in				(1'b0),
		.gtwiz_reset_rx_pll_and_datapath_in		(1'b0),
		.gtwiz_reset_rx_datapath_in				(rst_rx_datapath_gt),
		.gtwiz_reset_rx_cdr_stable_out			(),
		.gtwiz_reset_tx_done_out				(rst_tx_done_gt),
		.gtwiz_reset_rx_done_out				(rst_rx_done_gt),
		.gtwiz_userclk_tx_active_in				(tx_usr_clk_active),
		.txusrclk_in							(tx_usr_clk),
		.txusrclk2_in							(tx_clk),
		.txoutclk_out							(tx_gt_src_clk),
		.gtwiz_userclk_rx_active_in				(rx_usr_clk_active),
		.rxusrclk_in							(rx_usr_clk),
		.rxusrclk2_in							(rx_clk),
		.rxoutclk_out							(rx_gt_src_clk),
		.gtwiz_userdata_tx_in					(tx_data_gt),
		.gtwiz_userdata_rx_out					(rx_data_gt),
		.gtrefclk00_in							(gt_ref_clk),
		.qpll0outclk_out						(),
		.qpll0outrefclk_out						(),
		.loopback_in							(gt_loopback_in),
		.gtpowergood_out						(),
		.rxpmaresetdone_out						(rxpmaresetdone_out),
		.txpmaresetdone_out						(txpmaresetdone_out),
		.txprgdivresetdone_out					(txprgdivresetdone_out)
	);

	assign bypass_tx_reset_gt = ~tx_usr_clk_active;
	assign bypass_rx_reset_gt = ~rx_usr_clk_active | ~bypass_tx_done_gt;
	assign tx_rst_gt = ~(txpmaresetdone_out & txprgdivresetdone_out);
	assign rx_rst_gt = ~rxpmaresetdone_out;
	assign tx_good_tx_synced = rst_tx_done_gt & bypass_tx_done_gt;
	assign rx_good_rx_synced = rst_rx_done_gt & bypass_rx_done_gt & rx_aligned;

	//external
	assign tx_data_gt = tx_data;
	assign rx_data = rx_data_aligned;

endmodule
