PAGE UNDER EDIT



## tec-APUS

- This add-on combines a serial port from the MC6850 with maths from the AM9511 onto one pcb. 
- The goal is to support ASM and also MINT which buy default has bitbang and integer maths, but make it more powerful with fast serial and transcendental functions.


## MC6850 features
![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/6850chip.png)   

- chip select ......
- chip control.......
- clock can use stanbdared 4mhz or a baud rate frew of 7.3728 Mhz gives standard baud rates 4800, 9600... 
- the code divides this down  `/64 = 115,200` baud or `/16 =  460,800` baud 
- handles control registers and with INT control eg rx buffer sends a INT
- or use other speeds, 4Mhz pcb or slow RC clock then dial up custom baud rate with Tera-Term 
- code
- mycomputer.emu
- simple-echo.z80
- check and adjust code constants, will depend on RAM and ROM/EPROM space
- download the .bin then uploaded to EMU or burn rom with intel hex file

## AM9511 features
![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/9511chip.png)   

- chip select ......
- chip control.......
  - A0 controls Command/Data registers.
- clock
  - its also needs a slower clock just over 1Mh (unless u have the 3Mhz ver) 
  - or try drive with /M1 as a clock ( 2T states) 
  - or use the onboard flip flops /3; better. 
  - or use a slower baud clock and run it direct; mod needed.

- then send maths commands or data; 
- it executes and the result is placed on its internals stack, 
- then it signals via INT.
- the select line P1 is active low, driven by eg port 6 (h3000,3001) 
- or 7 (h3800,3801), 
- code
- 9511.asm, still a work in progress.
- check and adjust code constants, will depend on RAM and ROM/EPROM space
- https://github.com/z88dk/z88dk/tree/master/libsrc/_DEVELOPMENT/math/float/am9511
- needs 5V and 12V, add a step up board or add to main circuit design. https://easyeda.com/Little_Arc/MT3608





## Circuit

- this circuit is hacked together from
- https://www.tindie.com/products/semachthemonkey/rc2014-am9511a-apu-arithmetic-processor/
- https://github.com/RC2014Z80/RC2014/tree/master/Hardware/APU%20RC2014
- https://github.com/crsjones/Southern-Cross-Computer-z80/tree/main/ExpansionBoards/SC-Serial


## Ver 8

## Ver 7 and older 
- https://github.com/SteveJustin1963/tec-APUS/wiki




