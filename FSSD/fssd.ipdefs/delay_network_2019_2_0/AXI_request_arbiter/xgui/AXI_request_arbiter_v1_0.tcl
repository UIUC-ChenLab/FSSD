# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "ADDR_HIGH_ADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ADDR_LOW_ADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "BURST_HIGH_ADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "BURST_LOW_ADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "CACHE_HIGH_ADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "CACHE_LOW_ADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "CAM_DEPTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_M00_AXIS_TDATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_M00_AXI_ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_M00_AXI_ARUSER_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_M00_AXI_AWUSER_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_M00_AXI_BURST_LEN" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_M00_AXI_BUSER_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_M00_AXI_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_M00_AXI_ID_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_M00_AXI_RUSER_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_M00_AXI_TARGET_SLAVE_BASE_ADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_M00_AXI_WUSER_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S00_AXIS_TDATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S00_AXIS_TID_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S00_AXIS_TUSER_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S00_AXI_ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S00_AXI_ARUSER_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S00_AXI_AWUSER_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S00_AXI_BUSER_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S00_AXI_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S00_AXI_ID_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S00_AXI_RUSER_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S00_AXI_WUSER_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "KEY_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "LEN_HIGH_ADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "LEN_LOW_ADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "LOCK_ADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MODE_HIGH_ADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MODE_LOW_ADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PROT_HIGH_ADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PROT_LOW_ADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "QOS_HIGH_ADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "QOS_LOW_ADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SIZE_HIGH_ADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SIZE_LOW_ADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "TAG_HIGH_ADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "TAG_LOW_ADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "USER_HIGH_ADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "USER_LOW_ADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "VAL_WIDTH" -parent ${Page_0}


}

proc update_PARAM_VALUE.ADDR_HIGH_ADDR { PARAM_VALUE.ADDR_HIGH_ADDR } {
	# Procedure called to update ADDR_HIGH_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADDR_HIGH_ADDR { PARAM_VALUE.ADDR_HIGH_ADDR } {
	# Procedure called to validate ADDR_HIGH_ADDR
	return true
}

proc update_PARAM_VALUE.ADDR_LOW_ADDR { PARAM_VALUE.ADDR_LOW_ADDR } {
	# Procedure called to update ADDR_LOW_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADDR_LOW_ADDR { PARAM_VALUE.ADDR_LOW_ADDR } {
	# Procedure called to validate ADDR_LOW_ADDR
	return true
}

proc update_PARAM_VALUE.BURST_HIGH_ADDR { PARAM_VALUE.BURST_HIGH_ADDR } {
	# Procedure called to update BURST_HIGH_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BURST_HIGH_ADDR { PARAM_VALUE.BURST_HIGH_ADDR } {
	# Procedure called to validate BURST_HIGH_ADDR
	return true
}

proc update_PARAM_VALUE.BURST_LOW_ADDR { PARAM_VALUE.BURST_LOW_ADDR } {
	# Procedure called to update BURST_LOW_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BURST_LOW_ADDR { PARAM_VALUE.BURST_LOW_ADDR } {
	# Procedure called to validate BURST_LOW_ADDR
	return true
}

proc update_PARAM_VALUE.CACHE_HIGH_ADDR { PARAM_VALUE.CACHE_HIGH_ADDR } {
	# Procedure called to update CACHE_HIGH_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CACHE_HIGH_ADDR { PARAM_VALUE.CACHE_HIGH_ADDR } {
	# Procedure called to validate CACHE_HIGH_ADDR
	return true
}

proc update_PARAM_VALUE.CACHE_LOW_ADDR { PARAM_VALUE.CACHE_LOW_ADDR } {
	# Procedure called to update CACHE_LOW_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CACHE_LOW_ADDR { PARAM_VALUE.CACHE_LOW_ADDR } {
	# Procedure called to validate CACHE_LOW_ADDR
	return true
}

proc update_PARAM_VALUE.CAM_DEPTH { PARAM_VALUE.CAM_DEPTH } {
	# Procedure called to update CAM_DEPTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CAM_DEPTH { PARAM_VALUE.CAM_DEPTH } {
	# Procedure called to validate CAM_DEPTH
	return true
}

