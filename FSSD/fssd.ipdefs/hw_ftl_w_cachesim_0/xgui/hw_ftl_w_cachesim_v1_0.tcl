# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "addr_width" -parent ${Page_0}
  ipgui::add_param $IPINST -name "block_size" -parent ${Page_0}
  ipgui::add_param $IPINST -name "page_size" -parent ${Page_0}
  ipgui::add_param $IPINST -name "set_width" -parent ${Page_0}
  ipgui::add_param $IPINST -name "way_num" -parent ${Page_0}


}

proc update_PARAM_VALUE.addr_width { PARAM_VALUE.addr_width } {
	# Procedure called to update addr_width when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.addr_width { PARAM_VALUE.addr_width } {
	# Procedure called to validate addr_width
	return true
}

proc update_PARAM_VALUE.block_size { PARAM_VALUE.block_size } {
	# Procedure called to update block_size when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.block_size { PARAM_VALUE.block_size } {
	# Procedure called to validate block_size
	return true
}

proc update_PARAM_VALUE.page_size { PARAM_VALUE.page_size } {
	# Procedure called to update page_size when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.page_size { PARAM_VALUE.page_size } {
	# Procedure called to validate page_size
	return true
}

proc update_PARAM_VALUE.set_width { PARAM_VALUE.set_width } {
	# Procedure called to update set_width when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.set_width { PARAM_VALUE.set_width } {
	# Procedure called to validate set_width
	return true
}

proc update_PARAM_VALUE.way_num { PARAM_VALUE.way_num } {
	# Procedure called to update way_num when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.way_num { PARAM_VALUE.way_num } {
	# Procedure called to validate way_num
	return true
}


proc update_MODELPARAM_VALUE.addr_width { MODELPARAM_VALUE.addr_width PARAM_VALUE.addr_width } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.addr_width}] ${MODELPARAM_VALUE.addr_width}
}

proc update_MODELPARAM_VALUE.page_size { MODELPARAM_VALUE.page_size PARAM_VALUE.page_size } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.page_size}] ${MODELPARAM_VALUE.page_size}
}

proc update_MODELPARAM_VALUE.block_size { MODELPARAM_VALUE.block_size PARAM_VALUE.block_size } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.block_size}] ${MODELPARAM_VALUE.block_size}
}

proc update_MODELPARAM_VALUE.set_width { MODELPARAM_VALUE.set_width PARAM_VALUE.set_width } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.set_width}] ${MODELPARAM_VALUE.set_width}
}

proc update_MODELPARAM_VALUE.way_num { MODELPARAM_VALUE.way_num PARAM_VALUE.way_num } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.way_num}] ${MODELPARAM_VALUE.way_num}
}

