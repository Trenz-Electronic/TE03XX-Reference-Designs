# Reference projects for TE03XX modules
## Requirements:
* Xilinx ISE 13.2 
* Xilinx EDK 13.2
* Git client

## Get projects
* Without Git
Go to the download page https://github.com/Trenz-Electronic/TE03XX-Reference-Designs/downloads
Download project zip archive at the bottom of the page.
Unzip project
Open project in Xilinx EDK or Xilinx ISE
* Using Git
Run Git Bash
git clone git@github.com:Trenz-Electronic/TE03XX-Reference-Designs.git
cd TE03XX-Reference-Designs
git submodule init
git submodule update
Open project in Xilinx EDK or Xilinx ISE

## Build projects
All projects contain already implemented result files ready to download.  

* To build ISE projects - Open project for your module type in "Project Navigator"
and run "Generate Programming File"
* To build EDK projects - run set_FPGAID_project.bat (where FPGAID is size of FPGA
chip on your module) to setup project files in project directory and open 
system.xmp using "Xilinx Platform Studio". 
* To build project for all FPGA variants, run build_all.bat in projet directory.

## Projects description
* blinkin-TE0300 - Simple LED blinkin project for TE0300 module
* blinkin-TE0320 - Simple LED blinkin project for TE0320 module
* reference-TE0300 - EDK project with Microblaze processor, which show how to
	use FX2 USB interface at TE0300 module
* reference-TE0320 - EDK project with Microblaze processor, which show how to
	use FX2 USB interface at TE0320 module
* TE-EDK-IP - subproject which contain cores used in reference projects
* TE0300-MIG-2_3 - MIG for TE0300 module
* TE0320-MIG-2_3 - MIG for TE0320 module
* vcom-TE0300 - Virtual COM port ecample project for TE0300 module
* vcom-TE0320 - Virtual COM port ecample project for TE0320 module
