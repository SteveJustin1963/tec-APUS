 MC6850+ AM9511, use in MINT/ASM etc.


## Ver 10 Craig Jones  
Design is work in progress, a better io decode cct is needed, see Craigs notes below. Try proper decoding cct, eg 74HC688 (eg in the APU-RC2014 board), a 8 bit comparator as IO address decoder, can be decoded anywhere in the bottom 256 I/O addresses. 74HCT688 compares two 8-bit inputs and outputs an active low if both sets match. Enable is active low eg use MREQ to drive this. set inputs to address lines and to VCC, via a DIP switch dial in address you want your io peripheral to enabled on. Note interrupt modes of IOReq and M1 will be low at the same for an interrupt acknowledge, consider this when selecting io. There is a limit to the number of devices that the Z80 can drive, some systems need buffered address and data lines, not problem with CMOS processors which we all should be using. Put A0-A7 on the 'P' side, pull-up or pull-down the inputs on the 'Q' side, when they both match the one output goes low - decoding 1 address in 256. Leave off A0 and you decode 2 consecutive addresses in 256, and so on.

- https://github.com/feilipu/LLL-Floating-Point
- 10.3.22 I have just put the Lawrence Livermore Labs Floating Point Library on GitHub, with a little demo program to run in ASM80.
- use the 'import from GitHub' option and this link to load it. https://github.com/crsjones/APU
- Also, I have a new design for the APU, I will send you the schematic soon for the next version of your TEC-APUS.
- 74HC688 works well, does not have to be INT driven, but can be. My initial code replaces the functions of the LLL library above. I am using the Wait and software polling the APU status.
- I think we should be able to do Poll/Status and Interrupt Driven interfaces for the APU, perhaps even Demand/Wait.
- Int driven just let's you do something else while the APU is working. the other modes mean you just wait for the APU to finish the calculation.
- Each operation is probably ms or less, maybe the transcendental's are longer? Anyway we will be able to use it in more than one mode. And of course it will run at 4Mhz!
- You should be able to use it from Mint, although we don't have a method of using interrupts in Mint quite yet!
- Yes, it has a lot of history attached to it being the first of it's kind, and was apparently more popular than the IEEE754 AM9512. go figure!
- There's a lot we can use in RC2014. Things have changed a lot, now sharing is the thing to do as long as you acknowledge the source.
- 16.3.22
- https://github.com/SteveJustin1963/tec-APUS/blob/master/schem/TEC-APU-cj-1.pdf
- A0 selects between the command(write)/status(read) register ($C2)and the Read/Write 'data' registers (the operand stack) ($C3).
- Yes it will work with other addons, I chose $c2 to be out of the way on the TEC1-F, 
- it will need to change for the TEC, by changing the connections P7 to P1, because of the TEC's bad IO decoding. I'm not sure what the best approach is here...
- Yes, one 688 per APU. The 688 compares the P inputs with the Q inputs, 
- when they are the same, the output goes low.
- P0 is compared against Q0 which connects to MREQ, 
- so actually the 688 output goes low when A7 to A1 = $C2 and MREQ is high. 
- This is really just a little 'redesign' of the RC2014 board.



## Ver 9 Craig Jones  
### 9511 GPU
You cannot use two i/o selects at the same time, C/D should connect to A0, what you need is a select, that is enabled for 2 addresses; a0=0 and a0=1. Look at the serial circuit I sent you, have a look at the 138 and see that I have connected a,b,c to a1,a2, and a3. This gives 8 CS lines each with two addresses, the 6850 has the same deal. The other way to do it is like the LCD on the DAT board, connect CD to a higher address like A7.

Got it to work. I'm just doing the basic integer add like John Hardy's example code and I get the right answer. The chips I have are all AM9511A-4DC (4MHz!) so I have been using them at that speed. The chip you sent me works intermittently at 4MHz, SO I am checking it at 2MHz, it may be good at a lower frequency. see markings. I used Phillip Steven's circuit, using "demand wait" mode of operating, reading the busy bit and allowing the pause output to WAIT the Z80. Need code to convert floating point to a number as an ascii string, and visa-versa, so we can see a meaningful result of the calculations. Have used Phillip Stevens Z80 conversion of the Lawrence Livermore Labs Floating Point Library from Herb Johnson, so now I can enter numbers via the terminal and use this library to do a Floating Point calculation and display the result on the terminal. Phillip also has code to use the APU, but it's a bit complicated so I will start with something simpler. 

## Ver 8 Craig Jones  