proc update_PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH { PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH } {
	# Procedure called to update C_M00_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH { PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH } {
	# Procedure called to validate C_M00_AXIS_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M00_AXI_ADDR_WIDTH { PARAM_VALUE.C_M00_AXI_ADDR_WIDTH } {
	# Procedure called to update C_M00_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M00_AXI_ADDR_WIDTH { PARAM_VALUE.C_M00_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_M00_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M00_AXI_ARUSER_WIDTH { PARAM_VALUE.C_M00_AXI_ARUSER_WIDTH } {
	# Procedure called to update C_M00_AXI_ARUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M00_AXI_ARUSER_WIDTH { PARAM_VALUE.C_M00_AXI_ARUSER_WIDTH } {
	# Procedure called to validate C_M00_AXI_ARUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M00_AXI_AWUSER_WIDTH { PARAM_VALUE.C_M00_AXI_AWUSER_WIDTH } {
	# Procedure called to update C_M00_AXI_AWUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M00_AXI_AWUSER_WIDTH { PARAM_VALUE.C_M00_AXI_AWUSER_WIDTH } {
	# Procedure called to validate C_M00_AXI_AWUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M00_AXI_BURST_LEN { PARAM_VALUE.C_M00_AXI_BURST_LEN } {
	# Procedure called to update C_M00_AXI_BURST_LEN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M00_AXI_BURST_LEN { PARAM_VALUE.C_M00_AXI_BURST_LEN } {
	# Procedure called to validate C_M00_AXI_BURST_LEN
	return true
}

proc update_PARAM_VALUE.C_M00_AXI_BUSER_WIDTH { PARAM_VALUE.C_M00_AXI_BUSER_WIDTH } {
	# Procedure called to update C_M00_AXI_BUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M00_AXI_BUSER_WIDTH { PARAM_VALUE.C_M00_AXI_BUSER_WIDTH } {
	# Procedure called to validate C_M00_AXI_BUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M00_AXI_DATA_WIDTH { PARAM_VALUE.C_M00_AXI_DATA_WIDTH } {
	# Procedure called to update C_M00_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M00_AXI_DATA_WIDTH { PARAM_VALUE.C_M00_AXI_DATA_WIDTH } {
	# Procedure called to validate C_M00_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M00_AXI_ID_WIDTH { PARAM_VALUE.C_M00_AXI_ID_WIDTH } {
	# Procedure called to update C_M00_AXI_ID_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M00_AXI_ID_WIDTH { PARAM_VALUE.C_M00_AXI_ID_WIDTH } {
	# Procedure called to validate C_M00_AXI_ID_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M00_AXI_RUSER_WIDTH { PARAM_VALUE.C_M00_AXI_RUSER_WIDTH } {
	# Procedure called to update C_M00_AXI_RUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M00_AXI_RUSER_WIDTH { PARAM_VALUE.C_M00_AXI_RUSER_WIDTH } {
	# Procedure called to validate C_M00_AXI_RUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M00_AXI_TARGET_SLAVE_BASE_ADDR { PARAM_VALUE.C_M00_AXI_TARGET_SLAVE_BASE_ADDR } {
	# Procedure called to update C_M00_AXI_TARGET_SLAVE_BASE_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M00_AXI_TARGET_SLAVE_BASE_ADDR { PARAM_VALUE.C_M00_AXI_TARGET_SLAVE_BASE_ADDR } {
	# Procedure called to validate C_M00_AXI_TARGET_SLAVE_BASE_ADDR
	return true
}

