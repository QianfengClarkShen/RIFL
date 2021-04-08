proc addip {ipName displayName} {
    set vlnv_version_independent [lindex [get_ipdefs -all -filter "NAME == $ipName"] end]
    return [create_bd_cell -type ip -vlnv $vlnv_version_independent $displayName]
}

set script_dir [file dirname [file normalize [info script]]]
#get RIFL configuration
set rifl_config {}
foreach pp {GT_TYPE LANE_LINE_RATE GT_REF_FREQ N_CHANNEL MASTER_CHAN FRAME_WIDTH USER_WIDTH GT_WIDTH \
    CABLE_LENGTH CRC_WIDTH CRC_POLY SCRAMBLER_N1 SCRAMBLER_N2 ERROR_INJ ERROR_SEED
} {
    dict append rifl_config CONFIG.${pp} [get_property CONFIG.${pp} [get_ips]]
}
set project_dir [get_property DIRECTORY [current_project]]
set project_name [get_property NAME [current_project]]
remove_files  ${project_dir}/${project_name}.srcs/sources_1/ip/RIFL_*/RIFL_*.xci
file delete -force ${project_dir}/${project_name}.srcs/sources_1/ip/RIFL_*
source $script_dir/example_syn_bd.tcl
source $script_dir/example_sim_bd.tcl
create_syn_bd $rifl_config $project_dir $project_name
create_sim_bd $rifl_config $project_dir $project_name