create_clock -period 10.000 [get_ports clk100_clk_p]
set_property PACKAGE_PIN C4 [get_ports clk100_clk_p]
set_property PACKAGE_PIN C3 [get_ports clk100_clk_n]
set_property IOSTANDARD LVDS_25 [get_ports clk100_clk_p]
set_property IOSTANDARD LVDS_25 [get_ports clk100_clk_n]

create_clock -period 3.103 [get_ports gt_ref_clk_p]
set_property PACKAGE_PIN R32 [get_ports gt_ref_clk_p]
set_property PACKAGE_PIN R33 [get_ports gt_ref_clk_n]

set_property USER_CLOCK_ROOT X1Y6 [get_nets -of [get_pins -hier * -filter {NAME=~*tx_clock_buffer/bufg_inst1/O}]]
set_property USER_CLOCK_ROOT X1Y6 [get_nets -of [get_pins -hier * -filter {NAME=~*tx_clock_buffer/bufg_inst2/O}]]
set_property USER_CLOCK_ROOT X1Y6 [get_nets -of [get_pins -hier * -filter {NAME=~*rx_clock_buffer/bufg_inst1/O}]]
set_property USER_CLOCK_ROOT X1Y6 [get_nets -of [get_pins -hier * -filter {NAME=~*rx_clock_buffer/bufg_inst2/O}]]

