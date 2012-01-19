echo Created by Costantino Grana - University of Modena and Reggio Emilia, Italy
echo Edited by Ales Gorkic - Optomotive d.o.o., Slovenia

copy ..\SDK\SDK_Workspace\reference-TE0320-00-EDK-13-2_hw_platform\download.bit .
copy ..\SDK\SDK_Workspace\demo\Debug\demo.elf .

call build_boot.XC3SD1800A download.bit demo.elf 0x10000000

del download.bit
del demo.elf