proc update_PARAM_VALUE.C_M00_AXI_WUSER_WIDTH { PARAM_VALUE.C_M00_AXI_WUSER_WIDTH } {
	# Procedure called to update C_M00_AXI_WUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M00_AXI_WUSER_WIDTH { PARAM_VALUE.C_M00_AXI_WUSER_WIDTH } {
	# Procedure called to validate C_M00_AXI_WUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH { PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH } {
	# Procedure called to update C_S00_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH { PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH } {
	# Procedure called to validate C_S00_AXIS_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXIS_TID_WIDTH { PARAM_VALUE.C_S00_AXIS_TID_WIDTH } {
	# Procedure called to update C_S00_AXIS_TID_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXIS_TID_WIDTH { PARAM_VALUE.C_S00_AXIS_TID_WIDTH } {
	# Procedure called to validate C_S00_AXIS_TID_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXIS_TUSER_WIDTH { PARAM_VALUE.C_S00_AXIS_TUSER_WIDTH } {
	# Procedure called to update C_S00_AXIS_TUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXIS_TUSER_WIDTH { PARAM_VALUE.C_S00_AXIS_TUSER_WIDTH } {
	# Procedure called to validate C_S00_AXIS_TUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to update C_S00_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_S00_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_ARUSER_WIDTH { PARAM_VALUE.C_S00_AXI_ARUSER_WIDTH } {
	# Procedure called to update C_S00_AXI_ARUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_ARUSER_WIDTH { PARAM_VALUE.C_S00_AXI_ARUSER_WIDTH } {
	# Procedure called to validate C_S00_AXI_ARUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_AWUSER_WIDTH { PARAM_VALUE.C_S00_AXI_AWUSER_WIDTH } {
	# Procedure called to update C_S00_AXI_AWUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_AWUSER_WIDTH { PARAM_VALUE.C_S00_AXI_AWUSER_WIDTH } {
	# Procedure called to validate C_S00_AXI_AWUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_BUSER_WIDTH { PARAM_VALUE.C_S00_AXI_BUSER_WIDTH } {
	# Procedure called to update C_S00_AXI_BUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_BUSER_WIDTH { PARAM_VALUE.C_S00_AXI_BUSER_WIDTH } {
	# Procedure called to validate C_S00_AXI_BUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to update C_S00_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to validate C_S00_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_ID_WIDTH { PARAM_VALUE.C_S00_AXI_ID_WIDTH } {
	# Procedure called to update C_S00_AXI_ID_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_ID_WIDTH { PARAM_VALUE.C_S00_AXI_ID_WIDTH } {
	# Procedure called to validate C_S00_AXI_ID_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_RUSER_WIDTH { PARAM_VALUE.C_S00_AXI_RUSER_WIDTH } {
	# Procedure called to update C_S00_AXI_RUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_RUSER_WIDTH { PARAM_VALUE.C_S00_AXI_RUSER_WIDTH } {
	# Procedure called to validate C_S00_AXI_RUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_WUSER_WIDTH { PARAM_VALUE.C_S00_AXI_WUSER_WIDTH } {
	# Procedure called to update C_S00_AXI_WUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_WUSER_WIDTH { PARAM_VALUE.C_S00_AXI_WUSER_WIDTH } {
	# Procedure called to validate C_S00_AXI_WUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.KEY_WIDTH { PARAM_VALUE.KEY_WIDTH } {
	# Procedure called to update KEY_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.KEY_WIDTH { PARAM_VALUE.KEY_WIDTH } {
	# Procedure called to validate KEY_WIDTH
	return true
}

proc update_PARAM_VALUE.LEN_HIGH_ADDR { PARAM_VALUE.LEN_HIGH_ADDR } {
	# Procedure called to update LEN_HIGH_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LEN_HIGH_ADDR { PARAM_VALUE.LEN_HIGH_ADDR } {
	# Procedure called to validate LEN_HIGH_ADDR
	return true
}

proc update_PARAM_VALUE.LEN_LOW_ADDR { PARAM_VALUE.LEN_LOW_ADDR } {
	# Procedure called to update LEN_LOW_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LEN_LOW_ADDR { PARAM_VALUE.LEN_LOW_ADDR } {
	# Procedure called to validate LEN_LOW_ADDR
	return true
}

proc update_PARAM_VALUE.LOCK_ADDR { PARAM_VALUE.LOCK_ADDR } {
	# Procedure called to update LOCK_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LOCK_ADDR { PARAM_VALUE.LOCK_ADDR } {
	# Procedure called to validate LOCK_ADDR
	return true
}

