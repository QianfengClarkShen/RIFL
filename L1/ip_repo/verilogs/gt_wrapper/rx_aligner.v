`timescale 1ps/1ps
module rx_aligner (
	input wire clk,
	input wire rst,
	input wire [127:0] rxdata_unaligned_in,
	output wire [127:0] rxdata_aligned_out,
	output wire rx_aligned,
	output wire rx_up
);
	reg [20:0] rx_up_counter;
	reg rx_up_reg;

	reg [126:0] rxdata_unaligned_reg;
	reg [1:0] phase1_header_invalid_cnt[7:0];
	reg [4:0] phase1_cnt;
	reg phase1_slide_req[7:0];
	reg [1:0] phase2_header_invalid_cnt;
	reg [4:0] phase2_cnt;
	reg phase2_slide_req;
	reg [4:0] phase2_header_valid_cnt;
	reg rx_aligned_reg;

	wire [254:0] rxdata_combined;
	wire [239:0] phase1_out;
	wire phase1_slide;
	wire [127:0] phase2_out;
	wire phase2_slide;

	phase1_selector phase1_selector_inst (
		.rst(rst),
		.clk(clk),
		.data_in(rxdata_combined),
		.slide_in(phase1_slide),
		.data_out(phase1_out)
	);
	phase2_selector phase2_selector_inst (
		.rst(rst),
		.clk(clk),
		.data_in(phase1_out),
		.slide_in(phase2_slide),
		.data_out(phase2_out)
	);

	`ifdef SIM_SPEED_UP
		always @(posedge clk) begin
			if (rst) begin
				rx_up_counter <= 21'd0;
				rx_up_reg <= 1'b0;
			end
			else begin
				rx_up_reg <= rx_up_counter[12];
				if (~rx_aligned_reg) begin
					if (rx_up_counter != 0)
						rx_up_counter <= rx_up_counter - 21'd1;
					else
						rx_up_counter <= 21'd0;
				end
				else if (~rx_up_counter[12])
					rx_up_counter <= rx_up_counter + 21'd1;
			end
		end
	`else
		always @(posedge clk) begin
			if (rst) begin
				rx_up_counter <= 21'd0;
				rx_up_reg <= 1'b0;
			end
			else begin
				rx_up_reg <= rx_up_counter[20];
				if (~rx_aligned_reg) begin
					if (rx_up_counter != 0)
						rx_up_counter <= rx_up_counter - 21'd1;
				end
				else if (~rx_up_counter[20])
					rx_up_counter <= rx_up_counter + 21'd1;
			end
		end
	`endif

	always @(posedge clk) begin
		rxdata_unaligned_reg <= rxdata_unaligned_in[127:1];
	end
//Phase1 shift control
	always @(posedge clk) begin
		if (rst)
			phase1_cnt <= 5'd0;
		else if (phase1_cnt[4])
			phase1_cnt <= 5'd0;
		else
			phase1_cnt <= phase1_cnt + 1'b1;
	end
	genvar i;
	for (i = 0; i < 8; i = i + 1) begin
		always @(posedge clk) begin
			if (rst) begin
				phase1_header_invalid_cnt[i] <= 2'd0;
				phase1_slide_req[i] <= 1'b0;
			end
			else begin
				if (phase1_cnt[4] | phase1_slide)
					phase1_header_invalid_cnt[i] <= 2'd0;
				else if (phase1_out[239-i*16:236-i*16] != 4'b1010 && phase1_out[239-i*16:236-i*16] != 4'b0101)
					phase1_header_invalid_cnt[i] <= phase1_header_invalid_cnt[i] + 1'b1;
				if (phase1_slide)
					phase1_slide_req[i] <= 1'b0;
				else if (phase1_header_invalid_cnt[i][1])
					phase1_slide_req[i] <= 1'b1;
			end
		end
	end

