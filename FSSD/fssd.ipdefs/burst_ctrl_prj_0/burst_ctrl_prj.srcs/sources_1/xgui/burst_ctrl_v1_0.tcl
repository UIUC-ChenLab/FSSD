# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "addr_width" -parent ${Page_0}
  ipgui::add_param $IPINST -name "data_width" -parent ${Page_0}
  ipgui::add_param $IPINST -name "id_width" -parent ${Page_0}


}

proc update_PARAM_VALUE.addr_width { PARAM_VALUE.addr_width } {
	# Procedure called to update addr_width when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.addr_width { PARAM_VALUE.addr_width } {
	# Procedure called to validate addr_width
	return true
}

proc update_PARAM_VALUE.data_width { PARAM_VALUE.data_width } {
	# Procedure called to update data_width when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.data_width { PARAM_VALUE.data_width } {
	# Procedure called to validate data_width
	return true
}

proc update_PARAM_VALUE.id_width { PARAM_VALUE.id_width } {
	# Procedure called to update id_width when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.id_width { PARAM_VALUE.id_width } {
	# Procedure called to validate id_width
	return true
}

proc update_PARAM_VALUE.strb_width { PARAM_VALUE.strb_width } {
	# Procedure called to update strb_width when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.strb_width { PARAM_VALUE.strb_width } {
	# Procedure called to validate strb_width
	return true
}

proc update_PARAM_VALUE.user_width { PARAM_VALUE.user_width } {
	# Procedure called to update user_width when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.user_width { PARAM_VALUE.user_width } {
	# Procedure called to validate user_width
	return true
}


proc update_MODELPARAM_VALUE.id_width { MODELPARAM_VALUE.id_width PARAM_VALUE.id_width } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.id_width}] ${MODELPARAM_VALUE.id_width}
}

proc update_MODELPARAM_VALUE.addr_width { MODELPARAM_VALUE.addr_width PARAM_VALUE.addr_width } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.addr_width}] ${MODELPARAM_VALUE.addr_width}
}

proc update_MODELPARAM_VALUE.data_width { MODELPARAM_VALUE.data_width PARAM_VALUE.data_width } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.data_width}] ${MODELPARAM_VALUE.data_width}
}

proc update_MODELPARAM_VALUE.strb_width { MODELPARAM_VALUE.strb_width PARAM_VALUE.strb_width } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.strb_width}] ${MODELPARAM_VALUE.strb_width}
}

proc update_MODELPARAM_VALUE.user_width { MODELPARAM_VALUE.user_width PARAM_VALUE.user_width } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.user_width}] ${MODELPARAM_VALUE.user_width}
}

