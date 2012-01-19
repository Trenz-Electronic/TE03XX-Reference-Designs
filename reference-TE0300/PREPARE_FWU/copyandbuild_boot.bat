echo Created by Costantino Grana - University of Modena and Reggio Emilia, Italy
echo Edited by Ales Gorkic - Optomotive d.o.o., Slovenia

copy ..\SDK\SDK_Workspace\reference-TE0300-01-ISE-13_2_hw_platform\download.bit .
copy ..\SDK\SDK_Workspace\demo\Release\demo.elf .

call build_boot download.bit demo.elf 0x1C000000

del download.bit
del demo.elf