//Phase2 shift control
	always @(posedge clk) begin
		if (rst) begin
			phase2_header_invalid_cnt <= 2'd0;
			phase2_cnt <= 5'd0;
			phase2_slide_req <= 1'b0;
		end
		else begin
			if (phase2_cnt[4] | phase2_slide) begin
				phase2_header_invalid_cnt <= 2'd0;
				phase2_header_valid_cnt <= 5'd0;
			end
			else if (phase2_out[127:124] != 4'b1010 && phase2_out[127:124] != 4'b0101)
				phase2_header_invalid_cnt <= phase2_header_invalid_cnt + 1'b1;
			else if (~phase2_header_valid_cnt[4])
				phase2_header_valid_cnt <= phase2_header_valid_cnt + 1'b1;
			if (phase2_slide)
				phase2_slide_req <= 1'b0;
			else if (phase2_header_invalid_cnt[1])
				phase2_slide_req <= 1'b1;
			if (phase2_cnt[4])
				phase2_cnt <= 5'd0;
			else
				phase2_cnt <= phase2_cnt + 1'b1;
			if (phase2_slide)
				rx_aligned_reg <= 1'b0;
			else if (phase2_cnt[4] & phase2_header_valid_cnt[4])
				rx_aligned_reg <= 1'b1;
		end
	end

//internal
	assign rxdata_combined = {rxdata_unaligned_in,rxdata_unaligned_reg};
	assign phase1_slide = phase1_slide_req[0] & phase1_slide_req[1] & phase1_slide_req[2] & phase1_slide_req[3] & phase1_slide_req[4] & phase1_slide_req[5] & phase1_slide_req[6] & phase1_slide_req[7];
	assign phase2_slide = phase2_slide_req;

//external
	assign rxdata_aligned_out = phase2_out;
	assign rx_aligned = rx_aligned_reg;
	assign rx_up = rx_up_reg;

endmodule

module phase1_selector (
	input wire rst,
	input wire clk,
	input wire [254:0] data_in,
	input wire slide_in,
	output wire [239:0] data_out
);
	reg [3:0] selector;
	reg [254:0] data_reg;
	wire [3:0] selector_w;

	always @(posedge clk) begin
		if (rst)
			selector <= 4'b0;
		else
			selector <= selector_w;
	end
		
	always @(posedge clk) begin
		case (selector_w)
			4'd0: data_reg <= data_in[239:0];
			4'd1: data_reg <= data_in[240:1];
			4'd2: data_reg <= data_in[241:2];
			4'd3: data_reg <= data_in[242:3];
			4'd4: data_reg <= data_in[243:4];
			4'd5: data_reg <= data_in[244:5];
			4'd6: data_reg <= data_in[245:6];
			4'd7: data_reg <= data_in[246:7];
			4'd8: data_reg <= data_in[247:8];
			4'd9: data_reg <= data_in[248:9];
			4'd10: data_reg <= data_in[249:10];
			4'd11: data_reg <= data_in[250:11];
			4'd12: data_reg <= data_in[251:12];
			4'd13: data_reg <= data_in[252:13];
			4'd14: data_reg <= data_in[253:14];
			4'd15: data_reg <= data_in[254:15];
			default: data_reg <= data_in[239:0];
		endcase
	end
	assign selector_w = selector - slide_in;
	assign data_out = data_reg;
endmodule

module phase2_selector (
	input wire rst,
	input wire clk,
	input wire [239:0] data_in,
	input wire slide_in,
	output wire [127:0] data_out
);
	reg [2:0] selector;
	reg [127:0] data_reg;
	wire [2:0] selector_w;

	always @(posedge clk) begin
		if (rst)
			selector <= 4'b0;
		else
			selector <= selector_w;
	end

	always @(posedge clk) begin
		case (selector_w)
			3'd0: data_reg <= data_in[127:0];
			3'd1: data_reg <= data_in[143:16];
			3'd2: data_reg <= data_in[159:32];
			3'd3: data_reg <= data_in[175:48];
			3'd4: data_reg <= data_in[191:64];
			3'd5: data_reg <= data_in[207:80];
			3'd6: data_reg <= data_in[223:96];
			3'd7: data_reg <= data_in[239:112];
			default: data_reg <= data_in[127:0];
		endcase
	end
	assign selector_w = selector - slide_in;
	assign data_out = data_reg;
endmodule
