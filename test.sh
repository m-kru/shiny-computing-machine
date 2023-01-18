set -e

ghdl -a --std=08 counters.vhd tb_counter.vhd
ghdl -e --std=08 tb_counter
ghdl -r --std=08 tb_counter
