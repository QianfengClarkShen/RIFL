`timescale 1ps/1ps
module rifl_tx (
	input wire rst, 
	input wire clk,
	input wire [115:0] data_in,
	input wire valid_in,
	input wire rx_error,
	input wire rx_up,
	input wire remote_pause_req,
	input wire remote_retrans_req,
	output wire tx_up,
	output wire tx_ready,
	output wire [127:0] data_out
);
//header types
	localparam CONTROL = 4'b1010;
	localparam DATA = 4'b0101;
//control codes
	localparam IDLE_KEY = {4'b1001,4'b1101,4'b1001,4'b0001};
	localparam PAUSE_KEY = {4'b1101,4'b1001,4'b0001,4'b1001};
	localparam RETRANS_KEY = {4'b1001,4'b0001,4'b1001,4'b1101};
	localparam END_KEY = 10'b1100100111;
	localparam IDLE_CODE = {CONTROL,2'b00,IDLE_KEY,{6{IDLE_KEY}},END_KEY};
	localparam PAUSE_CODE = {CONTROL,2'b00,PAUSE_KEY,{6{IDLE_KEY}},END_KEY};
	localparam RETRANS_CODE = {CONTROL,2'b00,RETRANS_KEY,{6{IDLE_KEY}},END_KEY};
	localparam DATA_IDLE_CODE = {{56{2'b01}},4'b0};
//states
	localparam INIT = 3'd0;
	localparam NORMAL = 3'd1;
	localparam SEND_PAUSE = 3'd2;
	localparam SEND_RESTRANS = 3'd3;
	localparam PAUSE = 3'd4;
	localparam RETRANS = 3'd5;

	reg [2:0] state;
	reg [9:0] retrans_counter;
	reg [8:0] shiftreg_counter;
	reg [127:0] tx_data_reg;
	reg scrambler_valid_reg;
	reg [115:0] scrambler_out_reg;
	reg [115:0] scrambler_out_reg_1;
	reg crc_valid_reg;
	reg tx_up_reg;
	reg [4:0] tx_up_cnt;
	reg abnormal_flag;

	wire [115:0] scrambler_in;
	wire [115:0] scrambler_out;
	wire scrambler_valid;
	wire [115:0] crc_in;
	wire [7:0] crc_out;
	wire crc_valid_in;
	wire [123:0] shiftreg_in;
	wire [123:0] shiftreg_out;
	wire shiftreg_en;
	wire retrans_data;

//tx FSM
	always @(posedge clk) begin
		if (rst) begin
			state <= INIT;
			abnormal_flag <= 1'b0;
		end
		else begin
			case (state)
				INIT: begin
					if (shiftreg_counter[8])
						state <= SEND_PAUSE;
				end
				NORMAL: begin
					if ((remote_retrans_req | remote_pause_req | rx_error | ~rx_up) & ~abnormal_flag)
						abnormal_flag <= 1'b1;
					else if (abnormal_flag & ~scrambler_valid_reg) begin
						abnormal_flag <= 1'b0;
						if (~rx_up)
							state <= SEND_PAUSE;
						else if (remote_pause_req)
							state <= PAUSE;
						else if (remote_retrans_req)
							state <= RETRANS;
						else if (rx_error)
							state <= SEND_RESTRANS;
					end
				end
				SEND_PAUSE: begin
					if (rx_up) begin
						if (remote_pause_req)
							state <= PAUSE;
						else if (remote_retrans_req || retrans_counter != 0)
							state <= RETRANS;
						else if (rx_error)
							state <= SEND_RESTRANS;
						else
							state <= NORMAL;
					end
				end
				SEND_RESTRANS: begin
					if (~rx_up)
						state <= SEND_PAUSE;
					else if (remote_pause_req)
						state <= PAUSE;
					else if (remote_retrans_req || retrans_counter != 0)
						state <= RETRANS;
					else if (~rx_error)
						state <= NORMAL;
				end
				PAUSE: begin
					if (~rx_up)
						state <= SEND_PAUSE;
					else if (~remote_pause_req) begin
						if (remote_retrans_req || retrans_counter != 0)
							state <= RETRANS;
						else if (rx_error)
							state <= SEND_RESTRANS;
						else
							state <= NORMAL;
					end
				end
				RETRANS: begin
					if (~rx_up)
						state <= SEND_PAUSE;
					else if (remote_pause_req)
						state <= PAUSE;
					else if (~remote_retrans_req & retrans_counter[9]) begin
						if (rx_error)
							state <= SEND_RESTRANS;
						else
							state <= NORMAL;
					end
				end
				default: begin
					state <= INIT;
				end
			endcase
		end
	end

//counter logic
//1. shift register counter, 0-255: filling the restransmit regs up with idle flits
//2. retransmit counter 0-511: ODD: data, EVEN: idle or RETRANS depends on rx_error 512-767: IDLE, wait for remote_retrans_req to become low
	always @(posedge clk) begin
		if (rst) begin
			shiftreg_counter <= 9'd0;
			retrans_counter <= 10'd0;
		end
		else begin
			if (crc_valid_reg & ~shiftreg_counter[8])
				shiftreg_counter <= shiftreg_counter + 1'd1;
			if (state == RETRANS) begin
				if (retrans_counter[9:8] != 2'b11)
					retrans_counter <= retrans_counter + 1'd1;
				else
					retrans_counter <= 10'd0;
			end
		end
	end

//tx up logic
	always @(posedge clk) begin
		if (rst) begin
			tx_up_reg <= 1'b0;
			tx_up_cnt <= 5'd0;
		end
		else begin
			if (state == NORMAL)
				tx_up_reg <= 1'b1;
			else
				tx_up_reg <= 1'b0;
			if (tx_up_reg & ~tx_up_cnt[4])
				tx_up_cnt <= tx_up_cnt + 1'd1;
		end
	end

//tx mux based on different FSM state
	always @(posedge clk) begin
		if (rst)
			tx_data_reg <= PAUSE_CODE;
		else begin
			if (state == INIT)
				tx_data_reg <= PAUSE_CODE;
			else if (state == NORMAL)
				tx_data_reg <= IDLE_CODE;
			else if (state == RETRANS) begin
				if (rx_error)
					tx_data_reg <= RETRANS_CODE;
				else
					tx_data_reg <= IDLE_CODE;
			end
			else if (state == PAUSE)
				tx_data_reg <= IDLE_CODE;
			else if (state == SEND_PAUSE)
				tx_data_reg <= PAUSE_CODE;
			else if (state == SEND_RESTRANS)
				tx_data_reg <= RETRANS_CODE;
			else
				tx_data_reg <= IDLE_CODE;
		end
	end

/*
                                               -------------------------------
                                               |                    ___       |
                                               |                   |    \     |
                                               ---->| shift_reg |->|     \    |
                                                                   | MUX  |------>gt_tx_data
 user_data --> | scrambler | --> | tx_encode | -->(concat)-------->|     /
                             |                       ^             |___ /
                             |                       |
                             ------------------------
*/

	always @(posedge clk) begin
		scrambler_valid_reg <= scrambler_valid;
		scrambler_out_reg <= scrambler_out;
		scrambler_out_reg_1 <= scrambler_out_reg;
		crc_valid_reg <= crc_valid_in;
	end

	scrambler scrambler_inst (
		.clk(clk),
		.rst(rst),
		.data_in(scrambler_in),
		.valid_in(scrambler_valid),
		.data_out(scrambler_out)
	);

	tx_encode tx_encode_inst (
		.clk(clk),
		.rst(rst),
		.data_in(crc_in),
		.valid_in(crc_valid_in),
		.crc_out(crc_out)
	);

	shift_reg # (
		.DWIDTH(124)
	) shift_reg_inst (
		.clk(clk),
		.enable(shiftreg_en),
		.data_in(shiftreg_in),
		.data_out(shiftreg_out)
	);

	assign retrans_data = state == RETRANS && ~retrans_counter[9] && ~retrans_counter[0];
	assign shiftreg_in = state == RETRANS ? shiftreg_out : {scrambler_out_reg_1,crc_out};
	assign shiftreg_en = crc_valid_reg | retrans_data;

	assign crc_in = scrambler_out_reg;
	assign crc_valid_in = scrambler_valid_reg;

	assign scrambler_in = (valid_in && tx_ready) ? data_in : DATA_IDLE_CODE;
	assign scrambler_valid = (state == INIT && shiftreg_counter < 9'd255) || (state == NORMAL && ~abnormal_flag);

	assign tx_up = tx_up_reg;
	assign tx_ready = state == NORMAL && tx_up_cnt[4] && ~abnormal_flag;
	assign data_out = ((state == NORMAL && crc_valid_reg) || retrans_data) ? {DATA,shiftreg_in} : tx_data_reg;
endmodule
