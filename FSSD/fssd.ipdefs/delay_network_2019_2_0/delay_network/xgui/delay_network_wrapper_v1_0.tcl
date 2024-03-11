# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "ADDR_HIGH_ADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ADDR_LOW_ADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "CHANNEL" -parent ${Page_0}
  ipgui::add_param $IPINST -name "CHANNEL_CONTENTION_LAT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_AXIS_M_TUSER_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_AXIS_SND_TDEST_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_AXIS_TDATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_AXIS_TDEST_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_AXIS_TID_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_AXIS_TUSER_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DIE_PER_CHANNEL" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DOWNCNT_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MODE_HIGH_ADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MODE_LOW_ADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NUM_CHANNEL" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PAGE_BUFFER_SIZE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PB_ERASE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PB_HIT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PB_MISS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PB_WRITE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PLANE_PER_DIE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "TAG_HIGH_ADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "TAG_LOW_ADDR" -parent ${Page_0}


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

proc update_PARAM_VALUE.CHANNEL { PARAM_VALUE.CHANNEL } {
	# Procedure called to update CHANNEL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CHANNEL { PARAM_VALUE.CHANNEL } {
	# Procedure called to validate CHANNEL
	return true
}

proc update_PARAM_VALUE.CHANNEL_CONTENTION_LAT { PARAM_VALUE.CHANNEL_CONTENTION_LAT } {
	# Procedure called to update CHANNEL_CONTENTION_LAT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CHANNEL_CONTENTION_LAT { PARAM_VALUE.CHANNEL_CONTENTION_LAT } {
	# Procedure called to validate CHANNEL_CONTENTION_LAT
	return true
}

proc update_PARAM_VALUE.C_AXIS_M_TUSER_WIDTH { PARAM_VALUE.C_AXIS_M_TUSER_WIDTH } {
	# Procedure called to update C_AXIS_M_TUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXIS_M_TUSER_WIDTH { PARAM_VALUE.C_AXIS_M_TUSER_WIDTH } {
	# Procedure called to validate C_AXIS_M_TUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_AXIS_SND_TDEST_WIDTH { PARAM_VALUE.C_AXIS_SND_TDEST_WIDTH } {
	# Procedure called to update C_AXIS_SND_TDEST_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXIS_SND_TDEST_WIDTH { PARAM_VALUE.C_AXIS_SND_TDEST_WIDTH } {
	# Procedure called to validate C_AXIS_SND_TDEST_WIDTH
	return true
}

proc update_PARAM_VALUE.C_AXIS_TDATA_WIDTH { PARAM_VALUE.C_AXIS_TDATA_WIDTH } {
	# Procedure called to update C_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXIS_TDATA_WIDTH { PARAM_VALUE.C_AXIS_TDATA_WIDTH } {
	# Procedure called to validate C_AXIS_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_AXIS_TDEST_WIDTH { PARAM_VALUE.C_AXIS_TDEST_WIDTH } {
	# Procedure called to update C_AXIS_TDEST_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXIS_TDEST_WIDTH { PARAM_VALUE.C_AXIS_TDEST_WIDTH } {
	# Procedure called to validate C_AXIS_TDEST_WIDTH
	return true
}

proc update_PARAM_VALUE.C_AXIS_TID_WIDTH { PARAM_VALUE.C_AXIS_TID_WIDTH } {
	# Procedure called to update C_AXIS_TID_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXIS_TID_WIDTH { PARAM_VALUE.C_AXIS_TID_WIDTH } {
	# Procedure called to validate C_AXIS_TID_WIDTH
	return true
}

