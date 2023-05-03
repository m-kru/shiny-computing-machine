test:
	ghdl -a --std=08 counters.vhd tests/tb_counter.vhd
	ghdl -e --std=08 tb_counter
	ghdl -r --std=08 tb_counter

clean:
	rm *.o *.cf tb_*
