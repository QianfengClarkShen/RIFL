`timescale 1ps/1ps
//1+X13+X33
module scrambler
(
	input wire rst,
	input wire clk,
	input wire [115:0] data_in,
	input wire valid_in,
	output wire [115:0] data_out
);
	reg [57:0] scrambler_state;
	always @(posedge clk) begin
		if (rst == 1'b1)
			scrambler_state <= {29{2'b01}};
		else if(valid_in)
			scrambler_state <= data_out[115:58];
	end

	assign data_out[0] = data_in[0]^scrambler_state[0]^scrambler_state[19];
	assign data_out[1] = data_in[1]^scrambler_state[1]^scrambler_state[20];
	assign data_out[2] = data_in[2]^scrambler_state[2]^scrambler_state[21];
	assign data_out[3] = data_in[3]^scrambler_state[3]^scrambler_state[22];
	assign data_out[4] = data_in[4]^scrambler_state[4]^scrambler_state[23];
	assign data_out[5] = data_in[5]^scrambler_state[5]^scrambler_state[24];
	assign data_out[6] = data_in[6]^scrambler_state[6]^scrambler_state[25];
	assign data_out[7] = data_in[7]^scrambler_state[7]^scrambler_state[26];
	assign data_out[8] = data_in[8]^scrambler_state[8]^scrambler_state[27];
	assign data_out[9] = data_in[9]^scrambler_state[9]^scrambler_state[28];
	assign data_out[10] = data_in[10]^scrambler_state[10]^scrambler_state[29];
	assign data_out[11] = data_in[11]^scrambler_state[11]^scrambler_state[30];
	assign data_out[12] = data_in[12]^scrambler_state[12]^scrambler_state[31];
	assign data_out[13] = data_in[13]^scrambler_state[13]^scrambler_state[32];
	assign data_out[14] = data_in[14]^scrambler_state[14]^scrambler_state[33];
	assign data_out[15] = data_in[15]^scrambler_state[15]^scrambler_state[34];
	assign data_out[16] = data_in[16]^scrambler_state[16]^scrambler_state[35];
	assign data_out[17] = data_in[17]^scrambler_state[17]^scrambler_state[36];
	assign data_out[18] = data_in[18]^scrambler_state[18]^scrambler_state[37];
	assign data_out[19] = data_in[19]^scrambler_state[19]^scrambler_state[38];
	assign data_out[20] = data_in[20]^scrambler_state[20]^scrambler_state[39];
	assign data_out[21] = data_in[21]^scrambler_state[21]^scrambler_state[40];
	assign data_out[22] = data_in[22]^scrambler_state[22]^scrambler_state[41];
	assign data_out[23] = data_in[23]^scrambler_state[23]^scrambler_state[42];
	assign data_out[24] = data_in[24]^scrambler_state[24]^scrambler_state[43];
	assign data_out[25] = data_in[25]^scrambler_state[25]^scrambler_state[44];
	assign data_out[26] = data_in[26]^scrambler_state[26]^scrambler_state[45];
	assign data_out[27] = data_in[27]^scrambler_state[27]^scrambler_state[46];
	assign data_out[28] = data_in[28]^scrambler_state[28]^scrambler_state[47];
	assign data_out[29] = data_in[29]^scrambler_state[29]^scrambler_state[48];
	assign data_out[30] = data_in[30]^scrambler_state[30]^scrambler_state[49];
	assign data_out[31] = data_in[31]^scrambler_state[31]^scrambler_state[50];
	assign data_out[32] = data_in[32]^scrambler_state[32]^scrambler_state[51];
	assign data_out[33] = data_in[33]^scrambler_state[33]^scrambler_state[52];
	assign data_out[34] = data_in[34]^scrambler_state[34]^scrambler_state[53];
	assign data_out[35] = data_in[35]^scrambler_state[35]^scrambler_state[54];
	assign data_out[36] = data_in[36]^scrambler_state[36]^scrambler_state[55];
	assign data_out[37] = data_in[37]^scrambler_state[37]^scrambler_state[56];
	assign data_out[38] = data_in[38]^scrambler_state[38]^scrambler_state[57];
	assign data_out[39] = data_in[39]^scrambler_state[39]^data_in[0]^scrambler_state[0]^scrambler_state[19];
	assign data_out[40] = data_in[40]^scrambler_state[40]^data_in[1]^scrambler_state[1]^scrambler_state[20];
	assign data_out[41] = data_in[41]^scrambler_state[41]^data_in[2]^scrambler_state[2]^scrambler_state[21];
	assign data_out[42] = data_in[42]^scrambler_state[42]^data_in[3]^scrambler_state[3]^scrambler_state[22];
	assign data_out[43] = data_in[43]^scrambler_state[43]^data_in[4]^scrambler_state[4]^scrambler_state[23];
	assign data_out[44] = data_in[44]^scrambler_state[44]^data_in[5]^scrambler_state[5]^scrambler_state[24];
	assign data_out[45] = data_in[45]^scrambler_state[45]^data_in[6]^scrambler_state[6]^scrambler_state[25];
	assign data_out[46] = data_in[46]^scrambler_state[46]^data_in[7]^scrambler_state[7]^scrambler_state[26];
	assign data_out[47] = data_in[47]^scrambler_state[47]^data_in[8]^scrambler_state[8]^scrambler_state[27];
	assign data_out[48] = data_in[48]^scrambler_state[48]^data_in[9]^scrambler_state[9]^scrambler_state[28];
	assign data_out[49] = data_in[49]^scrambler_state[49]^data_in[10]^scrambler_state[10]^scrambler_state[29];
	assign data_out[50] = data_in[50]^scrambler_state[50]^data_in[11]^scrambler_state[11]^scrambler_state[30];
	assign data_out[51] = data_in[51]^scrambler_state[51]^data_in[12]^scrambler_state[12]^scrambler_state[31];
	assign data_out[52] = data_in[52]^scrambler_state[52]^data_in[13]^scrambler_state[13]^scrambler_state[32];
	assign data_out[53] = data_in[53]^scrambler_state[53]^data_in[14]^scrambler_state[14]^scrambler_state[33];
	assign data_out[54] = data_in[54]^scrambler_state[54]^data_in[15]^scrambler_state[15]^scrambler_state[34];
	assign data_out[55] = data_in[55]^scrambler_state[55]^data_in[16]^scrambler_state[16]^scrambler_state[35];
	assign data_out[56] = data_in[56]^scrambler_state[56]^data_in[17]^scrambler_state[17]^scrambler_state[36];
	assign data_out[57] = data_in[57]^scrambler_state[57]^data_in[18]^scrambler_state[18]^scrambler_state[37];
	assign data_out[58] = data_in[58]^data_in[0]^scrambler_state[0]^data_in[19]^scrambler_state[38];
	assign data_out[59] = data_in[59]^data_in[1]^scrambler_state[1]^data_in[20]^scrambler_state[39];
	assign data_out[60] = data_in[60]^data_in[2]^scrambler_state[2]^data_in[21]^scrambler_state[40];
	assign data_out[61] = data_in[61]^data_in[3]^scrambler_state[3]^data_in[22]^scrambler_state[41];
	assign data_out[62] = data_in[62]^data_in[4]^scrambler_state[4]^data_in[23]^scrambler_state[42];
	assign data_out[63] = data_in[63]^data_in[5]^scrambler_state[5]^data_in[24]^scrambler_state[43];
	assign data_out[64] = data_in[64]^data_in[6]^scrambler_state[6]^data_in[25]^scrambler_state[44];
	assign data_out[65] = data_in[65]^data_in[7]^scrambler_state[7]^data_in[26]^scrambler_state[45];
	assign data_out[66] = data_in[66]^data_in[8]^scrambler_state[8]^data_in[27]^scrambler_state[46];
	assign data_out[67] = data_in[67]^data_in[9]^scrambler_state[9]^data_in[28]^scrambler_state[47];
	assign data_out[68] = data_in[68]^data_in[10]^scrambler_state[10]^data_in[29]^scrambler_state[48];
	assign data_out[69] = data_in[69]^data_in[11]^scrambler_state[11]^data_in[30]^scrambler_state[49];
	assign data_out[70] = data_in[70]^data_in[12]^scrambler_state[12]^data_in[31]^scrambler_state[50];
	assign data_out[71] = data_in[71]^data_in[13]^scrambler_state[13]^data_in[32]^scrambler_state[51];
	assign data_out[72] = data_in[72]^data_in[14]^scrambler_state[14]^data_in[33]^scrambler_state[52];
	assign data_out[73] = data_in[73]^data_in[15]^scrambler_state[15]^data_in[34]^scrambler_state[53];
	assign data_out[74] = data_in[74]^data_in[16]^scrambler_state[16]^data_in[35]^scrambler_state[54];
	assign data_out[75] = data_in[75]^data_in[17]^scrambler_state[17]^data_in[36]^scrambler_state[55];
	assign data_out[76] = data_in[76]^data_in[18]^scrambler_state[18]^data_in[37]^scrambler_state[56];
	assign data_out[77] = data_in[77]^data_in[19]^scrambler_state[19]^data_in[38]^scrambler_state[57];
	assign data_out[78] = data_in[78]^data_in[20]^scrambler_state[20]^data_in[39]^data_in[0]^scrambler_state[0]^scrambler_state[19];
	assign data_out[79] = data_in[79]^data_in[21]^scrambler_state[21]^data_in[40]^data_in[1]^scrambler_state[1]^scrambler_state[20];
	assign data_out[80] = data_in[80]^data_in[22]^scrambler_state[22]^data_in[41]^data_in[2]^scrambler_state[2]^scrambler_state[21];
	assign data_out[81] = data_in[81]^data_in[23]^scrambler_state[23]^data_in[42]^data_in[3]^scrambler_state[3]^scrambler_state[22];
	assign data_out[82] = data_in[82]^data_in[24]^scrambler_state[24]^data_in[43]^data_in[4]^scrambler_state[4]^scrambler_state[23];
	assign data_out[83] = data_in[83]^data_in[25]^scrambler_state[25]^data_in[44]^data_in[5]^scrambler_state[5]^scrambler_state[24];
	assign data_out[84] = data_in[84]^data_in[26]^scrambler_state[26]^data_in[45]^data_in[6]^scrambler_state[6]^scrambler_state[25];
	assign data_out[85] = data_in[85]^data_in[27]^scrambler_state[27]^data_in[46]^data_in[7]^scrambler_state[7]^scrambler_state[26];
	assign data_out[86] = data_in[86]^data_in[28]^scrambler_state[28]^data_in[47]^data_in[8]^scrambler_state[8]^scrambler_state[27];
	assign data_out[87] = data_in[87]^data_in[29]^scrambler_state[29]^data_in[48]^data_in[9]^scrambler_state[9]^scrambler_state[28];
	assign data_out[88] = data_in[88]^data_in[30]^scrambler_state[30]^data_in[49]^data_in[10]^scrambler_state[10]^scrambler_state[29];
	assign data_out[89] = data_in[89]^data_in[31]^scrambler_state[31]^data_in[50]^data_in[11]^scrambler_state[11]^scrambler_state[30];
	assign data_out[90] = data_in[90]^data_in[32]^scrambler_state[32]^data_in[51]^data_in[12]^scrambler_state[12]^scrambler_state[31];
	assign data_out[91] = data_in[91]^data_in[33]^scrambler_state[33]^data_in[52]^data_in[13]^scrambler_state[13]^scrambler_state[32];
	assign data_out[92] = data_in[92]^data_in[34]^scrambler_state[34]^data_in[53]^data_in[14]^scrambler_state[14]^scrambler_state[33];
	assign data_out[93] = data_in[93]^data_in[35]^scrambler_state[35]^data_in[54]^data_in[15]^scrambler_state[15]^scrambler_state[34];
	assign data_out[94] = data_in[94]^data_in[36]^scrambler_state[36]^data_in[55]^data_in[16]^scrambler_state[16]^scrambler_state[35];
	assign data_out[95] = data_in[95]^data_in[37]^scrambler_state[37]^data_in[56]^data_in[17]^scrambler_state[17]^scrambler_state[36];
	assign data_out[96] = data_in[96]^data_in[38]^scrambler_state[38]^data_in[57]^data_in[18]^scrambler_state[18]^scrambler_state[37];
	assign data_out[97] = data_in[97]^data_in[39]^scrambler_state[39]^scrambler_state[19]^data_in[58]^data_in[19]^scrambler_state[38];
	assign data_out[98] = data_in[98]^data_in[40]^scrambler_state[40]^scrambler_state[20]^data_in[59]^data_in[20]^scrambler_state[39];
	assign data_out[99] = data_in[99]^data_in[41]^scrambler_state[41]^scrambler_state[21]^data_in[60]^data_in[21]^scrambler_state[40];
	assign data_out[100] = data_in[100]^data_in[42]^scrambler_state[42]^scrambler_state[22]^data_in[61]^data_in[22]^scrambler_state[41];
	assign data_out[101] = data_in[101]^data_in[43]^scrambler_state[43]^scrambler_state[23]^data_in[62]^data_in[23]^scrambler_state[42];
	assign data_out[102] = data_in[102]^data_in[44]^scrambler_state[44]^scrambler_state[24]^data_in[63]^data_in[24]^scrambler_state[43];
	assign data_out[103] = data_in[103]^data_in[45]^scrambler_state[45]^scrambler_state[25]^data_in[64]^data_in[25]^scrambler_state[44];
	assign data_out[104] = data_in[104]^data_in[46]^scrambler_state[46]^scrambler_state[26]^data_in[65]^data_in[26]^scrambler_state[45];
	assign data_out[105] = data_in[105]^data_in[47]^scrambler_state[47]^scrambler_state[27]^data_in[66]^data_in[27]^scrambler_state[46];
	assign data_out[106] = data_in[106]^data_in[48]^scrambler_state[48]^scrambler_state[28]^data_in[67]^data_in[28]^scrambler_state[47];
	assign data_out[107] = data_in[107]^data_in[49]^scrambler_state[49]^scrambler_state[29]^data_in[68]^data_in[29]^scrambler_state[48];
	assign data_out[108] = data_in[108]^data_in[50]^scrambler_state[50]^scrambler_state[30]^data_in[69]^data_in[30]^scrambler_state[49];
	assign data_out[109] = data_in[109]^data_in[51]^scrambler_state[51]^scrambler_state[31]^data_in[70]^data_in[31]^scrambler_state[50];
	assign data_out[110] = data_in[110]^data_in[52]^scrambler_state[52]^scrambler_state[32]^data_in[71]^data_in[32]^scrambler_state[51];
	assign data_out[111] = data_in[111]^data_in[53]^scrambler_state[53]^scrambler_state[33]^data_in[72]^data_in[33]^scrambler_state[52];
	assign data_out[112] = data_in[112]^data_in[54]^scrambler_state[54]^scrambler_state[34]^data_in[73]^data_in[34]^scrambler_state[53];
	assign data_out[113] = data_in[113]^data_in[55]^scrambler_state[55]^scrambler_state[35]^data_in[74]^data_in[35]^scrambler_state[54];
	assign data_out[114] = data_in[114]^data_in[56]^scrambler_state[56]^scrambler_state[36]^data_in[75]^data_in[36]^scrambler_state[55];
	assign data_out[115] = data_in[115]^data_in[57]^scrambler_state[57]^scrambler_state[37]^data_in[76]^data_in[37]^scrambler_state[56];
endmodule
