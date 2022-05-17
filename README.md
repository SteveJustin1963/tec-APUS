PAGE UNDER EDIT



## tec-APUS

PCB provides 1x async serial port upto 1Mbps (MC6850) and transcendental math functions (AM9511). Use in MINT or your ASM code etc.

## MC6850 

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/6850chip.png)   

### Datasheet
- https://github.com/SteveJustin1963/tec-APUS/blob/master/docs/MC6850.pdf

### chip control
- select, is used to select the device on the bus that the master is communicating with. 
- control, is used to control the operation of the device, such as writing to or reading from the device. 
- clock is used to synchronize the data transfer between the master and the device. from this we derive the baud rate at which data is transferred between the devices on serial port. 

### test code
- simple-echo.z80. it echoes back what you sent to it. set your RAM and ROM values. downloaded as intel hex or binary. load hex into into rom with burner (covets to binary) or bin to EMU.
- clocks speed determines baud rate, a &.3728 Mhz clk gives standard baud rates 4800, 9600... The code divides this down  `/64 = 115,200` baud or `/16 =  460,800` baud 
- but a standard clock is not required to operate such as 4Mhz. simply adjust the terminal speed to aquire the right baud rate with Tera-Term. 
- handles the control registers and with INT control, 
  - rx buffer sends a INT when the buffer is full. 


## AM9511  

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/9511chip.png)   

### Datasheet
- https://github.com/SteveJustin1963/tec-APUS/blob/master/docs/AMD%209511%20FPU.pdf

- needs 5V and 12V, add a step up board or add to main circuit design. 

### chip control
- select used to select the chip
- A0 controls Command/Data registers.
- clock, needs a slower clock 1Mh and 3Mhz versions, check markings . maybe but recommended yo use a slwer clock use the M1 signal as its 2T states 
- or use a divider cct with flip flops etc 
- the select line P1 is active low, driven by eg port 6 (h3000,3001) or 7 (h3800,3801), 


### test code
- see CJ code, url ?
- https://github.com/z88dk/z88dk/tree/master/libsrc/_DEVELOPMENT/math/float/am9511
- https://easyeda.com/Little_Arc/MT3608



## Circuit



## older cct versions 
- https://github.com/SteveJustin1963/tec-APUS/wiki


### Ref 
- https://www.tindie.com/products/semachthemonkey/rc2014-am9511a-apu-arithmetic-processor/
- https://github.com/RC2014Z80/RC2014/tree/master/Hardware/APU%20RC2014
- https://github.com/crsjones/Southern-Cross-Computer-z80/tree/main/ExpansionBoards/SC-Serial
- https://github.com/crsjones/Southern-Cross-Computer-z80/tree/main/ExpansionBoards/SC-APU