proc update_PARAM_VALUE.C_AXIS_TUSER_WIDTH { PARAM_VALUE.C_AXIS_TUSER_WIDTH } {
	# Procedure called to update C_AXIS_TUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXIS_TUSER_WIDTH { PARAM_VALUE.C_AXIS_TUSER_WIDTH } {
	# Procedure called to validate C_AXIS_TUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.DIE_PER_CHANNEL { PARAM_VALUE.DIE_PER_CHANNEL } {
	# Procedure called to update DIE_PER_CHANNEL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DIE_PER_CHANNEL { PARAM_VALUE.DIE_PER_CHANNEL } {
	# Procedure called to validate DIE_PER_CHANNEL
	return true
}

proc update_PARAM_VALUE.DOWNCNT_WIDTH { PARAM_VALUE.DOWNCNT_WIDTH } {
	# Procedure called to update DOWNCNT_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DOWNCNT_WIDTH { PARAM_VALUE.DOWNCNT_WIDTH } {
	# Procedure called to validate DOWNCNT_WIDTH
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

proc update_PARAM_VALUE.NUM_CHANNEL { PARAM_VALUE.NUM_CHANNEL } {
	# Procedure called to update NUM_CHANNEL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NUM_CHANNEL { PARAM_VALUE.NUM_CHANNEL } {
	# Procedure called to validate NUM_CHANNEL
	return true
}

proc update_PARAM_VALUE.PAGE_BUFFER_SIZE { PARAM_VALUE.PAGE_BUFFER_SIZE } {
	# Procedure called to update PAGE_BUFFER_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PAGE_BUFFER_SIZE { PARAM_VALUE.PAGE_BUFFER_SIZE } {
	# Procedure called to validate PAGE_BUFFER_SIZE
	return true
}

proc update_PARAM_VALUE.PB_ERASE { PARAM_VALUE.PB_ERASE } {
	# Procedure called to update PB_ERASE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PB_ERASE { PARAM_VALUE.PB_ERASE } {
	# Procedure called to validate PB_ERASE
	return true
}

proc update_PARAM_VALUE.PB_HIT { PARAM_VALUE.PB_HIT } {
	# Procedure called to update PB_HIT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PB_HIT { PARAM_VALUE.PB_HIT } {
	# Procedure called to validate PB_HIT
	return true
}

proc update_PARAM_VALUE.PB_MISS { PARAM_VALUE.PB_MISS } {
	# Procedure called to update PB_MISS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PB_MISS { PARAM_VALUE.PB_MISS } {
	# Procedure called to validate PB_MISS
	return true
}

proc update_PARAM_VALUE.PB_WRITE { PARAM_VALUE.PB_WRITE } {
	# Procedure called to update PB_WRITE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PB_WRITE { PARAM_VALUE.PB_WRITE } {
	# Procedure called to validate PB_WRITE
	return true
}

proc update_PARAM_VALUE.PLANE_PER_DIE { PARAM_VALUE.PLANE_PER_DIE } {
	# Procedure called to update PLANE_PER_DIE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PLANE_PER_DIE { PARAM_VALUE.PLANE_PER_DIE } {
	# Procedure called to validate PLANE_PER_DIE
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


proc update_MODELPARAM_VALUE.NUM_CHANNEL { MODELPARAM_VALUE.NUM_CHANNEL PARAM_VALUE.NUM_CHANNEL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NUM_CHANNEL}] ${MODELPARAM_VALUE.NUM_CHANNEL}
}

proc update_MODELPARAM_VALUE.CHANNEL { MODELPARAM_VALUE.CHANNEL PARAM_VALUE.CHANNEL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CHANNEL}] ${MODELPARAM_VALUE.CHANNEL}
}

proc update_MODELPARAM_VALUE.DIE_PER_CHANNEL { MODELPARAM_VALUE.DIE_PER_CHANNEL PARAM_VALUE.DIE_PER_CHANNEL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DIE_PER_CHANNEL}] ${MODELPARAM_VALUE.DIE_PER_CHANNEL}
}

proc update_MODELPARAM_VALUE.PLANE_PER_DIE { MODELPARAM_VALUE.PLANE_PER_DIE PARAM_VALUE.PLANE_PER_DIE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PLANE_PER_DIE}] ${MODELPARAM_VALUE.PLANE_PER_DIE}
}

