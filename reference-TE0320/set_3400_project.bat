@rem Configure environment
call C:\Xilinx\13.2\ISE_DS\settings64.bat

@rem Clean project
make -f system.make hwclean

@rem Prepare 3400 project
@copy /y system.xmp.3400 system.xmp
@copy /y system_incl.make.3400 system_incl.make
@copy /y data\system.ucf.3400 data\system.ucf
