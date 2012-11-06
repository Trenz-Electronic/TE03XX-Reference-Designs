@rem Configure environment
call C:\Xilinx\13.2\ISE_DS\settings64.bat

@rem Clean project
make -f system.make hwclean

@rem Prepare 1600 project
@copy /y system.xmp.1600 system.xmp
@copy /y system_incl.make.1600 system_incl.make
@copy /y data\system.ucf.1600 data\system.ucf