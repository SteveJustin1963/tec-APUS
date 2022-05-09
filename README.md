PAGE UNDER EDIT



## tec-APUS


- This add-on board provides a serial port and math functions using a MC6850 and AM9511 chip which provides fast serial and transcendental functions.


## MC6850 
![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/6850chip.png)   

The chip select signal is used to select the device on the bus that the master is communicating with. The chip control signal is used to control the operation of the device, such as writing to or reading from the device. The clock signal is used to synchronize the data transfer between the master and the device. The code divides the clock signal down to create the baud rate. The baud rate is the rate at which data is transferred between the devices on the bus. The code also handles the control registers and with INT control, the rx buffer sends a INT when the buffer is full. The code can also be used to create other speeds, such as 4Mhz, by using a different clock source, or by dialing up a custom baud rate with Tera-Term. The code is available for download on mycomputer.emu. The simple-echo.z80 code is a simple code that echoes back what is sent to it. The code can be used to check and adjust the code constants. The code will depend on the amount of RAM and ROM/EPROM space available. The code can be downloaded as a .bin file and uploaded to the EMU, or the code can be burned to a ROM with the intel hex file.
- data sheet https://github.com/SteveJustin1963/tec-APUS/blob/master/docs/MC6850.pdf
- clock can use stanbdared 4mhz or a baud rate frew of 7.3728 Mhz gives standard baud rates 4800, 9600... 
- the code divides this down  `/64 = 115,200` baud or `/16 =  460,800` baud 

## AM9511  
![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/9511chip.png)   

The chip select line is used to select the chip that the microcontroller wants to communicate with. The chip control lines are used to control the chip, such as setting the chip's address or data register. The clock line is used to provide a clock signal to the chip. The chip uses the clock signal to synchronize its internal operations. The chip select and chip control lines are used to send commands or data to the chip. The chip executes the commands or data and the results are placed on its internal stack. The chip signals via INT when the results are ready.

- data sheet https://github.com/SteveJustin1963/tec-APUS/blob/master/docs/AMD%209511%20FPU.pdf
- A0 controls Command/Data registers.
- clock
  - its also needs a slower clock just over 1Mh (unless u have the 3Mhz ver) 
  - or try drive with /M1 as a clock ( 2T states) 
  - or use the onboard flip flops /3; better. 
  - or use a slower baud clock and run it direct; mod needed.
- the select line P1 is active low, driven by eg port 6 (h3000,3001) 
- or 7 (h3800,3801), 
- https://github.com/z88dk/z88dk/tree/master/libsrc/_DEVELOPMENT/math/float/am9511
- needs 5V and 12V, add a step up board or add to main circuit design. 
- https://easyeda.com/Little_Arc/MT3608





## Circuit

- this circuit is hacked together from
- https://www.tindie.com/products/semachthemonkey/rc2014-am9511a-apu-arithmetic-processor/
- https://github.com/RC2014Z80/RC2014/tree/master/Hardware/APU%20RC2014
- https://github.com/crsjones/Southern-Cross-Computer-z80/tree/main/ExpansionBoards/SC-Serial


## Ver 8

## Ver 7 and older 
- https://github.com/SteveJustin1963/tec-APUS/wiki




