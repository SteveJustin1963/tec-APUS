
## tec-APUS

this ver7 add-on hack is to get Serial port MC6850 and Maths chip AM9511 on one pcb plugin to exploit Forth or MINT. 
- https://github.com/SteveJustin1963/tec-MINT
- https://github.com/jhlagado/firth
- https://github.com/yesco/ALForth

### Circuit
https://easyeda.com/editor#id=8384393150b147a79c794b78886917d1|c5e3f76b1960488e92af095fc1e68dca

error corrected in cct, more work needs to be done done in io decode.


this circuit was hacked together from
- https://www.tindie.com/products/semachthemonkey/rc2014-am9511a-apu-arithmetic-processor/
- https://github.com/RC2014Z80/RC2014/tree/master/Hardware/APU%20RC2014
- https://github.com/crsjones/Southern-Cross-Computer-z80/tree/main/ExpansionBoards/SC-Serial



MC6850 needs a baud clock eg 7.3728 Mhz or slower. the code divides this down eg /64 = 115,200 baud or /16 =  460,800 baud and also handles control registers  with INT control eg rx buffer > INT.

AM9511 setup the control registers then send maths commands or data; it executes and the result is placed on its internals stack, then it signals via INT.
the select line P1 is active low, driven by eg port 6 (h3000,3001) or 7 (h3800,3801), the A0 controls Command/Data registers.
its also needs a slower clock just over 1Mh so with drive direct with /M1 which is arount 2T states or just use the onboard flip flops /3; better. Or use a slower baud clock and run it direct; mod needed.


### AM9511 code
- 9511.asm, still a work in progress.
check and adjust code constants, will depend on RAM and ROM/EPROM space

### MC6850 code
- mycomputer.emu
- simple-echo.z80
check and adjust code constants, will depend on RAM and ROM/EPROM space

download the .bin then uploaded to EMU or burn rom with intel hex file

### asm80.com
reduce code size  
- .binfrom 0000h
- .binto 0130h

### OshonSoft IDE
trim code length insert "Define RAMEND = 4095".
compile to .obj (binary) which = .hex file


### EPROM emulation
Bens https://github.com/SteveJustin1963/tec-EMU-BG has the monitor code and or your own uploaded code. when you upload it executes it right away, a system reset goes back to the mon.
The EMU board goes in the ROM socket, code is uploaded via USB cable from the pc. When the USB end goes into pc, it will activate PnP and windows will auto install drivers for EMU. load code with Bens .bat file run in DOS, it calls a python script to load the code. run C:\cmd for dos.

### Cable
You also need a special USB to TTL cable; it has a TTL to USB bridging chip inside eg FT232R or PL2303TA and emulates a virtual com port. When the USB end goes into pc's USB, it will activate PnP and windows will auto install drivers and create a virtual com port. run C:\mode to check com port. Or use a TTL to RS-232 converter such the MAX232 chip on pcb. Then connect to TTL on tec-APUS and run a com cable to the db9 com port on the pc. Newer pcs and laptops don't have db9 com ports.

### Terminal
Then run a terminal app to generate ascii text such as
- https://www.putty.org/    
- https://www.chiark.greenend.org.uk/~sgtatham/putty/

On the USB to TTL cable, the TTL end presents Red=+5V, Black=GND, White=RXD, Green=TXD, but RTS, CTS, DSR are not there on a cheap cables, from the chip inside the lines are not presented and are not needed for the PCB. Some current limit resistors are on the tx and rx lines for protection. You can do loopback test on the cable, so short out TX to RX (white green), typing anything.. It should echo back.

## error on pcb
 
![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/errata-1.png)
- 2 errors on 6850
- pcb files updated for fix
- decoding not working properly see below

## Craig Jones

OK, I got the 6850 to work with the SC, 
- there are two errors on your schematic which got transferred to the PCB,  
- Firstly, you have an A5 net label on the A6 pin on the expansion socket so the board has A5 and A6 shorted together. 
- Secondly, the RXCLK and TXCLK of the 6850 are connected to the net label CLK bar, but there is no CLK bar net, so those two pins are connected together but nowhere else, they should connect to CLK.
-  Only two small errors so that's not too bad at all!

### decoding
- For the decoding I connected A6 to M1 
- I don't think you actually have to have M1 connected unless you are doing IM2 interrupts
- and I connected PORT1 to A7 to decode the 6850 at $40 and $41 for the CONTROL/STATUS and TDR/RDR registers respectively, 
- I might do this on the TEC-1F as well.

