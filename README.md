# tec-APUS
Welcome to the 16.3-tec-APUS wiki!

The tecAPUS addon; Arithmetic Processing Unit AM9511 and UART Serial-IO 6850 for the TEC-1.
    
![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/mc6850.png)
![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/am9511%20logo.png)

## Circuit

https://easyeda.com/editor#id=f38afcc535a449c0b98ccadf3163fde4

 

## Inspiration

* John Hardy and Grant Searl 
* https://github.com/feilipu/yaz180
* and others


 
 
## Abstract
Forth, 9511, APU, 6850, UART, Z80, Putty, Floating-point 32 bit double precision, ADD, SUB, MUL, DIV, SIN, COS, TAN, ASIN, ACOS, ATAN, LOG, LN, EXP, PWR
 
## Introduction
The TEC-1 needs a serial port especialy when Forth runs, adding maths support may help as well. 
Options for serial are 
bitbang serial without hardware
https://github.com/SteveJustin1963/tec-BANG 

or use a dedicated serial chip, in this case the MC6850. Description; its a "a classic Motorola chips ...old and simple" with up to 1.0 Mbps transmission, with a 7.3728 xtal can run 115,200 bps (/64) or 460,800 bps (/16). the old AM9511 APU - Arithmetic Processing Unit...has 32 bit floating point operations...still available and cheap” and runs so hot (2 watts) u can cook a hotdog. am going to try that. or a thermocouple to get some power back ?

## Observe and Question
The TEC-1 need to expand on its basic displays LED /LCD, maybe https://github.com/SteveJustin1963/tec-Vectrex or https://github.com/SteveJustin1963/tec-VGA later, adding serial port to terminal becomes a nice ascii display and used by forth. Adding the APU could improve math speed, maybe. 

* Comparisons of CPU
- published spec Z80, 0.580 MIPS at 4.000 MHz, will use 7.3728 MHz clk so uart is in spec, 
new mips is 7.3728/4*0.580=1.0691
- other cpus 
* 6502, 0.430 MIPS at 1.000 MHz
* 6809, 0.420 MIPS at 1.000 MHz
* 8086, 0.330 MIPS at 5.000 MHz
* 8051, 1 instruction /cycle, 50 Mips at 50 MHz
- the avr range of mcu like attiny etc are all risc based, usually get one instruction per clk cycle


## Theory - Testable
an APU can/could take load off z80 code, 9511 published speeds caparied to raw code can be evident.  
MIPS of <, >, less, greater, compare asm code vs forth code vs APU

 
## Prediction
- am predicting Forth + 9511 is the fastest, forth next, asm last
- predict using https://github.com/SteveJustin1963/tec-Forth-SCIENTIFIC will be easier than just forth+asm calls. the library needs extending if 9511 avail.

 
## Method
- use Grant Searls uart cct and on pc side use usb-ttl com port cable, on pcb side can run ttl on board. if have a proper rs232 port on pc then run that into max232 on pcb 
- use www docs for 9511 cct 
- combine cct in easyEDA
- build proto then smoke test
- install https://github.com/SteveJustin1963/tec-EMU-BG onto tec1 to transfer code
- do serial loop test with JH code “echo-Z80” "At this stage don't expect it to work, need to integrate and examine with logic analyser till perfect." JH
- 9511 test code then code to test all math functions 
8. Speed Test
  * ASM math < Forth math < Forth + 9511 
  * Code cycles; ASM math > Forth math > Forth + 9511 
  * Code length; ASM math > Forth math > Forth + 9511 

Problem, what will be the time base to measure against? how is this coded ?


