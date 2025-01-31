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
`timescale 1ns / 1ps
/*
    Meta Code       Valid Frame     EOP     ABV
    00                  NO          NO      NO
    01                  YES         NO      YES
    10                  YES         YES     NO
    11                  YES         YES     YES
    meta[0]=ABV
    meta[1]=EOP
*/
module remote_fc_detector # 
(
   parameter int DWIDTH = 64,
   parameter int FRAME_WIDTH = 256,
   parameter int CRC_WIDTH = 12
)
(
    input logic tx_gt_clk,
    input logic tx_frame_clk,
    input logic rst,
    input logic [DWIDTH-1:0] din,
    input logic data_sof,
    input logic crc_good,
    input logic din_valid,
    output logic remote_fc = 1'b0
);
    //flow control codes
    localparam bit [7:0] FC_ON_KEY = 8'h01;
    localparam bit [7:0] FC_OFF_KEY = 8'h02;

    if (DWIDTH == FRAME_WIDTH) begin
        logic [1:0] rifl_rx_meta;
        always_ff @(posedge tx_gt_clk) begin
            if (rst)
                remote_fc <= 1'b0;
            else if (rifl_rx_meta == 2'b00 && crc_good && din[CRC_WIDTH+7-:8] == FC_ON_KEY)
                remote_fc <= 1'b1;
            else if (rifl_rx_meta == 2'b00 && crc_good && din[CRC_WIDTH+7-:8] == FC_OFF_KEY)
                remote_fc <= 1'b0;
        end
        assign rifl_rx_meta = din[DWIDTH-3-:2];
    end
    else begin
        localparam int RATIO = FRAME_WIDTH / DWIDTH;
        localparam bit [$clog2(RATIO)-1:0] EOF_CNT = RATIO-1;
        logic [1:0] rifl_rx_meta = 2'b0;
        logic remote_fc_int;
        logic [$clog2(RATIO)-1:0] cnt = {$clog2(RATIO){1'b0}};

        always_ff @(posedge tx_gt_clk) begin
            if (din_valid) begin
                if (data_sof)
                    cnt <= {{($clog2(RATIO)-1){1'b0}},1'b1};
                else
                    cnt <= cnt + 1'b1;
            end
        end
        always_ff @(posedge tx_gt_clk) begin
            if (rst)
                remote_fc_int <= 1'b0;
            else if (din_valid) begin
                if (data_sof)
                    rifl_rx_meta <= din[DWIDTH-3-:2];
                if (cnt == EOF_CNT) begin
                    if (rifl_rx_meta == 2'b00 && crc_good && din[CRC_WIDTH+7-:8] == FC_ON_KEY)
                        remote_fc_int <= 1'b1;
                    else if (rifl_rx_meta == 2'b00 && crc_good && din[CRC_WIDTH+7-:8] == FC_OFF_KEY)
                        remote_fc_int <= 1'b0;
                end
            end
        end
        always_ff @(posedge tx_frame_clk) begin
            remote_fc <= remote_fc_int;
        end
    end
endmodule