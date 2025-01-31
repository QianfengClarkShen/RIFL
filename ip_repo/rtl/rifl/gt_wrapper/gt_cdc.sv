//MIT License
//
//Author: Qianfeng (Clark) Shen;Contact: qianfeng.shen@gmail.com
//
//Copyright (c) 2021 swift-link
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
`timescale 1ns/1ps
module gt_cdc (
    input logic init_clk,
    input logic txusrclk2,
    input logic rxusrclk2,
    input logic rst,
    input logic tx_good_tx_synced,
    input logic rx_good_rx_synced,
    output logic tx_good_init_synced,
    output logic rx_good_init_synced
);
    sync_signle_bit #(
        .N_STAGE   (5),
        .INPUT_REG (1)
    ) tx_good_init_sync_inst (
        .clk_in  (txusrclk2),
    	.clk_out (init_clk),
        .rst     (rst),
        .din     (tx_good_tx_synced),
        .dout    (tx_good_init_synced)
    );
    sync_signle_bit #(
        .N_STAGE   (5),
        .INPUT_REG (1)
    ) rx_good_init_sync_inst (
        .clk_in  (rxusrclk2),
        .clk_out (init_clk),
        .rst     (rst),
        .din     (rx_good_rx_synced),
        .dout    (rx_good_init_synced)
    );
endmodule
