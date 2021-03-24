`timescale 1ps/1ps
module bit_synchronizer (
	input wire clk_in,
	input wire i_in,
	output wire o_out
);
	xpm_cdc_single #(
		.DEST_SYNC_FF (5),
		.SIM_ASSERT_CHK (0),
		.SRC_INPUT_REG (0)
	) xpm_cdc_single_inst (
		.src_in (i_in),
		.dest_clk (clk_in),
		.dest_out (o_out)
	);
endmodule
