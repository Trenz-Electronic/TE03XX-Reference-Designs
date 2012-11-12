rem Configure environment
call C:\Xilinx\13.2\ISE_DS\settings64.bat

@rem Prepare 1800 project
@copy /y system.xmp.1800 system.xmp
@copy /y system_incl.make.1800 system_incl.make
@copy /y data\system.ucf.1800 data\system.ucf
@rem Clean project
make -f system.make hwclean
@rem Generate bitstream
make -f system.make init_bram
@rem Copy result
copy /y implementation\system.bit system_1800.bit
copy /y implementation\system_bd.bmm system_bd_1800.bmm
copy /y implementation\download.bit TE0320_1800.bit
@rem Clean project
make -f system.make hwclean

@rem Prepare 3400 project
@copy /y system.xmp.3400 system.xmp
@copy /y system_incl.make.3400 system_incl.make
@copy /y data\system.ucf.3400 data\system.ucf
@rem Clean project
make -f system.make hwclean
@rem Generate bitstream
make -f system.make init_bram
@rem Copy result
copy /y implementation\system.bit system_3400.bit
copy /y implementation\system_bd.bmm system_bd_3400.bmm
copy /y implementation\download.bit TE0320_3400.bit
@rem Clean project
make -f system.make hwclean

@rem Remove logs
@del *.log

@rem Making FWUs
@rem Configure environment
@set XILINX=C:\Xilinx\13.2\ISE_DS\ISE
@set XILINX_DSP=%XILINX%
@set PATH=%XILINX%\bin\nt;%XILINX%\lib\nt;%PATH%
@rem Copy needed files
@copy ..\..\TE_USB_FX2.firmware\ready_for_download\current_te.iic PREPARE_FWU\usb.bin
@copy PREPARE_FWU\usb.bin .\
@copy PREPARE_FWU\Bootload.ini .\

@rem Generate FWU for 1800
@copy TE0320_1800.bit fpga.bit
@impact -batch etc\bit2bin.cmd
@copy fpga.bin TE0320-1800.bin
@PREPARE_FWU\zip -q TE0320-1800.zip fpga.bin Bootload.ini usb.bin
@move TE0320-1800.zip TE0320-1800.fwu
@rem Remove logs
@del fpga.bin fpga.prm fpga.cfi fpga.bit

@rem Generate FWU for 3400
@copy TE0320_3400.bit fpga.bit
@impact -batch etc\bit2bin.cmd
@copy fpga.bin TE0320-3400.bin
@PREPARE_FWU\zip -q TE0320-3400.zip fpga.bin Bootload.ini usb.bin
@move TE0320-3400.zip TE0320-3400.fwu
@rem Remove logs
@del fpga.bin fpga.prm fpga.cfi fpga.bit

@rem Remove files
@del usb.bin 
@del Bootload.ini
@del _impactbatch.log