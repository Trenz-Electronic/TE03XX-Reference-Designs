project -new 
add_file -vhdl "../rtl/mig_23_parameters_0.vhd"
add_file -vhdl "../rtl/mig_23.vhd"
add_file -vhdl "../rtl/mig_23_cal_ctl.vhd"
add_file -vhdl "../rtl/mig_23_cal_top.vhd"
add_file -vhdl "../rtl/mig_23_controller_0.vhd"
add_file -vhdl "../rtl/mig_23_controller_iobs_0.vhd"
add_file -vhdl "../rtl/mig_23_data_path_0.vhd"
add_file -vhdl "../rtl/mig_23_data_path_iobs_0.vhd"
add_file -vhdl "../rtl/mig_23_data_read_0.vhd"
add_file -vhdl "../rtl/mig_23_data_read_controller_0.vhd"
add_file -vhdl "../rtl/mig_23_data_write_0.vhd"
add_file -vhdl "../rtl/mig_23_dqs_delay_0.vhd"
add_file -vhdl "../rtl/mig_23_fifo_0_wr_en_0.vhd"
add_file -vhdl "../rtl/mig_23_fifo_1_wr_en_0.vhd"
add_file -vhdl "../rtl/mig_23_infrastructure.vhd"
add_file -vhdl "../rtl/mig_23_infrastructure_iobs_0.vhd"
add_file -vhdl "../rtl/mig_23_infrastructure_top0.vhd"
add_file -vhdl "../rtl/mig_23_iobs_0.vhd"
add_file -vhdl "../rtl/mig_23_ram8d_0.vhd"
add_file -vhdl "../rtl/mig_23_rd_gray_cntr.vhd"
add_file -vhdl "../rtl/mig_23_s3_dm_iob.vhd"
add_file -vhdl "../rtl/mig_23_s3_dq_iob.vhd"
add_file -vhdl "../rtl/mig_23_s3_dqs_iob.vhd"
add_file -vhdl "../rtl/mig_23_tap_dly.vhd"
add_file -vhdl "../rtl/mig_23_top_0.vhd"
add_file -vhdl "../rtl/mig_23_wr_gray_cntr.vhd"
add_file -constraint "../synth/mem_interface_top_synp.sdc"
impl -add rev_1
set_option -technology spartan-3a dsp
set_option -part xc3sd1800a
set_option -package fg676
set_option -speed_grade -4
set_option -default_enum_encoding default
set_option -symbolic_fsm_compiler 1
set_option -resource_sharing 0
set_option -use_fsm_explorer 0
set_option -top_module "mig_23"
set_option -frequency 133
set_option -fanout_limit 1000
set_option -disable_io_insertion 0
set_option -pipe 1
set_option -fixgatedclocks 0
set_option -retiming 0
set_option -modular 0
set_option -update_models_cp 0
set_option -verification_mode 0
set_option -write_verilog 0
set_option -write_vhdl 0
set_option -write_apr_constraint 0
project -result_file "../synth/rev_1/mig_23.edf"
set_option -vlog_std v2001
set_option -auto_constrain_io 0
impl -active "../synth/rev_1"
project -run hdl_info_gen -fileorder
project -run
project -save