proc update_MODELPARAM_VALUE.PAGE_BUFFER_SIZE { MODELPARAM_VALUE.PAGE_BUFFER_SIZE PARAM_VALUE.PAGE_BUFFER_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PAGE_BUFFER_SIZE}] ${MODELPARAM_VALUE.PAGE_BUFFER_SIZE}
}

proc update_MODELPARAM_VALUE.C_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.C_AXIS_TDATA_WIDTH PARAM_VALUE.C_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_AXIS_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_AXIS_TID_WIDTH { MODELPARAM_VALUE.C_AXIS_TID_WIDTH PARAM_VALUE.C_AXIS_TID_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXIS_TID_WIDTH}] ${MODELPARAM_VALUE.C_AXIS_TID_WIDTH}
}

proc update_MODELPARAM_VALUE.C_AXIS_M_TUSER_WIDTH { MODELPARAM_VALUE.C_AXIS_M_TUSER_WIDTH PARAM_VALUE.C_AXIS_M_TUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXIS_M_TUSER_WIDTH}] ${MODELPARAM_VALUE.C_AXIS_M_TUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_AXIS_TDEST_WIDTH { MODELPARAM_VALUE.C_AXIS_TDEST_WIDTH PARAM_VALUE.C_AXIS_TDEST_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXIS_TDEST_WIDTH}] ${MODELPARAM_VALUE.C_AXIS_TDEST_WIDTH}
}

proc update_MODELPARAM_VALUE.C_AXIS_SND_TDEST_WIDTH { MODELPARAM_VALUE.C_AXIS_SND_TDEST_WIDTH PARAM_VALUE.C_AXIS_SND_TDEST_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXIS_SND_TDEST_WIDTH}] ${MODELPARAM_VALUE.C_AXIS_SND_TDEST_WIDTH}
}

proc update_MODELPARAM_VALUE.C_AXIS_TUSER_WIDTH { MODELPARAM_VALUE.C_AXIS_TUSER_WIDTH PARAM_VALUE.C_AXIS_TUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXIS_TUSER_WIDTH}] ${MODELPARAM_VALUE.C_AXIS_TUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.DOWNCNT_WIDTH { MODELPARAM_VALUE.DOWNCNT_WIDTH PARAM_VALUE.DOWNCNT_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DOWNCNT_WIDTH}] ${MODELPARAM_VALUE.DOWNCNT_WIDTH}
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

proc update_MODELPARAM_VALUE.PB_HIT { MODELPARAM_VALUE.PB_HIT PARAM_VALUE.PB_HIT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PB_HIT}] ${MODELPARAM_VALUE.PB_HIT}
}

proc update_MODELPARAM_VALUE.PB_MISS { MODELPARAM_VALUE.PB_MISS PARAM_VALUE.PB_MISS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PB_MISS}] ${MODELPARAM_VALUE.PB_MISS}
}

proc update_MODELPARAM_VALUE.PB_WRITE { MODELPARAM_VALUE.PB_WRITE PARAM_VALUE.PB_WRITE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PB_WRITE}] ${MODELPARAM_VALUE.PB_WRITE}
}

proc update_MODELPARAM_VALUE.PB_ERASE { MODELPARAM_VALUE.PB_ERASE PARAM_VALUE.PB_ERASE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PB_ERASE}] ${MODELPARAM_VALUE.PB_ERASE}
}

proc update_MODELPARAM_VALUE.CHANNEL_CONTENTION_LAT { MODELPARAM_VALUE.CHANNEL_CONTENTION_LAT PARAM_VALUE.CHANNEL_CONTENTION_LAT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CHANNEL_CONTENTION_LAT}] ${MODELPARAM_VALUE.CHANNEL_CONTENTION_LAT}
}

