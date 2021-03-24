`timescale 1ps/1ps

module clock_buffer (
	input wire src_clk,
	input wire rst,
	output wire usrclk,
	output wire usrclk2,
	output wire usrclk_active
);

	BUFG_GT bufg_inst1 (
		.CE(1'b1),
		.CEMASK(1'b0),
		.CLR(rst),
		.CLRMASK(1'b0),
		.DIV(3'b0),
		.I(src_clk),
        .O(usrclk)
	);
    BUFG_GT bufg_inst2 (
        .CE(1'b1),
        .CEMASK(1'b0),
        .CLR(rst),
        .CLRMASK(1'b0),
        .DIV(3'b1),
        .I(src_clk),
        .O(usrclk2)
    );

	(* ASYNC_REG = "TRUE" *) reg usrclk_active_meta;
	(* ASYNC_REG = "TRUE" *) reg usrclk_active_sync;

	always @(posedge usrclk2, posedge rst) begin
		if (rst) begin
			usrclk_active_meta <= 1'b0;
			usrclk_active_sync <= 1'b0;
		end
		else begin
			usrclk_active_meta <= 1'b1;
			usrclk_active_sync <= usrclk_active_meta;
        end
	end

	assign usrclk_active = usrclk_active_sync;
endmodule

