@rem Configure environment
set XILINX=C:\Xilinx\13.2\ISE_DS\ISE
set XILINX_DSP=%XILINX%
set PATH=%XILINX%\bin\nt;%XILINX%\lib\nt;%PATH%

@rem Run 1800 version build
xtclsh vcom-TE0320-1800.tcl rebuild_project
bitgen -intstyle ise -f batch.ut top.ncd
promgen -w -u 0 top.bit -o vcom-TE0320-1800.mcs
@del vcom-TE0320-1800.prm vcom-TE0320-1800.cfi
copy top.bit vcom-TE0320-1800.bit
@del /F /q _ngo bitgen.xmsgs map.xmsgs ngdbuild.xmsgs par.xmsgs trce.xmsgs xst.xmsgs
@del /F /q top.bgn top.bit top.bld top.cmd_log top.drc top.lso top.ncd top.ngc
@del /F /q top.ngd top.ngr top.pad top.par top.pcf top.prj top.ptwx top.stx
@del /F /q top.syr top.twr top.twx top.unroutes top.xpi top.xst top_map.map
@del /F /q top_map.mrp top_map.ncd top_map.ngm top_map.xrpt top_ngdbuild.xrpt
@del /F /q top_pad.csv top_pad.txt top_par.xrpt top_summary.html top_summary.xml
@del /F /q top_usage.xml top_vhdl.prj top_xst.xrpt webtalk.log webtalk_pn.xml
@del /F /q xlnx_auto_0_xdb xst top_summary.html

@rem Run 3400 version build
xtclsh vcom-TE0320-3400.tcl rebuild_project
bitgen -intstyle ise -f batch.ut top.ncd
promgen -w -u 0 top.bit -o vcom-TE0320-3400.mcs
@del vcom-TE0320-3400.prm vcom-TE0320-3400.cfi
copy top.bit vcom-TE0320-3400.bit
@del /F /q _ngo bitgen.xmsgs map.xmsgs ngdbuild.xmsgs par.xmsgs trce.xmsgs xst.xmsgs
@del /F /q top.bgn top.bit top.bld top.cmd_log top.drc top.lso top.ncd top.ngc
@del /F /q top.ngd top.ngr top.pad top.par top.pcf top.prj top.ptwx top.stx
@del /F /q top.syr top.twr top.twx top.unroutes top.xpi top.xst top_map.map
@del /F /q top_map.mrp top_map.ncd top_map.ngm top_map.xrpt top_ngdbuild.xrpt
@del /F /q top_pad.csv top_pad.txt top_par.xrpt top_summary.html top_summary.xml
@del /F /q top_usage.xml top_vhdl.prj top_xst.xrpt webtalk.log webtalk_pn.xml
@del /F /q xlnx_auto_0_xdb xst top_summary.html
