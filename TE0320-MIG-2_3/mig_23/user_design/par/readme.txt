This folder has the batch files to synthesize using the XST or Synplify Pro and PAR the design through command mode.

Steps to run the design using the ise flow :

1. Double clicking the ise_flow.bat file, synthesizes the design using XST or Synplify Pro and does the PAR.

2. On running the ise_flow.bat file, creates the all report files.

Steps to run the design using the create_ise(pjcli):

Note: supports only XST.

1. Double clicking the create_ise.bat file, it creates test.ise project file by setting all the properties of the design selected.

2. Once the test.ise project file is created, you can open the project file and synthesize and run the PAR.

 About other files in this folder :

* mig_23.ucf file is the constratint file for the design. This is used by ISE tool during PAR phase.
  It has all the clock constraints, Location constraints, false paths if any, IO standards and 
  Area group constraints if any.

* ise_run.txt file has synthesis options for the XST tool.

* mem_interface_top.ut file has the options for the Configuration file generation i.e. the .bit file.

* xco files are used to generate VIO, ILA and ICON cores when debug signals option is selected in the GUI.
Synth folder:

* Synth folder has the constraint file for synplify Pro designs i.e. the .sdc file, Project file which has the design files to be added to the project i.e. the .prj file  and the synthesis tool options file for synplify Pro i.e. .tcl file.
