
## tec-APUS

this ver7 add-on hack is to get Serial port MC6850 and Maths chip AM9511 on one pcb plugin to exploit forth or mint 

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/255080535_3114837952082902_9094347087018948754_n.jpg)

- https://github.com/jhlagado/firth  
- https://github.com/monsonite/MINT
- https://github.com/yesco/ALForth

### circuit
https://easyeda.com/editor#id=8384393150b147a79c794b78886917d1|c5e3f76b1960488e92af095fc1e68dca

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

## Testing

2 errors on 6850
![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/errata-1.png)

from CJ;
OK, I got the 6850 to work with the SC, there are two errors on your schematic which got transferred to the PCB,  Firstly, you have an A5 net label on the A6 pin on the expansion socket so the board has A5 and A6 shorted together. Secondly, the RXCLK and TXCLK of the 6850 are connected to the net label CLK bar, but there is no CLK bar net, so those two pins are connected together but nowhere else, they should connect to CLK. 
Only two small errors so that's not too bad at all!

For the decoding I connected A6 to M1 ( I don't think you actually have to have M1 connected unless you are doing IM2 interrupts) and I connected PORT1 to A7 to decode the 6850 at $40 and $41 for the CONTROL/STATUS and TDR/RDR registers respectively, I might do this on the TEC-1F as well.

Now I'm going to try again to get it going on the TEC-1F before I have a go at the APU.


![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/cg%201.jpg)
![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/cj-2.jpg)

### Forth
- JH's Firth https://github.com/jhlagado/firth is just over 4k ROM, with some hacking maybe can get it under 4k
- TEC-1 mod for 4k (https://github.com/SteveJustin1963/tec-4krom-12kram-mod), or use Grant Searls Z80 system.
- JH's Zedforth https://github.com/jhlagado/zedforth is working wip, maybe 2k target, not sure
- or MINT will fit in 1k ROM


### Journal
retired docs
- Wiki in https://github.com/SteveJustin1963/tec-APUS/wiki
- Docs in https://github.com/SteveJustin1963/tec-BOOKS/tree/master/tec-APUS



