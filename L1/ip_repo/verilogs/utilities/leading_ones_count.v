`timescale 1ps/1ps
module leading_ones_count
(
	input [13:0] keep_in,
	input [3:0] mty_out
);
	wire [15:0] keep_in_int;
	wire [15:0] int1;
	wire [11:0] int2;
	wire [7:0] int3;
	wire [4:0] int4;

	assign keep_in_int = {keep_in,2'b0};

	genvar i;

	for (i = 0; i < 8; i = i + 1) begin
		leading_ones_count_encode encode_inst (
			.din(keep_in_int[i*2+1:i*2]),
			.dout(int1[i*2+1:i*2])
		);
	end

	for (i = 0; i < 4; i = i + 1) begin
		leading_ones_countN # (
			.N(2)
		) count2_inst (
			.keep_in(int1[i*4+3:i*4]),
			.mty_out(int2[i*3+2:i*3])
		);
	end

	for (i = 0; i < 2; i = i + 1) begin
		leading_ones_countN # (
			.N(3)
		) count3_inst (
			.keep_in(int2[i*6+5:i*6]),
			.mty_out(int3[i*4+3:i*4])
		);
	end

	leading_ones_countN # (
		.N(4)
	) count4_inst (
		.keep_in(int3),
		.mty_out(int4)
	);
	assign mty_out = int4[3:0];

endmodule

module leading_ones_countN #
(
	parameter N = 2
)
(
	input [2*N-1:0] keep_in,
	output [N:0] mty_out	
);
	assign mty_out[N] = keep_in[2*N-1] ? (keep_in[2*N-1] & keep_in[N-1]) : 1'b0;
	assign mty_out[N-1] = keep_in[2*N-1] ? ~keep_in[N-1] : keep_in[2*N-1];
	assign mty_out[N-2:0] = keep_in[2*N-1] ? keep_in[N-2:0] : keep_in[2*N-2:N];

endmodule

module leading_ones_count_encode
(
	input wire [1:0] din,
	output wire [1:0] dout
);

	assign dout[0] = din == 2'b10;
	assign dout[1] = din == 2'b11;

endmodule
