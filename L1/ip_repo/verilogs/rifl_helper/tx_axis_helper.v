module tx_axis_helper
(
	input [111:0] tx_tdata,
	input [13:0] tx_tkeep,
	input tx_tlast,
	output [115:0] tx_int_data
);
	wire [3:0] tx_meta;
	wire [3:0] leading_ones;
	leading_ones_count leading_ones_count_inst (
		.keep_in(tx_tkeep),
		.mty_out(leading_ones)
	);
	assign tx_meta = (tx_tlast && leading_ones == 4'd14) ? 4'd15 : leading_ones;
	assign tx_int_data = {tx_tdata,tx_meta};
endmodule
