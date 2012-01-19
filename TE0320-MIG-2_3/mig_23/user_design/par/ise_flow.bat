

echo Synthesis Tool: XST

mkdir "../synth/__projnav" > ise_flow_results.txt
mkdir "../synth/xst" >> ise_flow_results.txt
mkdir "../synth/xst/work" >> ise_flow_results.txt

xst -ifn ise_run.txt -ofn mem_interface_top.syr -intstyle ise >> ise_flow_results.txt
ngdbuild -intstyle ise -dd ../synth/_ngo -uc mig_23.ucf -p xc3sd1800afg676-4 mig_23.ngc mig_23.ngd >> ise_flow_results.txt

map -intstyle ise -detail -p xc3sd1800afg676-4 -cm speed -pr off -k 4 -c 100 -o mig_23_map.ncd mig_23.ngd mig_23.pcf >> ise_flow_results.txt
par -w -intstyle ise -ol std -t 1 mig_23_map.ncd mig_23.ncd mig_23.pcf >> ise_flow_results.txt
trce -e 100 mig_23.ncd mig_23.pcf >> ise_flow_results.txt
bitgen -intstyle ise -f mem_interface_top.ut mig_23.ncd >> ise_flow_results.txt

echo done!
