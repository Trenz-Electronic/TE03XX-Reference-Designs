REM ########## Trenz Electronic - FPGA micromodules
REM ########## bit-stream generation script (FDR)

REM # To set environment variables in make or script files:
REM # Add <XILINX installation directory>\settings32.bat or settings64.bat to your script. 
REM # 32 or 64 corresponds to the bit-width of the operating system installed on the machine
REM # http://www.xilinx.com/support/documentation/sw_manuals/xilinx12_2/irn.pdf
call C:\Xilinx\12.2\ISE_DS\settings32.bat

REM ##############################
REM ########## TE0300-01 ##########
REM ##############################

REM ########## TE0300-01I ##########
REM ########## TE0300-01M ##########
xps -nw -scr batch_clean.tcl

COPY /Y .\data\system.ucf.XC3S1200E .\data\system.ucf
rem COPY /Y system_incl.make.XC3S1200E-demo system_incl.make
COPY /Y system.xmp.XC3S1200E-demo system.xmp
COPY /Y system.mhs.125MHz system.mhs
xps -nw -scr batch_init_bram.tcl
COPY /Y .\implementation\download.bit ..\TE0300-01I-demo.bit
COPY /Y .\implementation\download.bit ..\TE0300-01M-demo.bit
DEL     .\implementation\download.bit  

COPY /Y .\data\system.ucf.XC3S1200E .\data\system.ucf
rem COPY /Y system_incl.make.XC3S1200E-bootloader system_incl.make
COPY /Y system.xmp.XC3S1200E-bootloader system.xmp
COPY /Y system.mhs.125MHz system.mhs
xps -nw -scr batch_init_bram.tcl
COPY /Y .\implementation\download.bit ..\TE0300-01I-bootloader.bit
COPY /Y .\implementation\download.bit ..\TE0300-01M-bootloader.bit
DEL     .\implementation\download.bit  


REM ########## TE0300-01IBMLP ##########
REM ########## TE0300-01IBMLP ##########
xps -nw -scr batch_clean.tcl

COPY /Y .\data\system.ucf.XC3S1600E .\data\system.ucf
rem COPY /Y system_incl.make.XC3S1600E-demo system_incl.make
COPY /Y system.xmp.XC3S1600E-demo system.xmp
COPY /Y system.mhs.100MHz system.mhs
xps -nw -scr batch_init_bram.tcl
COPY /Y .\implementation\download.bit ..\TE0300-01IBMLP-demo.bit
COPY /Y .\implementation\download.bit ..\TE0300-01BMLP-demo.bit
DEL     .\implementation\download.bit  

COPY /Y .\data\system.ucf.XC3S1600E .\data\system.ucf
rem COPY /Y system_incl.make.XC3S1600E-bootloader system_incl.make
COPY /Y system.xmp.XC3S1600E-bootloader system.xmp
COPY /Y system.mhs.100MHz system.mhs
xps -nw -scr batch_init_bram.tcl
COPY /Y .\implementation\download.bit ..\TE0300-01IBMLP-bootloader.bit
COPY /Y .\implementation\download.bit ..\TE0300-01BMLP-bootloader.bit
DEL     .\implementation\download.bit 


REM ########## TE0300-01IBM ##########
REM ########## TE0300-01IBM ##########
xps -nw -scr batch_clean.tcl

COPY /Y .\data\system.ucf.XC3S1600E .\data\system.ucf
rem COPY /Y system_incl.make.XC3S1600E-demo system_incl.make
COPY /Y system.xmp.XC3S1600E-demo system.xmp
COPY /Y system.mhs.125MHz system.mhs
xps -nw -scr batch_init_bram.tcl
COPY /Y .\implementation\download.bit ..\TE0300-01IBM-demo.bit
COPY /Y .\implementation\download.bit ..\TE0300-01BM-demo.bit
DEL     .\implementation\download.bit  

COPY /Y .\data\system.ucf.XC3S1600E .\data\system.ucf
rem COPY /Y system_incl.make.XC3S1600E-bootloader system_incl.make
COPY /Y system.xmp.XC3S1600E-bootloader system.xmp
COPY /Y system.mhs.125MHz system.mhs
xps -nw -scr batch_init_bram.tcl
COPY /Y .\implementation\download.bit ..\TE0300-01IBM-bootloader.bit
COPY /Y .\implementation\download.bit ..\TE0300-01BM-bootloader.bit
DEL     .\implementation\download.bit  
