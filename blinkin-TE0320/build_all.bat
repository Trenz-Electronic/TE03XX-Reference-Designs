rem Configure environment
set XILINX=C:\Xilinx\13.3\ISE_DS\ISE
set XILINX_DSP=%XILINX%
set PATH=%XILINX%\bin\nt;%XILINX%\lib\nt;%PATH%

rem Run 1800 version build
xtclsh blinker-TE0320-1800.tcl rebuild_project
bitgen -intstyle ise -f blinker.ncd
promgen -w -u 0 blinker.bit -o TE0320-1800.mcs
promgen -w -p bin -u 0 blinker.bit -o fpga.bin
copy blinker.bit TE0320-1800.bit
zip -q TE0320-1800.zip fpga.bin Bootload.ini usb.bin
move TE0320-1800.zip TE0320-1800.fwu

rem Clean
@del /F /q fpga.bin fpga.cfi fpga.prm
@del /F /q TE0320-1800.cfi TE0320-1800.prm
@del /F /q bitgen.xmsgs map.xmsgs ngdbuild.xmsgs par.xmsgs trce.xmsgs xst.xmsgs
@del /F /q blinker.bgn blinker.bit blinker.bld blinker.cmd_log blinker.drc blinker.lso
@del /F /q blinker.ncd blinker.ngc blinker.ngd blinker.ngr blinker.pad blinker.par
@del /F /q blinker.pcf blinker.prj blinker.ptwx blinker.stx blinker.syr blinker.twr
@del /F /q blinker.twx blinker.unroutes blinker.xpi blinker.xst
@del /F /q blinker_map.map blinker_map.mrp blinker_map.ncd blinker_map.ngm
@del /F /q blinker_map.xrpt blinker_ngdbuild.xrpt blinker_pad.csv blinker_pad.txt
@del /F /q blinker_par.xrpt blinker_summary.html blinker_summary.xml blinker_usage.xml
@del /F /q blinker_vhdl.prj blinker_xst.xrpt webtalk.log webtalk_pn.xml
@rmdir /S /Q xst _ngo xlnx_auto_0_xdb
@del /F /q blinker_summary.html blinker_guide.ncd

rem Run 3400 version build
xtclsh blinker-TE0320-3400.tcl rebuild_project
bitgen -intstyle ise -f blinker.ncd
promgen -w -u 0 blinker.bit -o TE0320-3400.mcs
promgen -w -p bin -u 0 blinker.bit -o fpga.bin
copy blinker.bit TE0320-3400.bit
zip -q TE0320-3400.zip fpga.bin Bootload.ini usb.bin
move TE0320-3400.zip TE0320-3400.fwu

rem Clean
@del /F /q fpga.bin fpga.cfi fpga.prm
@del /F /q TE0320-3400.cfi TE0320-3400.prm
@del /F /q bitgen.xmsgs map.xmsgs ngdbuild.xmsgs par.xmsgs trce.xmsgs xst.xmsgs
@del /F /q blinker.bgn blinker.bit blinker.bld blinker.cmd_log blinker.drc blinker.lso
@del /F /q blinker.ncd blinker.ngc blinker.ngd blinker.ngr blinker.pad blinker.par
@del /F /q blinker.pcf blinker.prj blinker.ptwx blinker.stx blinker.syr blinker.twr
@del /F /q blinker.twx blinker.unroutes blinker.xpi blinker.xst
@del /F /q blinker_map.map blinker_map.mrp blinker_map.ncd blinker_map.ngm
@del /F /q blinker_map.xrpt blinker_ngdbuild.xrpt blinker_pad.csv blinker_pad.txt
@del /F /q blinker_par.xrpt blinker_summary.html blinker_summary.xml blinker_usage.xml
@del /F /q blinker_vhdl.prj blinker_xst.xrpt webtalk.log webtalk_pn.xml
@rmdir /S /Q xst _ngo xlnx_auto_0_xdb
@del /F /q blinker_summary.html blinker_guide.ncd
