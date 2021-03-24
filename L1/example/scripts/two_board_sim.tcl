set project_dir [file dirname [file dirname [file normalize [info script]]]]
set project_name "two_board_sim"
set script_dir [file dirname [file normalize [info script]]]
create_project $project_name $project_dir/$project_name -part xczu19eg-ffvc1760-2-i
set_property ip_repo_paths "${project_dir}/../ip_repo/assembled_ips/" [current_project]
update_ip_catalog -rebuild
import_files -fileset sim_1 -norecurse [glob $project_dir/testbench/*.sv]
import_files -fileset sim_1 -norecurse [glob $project_dir/testbench/*.bin]
import_files -fileset sim_1 -norecurse [glob $project_dir/testbench/*.csv]
set source_repo "${project_dir}/../ip_repo/verilogs"
import_files -norecurse [glob ${source_repo}/*/*.v]

set version [lindex [split [lindex [get_ipdefs -all -filter "NAME == gtwizard_ultrascale"] end] ":"] end]
set gt_ip_name "gtwizard_ultrascale"
create_ip -name gtwizard_ultrascale -vendor xilinx.com -library ip -version $version -module_name $gt_ip_name

set_property -dict [list CONFIG.GT_TYPE {GTY} CONFIG.CHANNEL_ENABLE {X0Y12} CONFIG.TX_MASTER_CHANNEL {X0Y12} CONFIG.RX_MASTER_CHANNEL {X0Y12} CONFIG.TX_LINE_RATE {27.9296875} CONFIG.TX_REFCLK_FREQUENCY {322.265625} CONFIG.TX_USER_DATA_WIDTH {128} CONFIG.TX_INT_DATA_WIDTH {64} CONFIG.TX_BUFFER_MODE {0} CONFIG.TX_OUTCLK_SOURCE {TXPROGDIVCLK} CONFIG.RX_LINE_RATE {27.9296875} CONFIG.RX_REFCLK_FREQUENCY {322.265625} CONFIG.RX_USER_DATA_WIDTH {128} CONFIG.RX_INT_DATA_WIDTH {64} CONFIG.RX_BUFFER_MODE {0} CONFIG.RX_EQ_MODE {AUTO} CONFIG.RX_JTOL_FC {10} CONFIG.ENABLE_OPTIONAL_PORTS {loopback_in} CONFIG.RX_REFCLK_SOURCE {} CONFIG.TX_REFCLK_SOURCE {} CONFIG.TXPROGDIV_FREQ_VAL {436.4013672} CONFIG.FREERUN_FREQUENCY {100}] [get_ips gtwizard_ultrascale]

#create_ip -name RIFL -vendor clarkshen.com -library user -module_name RIFL_0
set_property top tb [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]
set_property -name {xsim.compile.xvlog.more_options} -value {-d SIM_SPEED_UP} -objects [get_filesets sim_1]
set_property -name {xsim.simulate.log_all_signals} -value {true} -objects [get_filesets sim_1]
close_project
exit