Now I'm going to try again to get it going on the TEC-1F before I have a go at the APU.

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/cg%201.jpg)
![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/cj-2.jpg)

- I had to apply inverted A7 to the E3(G1) Pin 6 of the IO decoder of the TEC-1 using a transistor inverter. 
- This mod disables the TEC-1 IO decoder above $80. 
- Now A7 can be used to select the  6850 ACIA at $80.
- The Baud clock is coming from the 4MHz crystal, 
- a great feature of the terminal program Teraterm is the ability to enter non standard Baud Rates. With a 4Mhz crystal the Baud rate is 62500.
- I was also able to use the RC oscillator as the Baud clock by downloading a program that just sent lower case 'a' out the 6850 serial port, 
- I set Teraterm to 9600 and adjusted the RC oscillator to give a start bit of 104us as seen on the CRO. 
- if thigs fail try my serial board because it has the decoder for 8 x 2 IO addresses on board. 
- use the extras to select the APU and your 6850. I don't need 2 6850s going!
- just add a single IO input line like I have shown with the 74hc125 
- and you can connect bit bang to the original TEC-1 up to the TEC-1D
- your system has a subroutine calls to get a serial character and receive a serial character, 
- you add your own specific serial routines depending on the type of serial you have, 6850, bit bang, whatever. 
- with the specific serial routines for the serial port available on each board.


![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/260717599_280462014046158_384653013632846250_n.jpg)

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/261002318_280462027379490_7516334454848220787_n.jpg)

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/263019317_280462017379491_3466954581733273683_n.jpg)

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/262870855_463720035302369_3813373904138282086_n.jpg)


### code
- to see what's around. 
- The RC2014 code looks promising. I might even start with the JH code just to get it working. 
- It's not going to matter if the code for either the serial is in RAM or ROM. 
- also will be able to use bit bang serial or 6850 serial.

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/271732275_4710190225767426_3493303551305514214_n.jpg)

### 9511 gpu
- You cannot use two i/o selects at the same time, 
-C/D should connect to A0, 
- what you need is a select that is enabled for 2 addresses; a0=0 and a0=1. 
- look at the serial circuit I sent you, 
- have a look at the 138 and see that I have connected a,b,c to a1,a2, and a3. 
- this gives 8 cs lines each with two addresses, the 6850 has the same deal.
- The other way to do it is like the LCD on the DAT board, connect CD to a higher address like A7.
#### working
- got it to work
- I'm just doing the basic integer add like John Hardy's example code and I get the right answer.
- The chips I have are all AM9511A-4DC (4MHz!) so I have been using them at that speed. 
- The chip you sent me works intermittently at 4MHz, SO I am checking it at 2MHz, it may be good at a lower frequency. see markings.
- I used Phillip Steven's circuit, using "demand wait" mode of operating 
- reading the busy bit and allowing the pause output to WAIT the z80.
- need code to convert floating point to a number as an ascii string, and vica-versa 
- so we can see a meaningful result of the calculations.
- have used Phillip Stevens Z80 conversion of the Lawrence Livermore Labs Floating Point Library from Herb Johnson, 
- so now I can enter numbers via the terminal and use this library to do a Floating Point calculation and display the result on the terminal.
- Phillip also has code to use the APU, but it's a bit complicated so I will start with something simpler. 
- https://github.com/feilipu/LLL-Floating-Point

## iterate
- try proper decoding cct, eg 74HC688 (eg in the APU-RC2014 board), a 8 bit comparator as IO address decoder
- can be decoded anywhere in the bottom 256 I/O addresses. 74HCT688 compares two 8-bit inputs and outputs an active low if both sets match. Enable is active low eg use MREQ to drive this. set inputs to address lines and to VCC, via a DIP switch dial in address you want your io peripheral to enabled on.
- note interrupt modes of IOReq and M1 will be low at the same for an interrupt acknowledge, consider this when selecting io
- there is a limit to the number of devices that the Z80 can drive, some systems need buffered address and data lines, not problem with CMOS processors which we all should be using.
- put A0-A7 on the 'P' side, pullup or pull down the inputs on the 'Q' side, 
- when they both match the one output goes low - decoding 1 address in 256.
- Leave off A0 and you decode 2 consecutive addresses in 256, and so on.


