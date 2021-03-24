`timescale 1ps/1ps
module rifl_rx (
	input wire clk,
	input wire rst, 
	input wire [127:0] data_in,
	input wire rx_aligned,
	input wire rx_up,
	output wire rx_error,
	output wire remote_pause_req,
	output wire remote_retrans_req,
	output wire [115:0] data_out,
	output wire valid_out
);

//header types
	localparam CONTROL = 4'b1010;
	localparam DATA = 4'b0101;
//control codes
	localparam IDLE_KEY = {4'b1001,4'b1101,4'b1001,4'b0001};
	localparam PAUSE_KEY = {4'b1101,4'b1001,4'b0001,4'b1001};
	localparam RETRANS_KEY = {4'b1001,4'b0001,4'b1001,4'b1101};

//rx header and data regs
	reg [3:0] rx_header_reg;
	reg [15:0] rx_ctrl_code_reg;

//counters and status regs for remote control codes
	reg remote_pause_reg;
	reg remote_retrans_reg;
	reg [3:0] remote_pause_cnt;
	reg [3:0] remote_retrans_cnt;
	reg [4:0] remote_data_or_idle_cnt;

	wire crc_good;

//cache control plane for one cycle, wait for data plan crc decode
	always @(posedge clk) begin
		rx_header_reg <= data_in[127:124];
		rx_ctrl_code_reg <= data_in[121:106];
	end

//remote state counter logic
	always @(posedge clk) begin
		if (rst) begin
			remote_pause_reg <= 1'b1;
			remote_retrans_reg <= 1'b0;
			remote_pause_cnt <= 4'd0;
			remote_retrans_cnt <= 4'd0;
			remote_data_or_idle_cnt <= 5'd0;
		end
		else if (rx_up) begin
			if (rx_header_reg != CONTROL || rx_ctrl_code_reg != PAUSE_KEY)
				remote_pause_cnt <= 4'd0;
			else if (~remote_pause_cnt[3])
				remote_pause_cnt <= remote_pause_cnt + 1'd1;

			if (rx_header_reg != CONTROL || rx_ctrl_code_reg != RETRANS_KEY)
				remote_retrans_cnt <= 4'd0;
			else if (~remote_retrans_cnt[3])
				remote_retrans_cnt <= remote_retrans_cnt + 1'd1;

			if (rx_header_reg != DATA && (rx_header_reg != CONTROL || rx_ctrl_code_reg != IDLE_KEY))
				remote_data_or_idle_cnt <= 5'd0;
			else if (~remote_data_or_idle_cnt[4])
				remote_data_or_idle_cnt <= remote_data_or_idle_cnt + 1'd1;

			if (remote_data_or_idle_cnt[4])
				remote_retrans_reg <= 1'b0;
			else if (remote_retrans_cnt[3])
				remote_retrans_reg <= 1'b1;

			if (remote_pause_cnt[3])
				remote_pause_reg <= 1'b1;
			else if (valid_out | remote_data_or_idle_cnt[4] | remote_retrans_cnt[3])
				remote_pause_reg <= 1'b0;
		end
		else begin
			remote_pause_cnt <= 4'd0;
			remote_retrans_cnt <= 4'd0;
			remote_data_or_idle_cnt <= 5'd0;
		end
	end

	rx_decode rx_decode_inst (
		.clk(clk),
		.rst(rst),
		.data_in(data_in),
		.enable(rx_up),
		.data_out(data_out),
		.valid_out(valid_out),
		.crc_good(crc_good),
		.rx_error(rx_error)
	);

//external wires
    assign remote_pause_req = remote_pause_reg;
    assign remote_retrans_req = remote_retrans_reg;

endmodule
