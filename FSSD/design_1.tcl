
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2019.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcvu9p-flga2104-2L-e
   set_property BOARD_PART xilinx.com:vcu118:part0:2.3 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
user.org:user:AXI_request_arbiter:1.0\
xilinx.com:ip:axi_protocol_converter:2.1\
xilinx.com:ip:axi_dwidth_converter:2.1\
xilinx.com:ip:axi_clock_converter:2.1\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:axi_timer:2.0\
xilinx.com:ip:axi_uartlite:2.0\
xilinx.com:user:burst_ctrl:1.0\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:ddr4:2.2\
user.org:user:delay_network_wrapper:1.0\
user.org:user:hw_ftl_w_cachesim:1.0\
xilinx.com:ip:mdm:3.2\
xilinx.com:ip:microblaze:11.0\
xilinx.com:ip:axi_intc:4.1\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:nvme_mapper:1.0\
xilinx.com:ip:nvme_tc:1.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:qdma:3.0\
xilinx.com:ip:system_ila:1.1\
xilinx.com:ip:util_ds_buf:2.1\
xilinx.com:ip:util_vector_logic:2.0\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:lmb_bram_if_cntlr:4.0\
xilinx.com:ip:lmb_v10:3.0\
xilinx.com:ip:blk_mem_gen:8.4\
"

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}


##################################################################
# DATA FILE TCL PROCs
##################################################################

proc write_ddr4_file_design_1_ddr4_0_0 { str_filepath } {

   file mkdir [ file dirname "$str_filepath" ]
   set data_file [open $str_filepath  w+]

   puts $data_file {Part type,Part name,Rank,CA Mirror,Data mask,Address width,Row width,Column width,Bank width,Bank group width,CS width,CKE width,ODT width,CK width,Memory speed grade,Memory density,Component density,Memory device width,Memory component width,Data bits per strobe,IO Voltages,Data widths,Min period,Max period,tCKE,tFAW,tMRD,tRAS,tRCD,tREFI,tRFC,tRP,tRRD_S,tRRD_L,tRTP,tWR,tWTR_S,tWTR_L,tXPR,tZQCS,tZQINIT,cas latency,cas write latency,burst length,RTT (nominal) - ODT}
   puts $data_file {Components,DDR4_2400_64_250SP,1,0,1,17,16,10,2,1,1,1,1,1,83,4GB,8Gb,16,16,8,1.2V,64,833,1600,5000 ps,30000 ps,8 tck,32000 ps,14161 ps,7800000 ps,260000 ps,14161 ps,5300 ps,6400 ps,7500 ps,15000 ps,2500 ps,7500 ps,270 ns,128 tck,1024 tck,17,12,8,RZQ/6}

   close $data_file
}
# End of write_ddr4_file_design_1_ddr4_0_0()



