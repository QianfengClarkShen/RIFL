set project_dir [file dirname [file dirname [file normalize [info script]]]]
set project_name "traffic_gen_board1"
set script_dir [file dirname [file normalize [info script]]]
create_project $project_name $project_dir/$project_name -part xczu19eg-ffvc1760-2-i
set ip_repo_paths [list "${project_dir}/../ip_repo/assembled_ips/RIFL" "${project_dir}/${project_name}"]
set_property ip_repo_paths ${ip_repo_paths} [current_project]
update_ip_catalog -rebuild
update_ip_catalog -add_ip ${project_dir}/external_ips/SD_AXIS_traffic_gen_1.0.zip -repo_path ${project_dir}/${project_name}
update_ip_catalog -add_ip ${project_dir}/external_ips/zero_latency_axis_fifo_1.0.zip -repo_path ${project_dir}/${project_name}
update_ip_catalog -rebuild

source ${script_dir}/util.tcl
source ${script_dir}/${project_name}_bd.tcl

make_wrapper -files [get_files $project_dir/$project_name/${project_name}.srcs/sources_1/bd/${project_name}/${project_name}.bd] -top
add_files -norecurse $project_dir/$project_name/${project_name}.srcs/sources_1/bd/${project_name}/hdl/${project_name}_wrapper.v
save_bd_design
import_files -fileset constrs_1 -norecurse $project_dir/constraints/${project_name}.xdc
close_project
exit