OK, I got the 6850 to work with the SC, there are two errors on your schematic which got transferred to the PCB. Firstly, you have an A5 net label on the A6 pin on the expansion socket so the board has A5 and A6 shorted together. Secondly, the RXCLK and TXCLK of the 6850 are connected to the net label CLK bar, but there is no CLK bar net, so those two pins are connected together but nowhere else, they should connect to CLK. Only two small errors so that's not too bad at all! For the decoding I connected A6 to M1. I don't think you actually have to have M1 connected unless you are doing IM2 interrupts and I connected PORT1 to A7 to decode the 6850 at `$40 and $41` for the CONTROL/STATUS and TDR/RDR registers respectively. I might do this on the TEC-1F as well. Now I'm going to try again to get it going on the TEC-1F before I have a go at the APU.

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/cg%201.jpg)
![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/cj-2.jpg)

I had to apply inverted A7 to the E3(G1) Pin 6 of the IO decoder of the TEC-1 using a transistor inverter. This mod disables the TEC-1 IO decoder above $80. Now A7 can be used to select the 6850 ACIA at $80. The Baud clock is coming from the 4MHz crystal, a great feature of the terminal program Teraterm is the ability to enter non standard Baud Rates. With a 4Mhz crystal the Baud rate is 62500. I was also able to use the RC oscillator as the Baud clock by downloading a program that just sent lower case 'a' out the 6850 serial port, I set Teraterm to 9600 and adjusted the RC oscillator to give a start bit of 104us as seen on the CRO.
 
If things fail try my serial board because it has the decoder for 8 x 2 IO addresses on board. use the extras to select the APU and your 6850. I don't need 2 6850s going! just add a single IO input line like I have shown with the 74hc125 and you can connect bit bang to the original TEC-1 up to the TEC-1D. Your system has a subroutine calls to get a serial character and receive a serial character, you add your own specific serial routines depending on the type of serial you have, 6850, bit bang, whatever. with the specific serial routines for the serial port available on each board.


![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/260717599_280462014046158_384653013632846250_n.jpg)

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/261002318_280462027379490_7516334454848220787_n.jpg)

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/263019317_280462017379491_3466954581733273683_n.jpg)

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/262870855_463720035302369_3813373904138282086_n.jpg)


### code
See what's around. The RC2014 code looks promising. I might even start with the JH code just to get it working. It's not going to matter if the code for either the serial is in RAM or ROM.  Also will be able to use bit bang serial or 6850 serial.

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/271732275_4710190225767426_3493303551305514214_n.jpg)


## Ver 7 sj

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/x1.jpg)

- https://easyeda.com/editor#id=8384393150b147a79c794b78886917d1|c5e3f76b1960488e92af095fc1e68dca
- 2 errors on 6850 cct now corrected (see below)
- update pcb files for fix..done
- last batch of pcbs had this error; easy to fix
![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/errata-1.png)

## Ver 6

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/tec-APUS-6.png)

## Ver 5

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/tec-APUS-5.png)

## Ver 4

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/tec-APUS-4.png)

## Ver 3

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/tec-APUS-3.png)

## Ver 2

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/tec-APUS-2.png)

## Ver 1

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/tec-APUS-1a.png)
![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/tec-APUS-1b.png)