proc update_PARAM_VALUE.MODE_HIGH_ADDR { PARAM_VALUE.MODE_HIGH_ADDR } {
	# Procedure called to update MODE_HIGH_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MODE_HIGH_ADDR { PARAM_VALUE.MODE_HIGH_ADDR } {
	# Procedure called to validate MODE_HIGH_ADDR
	return true
}

proc update_PARAM_VALUE.MODE_LOW_ADDR { PARAM_VALUE.MODE_LOW_ADDR } {
	# Procedure called to update MODE_LOW_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MODE_LOW_ADDR { PARAM_VALUE.MODE_LOW_ADDR } {
	# Procedure called to validate MODE_LOW_ADDR
	return true
}

proc update_PARAM_VALUE.PROT_HIGH_ADDR { PARAM_VALUE.PROT_HIGH_ADDR } {
	# Procedure called to update PROT_HIGH_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PROT_HIGH_ADDR { PARAM_VALUE.PROT_HIGH_ADDR } {
	# Procedure called to validate PROT_HIGH_ADDR
	return true
}

proc update_PARAM_VALUE.PROT_LOW_ADDR { PARAM_VALUE.PROT_LOW_ADDR } {
	# Procedure called to update PROT_LOW_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PROT_LOW_ADDR { PARAM_VALUE.PROT_LOW_ADDR } {
	# Procedure called to validate PROT_LOW_ADDR
	return true
}

proc update_PARAM_VALUE.QOS_HIGH_ADDR { PARAM_VALUE.QOS_HIGH_ADDR } {
	# Procedure called to update QOS_HIGH_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.QOS_HIGH_ADDR { PARAM_VALUE.QOS_HIGH_ADDR } {
	# Procedure called to validate QOS_HIGH_ADDR
	return true
}

proc update_PARAM_VALUE.QOS_LOW_ADDR { PARAM_VALUE.QOS_LOW_ADDR } {
	# Procedure called to update QOS_LOW_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.QOS_LOW_ADDR { PARAM_VALUE.QOS_LOW_ADDR } {
	# Procedure called to validate QOS_LOW_ADDR
	return true
}

proc update_PARAM_VALUE.SIZE_HIGH_ADDR { PARAM_VALUE.SIZE_HIGH_ADDR } {
	# Procedure called to update SIZE_HIGH_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SIZE_HIGH_ADDR { PARAM_VALUE.SIZE_HIGH_ADDR } {
	# Procedure called to validate SIZE_HIGH_ADDR
	return true
}

proc update_PARAM_VALUE.SIZE_LOW_ADDR { PARAM_VALUE.SIZE_LOW_ADDR } {
	# Procedure called to update SIZE_LOW_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SIZE_LOW_ADDR { PARAM_VALUE.SIZE_LOW_ADDR } {
	# Procedure called to validate SIZE_LOW_ADDR
	return true
}

proc update_PARAM_VALUE.TAG_HIGH_ADDR { PARAM_VALUE.TAG_HIGH_ADDR } {
	# Procedure called to update TAG_HIGH_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TAG_HIGH_ADDR { PARAM_VALUE.TAG_HIGH_ADDR } {
	# Procedure called to validate TAG_HIGH_ADDR
	return true
}

proc update_PARAM_VALUE.TAG_LOW_ADDR { PARAM_VALUE.TAG_LOW_ADDR } {
	# Procedure called to update TAG_LOW_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TAG_LOW_ADDR { PARAM_VALUE.TAG_LOW_ADDR } {
	# Procedure called to validate TAG_LOW_ADDR
	return true
}

proc update_PARAM_VALUE.USER_HIGH_ADDR { PARAM_VALUE.USER_HIGH_ADDR } {
	# Procedure called to update USER_HIGH_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.USER_HIGH_ADDR { PARAM_VALUE.USER_HIGH_ADDR } {
	# Procedure called to validate USER_HIGH_ADDR
	return true
}

proc update_PARAM_VALUE.USER_LOW_ADDR { PARAM_VALUE.USER_LOW_ADDR } {
	# Procedure called to update USER_LOW_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.USER_LOW_ADDR { PARAM_VALUE.USER_LOW_ADDR } {
	# Procedure called to validate USER_LOW_ADDR
	return true
}

