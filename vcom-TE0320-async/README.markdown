# Reference project for Trenz Electronic TE0320 modules

## Requirements:
* Xilinx ISE 14.2 

This project show serial communication and serial data processing using Virtual COM port driver.

This project receive byte data from FX2 async interface and pass it to user logic via FIFO. After processing data transmitted back to FX2.
* Update FX2 EEPROM with firmware from "firmware" folder
* Install Cypress Virtual COM driver from "driver" folder
* Download FPFA bitstream
* Open COM port using any teminal programm
* Type any characters in terminal, firmware will send counter and received char back