## Ver 0.9
![fin-2](https://user-images.githubusercontent.com/58069246/171794676-d7530566-e6b8-4f0a-97ee-fc255f3c4004.png)
![fin-1](https://user-images.githubusercontent.com/58069246/171794668-1f3b8012-5cc5-4149-8588-dcf845952250.png)

## Ver 0.8
![IMG_4233](https://user-images.githubusercontent.com/58069246/171794788-c822c967-27e1-41ca-8b49-57c909bb38bd.jpg)

## Ver 0.7
![120720a](https://user-images.githubusercontent.com/58069246/171794754-10b2162e-6230-460b-b6b1-ebd805c65a23.png)

## 6850 code 
- Grant Searl solution. look at the loader in Searls msbasic rom. It sets up a sort of bios based on the 6850 serial io
- simple-echo.z80. it echoes back what you sent to it. set your RAM and ROM values. downloaded as intel hex or binary. load hex into into rom with burner (covets to binary) or bin to EMU.
- clocks speed determines baud rate, a &.3728 Mhz clk gives standard baud rates 4800, 9600... The code divides this down  `/64 = 115,200` baud or `/16 =  460,800` baud 
- but a standard clock is not required to operate such as 4Mhz. simply adjust the terminal speed to aquire the right baud rate with Tera-Term. 
- handles the control registers and with INT control, 
  - rx buffer sends a INT when the buffer is full. 


### 9511 code
- see CJ code, url ?
- https://github.com/z88dk/z88dk/tree/master/libsrc/_DEVELOPMENT/math/float/am9511
- https://easyeda.com/Little_Arc/MT3608


## IDE 
- ASM80 
- http://asm80.com runs generic but is a customizable emulator for CPU + memory + serial terminal. see config file. 
- https://manual.asm80.com/directives. 
- default compiles to bin to 64K size. 
- Reduce by using 
```
.binfrom 0000h
.binto 0130h
```

- OshonSoft IDE
- compile to .obj (binary) which (normally) is the same as .hex file
- to trim code length insert this
```
Define RAMEND = 4095
```


## EPROM emulator 
- you can use an EEPROM, fast to erase and reprogram but you can use a EMU form Ben
- https://github.com/SteveJustin1963/tec-EMU-BG 
- a https://github.com/OliviliK/STM32F103/wiki/F103CB piggy backs onto the EMU
- its default boots to tec-1 monitor or your uploaded your own code from pc then runs from 0000.
- when you upload your code it executes it right away, a system reset goes back to the monitor.
- The EMU board plugs into the ROM socket
- code is uploaded via USB cable from your pc. when inserted it will activate PnP and auto install drivers for the EMU. 
- there maybe extra steps to get it to work in win10, but win7 will work first go. 
- USB connections and ports must be healthy
- the micro usb connector on the EMU is VERY easy to break off, do not stress the joint.
- open a DOS box (C:\cmd) then load your code with Bens .bat file run. The bat file calls a python script to load all the code. 

## wiring
- the tec-APUS uses TTL serial not RS-232, use a usb to serial-TTL cable
- it has a TTL to USB bridging chip inside eg FT232R or PL2303TA and also emulates a virtual com port via a PnP driver load. 
- When the USB end goes into pc's USB, it will activate PnP and windows will auto install drivers and creates a virtual com port 
- run C:\mode to check for the com port number. 
- or convert TTL to real RS-232 levels with a converter chip ie MAX232, u can install it to the tecAPUS pcb 
- connect the TTL or rs232 lines of tx, rx, gnd lines to the tec-APUS and other end to usb or db9 or db25 pin port.
- On the USB to TTL cable, the TTL end presents 
```
Red=+5V
Black=GND
White=RXD
Green=TXD
```
- but RTS, CTS, DSR are not there on a cheap cables, from the chip inside the lines are not presented and are not needed for this project. 
- Some current limit resistors are a good idea on tx and rx lines but not needed. 
- do loopback test on the cable, short TX to RX (white-green), typing anything.. It should echo back at any baud speed.


## Terminal
Then run a terminal app to generate ascii text such as
- https://www.putty.org/    
- https://www.chiark.greenend.org.uk/~sgtatham/putty/
- tera term, best




## alternative parts
- CM603 Gold / Ceramic Pravetz ACIA Interface Adapter 1MHz IC MC6850P Motorola. about $12
 

## other io ports for the tec-1
- https://github.com/SteveJustin1963/tec-IO
- https://github.com/SteveJustin1963/tec-RELAY
- https://github.com/SteveJustin1963/tec-DAT
- https://github.com/SteveJustin1963/tec-EMU-BG
- https://github.com/SteveJustin1963/tec-SERIAL-BG
- https://github.com/SteveJustin1963/tec-SIO-BC
- https://github.com/SteveJustin1963/tec-BIT-BANG and the CJ port mod
- https://github.com/SteveJustin1963/tec-SERIAL-LOAD
- serial in https://github.com/SteveJustin1963/tec-Southern-Cross-Computer
- https://www.facebook.com/groups/623556744820045/posts/1139514603224254/




## Ref
- http://www.andreadrian.de/oldcpu/Z80_number_cruncher.html
- http://www.cpushack.com/2010/09/23/arithmetic-processors-then-and-now/
- https://archive.is/2015.07.14-173053/http://sgate.emt.bme.hu/patai/publications/z80guide/part4.html
- https://en.wikipedia.org/wiki/Instructions_per_second
- https://feilipu.me/2017/02/22/characterising-am9511a-1-apu/
- https://github.com/crsjones/Southern-Cross-Computer-z80/tree/main/ExpansionBoards/SC-APU
- https://github.com/crsjones/Southern-Cross-Computer-z80/tree/main/ExpansionBoards/SC-Serial
- https://github.com/feilipu/yaz180
- https://github.com/jhlagado/firth
- https://github.com/RC2014Z80/RC2014/tree/master/Hardware/APU%20RC2014
- https://github.com/SteveJustin1963/tec-MINT
- https://github.com/SteveJustin1963/z88dk/tree/master/libsrc/_DEVELOPMENT/target/yaz180/device/am9511a
- https://github.com/yesco/ALForth
- https://github.com/z88dk/z88dk/tree/master/libsrc/_DEVELOPMENT/target/yaz180/device/am9511a
- https://retrocomputing.stackexchange.com/questions/6835/why-did-ti-8x-calculator-series-use-the-z80-processor
- https://sourceforge.net/projects/realterm/files/Realterm/2.0.0.70/
- https://www.tindie.com/products/semachthemonkey/rc2014-am9511a-apu-arithmetic-processor/
 

