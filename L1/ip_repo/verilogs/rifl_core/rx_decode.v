`timescale 1ps/1ps
module rx_decode
(
	input clk,
	input rst,
	input [127:0] data_in,
	input enable,
	output [115:0] data_out,
	output valid_out,
	output crc_good,
	output rx_error
);
	localparam ROLLBACK_CYCLES = 8'd16;
//header types
	localparam CONTROL = 4'b1010;
	localparam DATA = 4'b0101;
//control codes
	localparam IDLE_KEY = {4'b1001,4'b1101,4'b1001,4'b0001};
	localparam PAUSE_KEY = {4'b1101,4'b1001,4'b0001,4'b1001};
	localparam RETRANS_KEY = {4'b1001,4'b0001,4'b1001,4'b1101};

	reg [115:0] data_reg;
	reg [7:0] threshold_counter;
	reg [7:0] counter;
	reg is_data;
	reg is_control;
	reg rx_error_reg;
	reg [7:0] crc_golden;
	reg [57:0] descrambler_state_reg;
	reg [7:0] crc_reg;

	wire [3:0] header;
	wire [115:0] data;
	wire [7:0] crc;
	wire [115:0] descrambler_state_xN1;
	wire [115:0] descrambler_state_xN2;

	always @(posedge clk) begin
		is_data <= header == DATA;
		is_control <= header == CONTROL && (data_in[121:106] == IDLE_KEY || data_in[121:106] == PAUSE_KEY || data_in[121:106] == RETRANS_KEY);
		if (header == DATA) data_reg <= data;
		if (crc_good)
			descrambler_state_reg <= data_reg[115:58];
	end

//there has to be 16 correct crc checks in a row to enable the rx gate, this avoids the random noise when cable is unplugged.
	always @(posedge clk) begin
		if (rst) begin
			rx_error_reg <= 1'b0;
			counter <= 8'd0;
			threshold_counter <= ROLLBACK_CYCLES;
		end
		else begin
			if (crc_good)
				counter <= counter + 1'd1;
			else if ((is_data | ~is_control) & enable)
				counter <= threshold_counter - ROLLBACK_CYCLES;

			if (threshold_counter == counter && crc_good)
				threshold_counter <= threshold_counter + 1'd1;

			if (~crc_good & ~is_control & enable)
				rx_error_reg <= 1'b1;
			else if (crc_good && (threshold_counter == counter + 1'd1))
				rx_error_reg <= 1'b0;
		end
	end

//crc logic
	always @(posedge clk) begin
		if (rst) begin
			crc_reg  <= 8'b0;
			crc_golden <= 8'b0;
		end	
		else begin
			crc_golden <= crc;
			crc_reg[0] <= data[0] ^ data[1] ^ data[2] ^ data[4] ^ data[6] ^ data[8] ^ data[13] ^ data[14] ^ data[17] ^ data[18] ^ data[20] ^ data[22] ^ data[23] ^ data[24] ^ data[26] ^ data[27] ^ data[28] ^ data[31] ^ data[32] ^ data[33] ^ data[34] ^ data[39] ^ data[45] ^ data[47] ^ data[50] ^ data[52] ^ data[54] ^ data[55] ^ data[58] ^ data[61] ^ data[62] ^ data[66] ^ data[69] ^ data[73] ^ data[75] ^ data[76] ^ data[78] ^ data[79] ^ data[81] ^ data[84] ^ data[85] ^ data[86] ^ data[90] ^ data[91] ^ data[93] ^ data[94] ^ data[95] ^ data[96] ^ data[98] ^ data[102] ^ data[103] ^ data[104] ^ data[105] ^ data[106] ^ data[109] ^ data[111] ^ data[112] ^ data[113] ^ data[114] ^ data[115];
			crc_reg[1] <= data[0] ^ data[3] ^ data[4] ^ data[5] ^ data[6] ^ data[7] ^ data[8] ^ data[9] ^ data[13] ^ data[15] ^ data[17] ^ data[19] ^ data[20] ^ data[21] ^ data[22] ^ data[25] ^ data[26] ^ data[29] ^ data[31] ^ data[35] ^ data[39] ^ data[40] ^ data[45] ^ data[46] ^ data[47] ^ data[48] ^ data[50] ^ data[51] ^ data[52] ^ data[53] ^ data[54] ^ data[56] ^ data[58] ^ data[59] ^ data[61] ^ data[63] ^ data[66] ^ data[67] ^ data[69] ^ data[70] ^ data[73] ^ data[74] ^ data[75] ^ data[77] ^ data[78] ^ data[80] ^ data[81] ^ data[82] ^ data[84] ^ data[87] ^ data[90] ^ data[92] ^ data[93] ^ data[97] ^ data[98] ^ data[99] ^ data[102] ^ data[107] ^ data[109] ^ data[110] ^ data[111];
			crc_reg[2] <= data[0] ^ data[2] ^ data[5] ^ data[7] ^ data[9] ^ data[10] ^ data[13] ^ data[16] ^ data[17] ^ data[21] ^ data[24] ^ data[28] ^ data[30] ^ data[31] ^ data[33] ^ data[34] ^ data[36] ^ data[39] ^ data[40] ^ data[41] ^ data[45] ^ data[46] ^ data[48] ^ data[49] ^ data[50] ^ data[51] ^ data[53] ^ data[57] ^ data[58] ^ data[59] ^ data[60] ^ data[61] ^ data[64] ^ data[66] ^ data[67] ^ data[68] ^ data[69] ^ data[70] ^ data[71] ^ data[73] ^ data[74] ^ data[82] ^ data[83] ^ data[84] ^ data[86] ^ data[88] ^ data[90] ^ data[95] ^ data[96] ^ data[99] ^ data[100] ^ data[102] ^ data[104] ^ data[105] ^ data[106] ^ data[108] ^ data[109] ^ data[110] ^ data[113] ^ data[114] ^ data[115];
			crc_reg[3] <= data[1] ^ data[3] ^ data[6] ^ data[8] ^ data[10] ^ data[11] ^ data[14] ^ data[17] ^ data[18] ^ data[22] ^ data[25] ^ data[29] ^ data[31] ^ data[32] ^ data[34] ^ data[35] ^ data[37] ^ data[40] ^ data[41] ^ data[42] ^ data[46] ^ data[47] ^ data[49] ^ data[50] ^ data[51] ^ data[52] ^ data[54] ^ data[58] ^ data[59] ^ data[60] ^ data[61] ^ data[62] ^ data[65] ^ data[67] ^ data[68] ^ data[69] ^ data[70] ^ data[71] ^ data[72] ^ data[74] ^ data[75] ^ data[83] ^ data[84] ^ data[85] ^ data[87] ^ data[89] ^ data[91] ^ data[96] ^ data[97] ^ data[100] ^ data[101] ^ data[103] ^ data[105] ^ data[106] ^ data[107] ^ data[109] ^ data[110] ^ data[111] ^ data[114] ^ data[115];
			crc_reg[4] <= data[2] ^ data[4] ^ data[7] ^ data[9] ^ data[11] ^ data[12] ^ data[15] ^ data[18] ^ data[19] ^ data[23] ^ data[26] ^ data[30] ^ data[32] ^ data[33] ^ data[35] ^ data[36] ^ data[38] ^ data[41] ^ data[42] ^ data[43] ^ data[47] ^ data[48] ^ data[50] ^ data[51] ^ data[52] ^ data[53] ^ data[55] ^ data[59] ^ data[60] ^ data[61] ^ data[62] ^ data[63] ^ data[66] ^ data[68] ^ data[69] ^ data[70] ^ data[71] ^ data[72] ^ data[73] ^ data[75] ^ data[76] ^ data[84] ^ data[85] ^ data[86] ^ data[88] ^ data[90] ^ data[92] ^ data[97] ^ data[98] ^ data[101] ^ data[102] ^ data[104] ^ data[106] ^ data[107] ^ data[108] ^ data[110] ^ data[111] ^ data[112] ^ data[115];
			crc_reg[5] <= data[0] ^ data[1] ^ data[2] ^ data[3] ^ data[4] ^ data[5] ^ data[6] ^ data[10] ^ data[12] ^ data[14] ^ data[16] ^ data[17] ^ data[18] ^ data[19] ^ data[22] ^ data[23] ^ data[26] ^ data[28] ^ data[32] ^ data[36] ^ data[37] ^ data[42] ^ data[43] ^ data[44] ^ data[45] ^ data[47] ^ data[48] ^ data[49] ^ data[50] ^ data[51] ^ data[53] ^ data[55] ^ data[56] ^ data[58] ^ data[60] ^ data[63] ^ data[64] ^ data[66] ^ data[67] ^ data[70] ^ data[71] ^ data[72] ^ data[74] ^ data[75] ^ data[77] ^ data[78] ^ data[79] ^ data[81] ^ data[84] ^ data[87] ^ data[89] ^ data[90] ^ data[94] ^ data[95] ^ data[96] ^ data[99] ^ data[104] ^ data[106] ^ data[107] ^ data[108] ^ data[114] ^ data[115];
			crc_reg[6] <= data[1] ^ data[2] ^ data[3] ^ data[4] ^ data[5] ^ data[6] ^ data[7] ^ data[11] ^ data[13] ^ data[15] ^ data[17] ^ data[18] ^ data[19] ^ data[20] ^ data[23] ^ data[24] ^ data[27] ^ data[29] ^ data[33] ^ data[37] ^ data[38] ^ data[43] ^ data[44] ^ data[45] ^ data[46] ^ data[48] ^ data[49] ^ data[50] ^ data[51] ^ data[52] ^ data[54] ^ data[56] ^ data[57] ^ data[59] ^ data[61] ^ data[64] ^ data[65] ^ data[67] ^ data[68] ^ data[71] ^ data[72] ^ data[73] ^ data[75] ^ data[76] ^ data[78] ^ data[79] ^ data[80] ^ data[82] ^ data[85] ^ data[88] ^ data[90] ^ data[91] ^ data[95] ^ data[96] ^ data[97] ^ data[100] ^ data[105] ^ data[107] ^ data[108] ^ data[109] ^ data[115];
			crc_reg[7] <= data[0] ^ data[1] ^ data[3] ^ data[5] ^ data[7] ^ data[12] ^ data[13] ^ data[16] ^ data[17] ^ data[19] ^ data[21] ^ data[22] ^ data[23] ^ data[25] ^ data[26] ^ data[27] ^ data[30] ^ data[31] ^ data[32] ^ data[33] ^ data[38] ^ data[44] ^ data[46] ^ data[49] ^ data[51] ^ data[53] ^ data[54] ^ data[57] ^ data[60] ^ data[61] ^ data[65] ^ data[68] ^ data[72] ^ data[74] ^ data[75] ^ data[77] ^ data[78] ^ data[80] ^ data[83] ^ data[84] ^ data[85] ^ data[89] ^ data[90] ^ data[92] ^ data[93] ^ data[94] ^ data[95] ^ data[97] ^ data[101] ^ data[102] ^ data[103] ^ data[104] ^ data[105] ^ data[108] ^ data[110] ^ data[111] ^ data[112] ^ data[113] ^ data[114] ^ data[115];
		end	
	end

//internal
	assign header = data_in[127:124];	
	assign data = data_in[123:8];
	assign crc = data_in[7:0];
	assign descrambler_state_xN1 = {data_reg[57:0],descrambler_state_reg};
	assign descrambler_state_xN2 = {data_reg[76:0],descrambler_state_reg[57:19]};

//external
	assign data_out = data_reg ^ descrambler_state_xN1 ^ descrambler_state_xN2;
	assign crc_good = is_data && (crc_reg ^ crc_golden ^ counter) == 8'd0 && enable;
	assign valid_out = crc_good && threshold_counter == counter;
	assign rx_error = rx_error_reg;

endmodule
