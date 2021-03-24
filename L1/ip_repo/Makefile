all: assembled_ips/RIFL
RIFL_SOURCES := $(shell find verilogs -name '*.v')

assembled_ips/RIFL: $(RIFL_SOURCES) assembled_ips/scripts/rifl.tcl
	rm -rf assembled_ips/RIFL
	vivado -nolog -nojournal -mode tcl -source assembled_ips/scripts/rifl.tcl

clean:
	rm -rf assembled_ips/RIFL