proc update_PARAM_VALUE.VAL_WIDTH { PARAM_VALUE.VAL_WIDTH } {
	# Procedure called to update VAL_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.VAL_WIDTH { PARAM_VALUE.VAL_WIDTH } {
	# Procedure called to validate VAL_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.KEY_WIDTH { MODELPARAM_VALUE.KEY_WIDTH PARAM_VALUE.KEY_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.KEY_WIDTH}] ${MODELPARAM_VALUE.KEY_WIDTH}
}

proc update_MODELPARAM_VALUE.VAL_WIDTH { MODELPARAM_VALUE.VAL_WIDTH PARAM_VALUE.VAL_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.VAL_WIDTH}] ${MODELPARAM_VALUE.VAL_WIDTH}
}

proc update_MODELPARAM_VALUE.CAM_DEPTH { MODELPARAM_VALUE.CAM_DEPTH PARAM_VALUE.CAM_DEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CAM_DEPTH}] ${MODELPARAM_VALUE.CAM_DEPTH}
}

proc update_MODELPARAM_VALUE.USER_HIGH_ADDR { MODELPARAM_VALUE.USER_HIGH_ADDR PARAM_VALUE.USER_HIGH_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.USER_HIGH_ADDR}] ${MODELPARAM_VALUE.USER_HIGH_ADDR}
}

proc update_MODELPARAM_VALUE.USER_LOW_ADDR { MODELPARAM_VALUE.USER_LOW_ADDR PARAM_VALUE.USER_LOW_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.USER_LOW_ADDR}] ${MODELPARAM_VALUE.USER_LOW_ADDR}
}

proc update_MODELPARAM_VALUE.LEN_HIGH_ADDR { MODELPARAM_VALUE.LEN_HIGH_ADDR PARAM_VALUE.LEN_HIGH_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LEN_HIGH_ADDR}] ${MODELPARAM_VALUE.LEN_HIGH_ADDR}
}

proc update_MODELPARAM_VALUE.LEN_LOW_ADDR { MODELPARAM_VALUE.LEN_LOW_ADDR PARAM_VALUE.LEN_LOW_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LEN_LOW_ADDR}] ${MODELPARAM_VALUE.LEN_LOW_ADDR}
}

proc update_MODELPARAM_VALUE.BURST_HIGH_ADDR { MODELPARAM_VALUE.BURST_HIGH_ADDR PARAM_VALUE.BURST_HIGH_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BURST_HIGH_ADDR}] ${MODELPARAM_VALUE.BURST_HIGH_ADDR}
}

proc update_MODELPARAM_VALUE.BURST_LOW_ADDR { MODELPARAM_VALUE.BURST_LOW_ADDR PARAM_VALUE.BURST_LOW_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BURST_LOW_ADDR}] ${MODELPARAM_VALUE.BURST_LOW_ADDR}
}

proc update_MODELPARAM_VALUE.QOS_HIGH_ADDR { MODELPARAM_VALUE.QOS_HIGH_ADDR PARAM_VALUE.QOS_HIGH_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.QOS_HIGH_ADDR}] ${MODELPARAM_VALUE.QOS_HIGH_ADDR}
}

proc update_MODELPARAM_VALUE.QOS_LOW_ADDR { MODELPARAM_VALUE.QOS_LOW_ADDR PARAM_VALUE.QOS_LOW_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.QOS_LOW_ADDR}] ${MODELPARAM_VALUE.QOS_LOW_ADDR}
}

proc update_MODELPARAM_VALUE.LOCK_ADDR { MODELPARAM_VALUE.LOCK_ADDR PARAM_VALUE.LOCK_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LOCK_ADDR}] ${MODELPARAM_VALUE.LOCK_ADDR}
}

proc update_MODELPARAM_VALUE.CACHE_HIGH_ADDR { MODELPARAM_VALUE.CACHE_HIGH_ADDR PARAM_VALUE.CACHE_HIGH_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CACHE_HIGH_ADDR}] ${MODELPARAM_VALUE.CACHE_HIGH_ADDR}
}

