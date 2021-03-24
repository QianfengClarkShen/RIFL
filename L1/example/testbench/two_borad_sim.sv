`timescale 1ps / 1ps
//bit error control
`define INJ_BIT_ERROR
//alginment error control
`define INJ_ALIGN_ERROR
module tb();

//first board
	reg init_clk_0;
	reg gt_refclk_p_0;
	reg gt_refclk_n_0;
	reg gt_rst_0;
	reg rifl_rst_0;
	reg error_bit_0;
	reg align_switch_0;
	wire send_done_0;
	wire check_result_0;
	wire check_result_valid_0;

	wire [111:0] m_axis_tdata_0;
	wire [13:0] m_axis_tkeep_0;
	wire m_axis_tlast_0;
	wire m_axis_tvalid_0;
	wire [111:0] s_axis_tdata_0;
	wire [13:0] s_axis_tkeep_0;
	wire s_axis_tlast_0;
	wire s_axis_tready_0;
	wire s_axis_tvalid_0;

	reg gt_rxn_in_0;
	reg gt_rxp_in_0;
	wire gt_txn_out_0;
	wire gt_txp_out_0;
	wire rx_up_0;
	wire tx_up_0;
	wire rx_clk_0;
	wire tx_clk_0;

	wire rx_error_captured_0;
	wire [31:0] rx_error_captured_cnt_0;
	wire rx_error_corrected_0;
	wire [31:0] rx_error_corrected_cnt_0;
	wire rx_misalign_captured_0;
	wire [31:0] rx_misalign_captured_cnt_0;
	wire rx_misalign_corrected_0;
	wire [31:0] rx_misalign_corrected_cnt_0;

//second board
	reg init_clk_1;
	reg gt_refclk_p_1;
	reg gt_refclk_n_1;
	reg gt_rst_1;
	reg rifl_rst_1;
	reg error_bit_1;
	reg align_switch_1;

	wire send_done_1;
	wire check_result_1;
	wire check_result_valid_1;

	wire [111:0] m_axis_tdata_1;
	wire [13:0] m_axis_tkeep_1;
	wire m_axis_tlast_1;
	wire m_axis_tvalid_1;
	wire [111:0] s_axis_tdata_1;
	wire [13:0] s_axis_tkeep_1;
	wire s_axis_tlast_1;
	wire s_axis_tready_1;
	wire s_axis_tvalid_1;

	reg gt_rxn_in_1;
	reg gt_rxp_in_1;
	wire gt_txn_out_1;
	wire gt_txp_out_1;
	wire rx_up_1;
	wire tx_up_1;
	wire rx_clk_1;
	wire tx_clk_1;

	wire rx_error_captured_1;
	wire [31:0] rx_error_captured_cnt_1;
	wire rx_error_corrected_1;
	wire [31:0] rx_error_corrected_cnt_1;
	wire rx_misalign_captured_1;
	wire [31:0] rx_misalign_captured_cnt_1;
	wire rx_misalign_corrected_1;
	wire [31:0] rx_misalign_corrected_cnt_1;

	rifl rifl_inst_0 (
		.gt_ref_clk_p(gt_refclk_p_0),
		.gt_ref_clk_n(gt_refclk_n_0),
		.init_clk(init_clk_0),
		.gt_rst(gt_rst_0),
		.rifl_rst(rifl_rst_0),
		.gt_rxp_in(gt_rxp_in_0),
		.gt_rxn_in(gt_rxn_in_0),
		.s_axis_tdata(s_axis_tdata_0),
		.s_axis_tkeep(s_axis_tkeep_0),
		.s_axis_tlast(s_axis_tlast_0),
		.s_axis_tvalid(s_axis_tvalid_0),
		.s_axis_tready(s_axis_tready_0),
		.m_axis_tdata(m_axis_tdata_0),
		.m_axis_tkeep(m_axis_tkeep_0),
		.m_axis_tlast(m_axis_tlast_0),
		.m_axis_tvalid(m_axis_tvalid_0),
		.tx_up(tx_up_0),
		.rx_up(rx_up_0),
		.rx_misalign_captured(rx_misalign_captured_0),
		.rx_misalign_corrected(rx_misalign_corrected_0),
		.rx_error_captured(rx_error_captured_0),
		.rx_error_corrected(rx_error_corrected_0),
		.rx_misalign_captured_cnt(rx_misalign_captured_cnt_0),
		.rx_misalign_corrected_cnt(rx_misalign_corrected_cnt_0),
		.rx_error_captured_cnt(rx_error_captured_cnt_0),
		.rx_error_corrected_cnt(rx_error_corrected_cnt_0),
		.tx_clk(tx_clk_0),
		.rx_clk(rx_clk_0),
		.tx_rst(),
		.rx_rst(),
		.gt_txp_out(gt_txp_out_0),
		.gt_txn_out(gt_txn_out_0)
	);

	traffic_verification # (
		.DWIDTH(112),
		.TX_TRAFFIC_FILE_IN("rifl0.bin"),
		.RX_TRAFFIC_FILE_OUT("rifl1_yield.csv"),
		.RX_TRAFFIC_GOLDEN_FILE_IN("rifl1_golden.csv")
	) traffic_verification_inst_0 (
		.tx_clk(tx_clk_0),
		.rx_clk(rx_clk_0),
		.rst(1'b0),
		.remote_send_done(send_done_1),
		.s_axis_tdata(m_axis_tdata_0),
		.s_axis_tkeep(m_axis_tkeep_0),
		.s_axis_tlast(m_axis_tlast_0),
		.s_axis_tvalid(m_axis_tvalid_0),
		.send_done(send_done_0),
		.m_axis_tready(s_axis_tready_0),
		.m_axis_tdata(s_axis_tdata_0),
		.m_axis_tkeep(s_axis_tkeep_0),
		.m_axis_tlast(s_axis_tlast_0),
		.m_axis_tvalid(s_axis_tvalid_0),
		.check_result(check_result_0),
		.check_result_valid(check_result_valid_0)
	);

	rifl rifl_inst_1 (
		.gt_ref_clk_p(gt_refclk_p_1),
		.gt_ref_clk_n(gt_refclk_n_1),
		.init_clk(init_clk_1),
		.gt_rst(gt_rst_1),
		.rifl_rst(rifl_rst_1),
		.gt_rxp_in(gt_rxp_in_1),
		.gt_rxn_in(gt_rxn_in_1),
		.s_axis_tdata(s_axis_tdata_1),
		.s_axis_tkeep(s_axis_tkeep_1),
		.s_axis_tlast(s_axis_tlast_1),
		.s_axis_tvalid(s_axis_tvalid_1),
		.s_axis_tready(s_axis_tready_1),
		.m_axis_tdata(m_axis_tdata_1),
		.m_axis_tkeep(m_axis_tkeep_1),
		.m_axis_tlast(m_axis_tlast_1),
		.m_axis_tvalid(m_axis_tvalid_1),
		.tx_up(tx_up_1),
		.rx_up(rx_up_1),
		.rx_misalign_captured(rx_misalign_captured_1),
		.rx_misalign_corrected(rx_misalign_corrected_1),
		.rx_error_captured(rx_error_captured_1),
		.rx_error_corrected(rx_error_corrected_1),
		.rx_misalign_captured_cnt(rx_misalign_captured_cnt_1),
		.rx_misalign_corrected_cnt(rx_misalign_corrected_cnt_1),
		.rx_error_captured_cnt(rx_error_captured_cnt_1),
		.rx_error_corrected_cnt(rx_error_corrected_cnt_1),
		.tx_clk(tx_clk_1),
		.rx_clk(rx_clk_1),
		.tx_rst(),
		.rx_rst(),
		.gt_txp_out(gt_txp_out_1),
		.gt_txn_out(gt_txn_out_1)
	);

	traffic_verification # (
		.DWIDTH(112),
		.TX_TRAFFIC_FILE_IN("rifl1.bin"),
		.RX_TRAFFIC_FILE_OUT("rifl0_yield.csv"),
		.RX_TRAFFIC_GOLDEN_FILE_IN("rifl0_golden.csv")
	) traffic_verification_inst_1 (
		.tx_clk(tx_clk_1),
		.rx_clk(rx_clk_1),
		.rst(1'b0),
		.remote_send_done(send_done_0),
		.s_axis_tdata(m_axis_tdata_1),
		.s_axis_tkeep(m_axis_tkeep_1),
		.s_axis_tlast(m_axis_tlast_1),
		.s_axis_tvalid(m_axis_tvalid_1),
		.send_done(send_done_1),
		.m_axis_tready(s_axis_tready_1),
		.m_axis_tdata(s_axis_tdata_1),
		.m_axis_tkeep(s_axis_tkeep_1),
		.m_axis_tlast(s_axis_tlast_1),
		.m_axis_tvalid(s_axis_tvalid_1),
		.check_result(check_result_1),
		.check_result_valid(check_result_valid_1)
	);

	initial begin
		gt_rst_0 = 1;
		rifl_rst_0 = 1;
		repeat (10) @(posedge init_clk_0);
		gt_rst_0 = 0;
		repeat (1000) @(posedge init_clk_0);
		rifl_rst_0 = 0;
		wait(rx_up_0);
		$display("board #0 rx up!");
		wait(tx_up_0);
		$display("board #0 tx up!");
	end

	initial begin
		gt_rst_1 = 1;
		rifl_rst_1 = 1;
		repeat (1000) @(posedge init_clk_1);
		gt_rst_1 = 0;
		repeat (200) @(posedge init_clk_1);
		rifl_rst_1 = 0;
		wait(rx_up_1);
		$display("board #1 rx up!");
		wait(tx_up_1);
		$display("board #1 tx up!");
		//reset gt #1 to simulate link unplug
		wait(tx_up_0 & rx_up_0);
		repeat (500) @(posedge init_clk_1);
		gt_rst_1 = 1;
		repeat (1000) @(posedge init_clk_1);
		gt_rst_1 = 0;
	end

	initial begin
		wait(check_result_valid_0 === 1 && check_result_valid_1 === 1);
		if (check_result_0 === 1 && check_result_1 === 1)
			$display("TEST PASSED");
		else
			$display("TEST FAILED");
		$finish;
	end

//injecting errors
`ifdef INJ_BIT_ERROR
	reg [1:0] rand_error_counter_0;
	reg [3:0] burst_error_counter_0;

	initial begin
		forever begin
			error_bit_0 = 1'b0;
			#100000; //100 ns
			rand_error_counter_0 = 0;
			burst_error_counter_0 = 0;
			if ($urandom % 1000 == 0) begin
				$display("injecting random errors from board #0 to board #1");
				while (1) begin
					if ($urandom % 33 == 0 && rand_error_counter_0 != 3) begin //%3 error rate
						error_bit_0 = 1'b1;
						rand_error_counter_0 = rand_error_counter_0 + 1;
					end
					else begin
						error_bit_0 = 1'b0;
						if (rand_error_counter_0 == 3)
							break;
					end
					#35.8;
				end
				$display("finished injecting random errors from board #0 to board #1");
			end
			else if ($urandom % 1000 == 1) begin
				$display("injecting burst errors from board #0 to board #1");
				while (1) begin
					if (burst_error_counter_0 != 8) begin;
						error_bit_0 = 1'b1;
						burst_error_counter_0 = burst_error_counter_0 + 1;
					end
					else begin
						error_bit_0 = 1'b0;
						break;
					end
					#35.8;
				end
				$display("finished injecting burst errors from board #0 to board #1");
			end
		end
	end
	reg [1:0] rand_error_counter_1;
	reg [3:0] burst_error_counter_1;
	initial begin
		forever begin
			error_bit_1 = 1'b0;
			#100000;
			rand_error_counter_1 = 0;
			burst_error_counter_1 = 0;
			if ($urandom % 1000 == 0) begin
				$display("injecting random errors from board #1 to board #0");
				while (1) begin
					if ($urandom % 33 == 0 && rand_error_counter_1 != 3) begin //%3 error rate
						error_bit_1 = 1'b1;
						rand_error_counter_1 = rand_error_counter_1 + 1;
					end
					else begin
						error_bit_1 = 1'b0;
						if (rand_error_counter_1 == 3)
							break;
					end
					#35.8;
				end
				$display("finished injecting random errors from board #1 to board #0");
			end
			else if ($urandom % 1000 == 1) begin
				$display("injecting burst errors from board #1 to board #0");
				while (1) begin
					if (burst_error_counter_1 != 8) begin;
						error_bit_1 = 1'b1;
						burst_error_counter_1 = burst_error_counter_1 + 1;
					end
					else begin
						error_bit_1 = 1'b0;
						break;
					end
					#35.8;
				end
				$display("finished injecting burst errors from board #1 to board #0");
			end
		end
	end
