# 
# Synthesis run script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
create_project -in_memory -part xc7a12ticsg325-1L

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir {D:/Projects/CS202/CPU Project/CPU Project.cache/wt} [current_project]
set_property parent.project_path {D:/Projects/CS202/CPU Project/CPU Project.xpr} [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_repo_paths d:/Downloads/SEU_CSE_507_user_uart_bmpg_1.3/uart [current_project]
set_property ip_output_repo {d:/Projects/CS202/CPU Project/CPU Project.cache/ip} [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib {
  {D:/Projects/CS202/CPU Project/CPU Project.srcs/sources_1/new/ALU32.v}
  {D:/Projects/CS202/CPU Project/CPU Project.srcs/sources_1/new/Controller32.v}
  {D:/Projects/CS202/CPU Project/CPU Project.srcs/sources_1/new/Decoder.v}
  {D:/Projects/CS202/CPU Project/CPU Project.srcs/sources_1/new/IFetch32.v}
  {D:/Projects/CS202/CPU Project/CPU Project.srcs/sources_1/new/MemOrIO.v}
  {D:/Projects/CS202/CPU Project/CPU Project.srcs/sources_1/new/ProgramROM32.v}
  {D:/Projects/CS202/CPU Project/CPU Project.srcs/sources_1/new/Screen.v}
  {D:/Projects/CS202/CPU Project/CPU Project.srcs/sources_1/new/debounce.v}
  {D:/Projects/CS202/CPU Project/CPU Project.srcs/sources_1/new/CPU32.v}
}
read_ip -quiet {{D:/Projects/CS202/CPU Project/CPU Project.srcs/sources_1/ip/prgrom/prgrom.xci}}
set_property used_in_implementation false [get_files -all {{d:/Projects/CS202/CPU Project/CPU Project.srcs/sources_1/ip/prgrom/prgrom_ooc.xdc}}]

read_ip -quiet {{D:/Projects/CS202/CPU Project/CPU Project.srcs/sources_1/ip/uart_bmpg_0/uart_bmpg_0.xci}}

read_ip -quiet {{D:/Projects/CS202/CPU Project/CPU Project.srcs/sources_1/ip/cpuclk/cpuclk.xci}}
set_property used_in_implementation false [get_files -all {{d:/Projects/CS202/CPU Project/CPU Project.srcs/sources_1/ip/cpuclk/cpuclk_board.xdc}}]
set_property used_in_implementation false [get_files -all {{d:/Projects/CS202/CPU Project/CPU Project.srcs/sources_1/ip/cpuclk/cpuclk.xdc}}]
set_property used_in_implementation false [get_files -all {{d:/Projects/CS202/CPU Project/CPU Project.srcs/sources_1/ip/cpuclk/cpuclk_ooc.xdc}}]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}

synth_design -top CPU32 -part xc7a12ticsg325-1L


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef CPU32.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file CPU32_utilization_synth.rpt -pb CPU32_utilization_synth.pb"