##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: microblaze_1_local_memory
proc create_hier_cell_microblaze_1_local_memory { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_microblaze_1_local_memory() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 DLMB

  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 ILMB


  # Create pins
  create_bd_pin -dir I -type clk LMB_Clk
  create_bd_pin -dir I -type rst SYS_Rst

  # Create instance: dlmb_bram_if_cntlr, and set properties
  set dlmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 dlmb_bram_if_cntlr ]
  set_property -dict [ list \
   CONFIG.C_ECC {0} \
 ] $dlmb_bram_if_cntlr

  # Create instance: dlmb_v10, and set properties
  set dlmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 dlmb_v10 ]

  # Create instance: ilmb_bram_if_cntlr, and set properties
  set ilmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 ilmb_bram_if_cntlr ]
  set_property -dict [ list \
   CONFIG.C_ECC {0} \
 ] $ilmb_bram_if_cntlr

  # Create instance: ilmb_v10, and set properties
  set ilmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 ilmb_v10 ]

  # Create instance: lmb_bram, and set properties
  set lmb_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 lmb_bram ]
  set_property -dict [ list \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
   CONFIG.use_bram_block {BRAM_Controller} \
 ] $lmb_bram

  # Create interface connections
  connect_bd_intf_net -intf_net microblaze_1_dlmb [get_bd_intf_pins DLMB] [get_bd_intf_pins dlmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_1_dlmb_bus [get_bd_intf_pins dlmb_bram_if_cntlr/SLMB] [get_bd_intf_pins dlmb_v10/LMB_Sl_0]
  connect_bd_intf_net -intf_net microblaze_1_dlmb_cntlr [get_bd_intf_pins dlmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTA]
  connect_bd_intf_net -intf_net microblaze_1_ilmb [get_bd_intf_pins ILMB] [get_bd_intf_pins ilmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_1_ilmb_bus [get_bd_intf_pins ilmb_bram_if_cntlr/SLMB] [get_bd_intf_pins ilmb_v10/LMB_Sl_0]
  connect_bd_intf_net -intf_net microblaze_1_ilmb_cntlr [get_bd_intf_pins ilmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTB]

  # Create port connections
  connect_bd_net -net SYS_Rst_1 [get_bd_pins SYS_Rst] [get_bd_pins dlmb_bram_if_cntlr/LMB_Rst] [get_bd_pins dlmb_v10/SYS_Rst] [get_bd_pins ilmb_bram_if_cntlr/LMB_Rst] [get_bd_pins ilmb_v10/SYS_Rst]
  connect_bd_net -net microblaze_1_Clk [get_bd_pins LMB_Clk] [get_bd_pins dlmb_bram_if_cntlr/LMB_Clk] [get_bd_pins dlmb_v10/LMB_Clk] [get_bd_pins ilmb_bram_if_cntlr/LMB_Clk] [get_bd_pins ilmb_v10/LMB_Clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: microblaze_0_local_memory
proc create_hier_cell_microblaze_0_local_memory { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_microblaze_0_local_memory() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 DLMB

  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 ILMB


  # Create pins
  create_bd_pin -dir I -type clk LMB_Clk
  create_bd_pin -dir I -type rst SYS_Rst

  # Create instance: dlmb_bram_if_cntlr, and set properties
  set dlmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 dlmb_bram_if_cntlr ]
  set_property -dict [ list \
   CONFIG.C_ECC {0} \
 ] $dlmb_bram_if_cntlr

  # Create instance: dlmb_v10, and set properties
  set dlmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 dlmb_v10 ]

  # Create instance: ilmb_bram_if_cntlr, and set properties
  set ilmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 ilmb_bram_if_cntlr ]
  set_property -dict [ list \
   CONFIG.C_ECC {0} \
 ] $ilmb_bram_if_cntlr

  # Create instance: ilmb_v10, and set properties
  set ilmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 ilmb_v10 ]

  # Create instance: lmb_bram, and set properties
  set lmb_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 lmb_bram ]
  set_property -dict [ list \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
   CONFIG.use_bram_block {BRAM_Controller} \
 ] $lmb_bram

  # Create interface connections
  connect_bd_intf_net -intf_net microblaze_0_dlmb [get_bd_intf_pins DLMB] [get_bd_intf_pins dlmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_bus [get_bd_intf_pins dlmb_bram_if_cntlr/SLMB] [get_bd_intf_pins dlmb_v10/LMB_Sl_0]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_cntlr [get_bd_intf_pins dlmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTA]
  connect_bd_intf_net -intf_net microblaze_0_ilmb [get_bd_intf_pins ILMB] [get_bd_intf_pins ilmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_bus [get_bd_intf_pins ilmb_bram_if_cntlr/SLMB] [get_bd_intf_pins ilmb_v10/LMB_Sl_0]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_cntlr [get_bd_intf_pins ilmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTB]

  # Create port connections
  connect_bd_net -net SYS_Rst_1 [get_bd_pins SYS_Rst] [get_bd_pins dlmb_bram_if_cntlr/LMB_Rst] [get_bd_pins dlmb_v10/SYS_Rst] [get_bd_pins ilmb_bram_if_cntlr/LMB_Rst] [get_bd_pins ilmb_v10/SYS_Rst]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins LMB_Clk] [get_bd_pins dlmb_bram_if_cntlr/LMB_Clk] [get_bd_pins dlmb_v10/LMB_Clk] [get_bd_pins ilmb_bram_if_cntlr/LMB_Clk] [get_bd_pins ilmb_v10/LMB_Clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set ddr4_sdram_c1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 ddr4_sdram_c1 ]

  set ddr4_sdram_c2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 ddr4_sdram_c2 ]

  set default_250mhz_clk1 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 default_250mhz_clk1 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   ] $default_250mhz_clk1

  set default_250mhz_clk2 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 default_250mhz_clk2 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   ] $default_250mhz_clk2

  set default_sysclk1_300 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 default_sysclk1_300 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {300000000} \
   ] $default_sysclk1_300

  set pci_express_x4 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pci_express_x4 ]

  set pcie_refclk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 pcie_refclk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
   ] $pcie_refclk

  set rs232_uart [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 rs232_uart ]


  # Create ports
  set pcie_perstn [ create_bd_port -dir I -type rst pcie_perstn ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] $pcie_perstn

  # Create instance: AXI_request_arbiter_0, and set properties
  set AXI_request_arbiter_0 [ create_bd_cell -type ip -vlnv user.org:user:AXI_request_arbiter:1.0 AXI_request_arbiter_0 ]

  # Create instance: auto_pc, and set properties
  set auto_pc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_protocol_converter:2.1 auto_pc ]
  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.MI_PROTOCOL {AXI4} \
   CONFIG.SI_PROTOCOL {AXI4LITE} \
 ] $auto_pc

  # Create instance: auto_us, and set properties
  set auto_us [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dwidth_converter:2.1 auto_us ]
  set_property -dict [ list \
   CONFIG.MI_DATA_WIDTH {512} \
   CONFIG.SI_DATA_WIDTH {32} \
 ] $auto_us

  # Create instance: axi_clock_converter_0, and set properties
  set axi_clock_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_clock_converter:2.1 axi_clock_converter_0 ]
  set_property -dict [ list \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.WUSER_WIDTH {0} \
 ] $axi_clock_converter_0

  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {1} \
   CONFIG.C_ALL_OUTPUTS_2 {1} \
   CONFIG.C_DOUT_DEFAULT_2 {0x0000000F} \
   CONFIG.C_GPIO2_WIDTH {4} \
   CONFIG.C_GPIO_WIDTH {29} \
   CONFIG.C_IS_DUAL {0} \
 ] $axi_gpio_0

  # Create instance: axi_interconnect_1, and set properties
  set axi_interconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_1 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {9} \
   CONFIG.NUM_SI {2} \
 ] $axi_interconnect_1

  # Create instance: axi_interconnect_2, and set properties
  set axi_interconnect_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_2 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {3} \
 ] $axi_interconnect_2

  # Create instance: axi_interconnect_4, and set properties
  set axi_interconnect_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_4 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {3} \
 ] $axi_interconnect_4

  # Create instance: axi_timer_0, and set properties
  set axi_timer_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 axi_timer_0 ]

  # Create instance: axi_uartlite_0, and set properties
  set axi_uartlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0 ]
  set_property -dict [ list \
   CONFIG.C_BAUDRATE {115200} \
   CONFIG.C_S_AXI_ACLK_FREQ_HZ {70000000} \
   CONFIG.UARTLITE_BOARD_INTERFACE {rs232_uart} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $axi_uartlite_0

  # Create instance: burst_ctrl_0, and set properties
  set burst_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:burst_ctrl:1.0 burst_ctrl_0 ]
  set_property -dict [ list \
   CONFIG.id_width {4} \
 ] $burst_ctrl_0

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {33.330000000000005} \
   CONFIG.CLKOUT1_JITTER {218.263} \
   CONFIG.CLKOUT1_PHASE_ERROR {353.636} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {70.000} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {119.875} \
   CONFIG.MMCM_CLKIN1_PERIOD {3.333} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {17.125} \
   CONFIG.MMCM_DIVCLK_DIVIDE {30} \
   CONFIG.PRIM_IN_FREQ {300.000} \
   CONFIG.RESET_PORT {resetn} \
   CONFIG.RESET_TYPE {ACTIVE_LOW} \
 ] $clk_wiz_0

  # Create instance: clk_wiz_1, and set properties
  set clk_wiz_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_1 ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {33.330000000000005} \
   CONFIG.CLKOUT1_JITTER {203.051} \
   CONFIG.CLKOUT1_PHASE_ERROR {331.749} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {70.000} \
   CONFIG.CLKOUT2_JITTER {170.919} \
   CONFIG.CLKOUT2_PHASE_ERROR {331.749} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {250.000} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLK_IN1_BOARD_INTERFACE {default_sysclk1_300} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {125.125} \
   CONFIG.MMCM_CLKIN1_PERIOD {3.333} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {17.875} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {5} \
   CONFIG.MMCM_DIVCLK_DIVIDE {30} \
   CONFIG.NUM_OUT_CLKS {2} \
   CONFIG.PRIM_IN_FREQ {300.000} \
   CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
   CONFIG.RESET_PORT {resetn} \
   CONFIG.RESET_TYPE {ACTIVE_LOW} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $clk_wiz_1

  # Create instance: ddr4_0, and set properties
  set ddr4_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ddr4:2.2 ddr4_0 ]

   # Generate the DDR4 Custom Parts File
   set str_ddr4_folder [get_property IP_DIR [ get_ips [ get_property CONFIG.Component_Name $ddr4_0 ] ] ]
   set str_ddr4_file_name DDR4_2400_64.csv
   set str_ddr4_file_path ${str_ddr4_folder}/${str_ddr4_file_name}

   write_ddr4_file_design_1_ddr4_0_0 $str_ddr4_file_path

  set_property -dict [ list \
   CONFIG.ADDN_UI_CLKOUT1_FREQ_HZ {100} \
   CONFIG.C0.BANK_GROUP_WIDTH {1} \
   CONFIG.C0.DDR4_AxiAddressWidth {31} \
   CONFIG.C0.DDR4_AxiDataWidth {512} \
   CONFIG.C0.DDR4_CLKFBOUT_MULT {6} \
   CONFIG.C0.DDR4_CLKOUT0_DIVIDE {5} \
   CONFIG.C0.DDR4_CasLatency {18} \
   CONFIG.C0.DDR4_CasWriteLatency {12} \
   CONFIG.C0.DDR4_CustomParts {DDR4_2400_64.csv} \
   CONFIG.C0.DDR4_DIVCLK_DIVIDE {1} \
   CONFIG.C0.DDR4_DataMask {DM_NO_DBI} \
   CONFIG.C0.DDR4_DataWidth {64} \
   CONFIG.C0.DDR4_Ecc {false} \
   CONFIG.C0.DDR4_InputClockPeriod {4000} \
   CONFIG.C0.DDR4_MemoryPart {MT40A256M16GE-083E} \
   CONFIG.C0.DDR4_TimePeriod {833} \
   CONFIG.C0.DDR4_isCustom {true} \
   CONFIG.C0_CLOCK_BOARD_INTERFACE {default_250mhz_clk1} \
   CONFIG.C0_DDR4_BOARD_INTERFACE {ddr4_sdram_c1} \
 ] $ddr4_0

  # Create instance: ddr4_1, and set properties
  set ddr4_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ddr4:2.2 ddr4_1 ]
  set_property -dict [ list \
   CONFIG.ADDN_UI_CLKOUT1_FREQ_HZ {100} \
   CONFIG.C0.BANK_GROUP_WIDTH {1} \
   CONFIG.C0.DDR4_AxiAddressWidth {31} \
   CONFIG.C0.DDR4_AxiDataWidth {512} \
   CONFIG.C0.DDR4_CLKOUT0_DIVIDE {5} \
   CONFIG.C0.DDR4_CasWriteLatency {12} \
   CONFIG.C0.DDR4_DataWidth {64} \
   CONFIG.C0.DDR4_InputClockPeriod {4000} \
   CONFIG.C0.DDR4_MemoryPart {MT40A256M16GE-083E} \
   CONFIG.C0.DDR4_TimePeriod {833} \
   CONFIG.C0_CLOCK_BOARD_INTERFACE {default_250mhz_clk2} \
   CONFIG.C0_DDR4_BOARD_INTERFACE {ddr4_sdram_c2} \
 ] $ddr4_1

  # Create instance: delay_network_wrapper_0, and set properties
  set delay_network_wrapper_0 [ create_bd_cell -type ip -vlnv user.org:user:delay_network_wrapper:1.0 delay_network_wrapper_0 ]
  set_property -dict [ list \
   CONFIG.CHANNEL {2} \
   CONFIG.DIE_PER_CHANNEL {1} \
   CONFIG.PAGE_BUFFER_SIZE {4096} \
   CONFIG.PB_MISS {1748} \
   CONFIG.PB_WRITE {15385} \
   CONFIG.PLANE_PER_DIE {8} \
 ] $delay_network_wrapper_0

  # Create instance: hw_ftl_w_cachesim_0, and set properties
  set hw_ftl_w_cachesim_0 [ create_bd_cell -type ip -vlnv user.org:user:hw_ftl_w_cachesim:1.0 hw_ftl_w_cachesim_0 ]
  set_property -dict [ list \
   CONFIG.page_size {4096} \
 ] $hw_ftl_w_cachesim_0

  # Create instance: mdm_1, and set properties
  set mdm_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mdm:3.2 mdm_1 ]
  set_property -dict [ list \
   CONFIG.C_MB_DBG_PORTS {2} \
   CONFIG.C_USE_UART {1} \
 ] $mdm_1

  # Create instance: microblaze_0, and set properties
  set microblaze_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 microblaze_0 ]
  set_property -dict [ list \
   CONFIG.C_ADDR_TAG_BITS {15} \
   CONFIG.C_CACHE_BYTE_SIZE {32768} \
   CONFIG.C_DCACHE_ADDR_TAG {15} \
   CONFIG.C_DCACHE_BYTE_SIZE {32768} \
   CONFIG.C_DCACHE_VICTIMS {8} \
   CONFIG.C_DEBUG_ENABLED {1} \
   CONFIG.C_DIV_ZERO_EXCEPTION {1} \
   CONFIG.C_D_AXI {1} \
   CONFIG.C_D_LMB {1} \
   CONFIG.C_ICACHE_LINE_LEN {8} \
   CONFIG.C_ICACHE_STREAMS {1} \
   CONFIG.C_ICACHE_VICTIMS {8} \
   CONFIG.C_ILL_OPCODE_EXCEPTION {1} \
   CONFIG.C_I_LMB {1} \
   CONFIG.C_MMU_ZONES {2} \
   CONFIG.C_M_AXI_D_BUS_EXCEPTION {1} \
   CONFIG.C_M_AXI_I_BUS_EXCEPTION {1} \
   CONFIG.C_OPCODE_0x0_ILLEGAL {1} \
   CONFIG.C_PVR {2} \
   CONFIG.C_UNALIGNED_EXCEPTIONS {1} \
   CONFIG.C_USE_BARREL {1} \
   CONFIG.C_USE_DCACHE {1} \
   CONFIG.C_USE_DIV {1} \
   CONFIG.C_USE_HW_MUL {2} \
   CONFIG.C_USE_ICACHE {1} \
   CONFIG.C_USE_MMU {3} \
   CONFIG.C_USE_MSR_INSTR {1} \
   CONFIG.C_USE_PCMP_INSTR {1} \
   CONFIG.G_TEMPLATE_LIST {4} \
   CONFIG.G_USE_EXCEPTIONS {1} \
 ] $microblaze_0

  # Create instance: microblaze_0_axi_intc, and set properties
  set microblaze_0_axi_intc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 microblaze_0_axi_intc ]
  set_property -dict [ list \
   CONFIG.C_HAS_FAST {1} \
 ] $microblaze_0_axi_intc

  # Create instance: microblaze_0_local_memory
  create_hier_cell_microblaze_0_local_memory [current_bd_instance .] microblaze_0_local_memory

  # Create instance: microblaze_0_xlconcat, and set properties
  set microblaze_0_xlconcat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 microblaze_0_xlconcat ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {8} \
 ] $microblaze_0_xlconcat

  # Create instance: microblaze_1, and set properties
  set microblaze_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 microblaze_1 ]
  set_property -dict [ list \
   CONFIG.C_ADDR_TAG_BITS {0} \
   CONFIG.C_BASE_VECTORS {0x0000000080004000} \
   CONFIG.C_CACHE_BYTE_SIZE {8192} \
   CONFIG.C_DCACHE_ADDR_TAG {0} \
   CONFIG.C_DCACHE_ALWAYS_USED {1} \
   CONFIG.C_DCACHE_BYTE_SIZE {8192} \
   CONFIG.C_DEBUG_ENABLED {1} \
   CONFIG.C_D_AXI {1} \
   CONFIG.C_D_LMB {1} \
   CONFIG.C_ICACHE_ALWAYS_USED {1} \
   CONFIG.C_I_LMB {1} \
   CONFIG.C_USE_DCACHE {0} \
   CONFIG.C_USE_ICACHE {0} \
 ] $microblaze_1

  # Create instance: microblaze_1_local_memory
  create_hier_cell_microblaze_1_local_memory [current_bd_instance .] microblaze_1_local_memory

  # Create instance: nvme_mapper_0, and set properties
  set nvme_mapper_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:nvme_mapper:1.0 nvme_mapper_0 ]
  set_property -dict [ list \
   CONFIG.AXI_DDR_ADDR_WIDTH {32} \
   CONFIG.AXI_DDR_DWIDTH {256} \
   CONFIG.AXI_SW_ID_WIDTH {4} \
   CONFIG.C2H_CONTROLLER_FIFO_DEPTH {512} \
   CONFIG.C2H_WQE_FIFO_DEPTH {16} \
   CONFIG.CQ_FIFO_DEPTH {128} \
   CONFIG.C_NUM_SSD {1} \
   CONFIG.DEBUG_EN {true} \
   CONFIG.EN_P2P_BUFFERS {false} \
   CONFIG.EN_SW_IF {false} \
   CONFIG.FREEPOOL_CMDID_FIFO_DEPTH {4096} \
   CONFIG.FREEPOOL_DBID_FIFO_DEPTH {1024} \
   CONFIG.FREEPOOL_SGLIND_FIFO_DEPTH {4096} \
   CONFIG.H2C_CONTROLLER_FIFO_DEPTH {16} \
   CONFIG.H2C_WQE_FIFO_DEPTH {16} \
   CONFIG.HW_FULL_CMD {true} \
   CONFIG.MAX_PRP_PER_CMD {16} \
   CONFIG.MAX_PRP_PER_DDR_RD {32} \
   CONFIG.NSID_SSDID_LUT_DEPTH {32} \
   CONFIG.NS_MAPPER_FIFO_DEPTH {512} \
   CONFIG.NUM_UID_SUPPORT {512} \
   CONFIG.P2P_PF_NUM {1} \
   CONFIG.PAGE_SIZE {4096} \
   CONFIG.RD_SQ_FIFO_DEPTH {128} \
   CONFIG.SSD_CREDIT_LMT_0 {126} \
   CONFIG.SSD_CREDIT_LMT_1 {252} \
   CONFIG.SSD_CREDIT_LMT_2 {252} \
   CONFIG.SSD_CREDIT_LMT_3 {252} \
   CONFIG.SSD_CREDIT_LMT_4 {252} \
   CONFIG.SSD_CREDIT_LMT_5 {252} \
   CONFIG.SSD_CREDIT_LMT_6 {252} \
   CONFIG.SSD_CREDIT_LMT_7 {252} \
   CONFIG.SSD_CREDIT_LMT_8 {252} \
   CONFIG.SSD_CREDIT_LMT_9 {252} \
   CONFIG.SSD_CREDIT_LMT_10 {252} \
   CONFIG.SSD_CREDIT_LMT_11 {252} \
   CONFIG.SSD_CREDIT_LMT_12 {252} \
   CONFIG.SSD_CREDIT_LMT_13 {252} \
   CONFIG.SSD_CREDIT_LMT_14 {252} \
   CONFIG.SSD_CREDIT_LMT_15 {252} \
   CONFIG.SSD_CREDIT_LMT_16 {252} \
   CONFIG.SSD_CREDIT_LMT_17 {252} \
   CONFIG.SSD_CREDIT_LMT_18 {252} \
   CONFIG.SSD_CREDIT_LMT_19 {252} \
   CONFIG.SSD_CREDIT_LMT_20 {252} \
   CONFIG.SSD_CREDIT_LMT_21 {252} \
   CONFIG.SSD_CREDIT_LMT_22 {252} \
   CONFIG.SSD_CREDIT_LMT_23 {252} \
   CONFIG.SSD_CREDIT_LMT_24 {252} \
   CONFIG.SSD_CREDIT_LMT_25 {252} \
   CONFIG.SSD_CREDIT_LMT_26 {252} \
   CONFIG.SSD_CREDIT_LMT_27 {252} \
   CONFIG.SSD_CREDIT_LMT_28 {252} \
   CONFIG.SSD_CREDIT_LMT_29 {252} \
   CONFIG.SSD_CREDIT_LMT_30 {252} \
   CONFIG.SSD_CREDIT_LMT_31 {252} \
   CONFIG.SW_FULL_CMD {true} \
   CONFIG.TC_STAND_ALONE {true} \
   CONFIG.WR_SQ_FIFO_DEPTH {128} \
 ] $nvme_mapper_0

  # Create instance: nvme_tc_0, and set properties
  set nvme_tc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:nvme_tc:1.0 nvme_tc_0 ]
  set_property -dict [ list \
   CONFIG.C_AGGREGATOR_SYS {0} \
   CONFIG.C_ARB_BURST {2} \
   CONFIG.C_CAP_MAX_HOST_Q_DEPTH {255} \
   CONFIG.C_CAP_MPSMAX {0} \
   CONFIG.C_CAP_MPSMIN {0} \
   CONFIG.C_CAP_TIMEOUT {255} \
   CONFIG.C_DEBUG_EN {1} \
   CONFIG.C_LBA_DATA_SIZE {4096} \
   CONFIG.C_MAX_DMA_SIZE {4096} \
   CONFIG.C_MDTS {1} \
   CONFIG.C_M_AXI_ADDR_WIDTH {32} \
   CONFIG.C_M_AXI_DATA_WIDTH {256} \
   CONFIG.C_NUM_CMD_INDX {512} \
   CONFIG.C_NUM_FUNC {1} \
   CONFIG.C_NUM_HSQ {2} \
   CONFIG.C_NUM_SGLS_PER_INDX {16} \
   CONFIG.C_PERF_MON_EN {1} \
   CONFIG.C_SGL_SUPPORT {0} \
   CONFIG.C_S_AXI_ADDR_WIDTH {32} \
   CONFIG.C_S_AXI_DATA_WIDTH {128} \
   CONFIG.C_S_AXI_ID_WIDTH {1} \
   CONFIG.C_S_AXI_LITE_ADDR_WIDTH {32} \
   CONFIG.C_S_AXI_LITE_DATA_WIDTH {32} \
 ] $nvme_tc_0

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: qdma_0, and set properties
  set qdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:qdma:3.0 qdma_0 ]
  set_property -dict [ list \
   CONFIG.MAILBOX_ENABLE {true} \
   CONFIG.PCIE_BOARD_INTERFACE {pci_express_x4} \
   CONFIG.PF0_MSIX_CAP_PBA_BIR_qdma {BAR_5:4} \
   CONFIG.PF0_MSIX_CAP_TABLE_BIR_qdma {BAR_5:4} \
   CONFIG.PF0_SRIOV_CAP_INITIAL_VF {4} \
   CONFIG.PF0_SRIOV_FIRST_VF_OFFSET {4} \
   CONFIG.PF0_SRIOV_VF_DEVICE_ID {A034} \
   CONFIG.PF1_MSIX_CAP_PBA_BIR_qdma {BAR_5:4} \
   CONFIG.PF1_MSIX_CAP_TABLE_BIR_qdma {BAR_5:4} \
   CONFIG.PF1_SRIOV_VF_DEVICE_ID {A134} \
   CONFIG.PF2_MSIX_CAP_PBA_BIR_qdma {BAR_5:4} \
   CONFIG.PF2_MSIX_CAP_TABLE_BIR_qdma {BAR_5:4} \
   CONFIG.PF2_SRIOV_VF_DEVICE_ID {A234} \
   CONFIG.PF3_MSIX_CAP_PBA_BIR_qdma {BAR_5:4} \
   CONFIG.PF3_MSIX_CAP_TABLE_BIR_qdma {BAR_5:4} \
   CONFIG.PF3_SRIOV_VF_DEVICE_ID {A334} \
   CONFIG.SRIOV_CAP_ENABLE {true} \
   CONFIG.SRIOV_FIRST_VF_OFFSET {4} \
   CONFIG.SYS_RST_N_BOARD_INTERFACE {pcie_perstn} \
   CONFIG.axi_data_width {256_bit} \
   CONFIG.axilite_master_en {true} \
   CONFIG.axisten_freq {125} \
   CONFIG.barlite_mb_pf0 {16} \
   CONFIG.c2h_stream_cpl_col_bit_pos0 {0} \
   CONFIG.c2h_stream_cpl_err_bit_pos0 {0} \
   CONFIG.coreclk_freq {250} \
   CONFIG.dma_intf_sel_qdma {AXI_Stream_with_Completion} \
   CONFIG.dsc_bypass_rd {true} \
   CONFIG.dsc_bypass_wr {true} \
   CONFIG.en_axi_mm_qdma {false} \
   CONFIG.en_gt_selection {true} \
   CONFIG.flr_enable {true} \
   CONFIG.pf0_ari_enabled {true} \
   CONFIG.pf0_bar0_prefetchable_qdma {true} \
   CONFIG.pf0_bar0_size_qdma {64} \
   CONFIG.pf0_bar0_type_qdma {AXI_Lite_Master} \
   CONFIG.pf0_bar2_64bit_qdma {false} \
   CONFIG.pf0_bar2_enabled_qdma {false} \
   CONFIG.pf0_bar2_prefetchable_qdma {false} \
   CONFIG.pf0_bar2_size_qdma {4} \
   CONFIG.pf0_bar2_type_qdma {AXI_Lite_Master} \
   CONFIG.pf0_bar4_64bit_qdma {true} \
   CONFIG.pf0_bar4_enabled_qdma {true} \
   CONFIG.pf0_bar4_prefetchable_qdma {true} \
   CONFIG.pf0_bar4_type_qdma {DMA} \
   CONFIG.pf0_class_code_base_qdma {01} \
   CONFIG.pf0_class_code_interface_qdma {02} \
   CONFIG.pf0_class_code_qdma {010802} \
   CONFIG.pf0_class_code_sub_qdma {08} \
   CONFIG.pf0_device_id {9034} \
   CONFIG.pf0_sriov_bar0_size {64} \
   CONFIG.pf0_sriov_bar0_type {AXI_Lite_Master} \
   CONFIG.pf0_sriov_bar2_64bit {false} \
   CONFIG.pf0_sriov_bar2_enabled {false} \
   CONFIG.pf0_sriov_bar2_prefetchable {false} \
   CONFIG.pf0_sriov_bar2_size {4} \
   CONFIG.pf0_sriov_bar2_type {AXI_Lite_Master} \
   CONFIG.pf0_sriov_bar4_64bit {true} \
   CONFIG.pf0_sriov_bar4_enabled {true} \
   CONFIG.pf0_sriov_bar4_prefetchable {true} \
   CONFIG.pf0_sriov_bar4_size {128} \
   CONFIG.pf0_sriov_bar4_type {DMA} \
   CONFIG.pf1_bar0_prefetchable_qdma {true} \
   CONFIG.pf1_bar0_size_qdma {64} \
   CONFIG.pf1_bar0_type_qdma {AXI_Lite_Master} \
   CONFIG.pf1_bar2_64bit_qdma {false} \
   CONFIG.pf1_bar2_enabled_qdma {false} \
   CONFIG.pf1_bar2_prefetchable_qdma {false} \
   CONFIG.pf1_bar2_size_qdma {4} \
   CONFIG.pf1_bar2_type_qdma {AXI_Lite_Master} \
   CONFIG.pf1_bar4_64bit_qdma {true} \
   CONFIG.pf1_bar4_enabled_qdma {true} \
   CONFIG.pf1_bar4_prefetchable_qdma {true} \
   CONFIG.pf1_bar4_type_qdma {DMA} \
   CONFIG.pf1_sriov_bar0_size {64} \
   CONFIG.pf1_sriov_bar0_type {AXI_Lite_Master} \
   CONFIG.pf1_sriov_bar2_64bit {false} \
   CONFIG.pf1_sriov_bar2_enabled {false} \
   CONFIG.pf1_sriov_bar2_prefetchable {false} \
   CONFIG.pf1_sriov_bar2_size {4} \
   CONFIG.pf1_sriov_bar2_type {AXI_Lite_Master} \
   CONFIG.pf1_sriov_bar4_64bit {true} \
   CONFIG.pf1_sriov_bar4_enabled {true} \
   CONFIG.pf1_sriov_bar4_prefetchable {true} \
   CONFIG.pf1_sriov_bar4_size {128} \
   CONFIG.pf1_sriov_bar4_type {DMA} \
   CONFIG.pf2_bar0_prefetchable_qdma {true} \
   CONFIG.pf2_bar0_size_qdma {64} \
   CONFIG.pf2_bar0_type_qdma {AXI_Lite_Master} \
   CONFIG.pf2_bar2_64bit_qdma {false} \
   CONFIG.pf2_bar2_enabled_qdma {false} \
   CONFIG.pf2_bar2_prefetchable_qdma {false} \
   CONFIG.pf2_bar2_size_qdma {4} \
   CONFIG.pf2_bar2_type_qdma {AXI_Lite_Master} \
   CONFIG.pf2_bar4_64bit_qdma {true} \
   CONFIG.pf2_bar4_enabled_qdma {true} \
   CONFIG.pf2_bar4_prefetchable_qdma {true} \
   CONFIG.pf2_bar4_type_qdma {DMA} \
   CONFIG.pf2_device_id {9234} \
   CONFIG.pf2_sriov_bar0_size {64} \
   CONFIG.pf2_sriov_bar0_type {AXI_Lite_Master} \
   CONFIG.pf2_sriov_bar2_64bit {false} \
   CONFIG.pf2_sriov_bar2_enabled {false} \
   CONFIG.pf2_sriov_bar2_prefetchable {false} \
   CONFIG.pf2_sriov_bar2_size {4} \
   CONFIG.pf2_sriov_bar2_type {AXI_Lite_Master} \
   CONFIG.pf2_sriov_bar4_64bit {true} \
   CONFIG.pf2_sriov_bar4_enabled {true} \
   CONFIG.pf2_sriov_bar4_prefetchable {true} \
   CONFIG.pf2_sriov_bar4_size {128} \
   CONFIG.pf2_sriov_bar4_type {DMA} \
   CONFIG.pf3_bar0_prefetchable_qdma {true} \
   CONFIG.pf3_bar0_size_qdma {64} \
   CONFIG.pf3_bar0_type_qdma {AXI_Lite_Master} \
   CONFIG.pf3_bar2_64bit_qdma {false} \
   CONFIG.pf3_bar2_enabled_qdma {false} \
   CONFIG.pf3_bar2_prefetchable_qdma {false} \
   CONFIG.pf3_bar2_size_qdma {4} \
   CONFIG.pf3_bar2_type_qdma {AXI_Lite_Master} \
   CONFIG.pf3_bar4_64bit_qdma {true} \
   CONFIG.pf3_bar4_enabled_qdma {true} \
   CONFIG.pf3_bar4_prefetchable_qdma {true} \
   CONFIG.pf3_bar4_type_qdma {DMA} \
   CONFIG.pf3_device_id {9334} \
   CONFIG.pf3_sriov_bar0_size {64} \
   CONFIG.pf3_sriov_bar0_type {AXI_Lite_Master} \
   CONFIG.pf3_sriov_bar2_64bit {false} \
   CONFIG.pf3_sriov_bar2_enabled {false} \
   CONFIG.pf3_sriov_bar2_prefetchable {false} \
   CONFIG.pf3_sriov_bar2_size {4} \
   CONFIG.pf3_sriov_bar2_type {AXI_Lite_Master} \
   CONFIG.pf3_sriov_bar4_64bit {true} \
   CONFIG.pf3_sriov_bar4_enabled {true} \
   CONFIG.pf3_sriov_bar4_prefetchable {true} \
   CONFIG.pf3_sriov_bar4_size {128} \
   CONFIG.pf3_sriov_bar4_type {DMA} \
   CONFIG.pl_link_cap_max_link_width {X4} \
   CONFIG.testname {st} \
   CONFIG.xdma_axilite_slave {true} \
 ] $qdma_0

  # Create instance: qdma_0_axi_periph, and set properties
  set qdma_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 qdma_0_axi_periph ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
 ] $qdma_0_axi_periph

  # Create instance: rst_clk_wiz_0_70M, and set properties
  set rst_clk_wiz_0_70M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_0_70M ]

  # Create instance: rst_clk_wiz_1_100M, and set properties
  set rst_clk_wiz_1_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_1_100M ]
  set_property -dict [ list \
   CONFIG.C_AUX_RST_WIDTH {4} \
   CONFIG.C_EXT_RST_WIDTH {4} \
 ] $rst_clk_wiz_1_100M

  # Create instance: rst_clk_wiz_1_100M1, and set properties
  set rst_clk_wiz_1_100M1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_1_100M1 ]

  # Create instance: rst_ddr4_0_333M, and set properties
  set rst_ddr4_0_333M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ddr4_0_333M ]

  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [ list \
   CONFIG.C_BRAM_CNT {275.5} \
   CONFIG.C_DATA_DEPTH {4096} \
   CONFIG.C_NUM_MONITOR_SLOTS {1} \
 ] $system_ila_0

  # Create instance: system_ila_2, and set properties
  set system_ila_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_2 ]

  # Create instance: util_ds_buf_4, and set properties
  set util_ds_buf_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_4 ]
  set_property -dict [ list \
   CONFIG.C_BUFGCE_DIV {1} \
   CONFIG.C_BUF_TYPE {IBUFDSGTE} \
   CONFIG.DIFF_CLK_IN_BOARD_INTERFACE {pcie_refclk} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $util_ds_buf_4

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_vector_logic_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {6} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {6} \
   CONFIG.IN3_WIDTH {1} \
   CONFIG.IN4_WIDTH {6} \
   CONFIG.IN5_WIDTH {1} \
   CONFIG.IN6_WIDTH {6} \
   CONFIG.IN7_WIDTH {1} \
   CONFIG.NUM_PORTS {9} \
 ] $xlconcat_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]

  # Create instance: xlconstant_2, and set properties
  set xlconstant_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_2 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {256} \
 ] $xlconstant_2

  # Create instance: xlconstant_3, and set properties
  set xlconstant_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_3 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_3

  # Create interface connections
  connect_bd_intf_net -intf_net AXI_request_arbiter_0_m00_axis [get_bd_intf_pins AXI_request_arbiter_0/m00_axis] [get_bd_intf_pins delay_network_wrapper_0/s01_axis]
  connect_bd_intf_net -intf_net S01_AXI_1 [get_bd_intf_pins axi_interconnect_2/S01_AXI] [get_bd_intf_pins axi_interconnect_4/M00_AXI]
  connect_bd_intf_net -intf_net auto_pc_M_AXI [get_bd_intf_pins auto_pc/M_AXI] [get_bd_intf_pins auto_us/S_AXI]
  connect_bd_intf_net -intf_net auto_us_M_AXI [get_bd_intf_pins auto_us/M_AXI] [get_bd_intf_pins axi_interconnect_4/S02_AXI]
  connect_bd_intf_net -intf_net axi_clock_converter_0_M_AXI [get_bd_intf_pins axi_clock_converter_0/M_AXI] [get_bd_intf_pins ddr4_1/C0_DDR4_S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M00_AXI [get_bd_intf_pins axi_interconnect_1/M00_AXI] [get_bd_intf_pins microblaze_0_axi_intc/s_axi]
  connect_bd_intf_net -intf_net axi_interconnect_1_M01_AXI [get_bd_intf_pins axi_interconnect_1/M01_AXI] [get_bd_intf_pins mdm_1/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M02_AXI [get_bd_intf_pins axi_interconnect_1/M02_AXI] [get_bd_intf_pins axi_uartlite_0/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M03_AXI [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins axi_interconnect_1/M03_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M04_AXI [get_bd_intf_pins axi_interconnect_1/M04_AXI] [get_bd_intf_pins nvme_mapper_0/S_AXI_LITE]
  connect_bd_intf_net -intf_net axi_interconnect_1_M05_AXI [get_bd_intf_pins auto_pc/S_AXI] [get_bd_intf_pins axi_interconnect_1/M05_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M06_AXI [get_bd_intf_pins axi_interconnect_1/M06_AXI] [get_bd_intf_pins nvme_tc_0/sw_s_axi_lite]
  connect_bd_intf_net -intf_net axi_interconnect_1_M07_AXI [get_bd_intf_pins axi_interconnect_1/M07_AXI] [get_bd_intf_pins axi_timer_0/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M08_AXI [get_bd_intf_pins axi_interconnect_1/M08_AXI] [get_bd_intf_pins nvme_tc_0/sw_s_axi]
  connect_bd_intf_net -intf_net axi_interconnect_2_M00_AXI [get_bd_intf_pins axi_interconnect_2/M00_AXI] [get_bd_intf_pins ddr4_0/C0_DDR4_S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M01_AXI [get_bd_intf_pins axi_interconnect_2/M01_AXI] [get_bd_intf_pins burst_ctrl_0/axi_s]
connect_bd_intf_net -intf_net [get_bd_intf_nets axi_interconnect_2_M01_AXI] [get_bd_intf_pins axi_interconnect_2/M01_AXI] [get_bd_intf_pins system_ila_2/SLOT_0_AXI]
  connect_bd_intf_net -intf_net axi_uartlite_0_UART [get_bd_intf_ports rs232_uart] [get_bd_intf_pins axi_uartlite_0/UART]
  connect_bd_intf_net -intf_net burst_ctrl_0_axi_m_cache [get_bd_intf_pins AXI_request_arbiter_0/s00_axi] [get_bd_intf_pins burst_ctrl_0/axi_m_cache]
  connect_bd_intf_net -intf_net ddr4_0_C0_DDR4 [get_bd_intf_ports ddr4_sdram_c1] [get_bd_intf_pins ddr4_0/C0_DDR4]
  connect_bd_intf_net -intf_net ddr4_1_C0_DDR4 [get_bd_intf_ports ddr4_sdram_c2] [get_bd_intf_pins ddr4_1/C0_DDR4]
  connect_bd_intf_net -intf_net default_250mhz_clk1_1 [get_bd_intf_ports default_250mhz_clk1] [get_bd_intf_pins ddr4_0/C0_SYS_CLK]
  connect_bd_intf_net -intf_net default_250mhz_clk2_1 [get_bd_intf_ports default_250mhz_clk2] [get_bd_intf_pins ddr4_1/C0_SYS_CLK]
  connect_bd_intf_net -intf_net default_sysclk1_300_1 [get_bd_intf_ports default_sysclk1_300] [get_bd_intf_pins clk_wiz_1/CLK_IN1_D]
  connect_bd_intf_net -intf_net delay_emulation_m00_axi [get_bd_intf_pins AXI_request_arbiter_0/m00_axi] [get_bd_intf_pins axi_clock_converter_0/S_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets delay_emulation_m00_axi] [get_bd_intf_pins axi_clock_converter_0/S_AXI] [get_bd_intf_pins system_ila_0/SLOT_0_AXI]
  connect_bd_intf_net -intf_net delay_network_wrapper_0_m01_axis [get_bd_intf_pins AXI_request_arbiter_0/s00_axis] [get_bd_intf_pins delay_network_wrapper_0/m01_axis]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_DC [get_bd_intf_pins axi_interconnect_4/S00_AXI] [get_bd_intf_pins microblaze_0/M_AXI_DC]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_DP [get_bd_intf_pins axi_interconnect_1/S00_AXI] [get_bd_intf_pins microblaze_0/M_AXI_DP]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_IC [get_bd_intf_pins axi_interconnect_4/S01_AXI] [get_bd_intf_pins microblaze_0/M_AXI_IC]
  connect_bd_intf_net -intf_net microblaze_0_debug [get_bd_intf_pins mdm_1/MBDEBUG_0] [get_bd_intf_pins microblaze_0/DEBUG]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_1 [get_bd_intf_pins microblaze_0/DLMB] [get_bd_intf_pins microblaze_0_local_memory/DLMB]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_1 [get_bd_intf_pins microblaze_0/ILMB] [get_bd_intf_pins microblaze_0_local_memory/ILMB]
  connect_bd_intf_net -intf_net microblaze_0_interrupt [get_bd_intf_pins microblaze_0/INTERRUPT] [get_bd_intf_pins microblaze_0_axi_intc/interrupt]
  connect_bd_intf_net -intf_net microblaze_1_M_AXI_DP [get_bd_intf_pins axi_interconnect_1/S01_AXI] [get_bd_intf_pins microblaze_1/M_AXI_DP]
  connect_bd_intf_net -intf_net microblaze_1_debug [get_bd_intf_pins mdm_1/MBDEBUG_1] [get_bd_intf_pins microblaze_1/DEBUG]
  connect_bd_intf_net -intf_net microblaze_1_dlmb_1 [get_bd_intf_pins microblaze_1/DLMB] [get_bd_intf_pins microblaze_1_local_memory/DLMB]
  connect_bd_intf_net -intf_net microblaze_1_ilmb_1 [get_bd_intf_pins microblaze_1/ILMB] [get_bd_intf_pins microblaze_1_local_memory/ILMB]
  connect_bd_intf_net -intf_net nvme_mapper_0_M_AXIS_HA [get_bd_intf_pins nvme_mapper_0/M_AXIS_HA] [get_bd_intf_pins nvme_mapper_0/S_AXIS_HA]
  connect_bd_intf_net -intf_net nvme_mapper_0_M_AXIS_SGL_PRP_REQ [get_bd_intf_pins nvme_mapper_0/M_AXIS_SGL_PRP_REQ] [get_bd_intf_pins nvme_tc_0/sgl_prp_req_s_axis]
  connect_bd_intf_net -intf_net nvme_mapper_0_M_AXIS_WQE_EP [get_bd_intf_pins nvme_mapper_0/M_AXIS_WQE_EP] [get_bd_intf_pins nvme_tc_0/wqe_s_axis]
  connect_bd_intf_net -intf_net nvme_mapper_0_M_AXI_DDR [get_bd_intf_pins axi_interconnect_2/S02_AXI] [get_bd_intf_pins nvme_mapper_0/M_AXI_DDR]
  connect_bd_intf_net -intf_net nvme_tc_0_c2h_byp_out [get_bd_intf_pins nvme_tc_0/c2h_byp_out] [get_bd_intf_pins qdma_0/c2h_byp_in_st]
  connect_bd_intf_net -intf_net nvme_tc_0_cmd_m_axis [get_bd_intf_pins nvme_mapper_0/S_AXIS_CMD_EP] [get_bd_intf_pins nvme_tc_0/cmd_m_axis]
  connect_bd_intf_net -intf_net nvme_tc_0_ddr_m_axi [get_bd_intf_pins axi_interconnect_2/S00_AXI] [get_bd_intf_pins nvme_tc_0/ddr_m_axi]
  connect_bd_intf_net -intf_net nvme_tc_0_dsc_crdt_in [get_bd_intf_pins nvme_tc_0/dsc_crdt_in] [get_bd_intf_pins qdma_0/dsc_crdt_in]
  connect_bd_intf_net -intf_net nvme_tc_0_h2c_byp_out [get_bd_intf_pins nvme_tc_0/h2c_byp_out] [get_bd_intf_pins qdma_0/h2c_byp_in_st]
  connect_bd_intf_net -intf_net nvme_tc_0_m_axis_c2h [get_bd_intf_pins nvme_tc_0/m_axis_c2h] [get_bd_intf_pins qdma_0/s_axis_c2h]
  connect_bd_intf_net -intf_net nvme_tc_0_m_axis_c2h_cmpt [get_bd_intf_pins nvme_tc_0/m_axis_c2h_cmpt] [get_bd_intf_pins qdma_0/s_axis_c2h_cmpt]
  connect_bd_intf_net -intf_net nvme_tc_0_qdma_m_axi_lite [get_bd_intf_pins nvme_tc_0/qdma_m_axi_lite] [get_bd_intf_pins qdma_0/S_AXI_LITE]
  connect_bd_intf_net -intf_net nvme_tc_0_sgl_prp_fill_m_axis [get_bd_intf_pins nvme_mapper_0/S_AXIS_SGL_PRP_RESP] [get_bd_intf_pins nvme_tc_0/sgl_prp_fill_m_axis]
  connect_bd_intf_net -intf_net nvme_tc_0_usr_flr [get_bd_intf_pins nvme_tc_0/usr_flr] [get_bd_intf_pins qdma_0/usr_flr]
  connect_bd_intf_net -intf_net nvme_tc_0_usr_irq [get_bd_intf_pins nvme_tc_0/usr_irq] [get_bd_intf_pins qdma_0/usr_irq]
  connect_bd_intf_net -intf_net nvme_tc_0_wqe_cmpl_m_axis [get_bd_intf_pins nvme_mapper_0/S_AXIS_WQC_EP] [get_bd_intf_pins nvme_tc_0/wqe_cmpl_m_axis]
  connect_bd_intf_net -intf_net pcie_refclk_1 [get_bd_intf_ports pcie_refclk] [get_bd_intf_pins util_ds_buf_4/CLK_IN_D]
  connect_bd_intf_net -intf_net qdma_0_M_AXI_LITE [get_bd_intf_pins qdma_0/M_AXI_LITE] [get_bd_intf_pins qdma_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net qdma_0_axi_periph_M00_AXI [get_bd_intf_pins nvme_tc_0/host_s_axi_lite] [get_bd_intf_pins qdma_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net qdma_0_axis_c2h_drop [get_bd_intf_pins nvme_tc_0/axis_c2h_drop] [get_bd_intf_pins qdma_0/axis_c2h_drop]
  connect_bd_intf_net -intf_net qdma_0_c2h_byp_out [get_bd_intf_pins nvme_tc_0/c2h_byp_in] [get_bd_intf_pins qdma_0/c2h_byp_out]
  connect_bd_intf_net -intf_net qdma_0_h2c_byp_out [get_bd_intf_pins nvme_tc_0/h2c_byp_in] [get_bd_intf_pins qdma_0/h2c_byp_out]
  connect_bd_intf_net -intf_net qdma_0_m_axis_h2c [get_bd_intf_pins nvme_tc_0/s_axis_h2c] [get_bd_intf_pins qdma_0/m_axis_h2c]
  connect_bd_intf_net -intf_net qdma_0_pcie_mgt [get_bd_intf_ports pci_express_x4] [get_bd_intf_pins qdma_0/pcie_mgt]
  connect_bd_intf_net -intf_net qdma_0_st_rx_msg [get_bd_intf_pins nvme_tc_0/st_rx_msg] [get_bd_intf_pins qdma_0/st_rx_msg]
  connect_bd_intf_net -intf_net qdma_0_tm_dsc_sts [get_bd_intf_pins nvme_tc_0/tm_dsc_sts] [get_bd_intf_pins qdma_0/tm_dsc_sts]

  # Create port connections
  connect_bd_net -net axi_timer_0_interrupt [get_bd_pins axi_timer_0/interrupt] [get_bd_pins microblaze_0_xlconcat/In4]
  connect_bd_net -net axi_uartlite_0_interrupt [get_bd_pins axi_uartlite_0/interrupt] [get_bd_pins microblaze_0_xlconcat/In0]
  connect_bd_net -net burst_ctrl_0_addr_valid [get_bd_pins burst_ctrl_0/addr_valid] [get_bd_pins hw_ftl_w_cachesim_0/addr_valid]
  connect_bd_net -net burst_ctrl_0_mem_address [get_bd_pins burst_ctrl_0/mem_address] [get_bd_pins hw_ftl_w_cachesim_0/mem_address]
  connect_bd_net -net burst_ctrl_0_mem_rw [get_bd_pins burst_ctrl_0/mem_rw] [get_bd_pins hw_ftl_w_cachesim_0/mem_rw]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins AXI_request_arbiter_0/m00_axi_aclk] [get_bd_pins AXI_request_arbiter_0/m00_axis_aclk] [get_bd_pins AXI_request_arbiter_0/s00_axi_aclk] [get_bd_pins AXI_request_arbiter_0/s00_axis_aclk] [get_bd_pins axi_clock_converter_0/s_axi_aclk] [get_bd_pins axi_interconnect_2/M01_ACLK] [get_bd_pins burst_ctrl_0/clk] [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins delay_network_wrapper_0/clk] [get_bd_pins hw_ftl_w_cachesim_0/clk] [get_bd_pins rst_clk_wiz_0_70M/slowest_sync_clk] [get_bd_pins system_ila_0/clk] [get_bd_pins system_ila_2/clk]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins rst_clk_wiz_0_70M/dcm_locked]
  connect_bd_net -net clk_wiz_1_clk_out1 [get_bd_pins auto_pc/aclk] [get_bd_pins auto_us/s_axi_aclk] [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins axi_interconnect_1/ACLK] [get_bd_pins axi_interconnect_1/M00_ACLK] [get_bd_pins axi_interconnect_1/M01_ACLK] [get_bd_pins axi_interconnect_1/M02_ACLK] [get_bd_pins axi_interconnect_1/M03_ACLK] [get_bd_pins axi_interconnect_1/M04_ACLK] [get_bd_pins axi_interconnect_1/M05_ACLK] [get_bd_pins axi_interconnect_1/M06_ACLK] [get_bd_pins axi_interconnect_1/M07_ACLK] [get_bd_pins axi_interconnect_1/S00_ACLK] [get_bd_pins axi_interconnect_1/S01_ACLK] [get_bd_pins axi_interconnect_2/S01_ACLK] [get_bd_pins axi_interconnect_4/ACLK] [get_bd_pins axi_interconnect_4/M00_ACLK] [get_bd_pins axi_interconnect_4/S00_ACLK] [get_bd_pins axi_interconnect_4/S01_ACLK] [get_bd_pins axi_interconnect_4/S02_ACLK] [get_bd_pins axi_timer_0/s_axi_aclk] [get_bd_pins axi_uartlite_0/s_axi_aclk] [get_bd_pins clk_wiz_1/clk_out1] [get_bd_pins mdm_1/S_AXI_ACLK] [get_bd_pins microblaze_0/Clk] [get_bd_pins microblaze_0_axi_intc/processor_clk] [get_bd_pins microblaze_0_axi_intc/s_axi_aclk] [get_bd_pins microblaze_0_local_memory/LMB_Clk] [get_bd_pins microblaze_1/Clk] [get_bd_pins microblaze_1_local_memory/LMB_Clk] [get_bd_pins nvme_mapper_0/clk_axi_lite] [get_bd_pins nvme_tc_0/sw_s_axi_lite_aclk] [get_bd_pins rst_clk_wiz_1_100M/slowest_sync_clk]
  connect_bd_net -net clk_wiz_1_clk_out2 [get_bd_pins axi_interconnect_2/ACLK] [get_bd_pins clk_wiz_1/clk_out2] [get_bd_pins nvme_mapper_0/clk_ha] [get_bd_pins rst_clk_wiz_1_100M1/slowest_sync_clk]
  connect_bd_net -net clk_wiz_1_locked [get_bd_pins clk_wiz_1/locked] [get_bd_pins rst_clk_wiz_1_100M/dcm_locked] [get_bd_pins rst_clk_wiz_1_100M1/dcm_locked] [get_bd_pins util_vector_logic_0/Op2]
  connect_bd_net -net ddr4_0_c0_ddr4_ui_clk [get_bd_pins axi_interconnect_2/M00_ACLK] [get_bd_pins ddr4_0/c0_ddr4_ui_clk] [get_bd_pins rst_ddr4_0_333M/slowest_sync_clk]
  connect_bd_net -net ddr4_0_c0_ddr4_ui_clk_sync_rst [get_bd_pins ddr4_0/c0_ddr4_ui_clk_sync_rst] [get_bd_pins rst_ddr4_0_333M/ext_reset_in]
  connect_bd_net -net ddr4_1_c0_ddr4_ui_clk [get_bd_pins axi_clock_converter_0/m_axi_aclk] [get_bd_pins clk_wiz_0/clk_in1] [get_bd_pins ddr4_1/c0_ddr4_ui_clk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
  connect_bd_net -net ddr4_1_c0_ddr4_ui_clk_sync_rst [get_bd_pins ddr4_1/c0_ddr4_ui_clk_sync_rst] [get_bd_pins proc_sys_reset_0/ext_reset_in]
  connect_bd_net -net hw_ftl_w_cachesim_0_addr_resp [get_bd_pins burst_ctrl_0/addr_resp] [get_bd_pins hw_ftl_w_cachesim_0/addr_resp]
  connect_bd_net -net hw_ftl_w_cachesim_0_cache_hit [get_bd_pins burst_ctrl_0/cache_hit] [get_bd_pins hw_ftl_w_cachesim_0/cache_hit]
  connect_bd_net -net hw_ftl_w_cachesim_0_mem_new_address [get_bd_pins burst_ctrl_0/mem_new_address] [get_bd_pins hw_ftl_w_cachesim_0/mem_new_address]
  connect_bd_net -net mdm_1_debug_sys_rst [get_bd_pins mdm_1/Debug_SYS_Rst] [get_bd_pins rst_clk_wiz_1_100M/mb_debug_sys_rst]
  connect_bd_net -net microblaze_0_intr [get_bd_pins microblaze_0_axi_intc/intr] [get_bd_pins microblaze_0_xlconcat/dout]
  connect_bd_net -net nvme_tc_0_c2h_wqe_fifo_full [get_bd_pins nvme_mapper_0/c2h_wqfifo_full] [get_bd_pins nvme_tc_0/c2h_wqe_fifo_full]
  connect_bd_net -net nvme_tc_0_h2c_wqe_fifo_full [get_bd_pins nvme_mapper_0/h2c_wqfifo_full] [get_bd_pins nvme_tc_0/h2c_wqe_fifo_full]
  connect_bd_net -net nvme_tc_0_nvme_tc_intr [get_bd_pins microblaze_0_xlconcat/In3] [get_bd_pins nvme_tc_0/nvme_tc_intr]
  connect_bd_net -net pcie_perstn_1 [get_bd_ports pcie_perstn] [get_bd_pins qdma_0/sys_rst_n] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn1 [get_bd_pins axi_clock_converter_0/m_axi_aresetn] [get_bd_pins clk_wiz_0/resetn] [get_bd_pins ddr4_1/c0_ddr4_aresetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins rst_clk_wiz_0_70M/ext_reset_in]
  connect_bd_net -net qdma_0_axi_aclk [get_bd_pins axi_interconnect_1/M08_ACLK] [get_bd_pins axi_interconnect_2/S00_ACLK] [get_bd_pins axi_interconnect_2/S02_ACLK] [get_bd_pins nvme_mapper_0/clk_core] [get_bd_pins nvme_tc_0/core_clk] [get_bd_pins qdma_0/axi_aclk] [get_bd_pins qdma_0_axi_periph/ACLK] [get_bd_pins qdma_0_axi_periph/M00_ACLK] [get_bd_pins qdma_0_axi_periph/S00_ACLK]
  connect_bd_net -net qdma_0_axi_aresetn [get_bd_pins axi_interconnect_1/M08_ARESETN] [get_bd_pins axi_interconnect_2/S00_ARESETN] [get_bd_pins axi_interconnect_2/S02_ARESETN] [get_bd_pins nvme_mapper_0/rst_n_core] [get_bd_pins nvme_tc_0/core_rstn] [get_bd_pins qdma_0/axi_aresetn] [get_bd_pins qdma_0_axi_periph/ARESETN] [get_bd_pins qdma_0_axi_periph/M00_ARESETN] [get_bd_pins qdma_0_axi_periph/S00_ARESETN]
  connect_bd_net -net qdma_0_user_lnk_up [get_bd_pins nvme_mapper_0/host_link_up] [get_bd_pins nvme_tc_0/pcie_link_up] [get_bd_pins qdma_0/user_lnk_up] [get_bd_pins xlconcat_0/In8]
  connect_bd_net -net rst_clk_wiz_0_70M_peripheral_aresetn [get_bd_pins AXI_request_arbiter_0/m00_axi_aresetn] [get_bd_pins AXI_request_arbiter_0/m00_axis_aresetn] [get_bd_pins AXI_request_arbiter_0/s00_axi_aresetn] [get_bd_pins AXI_request_arbiter_0/s00_axis_aresetn] [get_bd_pins axi_clock_converter_0/s_axi_aresetn] [get_bd_pins axi_interconnect_2/M01_ARESETN] [get_bd_pins burst_ctrl_0/arstn] [get_bd_pins delay_network_wrapper_0/arstn] [get_bd_pins hw_ftl_w_cachesim_0/rstn] [get_bd_pins rst_clk_wiz_0_70M/peripheral_aresetn] [get_bd_pins system_ila_0/resetn] [get_bd_pins system_ila_2/resetn]
  connect_bd_net -net rst_clk_wiz_1_100M1_peripheral_aresetn [get_bd_pins axi_interconnect_2/ARESETN] [get_bd_pins nvme_mapper_0/rst_n_ha] [get_bd_pins rst_clk_wiz_1_100M1/peripheral_aresetn]
  connect_bd_net -net rst_clk_wiz_1_100M_bus_struct_reset [get_bd_pins microblaze_0_local_memory/SYS_Rst] [get_bd_pins microblaze_1_local_memory/SYS_Rst] [get_bd_pins rst_clk_wiz_1_100M/bus_struct_reset]
  connect_bd_net -net rst_clk_wiz_1_100M_interconnect_aresetn [get_bd_pins axi_interconnect_1/ARESETN] [get_bd_pins axi_interconnect_4/ARESETN] [get_bd_pins rst_clk_wiz_1_100M/interconnect_aresetn]
  connect_bd_net -net rst_clk_wiz_1_100M_mb_reset [get_bd_pins microblaze_0/Reset] [get_bd_pins microblaze_0_axi_intc/processor_rst] [get_bd_pins microblaze_1/Reset] [get_bd_pins rst_clk_wiz_1_100M/mb_reset]
  connect_bd_net -net rst_clk_wiz_1_100M_peripheral_aresetn [get_bd_pins auto_pc/aresetn] [get_bd_pins auto_us/s_axi_aresetn] [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins axi_interconnect_1/M00_ARESETN] [get_bd_pins axi_interconnect_1/M01_ARESETN] [get_bd_pins axi_interconnect_1/M02_ARESETN] [get_bd_pins axi_interconnect_1/M03_ARESETN] [get_bd_pins axi_interconnect_1/M04_ARESETN] [get_bd_pins axi_interconnect_1/M05_ARESETN] [get_bd_pins axi_interconnect_1/M06_ARESETN] [get_bd_pins axi_interconnect_1/M07_ARESETN] [get_bd_pins axi_interconnect_1/S00_ARESETN] [get_bd_pins axi_interconnect_1/S01_ARESETN] [get_bd_pins axi_interconnect_2/S01_ARESETN] [get_bd_pins axi_interconnect_4/M00_ARESETN] [get_bd_pins axi_interconnect_4/S00_ARESETN] [get_bd_pins axi_interconnect_4/S01_ARESETN] [get_bd_pins axi_interconnect_4/S02_ARESETN] [get_bd_pins axi_timer_0/s_axi_aresetn] [get_bd_pins axi_uartlite_0/s_axi_aresetn] [get_bd_pins mdm_1/S_AXI_ARESETN] [get_bd_pins microblaze_0_axi_intc/s_axi_aresetn] [get_bd_pins nvme_tc_0/sw_s_axi_lite_aresetn] [get_bd_pins rst_clk_wiz_1_100M/peripheral_aresetn]
  connect_bd_net -net rst_clk_wiz_1_100M_peripheral_reset [get_bd_pins ddr4_0/sys_rst] [get_bd_pins ddr4_1/sys_rst] [get_bd_pins rst_clk_wiz_1_100M/peripheral_reset]
  connect_bd_net -net rst_ddr4_0_333M_peripheral_aresetn [get_bd_pins axi_interconnect_2/M00_ARESETN] [get_bd_pins ddr4_0/c0_ddr4_aresetn] [get_bd_pins rst_ddr4_0_333M/peripheral_aresetn]
  connect_bd_net -net util_ds_buf_4_IBUF_DS_ODIV2 [get_bd_pins qdma_0/sys_clk] [get_bd_pins util_ds_buf_4/IBUF_DS_ODIV2]
  connect_bd_net -net util_ds_buf_4_IBUF_OUT [get_bd_pins qdma_0/sys_clk_gt] [get_bd_pins util_ds_buf_4/IBUF_OUT]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins clk_wiz_1/resetn] [get_bd_pins rst_clk_wiz_1_100M/ext_reset_in] [get_bd_pins rst_clk_wiz_1_100M1/ext_reset_in] [get_bd_pins util_vector_logic_0/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins axi_gpio_0/gpio_io_i] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins microblaze_0_xlconcat/In1] [get_bd_pins microblaze_0_xlconcat/In2] [get_bd_pins microblaze_0_xlconcat/In5] [get_bd_pins microblaze_0_xlconcat/In6] [get_bd_pins microblaze_0_xlconcat/In7] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins qdma_0/soft_reset_n] [get_bd_pins xlconstant_1/dout]
  connect_bd_net -net xlconstant_2_dout [get_bd_pins nvme_tc_0/dbg_mapper_mimic] [get_bd_pins xlconstant_2/dout]
  connect_bd_net -net xlconstant_3_dout [get_bd_pins nvme_tc_0/aes_s_axis_tvalid] [get_bd_pins nvme_tc_0/pcie_phy_ready] [get_bd_pins xlconstant_3/dout]

  # Create address segments
  assign_bd_address -offset 0x80000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces AXI_request_arbiter_0/m00_axi] [get_bd_addr_segs ddr4_1/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces burst_ctrl_0/axi_m_cache] [get_bd_addr_segs AXI_request_arbiter_0/s00_axi/reg0] -force
  assign_bd_address -offset 0x800D0000 -range 0x00001000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x800C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_timer_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x80010000 -range 0x00004000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_uartlite_0/S_AXI/Reg] -force
  assign_bd_address -offset 0xC0000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs burst_ctrl_0/axi_s/reg0] -force
  assign_bd_address -offset 0xC0000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs burst_ctrl_0/axi_s/reg0] -force
  assign_bd_address -offset 0x40000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
  assign_bd_address -offset 0x40000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
  assign_bd_address -offset 0x00000000 -range 0x00040000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs microblaze_0_local_memory/dlmb_bram_if_cntlr/SLMB/Mem] -force
  assign_bd_address -offset 0x00000000 -range 0x00040000 -target_address_space [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs microblaze_0_local_memory/ilmb_bram_if_cntlr/SLMB/Mem] -force
  assign_bd_address -offset 0x80002000 -range 0x00001000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs mdm_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x800A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs microblaze_0_axi_intc/S_AXI/Reg] -force
  assign_bd_address -offset 0x80050000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs nvme_mapper_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x8C000000 -range 0x04000000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs nvme_tc_0/sw_s_axi/mem0] -force
  assign_bd_address -offset 0x88000000 -range 0x02000000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs nvme_tc_0/sw_s_axi_lite/reg0] -force
  assign_bd_address -offset 0x800D0000 -range 0x00001000 -target_address_space [get_bd_addr_spaces microblaze_1/Data] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x800C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_1/Data] [get_bd_addr_segs axi_timer_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x80010000 -range 0x00004000 -target_address_space [get_bd_addr_spaces microblaze_1/Data] [get_bd_addr_segs axi_uartlite_0/S_AXI/Reg] -force
  assign_bd_address -offset 0xC0000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces microblaze_1/Data] [get_bd_addr_segs burst_ctrl_0/axi_s/reg0] -force
  assign_bd_address -offset 0x40000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces microblaze_1/Data] [get_bd_addr_segs ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
  assign_bd_address -offset 0x80004000 -range 0x00002000 -target_address_space [get_bd_addr_spaces microblaze_1/Data] [get_bd_addr_segs microblaze_1_local_memory/dlmb_bram_if_cntlr/SLMB/Mem] -force
  assign_bd_address -offset 0x80004000 -range 0x00002000 -target_address_space [get_bd_addr_spaces microblaze_1/Instruction] [get_bd_addr_segs microblaze_1_local_memory/ilmb_bram_if_cntlr/SLMB/Mem] -force
  assign_bd_address -offset 0x80002000 -range 0x00001000 -target_address_space [get_bd_addr_spaces microblaze_1/Data] [get_bd_addr_segs mdm_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x800A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_1/Data] [get_bd_addr_segs microblaze_0_axi_intc/S_AXI/Reg] -force
  assign_bd_address -offset 0x80050000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_1/Data] [get_bd_addr_segs nvme_mapper_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x8C000000 -range 0x04000000 -target_address_space [get_bd_addr_spaces microblaze_1/Data] [get_bd_addr_segs nvme_tc_0/sw_s_axi/mem0] -force
  assign_bd_address -offset 0x88000000 -range 0x02000000 -target_address_space [get_bd_addr_spaces microblaze_1/Data] [get_bd_addr_segs nvme_tc_0/sw_s_axi_lite/reg0] -force
  assign_bd_address -offset 0xC0000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces nvme_mapper_0/Data] [get_bd_addr_segs burst_ctrl_0/axi_s/reg0] -force
  assign_bd_address -offset 0x40000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces nvme_mapper_0/Data] [get_bd_addr_segs ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
  assign_bd_address -offset 0xC0000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces nvme_tc_0/ddr_m_axi] [get_bd_addr_segs burst_ctrl_0/axi_s/reg0] -force
  assign_bd_address -offset 0x40000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces nvme_tc_0/ddr_m_axi] [get_bd_addr_segs ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
  assign_bd_address -offset 0x00000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces nvme_tc_0/qdma_m_axi_lite] [get_bd_addr_segs qdma_0/S_AXI_LITE/CTL0] -force
  assign_bd_address -offset 0x00000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI_LITE] [get_bd_addr_segs nvme_tc_0/host_s_axi_lite/reg0] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################


common::send_msg_id "BD_TCL-2000" "CRITICAL WARNING" "This Tcl script was generated from a block design that is out-of-date/locked. It is possible that design <$design_name> may result in errors during construction."

create_root_design ""


