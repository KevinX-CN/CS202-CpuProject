vlib work
vlib riviera

vlib riviera/xil_defaultlib
vlib riviera/xpm

vmap xil_defaultlib riviera/xil_defaultlib
vmap xpm riviera/xpm

vlog -work xil_defaultlib  -sv2k12 \
"D:/Symlinks/IDEs/Vivado/2017.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"D:/Symlinks/IDEs/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 \
"../../../../CPU Project.srcs/sources_1/ip/uart_bmpg_0/uart_bmpg.v" \
"../../../../CPU Project.srcs/sources_1/ip/uart_bmpg_0/upg.v" \
"../../../../CPU Project.srcs/sources_1/ip/uart_bmpg_0/sim/uart_bmpg_0.v" \

vlog -work xil_defaultlib \
"glbl.v"