proc update_MODELPARAM_VALUE.CACHE_LOW_ADDR { MODELPARAM_VALUE.CACHE_LOW_ADDR PARAM_VALUE.CACHE_LOW_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CACHE_LOW_ADDR}] ${MODELPARAM_VALUE.CACHE_LOW_ADDR}
}

proc update_MODELPARAM_VALUE.PROT_HIGH_ADDR { MODELPARAM_VALUE.PROT_HIGH_ADDR PARAM_VALUE.PROT_HIGH_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PROT_HIGH_ADDR}] ${MODELPARAM_VALUE.PROT_HIGH_ADDR}
}

proc update_MODELPARAM_VALUE.PROT_LOW_ADDR { MODELPARAM_VALUE.PROT_LOW_ADDR PARAM_VALUE.PROT_LOW_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PROT_LOW_ADDR}] ${MODELPARAM_VALUE.PROT_LOW_ADDR}
}

proc update_MODELPARAM_VALUE.SIZE_HIGH_ADDR { MODELPARAM_VALUE.SIZE_HIGH_ADDR PARAM_VALUE.SIZE_HIGH_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SIZE_HIGH_ADDR}] ${MODELPARAM_VALUE.SIZE_HIGH_ADDR}
}

proc update_MODELPARAM_VALUE.SIZE_LOW_ADDR { MODELPARAM_VALUE.SIZE_LOW_ADDR PARAM_VALUE.SIZE_LOW_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SIZE_LOW_ADDR}] ${MODELPARAM_VALUE.SIZE_LOW_ADDR}
}

proc update_MODELPARAM_VALUE.TAG_HIGH_ADDR { MODELPARAM_VALUE.TAG_HIGH_ADDR PARAM_VALUE.TAG_HIGH_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TAG_HIGH_ADDR}] ${MODELPARAM_VALUE.TAG_HIGH_ADDR}
}

proc update_MODELPARAM_VALUE.TAG_LOW_ADDR { MODELPARAM_VALUE.TAG_LOW_ADDR PARAM_VALUE.TAG_LOW_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TAG_LOW_ADDR}] ${MODELPARAM_VALUE.TAG_LOW_ADDR}
}

proc update_MODELPARAM_VALUE.MODE_HIGH_ADDR { MODELPARAM_VALUE.MODE_HIGH_ADDR PARAM_VALUE.MODE_HIGH_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MODE_HIGH_ADDR}] ${MODELPARAM_VALUE.MODE_HIGH_ADDR}
}

proc update_MODELPARAM_VALUE.MODE_LOW_ADDR { MODELPARAM_VALUE.MODE_LOW_ADDR PARAM_VALUE.MODE_LOW_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MODE_LOW_ADDR}] ${MODELPARAM_VALUE.MODE_LOW_ADDR}
}

proc update_MODELPARAM_VALUE.ADDR_HIGH_ADDR { MODELPARAM_VALUE.ADDR_HIGH_ADDR PARAM_VALUE.ADDR_HIGH_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADDR_HIGH_ADDR}] ${MODELPARAM_VALUE.ADDR_HIGH_ADDR}
}

