-makelib ies_lib/xil_defaultlib -sv \
  "D:/Symlinks/IDEs/Vivado/2017.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "D:/Symlinks/IDEs/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../CPU Project.srcs/sources_1/ip/cpuclk/cpuclk_clk_wiz.v" \
  "../../../../CPU Project.srcs/sources_1/ip/cpuclk/cpuclk.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

