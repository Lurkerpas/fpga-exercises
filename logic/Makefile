.PHONY: all clean

all: trace

verify: logic_tb.vhd logic.vhd
	ghdl -a --std=08 logic.vhd logic_tb.vhd
	ghdl -e --std=08 logic_tb

trace: verify
	ghdl -r --std=08 logic_tb --wave=trace.ghw --stop-time=1us

view: verify
	gtkwave trace.ghw
clean:
	rm -f *.o *.cf logic_tb