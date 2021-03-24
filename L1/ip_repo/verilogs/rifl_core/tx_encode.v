//1+x^1+x^2+x^5+x^7+x^8 CRC-8-Bluetooth, detect up to 3 bits random errors and 8 bits burst erros in every 128-bit frame,
//tolerant BER equal or better than 10^-6, IEEE standard is 10^-12
`timescale 1ps/1ps
module tx_encode
(
	input clk,
	input rst,
	input [115:0] data_in,
	input valid_in,
	output [7:0] crc_out
);
	reg [7:0] crc_reg;
	wire [7:0] tx_counter;

	tx_counter tx_counter_inst (
		.clk(clk),
		.rst(rst),
		.enable(valid_in),
		.tx_counter_out(tx_counter)
	);

	always @(posedge clk) begin
		if(rst)
			crc_reg <= 8'b0;
		else begin
			crc_reg[0] <= data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[13] ^ data_in[14] ^ data_in[17] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[26] ^ data_in[27] ^ data_in[28] ^ data_in[31] ^ data_in[32] ^ data_in[33] ^ data_in[34] ^ data_in[39] ^ data_in[45] ^ data_in[47] ^ data_in[50] ^ data_in[52] ^ data_in[54] ^ data_in[55] ^ data_in[58] ^ data_in[61] ^ data_in[62] ^ data_in[66] ^ data_in[69] ^ data_in[73] ^ data_in[75] ^ data_in[76] ^ data_in[78] ^ data_in[79] ^ data_in[81] ^ data_in[84] ^ data_in[85] ^ data_in[86] ^ data_in[90] ^ data_in[91] ^ data_in[93] ^ data_in[94] ^ data_in[95] ^ data_in[96] ^ data_in[98] ^ data_in[102] ^ data_in[103] ^ data_in[104] ^ data_in[105] ^ data_in[106] ^ data_in[109] ^ data_in[111] ^ data_in[112] ^ data_in[113] ^ data_in[114] ^ data_in[115] ^ tx_counter[0];
			crc_reg[1] <= data_in[0] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[20] ^ data_in[21] ^ data_in[22] ^ data_in[25] ^ data_in[26] ^ data_in[29] ^ data_in[31] ^ data_in[35] ^ data_in[39] ^ data_in[40] ^ data_in[45] ^ data_in[46] ^ data_in[47] ^ data_in[48] ^ data_in[50] ^ data_in[51] ^ data_in[52] ^ data_in[53] ^ data_in[54] ^ data_in[56] ^ data_in[58] ^ data_in[59] ^ data_in[61] ^ data_in[63] ^ data_in[66] ^ data_in[67] ^ data_in[69] ^ data_in[70] ^ data_in[73] ^ data_in[74] ^ data_in[75] ^ data_in[77] ^ data_in[78] ^ data_in[80] ^ data_in[81] ^ data_in[82] ^ data_in[84] ^ data_in[87] ^ data_in[90] ^ data_in[92] ^ data_in[93] ^ data_in[97] ^ data_in[98] ^ data_in[99] ^ data_in[102] ^ data_in[107] ^ data_in[109] ^ data_in[110] ^ data_in[111] ^ tx_counter[1];
			crc_reg[2] <= data_in[0] ^ data_in[2] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[10] ^ data_in[13] ^ data_in[16] ^ data_in[17] ^ data_in[21] ^ data_in[24] ^ data_in[28] ^ data_in[30] ^ data_in[31] ^ data_in[33] ^ data_in[34] ^ data_in[36] ^ data_in[39] ^ data_in[40] ^ data_in[41] ^ data_in[45] ^ data_in[46] ^ data_in[48] ^ data_in[49] ^ data_in[50] ^ data_in[51] ^ data_in[53] ^ data_in[57] ^ data_in[58] ^ data_in[59] ^ data_in[60] ^ data_in[61] ^ data_in[64] ^ data_in[66] ^ data_in[67] ^ data_in[68] ^ data_in[69] ^ data_in[70] ^ data_in[71] ^ data_in[73] ^ data_in[74] ^ data_in[82] ^ data_in[83] ^ data_in[84] ^ data_in[86] ^ data_in[88] ^ data_in[90] ^ data_in[95] ^ data_in[96] ^ data_in[99] ^ data_in[100] ^ data_in[102] ^ data_in[104] ^ data_in[105] ^ data_in[106] ^ data_in[108] ^ data_in[109] ^ data_in[110] ^ data_in[113] ^ data_in[114] ^ data_in[115] ^ tx_counter[2];
			crc_reg[3] <= data_in[1] ^ data_in[3] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[11] ^ data_in[14] ^ data_in[17] ^ data_in[18] ^ data_in[22] ^ data_in[25] ^ data_in[29] ^ data_in[31] ^ data_in[32] ^ data_in[34] ^ data_in[35] ^ data_in[37] ^ data_in[40] ^ data_in[41] ^ data_in[42] ^ data_in[46] ^ data_in[47] ^ data_in[49] ^ data_in[50] ^ data_in[51] ^ data_in[52] ^ data_in[54] ^ data_in[58] ^ data_in[59] ^ data_in[60] ^ data_in[61] ^ data_in[62] ^ data_in[65] ^ data_in[67] ^ data_in[68] ^ data_in[69] ^ data_in[70] ^ data_in[71] ^ data_in[72] ^ data_in[74] ^ data_in[75] ^ data_in[83] ^ data_in[84] ^ data_in[85] ^ data_in[87] ^ data_in[89] ^ data_in[91] ^ data_in[96] ^ data_in[97] ^ data_in[100] ^ data_in[101] ^ data_in[103] ^ data_in[105] ^ data_in[106] ^ data_in[107] ^ data_in[109] ^ data_in[110] ^ data_in[111] ^ data_in[114] ^ data_in[115] ^ tx_counter[3];
			crc_reg[4] <= data_in[2] ^ data_in[4] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[12] ^ data_in[15] ^ data_in[18] ^ data_in[19] ^ data_in[23] ^ data_in[26] ^ data_in[30] ^ data_in[32] ^ data_in[33] ^ data_in[35] ^ data_in[36] ^ data_in[38] ^ data_in[41] ^ data_in[42] ^ data_in[43] ^ data_in[47] ^ data_in[48] ^ data_in[50] ^ data_in[51] ^ data_in[52] ^ data_in[53] ^ data_in[55] ^ data_in[59] ^ data_in[60] ^ data_in[61] ^ data_in[62] ^ data_in[63] ^ data_in[66] ^ data_in[68] ^ data_in[69] ^ data_in[70] ^ data_in[71] ^ data_in[72] ^ data_in[73] ^ data_in[75] ^ data_in[76] ^ data_in[84] ^ data_in[85] ^ data_in[86] ^ data_in[88] ^ data_in[90] ^ data_in[92] ^ data_in[97] ^ data_in[98] ^ data_in[101] ^ data_in[102] ^ data_in[104] ^ data_in[106] ^ data_in[107] ^ data_in[108] ^ data_in[110] ^ data_in[111] ^ data_in[112] ^ data_in[115] ^ tx_counter[4];
			crc_reg[5] <= data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[17] ^ data_in[18] ^ data_in[19] ^ data_in[22] ^ data_in[23] ^ data_in[26] ^ data_in[28] ^ data_in[32] ^ data_in[36] ^ data_in[37] ^ data_in[42] ^ data_in[43] ^ data_in[44] ^ data_in[45] ^ data_in[47] ^ data_in[48] ^ data_in[49] ^ data_in[50] ^ data_in[51] ^ data_in[53] ^ data_in[55] ^ data_in[56] ^ data_in[58] ^ data_in[60] ^ data_in[63] ^ data_in[64] ^ data_in[66] ^ data_in[67] ^ data_in[70] ^ data_in[71] ^ data_in[72] ^ data_in[74] ^ data_in[75] ^ data_in[77] ^ data_in[78] ^ data_in[79] ^ data_in[81] ^ data_in[84] ^ data_in[87] ^ data_in[89] ^ data_in[90] ^ data_in[94] ^ data_in[95] ^ data_in[96] ^ data_in[99] ^ data_in[104] ^ data_in[106] ^ data_in[107] ^ data_in[108] ^ data_in[114] ^ data_in[115] ^ tx_counter[5];
			crc_reg[6] <= data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[18] ^ data_in[19] ^ data_in[20] ^ data_in[23] ^ data_in[24] ^ data_in[27] ^ data_in[29] ^ data_in[33] ^ data_in[37] ^ data_in[38] ^ data_in[43] ^ data_in[44] ^ data_in[45] ^ data_in[46] ^ data_in[48] ^ data_in[49] ^ data_in[50] ^ data_in[51] ^ data_in[52] ^ data_in[54] ^ data_in[56] ^ data_in[57] ^ data_in[59] ^ data_in[61] ^ data_in[64] ^ data_in[65] ^ data_in[67] ^ data_in[68] ^ data_in[71] ^ data_in[72] ^ data_in[73] ^ data_in[75] ^ data_in[76] ^ data_in[78] ^ data_in[79] ^ data_in[80] ^ data_in[82] ^ data_in[85] ^ data_in[88] ^ data_in[90] ^ data_in[91] ^ data_in[95] ^ data_in[96] ^ data_in[97] ^ data_in[100] ^ data_in[105] ^ data_in[107] ^ data_in[108] ^ data_in[109] ^ data_in[115] ^ tx_counter[6];
			crc_reg[7] <= data_in[0] ^ data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[12] ^ data_in[13] ^ data_in[16] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[22] ^ data_in[23] ^ data_in[25] ^ data_in[26] ^ data_in[27] ^ data_in[30] ^ data_in[31] ^ data_in[32] ^ data_in[33] ^ data_in[38] ^ data_in[44] ^ data_in[46] ^ data_in[49] ^ data_in[51] ^ data_in[53] ^ data_in[54] ^ data_in[57] ^ data_in[60] ^ data_in[61] ^ data_in[65] ^ data_in[68] ^ data_in[72] ^ data_in[74] ^ data_in[75] ^ data_in[77] ^ data_in[78] ^ data_in[80] ^ data_in[83] ^ data_in[84] ^ data_in[85] ^ data_in[89] ^ data_in[90] ^ data_in[92] ^ data_in[93] ^ data_in[94] ^ data_in[95] ^ data_in[97] ^ data_in[101] ^ data_in[102] ^ data_in[103] ^ data_in[104] ^ data_in[105] ^ data_in[108] ^ data_in[110] ^ data_in[111] ^ data_in[112] ^ data_in[113] ^ data_in[114] ^ data_in[115] ^ tx_counter[7];
		end
	end

	assign crc_out = crc_reg;

endmodule

module tx_counter #
(
	parameter WIDTH = 8
)
(
	input wire rst,
	input wire clk,
	input wire enable,
	output wire [WIDTH-1:0] tx_counter_out
);
	reg [WIDTH-1:0] tx_counter_reg;
	always @(posedge clk) begin
		if (rst == 1'b1)
			tx_counter_reg <= 0;
		else if (enable)
			tx_counter_reg <= tx_counter_reg + 1'b1;
	end
	assign tx_counter_out = tx_counter_reg;
endmodule