proc update_MODELPARAM_VALUE.ADDR_LOW_ADDR { MODELPARAM_VALUE.ADDR_LOW_ADDR PARAM_VALUE.ADDR_LOW_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADDR_LOW_ADDR}] ${MODELPARAM_VALUE.ADDR_LOW_ADDR}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_ID_WIDTH { MODELPARAM_VALUE.C_S00_AXI_ID_WIDTH PARAM_VALUE.C_S00_AXI_ID_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_ID_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_ID_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_AWUSER_WIDTH { MODELPARAM_VALUE.C_S00_AXI_AWUSER_WIDTH PARAM_VALUE.C_S00_AXI_AWUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_AWUSER_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_AWUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_ARUSER_WIDTH { MODELPARAM_VALUE.C_S00_AXI_ARUSER_WIDTH PARAM_VALUE.C_S00_AXI_ARUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_ARUSER_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_ARUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_WUSER_WIDTH { MODELPARAM_VALUE.C_S00_AXI_WUSER_WIDTH PARAM_VALUE.C_S00_AXI_WUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_WUSER_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_WUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_RUSER_WIDTH { MODELPARAM_VALUE.C_S00_AXI_RUSER_WIDTH PARAM_VALUE.C_S00_AXI_RUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_RUSER_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_RUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_BUSER_WIDTH { MODELPARAM_VALUE.C_S00_AXI_BUSER_WIDTH PARAM_VALUE.C_S00_AXI_BUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_BUSER_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_BUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.C_S00_AXIS_TDATA_WIDTH PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXIS_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXIS_TID_WIDTH { MODELPARAM_VALUE.C_S00_AXIS_TID_WIDTH PARAM_VALUE.C_S00_AXIS_TID_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXIS_TID_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXIS_TID_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXIS_TUSER_WIDTH { MODELPARAM_VALUE.C_S00_AXIS_TUSER_WIDTH PARAM_VALUE.C_S00_AXIS_TUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXIS_TUSER_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXIS_TUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M00_AXI_TARGET_SLAVE_BASE_ADDR { MODELPARAM_VALUE.C_M00_AXI_TARGET_SLAVE_BASE_ADDR PARAM_VALUE.C_M00_AXI_TARGET_SLAVE_BASE_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M00_AXI_TARGET_SLAVE_BASE_ADDR}] ${MODELPARAM_VALUE.C_M00_AXI_TARGET_SLAVE_BASE_ADDR}
}

proc update_MODELPARAM_VALUE.C_M00_AXI_BURST_LEN { MODELPARAM_VALUE.C_M00_AXI_BURST_LEN PARAM_VALUE.C_M00_AXI_BURST_LEN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M00_AXI_BURST_LEN}] ${MODELPARAM_VALUE.C_M00_AXI_BURST_LEN}
}

proc update_MODELPARAM_VALUE.C_M00_AXI_ID_WIDTH { MODELPARAM_VALUE.C_M00_AXI_ID_WIDTH PARAM_VALUE.C_M00_AXI_ID_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M00_AXI_ID_WIDTH}] ${MODELPARAM_VALUE.C_M00_AXI_ID_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M00_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_M00_AXI_ADDR_WIDTH PARAM_VALUE.C_M00_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M00_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_M00_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M00_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_M00_AXI_DATA_WIDTH PARAM_VALUE.C_M00_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M00_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_M00_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M00_AXI_AWUSER_WIDTH { MODELPARAM_VALUE.C_M00_AXI_AWUSER_WIDTH PARAM_VALUE.C_M00_AXI_AWUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M00_AXI_AWUSER_WIDTH}] ${MODELPARAM_VALUE.C_M00_AXI_AWUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M00_AXI_ARUSER_WIDTH { MODELPARAM_VALUE.C_M00_AXI_ARUSER_WIDTH PARAM_VALUE.C_M00_AXI_ARUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M00_AXI_ARUSER_WIDTH}] ${MODELPARAM_VALUE.C_M00_AXI_ARUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M00_AXI_WUSER_WIDTH { MODELPARAM_VALUE.C_M00_AXI_WUSER_WIDTH PARAM_VALUE.C_M00_AXI_WUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M00_AXI_WUSER_WIDTH}] ${MODELPARAM_VALUE.C_M00_AXI_WUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M00_AXI_RUSER_WIDTH { MODELPARAM_VALUE.C_M00_AXI_RUSER_WIDTH PARAM_VALUE.C_M00_AXI_RUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M00_AXI_RUSER_WIDTH}] ${MODELPARAM_VALUE.C_M00_AXI_RUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M00_AXI_BUSER_WIDTH { MODELPARAM_VALUE.C_M00_AXI_BUSER_WIDTH PARAM_VALUE.C_M00_AXI_BUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M00_AXI_BUSER_WIDTH}] ${MODELPARAM_VALUE.C_M00_AXI_BUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M00_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.C_M00_AXIS_TDATA_WIDTH PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_M00_AXIS_TDATA_WIDTH}
}