`else
	initial begin
		error_bit_0 = 0;
		error_bit_1 = 0;
	end
`endif
`ifdef INJ_ALIGN_ERROR
	initial begin
		align_switch_0 = 1;
		forever begin
			#100000;
			if ($urandom % 1000 == 0) begin
				$display("injecting alignment error from board #0 to board #1");
				align_switch_0 = ~align_switch_0;
			end
		end
	end
	initial begin
		align_switch_1 = 1;
		forever begin
			#100000;
			if ($urandom % 1000 == 0) begin
				$display("injecting alignment error from board #1 to board #0");
				align_switch_1 = ~align_switch_1;
			end
		end
	end
`else
	initial begin
		align_switch_0 = 1;
		align_switch_1 = 1;
	end
`endif
	
	always @(*) begin
		if (align_switch_0)	begin
			gt_rxp_in_0 <= gt_txp_out_1 ^ error_bit_0;
			gt_rxn_in_0 <= gt_txn_out_1 ^ error_bit_0;
		end
		else begin
			gt_rxp_in_0 <= #35.8 gt_txp_out_1 ^ error_bit_0;
			gt_rxn_in_0 <= #35.8 gt_txn_out_1 ^ error_bit_0;
		end
	end

	always @(*) begin
		if (align_switch_1) begin
			gt_rxp_in_1 <= gt_txp_out_0 ^ error_bit_1;
			gt_rxn_in_1 <= gt_txn_out_0 ^ error_bit_1;
		end
		else begin
			gt_rxp_in_1 <= #35.8 gt_txp_out_0 ^ error_bit_1;
			gt_rxn_in_1 <= #35.8 gt_txn_out_0 ^ error_bit_1;
		end
	end

	initial begin
		gt_refclk_p_0 = 1;
		forever #1551.515 gt_refclk_p_0 = ~ gt_refclk_p_0;
	end
	initial begin
		gt_refclk_n_0 = 0;
		forever #1551.515 gt_refclk_n_0 = ~ gt_refclk_n_0;
	end

	initial begin
		init_clk_0 = 0;
		forever #5000.000 init_clk_0 = ~ init_clk_0;
	end

//reference clock frequencies are set to be slightly different from the other board's, the is closer to the reality.
	initial begin
		gt_refclk_p_1 = 1;
		forever #1551.000 gt_refclk_p_1 = ~ gt_refclk_p_1;
	end
	initial begin
		gt_refclk_n_1 = 0;
		forever #1551.000 gt_refclk_n_1 = ~ gt_refclk_n_1;
	end

	initial begin
		init_clk_1 = 0;
		forever #5001.000 init_clk_1 = ~ init_clk_1;
	end

endmodule
