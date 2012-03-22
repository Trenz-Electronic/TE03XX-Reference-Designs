rem Configure environment
call C:\Xilinx\13.2\ISE_DS\settings64.bat

@rem Prepare 1200 project
@copy /y system.xmp.1200 system.xmp
@copy /y system_incl.make.1200 system_incl.make
@copy /y data\system.ucf.1200 data\system.ucf
@rem Clean project
make -f system.make hwclean
@rem Generate bitstream
make -f system.make init_bram
@rem Copy result
copy /y implementation\system.bit system_1200.bit
copy /y implementation\system_bd.bmm system_bd_1200.bmm
copy /y implementation\download.bit download_1200.bit
@rem Clean project
make -f system.make hwclean

@rem Prepare 1600 project
@copy /y system.xmp.1600 system.xmp
@copy /y system_incl.make.1600 system_incl.make
@copy /y data\system.ucf.1600 data\system.ucf
@rem Clean project
make -f system.make hwclean
@rem Generate bitstream
make -f system.make init_bram
@rem Copy result
copy /y implementation\system.bit system_1600.bit
copy /y implementation\system_bd.bmm system_bd_1600.bmm
copy /y implementation\download.bit download_1600.bit
@rem Clean project
make -f system.make hwclean

@rem Remove logs
@del *.log

@rem Making FWUs
@rem Configure environment
set XILINX=C:\Xilinx\13.2\ISE_DS\ISE
set XILINX_DSP=%XILINX%
set PATH=%XILINX%\bin\nt;%XILINX%\lib\nt;%PATH%
@rem Copy needed files
copy PREPARE_FWU\bin\usb.bin .\
copy PREPARE_FWU\bin\Bootload.ini .\

@rem Generate FWU for 1200
promgen -w -p bin -u 0 download_1200.bit -o fpga.bin
zip -q TE0300-1200.zip fpga.bin Bootload.ini usb.bin
move TE0300-1200.zip TE0300-1200.fwu
@rem Remove logs
@del fpga.bin fpga.prm fpga.cfi

@rem Generate FWU for 1600
promgen -w -p bin -u 0 download_1600.bit -o fpga.bin
zip -q TE0300-1600.zip fpga.bin Bootload.ini usb.bin
move TE0300-1600.zip TE0300-1600.fwu
@rem Remove logs
@del fpga.bin fpga.prm fpga.cfi

@rem Remove files
@del usb.bin 
@del Bootload.ini
