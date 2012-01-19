###############################################################################
## DISCLAIMER OF LIABILITY
##
## This text/file contains proprietary, confidential
## information of Xilinx, Inc., is distributed under license
## from Xilinx, Inc., and may be used, copied and/or
## disclosed only pursuant to the terms of a valid license
## agreement with Xilinx, Inc. Xilinx hereby grants you a
## license to use this text/file solely for design, simulation,
## implementation and creation of design files limited
## to Xilinx devices or technologies. Use with non-Xilinx
## devices or technologies is expressly prohibited and
## immediately terminates your license unless covered by
## a separate agreement.
##
## Xilinx is providing this design, code, or information
## "as-is" solely for use in developing programs and
## solutions for Xilinx devices, with no obligation on the
## part of Xilinx to provide support. By providing this design,
## code, or information as one possible implementation of
## this feature, application or standard, Xilinx is making no
## representation that this implementation is free from any
## claims of infringement. You are responsible for
## obtaining any rights you may require for your implementation.
## Xilinx expressly disclaims any warranty whatsoever with
## respect to the adequacy of the implementation, including
## but not limited to any warranties or representations that this
## implementation is free from claims of infringement, implied
## warranties of merchantability or fitness for a particular
## purpose.
##
## Xilinx products are not intended for use in life support
## appliances, devices, or systems. Use in such applications is
## expressly prohibited.
##
## Any modifications that are made to the Source Code are
## done at the user’s sole risk and will be unsupported.
##
## Copyright (c) 2006-2007 Xilinx, Inc. All rights reserved.
##
## This copyright and support notice must be retained as part
## of this text at all times.
###############################################################################
##   ____  ____
##  /   /\/   /
## /___/  \  /    Vendor             : Xilinx
## \   \   \/     Version            : 2.3
##  \   \         Application        : MIG
##  /   /         Filename           : sim.do
## /___/   /\     Date Last Modified : $Date: 2008/08/12 15:32:22 $
## \   \  /  \    Date Created       : Mon May 14 2007
##  \___\/\___\
##
## Device: Spartan-3/3A/3A-DSP/3E
## Design Name : DDR SDRAM
## Purpose:
##    Sample sim .do file to compile and simulate memory interface
##    design and run the simulation for specified period of time. Display the
##    waveforms that are listed with "add wave" command.
##    Assumptions:
##      - Simulation takes place in \sim folder of MIG output directory
## Reference:
## Revision History:
###############################################################################
vlib work
#Map the required libraries here.#
#Complie design parameter file first. This is required for VHDL designs which #
#include a parameter file.#
vcom  ../rtl/*parameters*
#Compile all modules#
vcom  ../rtl/*
#Compile files in sim folder (excluding model parameter file)#
vlog  ../sim/*.v
vcom  ../sim/*.vhd
#Pass the parameters for memory model parameter file#
vlog  +incdir+. +define+x512Mb +define+sg5B +define+x16 ddr_model.v
#Load the design. Use required libraries.#
vsim -t ps -novopt +notimingchecks -L unisim work.sim_tb_top glbl
onerror {resume}

#Log all the objects in design. These will appear in .wlf file#
log -r /*
#View sim_tb_top signals in waveform#
add wave sim:/sim_tb_top/*
#Change radix to Hexadecimal#
radix hex
#Supress Numeric Std package and Arith package warnings.#
#For VHDL designs we get some warnings due to unknown values on some signals at startup#
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0#
#We may also get some Arithmetic package warnings because of unknown values on#
#some of the signals that are used in an Arithmetic operation.#
#In order to suppress these warnings, we use following two commands#
set NumericStdNoWarnings 1
set StdArithNoWarnings 1
#Choose simulation run time by inserting a breakpoint and then run for specified #
#period. Refer simulation_help file.#
when {/sim_tb_top/init_done = 1} {
if {[when -label a_100] == ""} {
when -label a_100 { $now = 50 us } {
nowhen a_100
report simulator control
report simulator state
if {[examine /sim_tb_top/error] == 0} {
echo "TEST PASSED"
stop
}
if {[examine /sim_tb_top/error] != 0} {
echo "TEST FAILED: DATA ERROR"
stop
}
}
}
}
#In case calibration fails to complete, choose the run time and then quit#
when {$now = @500 us and /sim_tb_top/init_done != 1} {
echo "TEST FAILED: INITIALIZATION DID NOT COMPLETE"
stop
}
run -all
stop
