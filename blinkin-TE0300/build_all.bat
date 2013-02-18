rem Configure environment 
set XILINX=C:\Xilinx\13.3\ISE_DS\ISE
set XILINX_DSP=%XILINX%
set PATH=%XILINX%\bin\nt;%XILINX%\lib\nt;%PATH%

rem Run 1200 version build
xtclsh blinkin-TE0300-1200.tcl rebuild_project
promgen -w -u 0 blinkin.bit -o TE0300-1200.mcs
promgen -w -p bin -u 0 blinkin.bit -o fpga.bin
copy blinkin.bit TE0300-1200.bit
zip -q TE0300-1200.zip fpga.bin Bootload.ini usb.bin
move TE0300-1200.zip TE0300-1200.fwu

rem Clean
@del /F /q fpga.bin fpga.cfi fpga.prm
@del /F /q TE0300-1200.cfi TE0300-1200.prm
@del /F /q bitgen.xmsgs map.xmsgs ngdbuild.xmsgs par.xmsgs trce.xmsgs xst.xmsgs
@del /F /q blinkin.bgn blinkin.bit blinkin.bld blinkin.cmd_log blinkin.drc blinkin.lso
@del /F /q blinkin.ncd blinkin.ngc blinkin.ngd blinkin.ngr blinkin.pad blinkin.par
@del /F /q blinkin.pcf blinkin.prj blinkin.ptwx blinkin.stx blinkin.syr blinkin.twr
@del /F /q blinkin.twx blinkin.unroutes blinkin.xpi blinkin.xst
@del /F /q blinkin_map.map blinkin_map.mrp blinkin_map.ncd blinkin_map.ngm
@del /F /q blinkin_map.xrpt blinkin_ngdbuild.xrpt blinkin_pad.csv blinkin_pad.txt
@del /F /q blinkin_par.xrpt blinkin_summary.html blinkin_summary.xml blinkin_usage.xml
@del /F /q blinkin_vhdl.prj blinkin_xst.xrpt webtalk.log webtalk_pn.xml
@rmdir /S /Q xst _ngo xlnx_auto_0_xdb
@del /F /q blinkin_summary.html blinkin_guide.ncd

rem Run 1200 version build
xtclsh blinkin-TE0300-1600.tcl rebuild_project
promgen -w -u 0 blinkin.bit -o TE0300-1600.mcs
promgen -w -p bin -u 0 blinkin.bit -o fpga.bin
copy blinkin.bit TE0300-1600.bit
zip -q TE0300-1600.zip fpga.bin Bootload.ini usb.bin
move TE0300-1600.zip TE0300-1600.fwu

rem Clean
@del /F /q fpga.bin fpga.cfi fpga.prm
@del /F /q TE0300-1600.cfi TE0300-1600.prm
@del /F /q bitgen.xmsgs map.xmsgs ngdbuild.xmsgs par.xmsgs trce.xmsgs xst.xmsgs
@del /F /q blinkin.bgn blinkin.bit blinkin.bld blinkin.cmd_log blinkin.drc blinkin.lso
@del /F /q blinkin.ncd blinkin.ngc blinkin.ngd blinkin.ngr blinkin.pad blinkin.par
@del /F /q blinkin.pcf blinkin.prj blinkin.ptwx blinkin.stx blinkin.syr blinkin.twr
@del /F /q blinkin.twx blinkin.unroutes blinkin.xpi blinkin.xst
@del /F /q blinkin_map.map blinkin_map.mrp blinkin_map.ncd blinkin_map.ngm
@del /F /q blinkin_map.xrpt blinkin_ngdbuild.xrpt blinkin_pad.csv blinkin_pad.txt
@del /F /q blinkin_par.xrpt blinkin_summary.html blinkin_summary.xml blinkin_usage.xml
@del /F /q blinkin_vhdl.prj blinkin_xst.xrpt webtalk.log webtalk_pn.xml
@rmdir /S /Q xst _ngo xlnx_auto_0_xdb
@del /F /q blinkin_summary.html blinkin_guide.ncd
