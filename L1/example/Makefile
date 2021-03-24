SIM_SOURCES := $(shell find scripts -name 'two_board_sim.tcl')
IMPL_SOURCES := $(shell find scripts -name *.tcl -not -path "scripts/*sim.tcl")
impl: traffic_gen_board1 traffic_loopback_board2

traffic_gen_board1:	$(IMPL_SOURCES)
	rm -rf traffic_gen_board1
	vivado -mode tcl -source scripts/traffic_gen_board1.tcl -nolog -nojournal

traffic_loopback_board2: $(IMPL_SOURCES)
	rm -rf traffic_loopback_board2
	vivado -mode tcl -source scripts/traffic_loopback_board2.tcl -nolog -nojournal

sim: two_board_sim
two_board_sim: $(SIM_SOURCES)
	rm -rf two_board_sim
	vivado -mode tcl -source scripts/two_board_sim.tcl -nolog -nojournal
clean:
	rm -rf two_board_sim traffic_gen_board1 traffic_loopback_board2 .Xil
