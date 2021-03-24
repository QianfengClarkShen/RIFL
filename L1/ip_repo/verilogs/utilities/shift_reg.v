`timescale 1ps/1ps
module shift_reg # 
(
	parameter DEPTH = 256,
	parameter DWIDTH = 128
)
(
	input clk,
	input enable,
	input [DWIDTH-1:0] data_in,
	output [DWIDTH-1:0] data_out
);
	reg [DWIDTH-1:0] shiftreg[DEPTH-1:0];
	always @(posedge clk) begin
		if (enable)	shiftreg[0] <= data_in;
	end
	genvar i;
	for (i = 0; i < DEPTH-1; i = i+1) begin
		always @(posedge clk) begin
			if (enable) shiftreg[i+1] <= shiftreg[i];
		end
	end
	assign data_out = shiftreg[DEPTH-1];
endmodule
