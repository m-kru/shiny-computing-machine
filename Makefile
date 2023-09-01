FILES = counters.vhd \
	tests/tb_counter.vhd \
	tests/tb_saturated_counter.vhd

.PHONY: test
test:
	ghdl -a --std=08 $(FILES)
	ghdl -e --std=08 tb_counter
	ghdl -r --std=08 tb_counter
	ghdl -e --std=08 tb_saturated_counter
	ghdl -r --std=08 tb_saturated_counter

.PHONY: clean
clean:
	rm *.o *.cf tb_*
