module rx_axis_helper
(
	input [115:0] rx_int_data,
	input rx_int_valid,
	output [111:0] rx_tdata,
	output [13:0] rx_tkeep,
	output rx_tlast,
	output rx_valid
);
	wire [3:0] mty;
	
	assign mty = rx_int_data[3:0];

	assign rx_tdata = rx_int_data[115:4];
	assign rx_tlast = mty != 4'd14 ? 1'b1 : 1'b0;
	assign rx_valid = mty != 0 && rx_int_valid;
	genvar i;
	for (i = 0; i < 14; i = i + 1) begin
		assign rx_tkeep[13-i] = mty > i;
	end
endmodule
