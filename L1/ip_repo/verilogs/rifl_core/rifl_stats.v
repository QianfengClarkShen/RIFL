`timescale 1ps/1ps
module rifl_stats (
	input wire clk,
	input wire rst,
	input wire rx_up,
	input wire rx_error,
	output wire rx_misalign_captured,
	output wire rx_misalign_corrected,
	output wire rx_error_captured,
	output wire rx_error_corrected,
	output wire [31:0] rx_misalign_captured_cnt,
	output wire [31:0] rx_misalign_corrected_cnt,
	output wire [31:0] rx_error_captured_cnt,
	output wire [31:0] rx_error_corrected_cnt
);
	reg rx_up_reg;
	reg rx_error_reg;
	reg rx_init_done;
	reg [31:0] rx_misalign_captured_cnt_reg;
	reg [31:0] rx_misalign_corrected_cnt_reg;
	reg [31:0] rx_error_captured_cnt_reg;
	reg [31:0] rx_error_corrected_cnt_reg;
	always @(posedge clk) begin
		rx_up_reg <= rx_up;
		rx_error_reg <= rx_error;
	end
	always @(posedge clk) begin
		if (rst) begin
			rx_init_done <= 1'b0;
			rx_misalign_captured_cnt_reg <= 32'd0;
			rx_misalign_corrected_cnt_reg <= 32'd0;
			rx_error_captured_cnt_reg <= 32'd0;
			rx_error_corrected_cnt_reg <= 32'd0;
		end
		else begin
			if (rx_up) rx_init_done <= 1'b1;
			if (rx_misalign_captured)
				rx_misalign_captured_cnt_reg <= rx_misalign_captured_cnt_reg + 1'd1;
			if (rx_misalign_corrected)
				rx_misalign_corrected_cnt_reg <= rx_misalign_corrected_cnt_reg + 1'd1;
			if (rx_error_captured)
				rx_error_captured_cnt_reg <= rx_error_captured_cnt_reg + 1'd1;
			if (rx_error_corrected)
				rx_error_corrected_cnt_reg <= rx_error_corrected_cnt_reg + 1'd1;
		end
	end
	assign rx_misalign_captured = rx_init_done & ~rx_up & rx_up_reg;
	assign rx_misalign_corrected = rx_init_done & rx_up & ~rx_up_reg;
	assign rx_error_captured = rx_error & ~rx_error_reg;
	assign rx_error_corrected = ~rx_error & rx_error_reg;
	assign rx_misalign_captured_cnt = rx_misalign_captured_cnt_reg;
	assign rx_misalign_corrected_cnt = rx_misalign_corrected_cnt_reg;
	assign rx_error_captured_cnt = rx_error_captured_cnt_reg;
	assign rx_error_corrected_cnt = rx_error_corrected_cnt_reg;
endmodule
