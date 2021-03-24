#!/bin/bash

traffic_file_name=$1
num_packets=100
min_packet_length=100 #bytes
max_packet_length=1000 
dwidth=14

./gen_traffic_csv.py -n $num_packets -min $min_packet_length -max $max_packet_length -dwidth $dwidth -ignore_cycle_id -ignore_packet_id ${traffic_file_name}_golden.csv
./gen_traffic_bin.py -i ${traffic_file_name}_golden.csv -o ${traffic_file_name}.bin
