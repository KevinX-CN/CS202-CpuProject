vlib work
vlib riviera

vlib riviera/xil_defaultlib
vlib riviera/xpm

vmap xil_defaultlib riviera/xil_defaultlib
vmap xpm riviera/xpm

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../ipstatic" "+incdir+../../../ipstatic" \
"D:/Symlinks/IDEs/Vivado/2017.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"D:/Symlinks/IDEs/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../ipstatic" "+incdir+../../../ipstatic" \
"../../../../CPU Project.srcs/sources_1/ip/cpuclk/cpuclk_clk_wiz.v" \
"../../../../CPU Project.srcs/sources_1/ip/cpuclk/cpuclk.v" \

vlog -work xil_defaultlib \
"glbl.v"

