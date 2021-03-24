`timescale 1ps/1ps
module reset_synchronizer (
	input wire clk_in,
	input wire rst_in,
	output wire rst_out
);
	xpm_cdc_async_rst #(
		.DEST_SYNC_FF (5),
		.RST_ACTIVE_HIGH (1)
	) xpm_cdc_async_rst_inst (
		.src_arst (rst_in),
		.dest_clk (clk_in),
		.dest_arst (rst_out)
	);
endmodule
