### INIT CLOCK##########################################
#create_clock -period 10.000 [get_ports init_clk_p]
#set_property IOSTANDARD LVDS_25 [get_ports {init_clk_p[0]}]
#set_property IOSTANDARD LVDS_25 [get_ports {init_clk_n[0]}]
#set_property PACKAGE_PIN C4 [get_ports {init_clk_p[0]}]
#set_property PACKAGE_PIN C3 [get_ports {init_clk_n[0]}]
#create_clock -period 3.103 [get_ports gt_ref_clk_p]
#set_property PACKAGE_PIN R32 [get_ports gt_ref_clk_p]
#set_property PACKAGE_PIN R33 [get_ports gt_ref_clk_n]
