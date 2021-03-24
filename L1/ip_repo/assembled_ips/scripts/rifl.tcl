set project_dir [file dirname [file dirname [file normalize [info script]]]]
set project_name "RIFL"

create_project $project_name ${project_dir}/${project_name} -part xczu19eg-ffvc1760-2-i
set source_repo "${project_dir}/../verilogs"
set interface_repo "${project_dir}/../interfaces"
import_files -norecurse [glob ${source_repo}/*/*.v]
import_files -norecurse [glob ${interface_repo}/*/*.xml]
set_property ip_repo_paths "${project_dir}/${project_name}/${project_name}.srcs/sources_1/imports/interfaces" [current_project]
update_ip_catalog -rebuild

set version [lindex [split [lindex [get_ipdefs -all -filter "NAME == gtwizard_ultrascale"] end] ":"] end]
set gt_ip_name "gtwizard_ultrascale"
create_ip -name gtwizard_ultrascale -vendor xilinx.com -library ip -version $version -module_name $gt_ip_name

set_property -dict [list CONFIG.GT_TYPE {GTY} CONFIG.CHANNEL_ENABLE {X0Y12} CONFIG.TX_MASTER_CHANNEL {X0Y12} CONFIG.RX_MASTER_CHANNEL {X0Y12} CONFIG.TX_LINE_RATE {27.9296875} CONFIG.TX_REFCLK_FREQUENCY {322.265625} CONFIG.TX_USER_DATA_WIDTH {128} CONFIG.TX_INT_DATA_WIDTH {64} CONFIG.TX_BUFFER_MODE {0} CONFIG.TX_OUTCLK_SOURCE {TXPROGDIVCLK} CONFIG.RX_LINE_RATE {27.9296875} CONFIG.RX_REFCLK_FREQUENCY {322.265625} CONFIG.RX_USER_DATA_WIDTH {128} CONFIG.RX_INT_DATA_WIDTH {64} CONFIG.RX_BUFFER_MODE {0} CONFIG.RX_EQ_MODE {AUTO} CONFIG.RX_JTOL_FC {10} CONFIG.ENABLE_OPTIONAL_PORTS {loopback_in} CONFIG.RX_REFCLK_SOURCE {} CONFIG.TX_REFCLK_SOURCE {} CONFIG.TXPROGDIV_FREQ_VAL {436.4013672} CONFIG.FREERUN_FREQUENCY {100}] [get_ips gtwizard_ultrascale]

ipx::package_project -root_dir ${project_dir}/${project_name}/${project_name}.srcs/sources_1 -vendor clarkshen.com -library user -taxonomy /UserIP
set_property vendor_display_name {clarkshen.com} [ipx::current_core]
set_property name $project_name [ipx::current_core]
set_property display_name $project_name [ipx::current_core]
set_property description $project_name [ipx::current_core]
set_property core_revision 2 [ipx::current_core]

ipx::add_bus_interface gt_ref_clk [ipx::current_core]
set_property abstraction_type_vlnv xilinx.com:interface:diff_clock_rtl:1.0 [ipx::get_bus_interfaces gt_ref_clk -of_objects [ipx::current_core]]
set_property bus_type_vlnv xilinx.com:interface:diff_clock:1.0 [ipx::get_bus_interfaces gt_ref_clk -of_objects [ipx::current_core]]
set_property display_name gt_ref_clk [ipx::get_bus_interfaces gt_ref_clk -of_objects [ipx::current_core]]
ipx::add_port_map CLK_P [ipx::get_bus_interfaces gt_ref_clk -of_objects [ipx::current_core]]
set_property physical_name gt_ref_clk_p [ipx::get_port_maps CLK_P -of_objects [ipx::get_bus_interfaces gt_ref_clk -of_objects [ipx::current_core]]]
ipx::add_port_map CLK_N [ipx::get_bus_interfaces gt_ref_clk -of_objects [ipx::current_core]]
set_property physical_name gt_ref_clk_n [ipx::get_port_maps CLK_N -of_objects [ipx::get_bus_interfaces gt_ref_clk -of_objects [ipx::current_core]]]

ipx::add_bus_parameter FREQ_HZ [ipx::get_bus_interfaces tx_clk -of_objects [ipx::current_core]]
ipx::add_bus_parameter FREQ_HZ [ipx::get_bus_interfaces rx_clk -of_objects [ipx::current_core]]

set_property value 218200684 [ipx::get_bus_parameters FREQ_HZ -of_objects [ipx::get_bus_interfaces tx_clk -of_objects [ipx::current_core]]]
set_property value 218200684 [ipx::get_bus_parameters FREQ_HZ -of_objects [ipx::get_bus_interfaces rx_clk -of_objects [ipx::current_core]]]
set_property name rifl_stats [ipx::get_bus_interfaces *rifl_stats* -of_objects [ipx::current_core]]
set_property name rifl_gt [ipx::get_bus_interfaces *rifl_gt* -of_objects [ipx::current_core]]
ipx::associate_bus_interfaces -busif m_axis -clock rx_clk [ipx::current_core]
ipx::associate_bus_interfaces -busif s_axis -clock tx_clk [ipx::current_core]
ipx::associate_bus_interfaces -busif rifl_stats -clock init_clk [ipx::current_core]

set_property driver_value 0 [ipx::get_ports gt_loopback_in -of_objects [ipx::current_core]]
set_property enablement_dependency {$ENABLE_GT_LOOPBACK = 1} [ipx::get_ports gt_loopback_in -of_objects [ipx::current_core]]
set_property display_name {enable GT loopback port (not recommended)} [ipgui::get_guiparamspec -name "ENABLE_GT_LOOPBACK" -component [ipx::current_core] ]
set_property widget {checkBox} [ipgui::get_guiparamspec -name "ENABLE_GT_LOOPBACK" -component [ipx::current_core] ]
set_property value false [ipx::get_user_parameters ENABLE_GT_LOOPBACK -of_objects [ipx::current_core]]
set_property value false [ipx::get_hdl_parameters ENABLE_GT_LOOPBACK -of_objects [ipx::current_core]]
set_property value_format bool [ipx::get_user_parameters ENABLE_GT_LOOPBACK -of_objects [ipx::current_core]]
set_property value_format bool [ipx::get_hdl_parameters ENABLE_GT_LOOPBACK -of_objects [ipx::current_core]]

ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::save_core [ipx::current_core]
ipx::merge_project_changes files [ipx::current_core]
ipx::check_integrity -quiet [ipx::current_core]
ipx::archive_core $project_dir/$project_name/${project_name}.srcs/sources_1/${project_name}_1.0.zip [ipx::current_core]
close_project
exit
