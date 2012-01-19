REM ########## Trenz Electronic - FPGA micromodules
REM ########## bit-stream generation script (FDR)

REM # To set environment variables in make or script files:
REM # Add <XILINX installation directory>\settings32.bat or settings64.bat to your script. 
REM # 32 or 64 corresponds to the bit-width of the operating system installed on the machine
REM # http://www.xilinx.com/support/documentation/sw_manuals/xilinx12_2/irn.pdf
call C:\Xilinx\12.2\ISE_DS\settings32.bat

REM ##############################
REM ########## TE0320-00 ##########
REM ##############################

REM ########## TE0320-00-EV01 ##########
REM ########## TE0320-00-EV02 ##########
xps -nw -scr batch_clean.tcl

COPY /Y .\data\system.ucf.XC3SD1800A .\data\system.ucf
rem COPY /Y system_incl.make.XC3SD1800A-demo system_incl.make
COPY /Y system.xmp.XC3SD1800A-demo system.xmp
COPY /Y .\bootloader\main.XC3SD1800A.c .\bootloader\main.c
xps -nw -scr batch_init_bram.tcl
COPY /Y .\implementation\download.bit ..\TE0320-00-EV01-demo.bit
COPY /Y .\implementation\download.bit ..\TE0320-00-EV02-demo.bit
DEL     .\implementation\download.bit  

COPY /Y .\data\system.ucf.XC3SD1800A .\data\system.ucf
rem COPY /Y system_incl.make.XC3SD1800A-bootloader system_incl.make
COPY /Y system.xmp.XC3SD1800A-bootloader system.xmp
COPY /Y .\bootloader\main.XC3SD1800A.c .\bootloader\main.c
xps -nw -scr batch_init_bram.tcl
COPY /Y .\implementation\download.bit ..\TE0320-00-EV01-bootloader.bit
COPY /Y .\implementation\download.bit ..\TE0320-00-EV02-bootloader.bit
DEL     .\implementation\download.bit  


REM ########## TE0320-00-EV02B ##########
REM ########## TE0320-00-EV02IB ##########
xps -nw -scr batch_clean.tcl

COPY /Y .\data\system.ucf.XC3SD3400A .\data\system.ucf
rem COPY /Y system_incl.make.XC3SD3400A-demo system_incl.make
COPY /Y system.xmp.XC3SD3400A-demo system.xmp
COPY /Y .\bootloader\main.XC3SD3400A.c .\bootloader\main.c
xps -nw -scr batch_init_bram.tcl
COPY /Y .\implementation\download.bit ..\TE0320-00-EV02B-demo.bit
COPY /Y .\implementation\download.bit ..\TE0320-00-EV02IB-demo.bit
DEL     .\implementation\download.bit  

COPY /Y .\data\system.ucf.XC3SD3400A .\data\system.ucf
rem COPY /Y system_incl.make.XC3SD3400A-bootloader system_incl.make
COPY /Y system.xmp.XC3SD3400A-bootloader system.xmp
COPY /Y .\bootloader\main.XC3SD3400A.c .\bootloader\main.c
xps -nw -scr batch_init_bram.tcl
COPY /Y .\implementation\download.bit ..\TE0320-00-EV02B-bootloader.bit
COPY /Y .\implementation\download.bit ..\TE0320-00-EV02IB-bootloader.bit
DEL     .\implementation\download.bit  
