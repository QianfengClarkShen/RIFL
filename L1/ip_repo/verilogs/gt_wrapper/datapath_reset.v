`timescale 1ps/1ps

module datapath_reset #
(
	parameter COUNTER_WIDTH = 16
)
(
	input wire clk,
	input wire rst,
	input wire channel_good,
	output wire rst_out
);
	reg	[COUNTER_WIDTH-1:0] reset_counter = {COUNTER_WIDTH{1'b0}};
	reg rst_out_reg;

	always @(posedge clk) begin
		if (rst) begin
			rst_out_reg <= 1'b0;
			reset_counter <= {COUNTER_WIDTH{1'b0}};
		end
		else if (channel_good) begin
			rst_out_reg <= 1'b0;
			reset_counter <= {COUNTER_WIDTH{1'b0}};
		end
		else begin
			rst_out_reg <= reset_counter[COUNTER_WIDTH-1];
			if (reset_counter[COUNTER_WIDTH-1])
				reset_counter <= {COUNTER_WIDTH{1'b0}};
			else
				reset_counter <= reset_counter + 1'd1;
		end
	end
	assign rst_out = rst_out_reg;
endmodule
