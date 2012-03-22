@rem Configure environment
call C:\Xilinx\13.2\ISE_DS\settings64.bat

@rem Clean project
make -f system.make hwclean

@rem Prepare 1800 project
@copy /y system.xmp.1800 system.xmp
@copy /y system_incl.make.1800 system_incl.make
@copy /y data/system.ucf.1800 data/system.ucf
