
## tec-APUS

this addon hack is for Serial port MC6850 and Maths chip AM9511

- https://github.com/jhlagado/firth  
- https://github.com/monsonite/MINT 
- https://github.com/yesco/ALForth

### circuit
https://easyeda.com/editor#id=8384393150b147a79c794b78886917d1|c5e3f76b1960488e92af095fc1e68dca

this circuit was hacked together from
- https://www.tindie.com/products/semachthemonkey/rc2014-am9511a-apu-arithmetic-processor/
- https://github.com/RC2014Z80/RC2014/tree/master/Hardware/APU%20RC2014
- https://github.com/crsjones/Southern-Cross-Computer-z80/tree/main/ExpansionBoards/SC-Serial


MC6850 needs a baud clock, am using 7.3728 Mhz. the code divids this down eg /64 = 115,200 baud or /16 =  460,800 baud and also handles control registers  with INT control eg rx buffer > INT.

AM9511 setup the control registers then send maths commands or data; it executes and the result is placed on its internals stack, then it signals via NMI or INT call per jumper setting. 
the select line is active low, drive it with a free ram select say 6 (h3000,3001)  and 7 (h3800,3801), the A0 controls Command/Data registers. 
its alos needs a slow clock soam trying RC slowed /M1 its more than 2 T states or if that fails will use a pair of flip flops to /3.


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
You also need a special USB to TTL cable; it has a TTL to USB bridging chip inside eg FT232R or PL2303TA and emulates a virtual com port. When the USB end goes into pc's USB, it will activate PnP and windows will auto install drivers and create a virtual com port. run C:\mode to check com port. Or use a TTL to RS-232 converter such the MAX232 chip on pcb. Then connect to TTL on tec-APUS and run a com cable to the db9 com port on the pc. Newer pcs and laptops dont have db9 com ports.

### Terminal
Then run a terminal app to generate ascii text such as 
- https://www.putty.org/    
- https://www.chiark.greenend.org.uk/~sgtatham/putty/ 

On the USB to TTL cable, the TTL end presents Red=+5V, Black=GND, White=RXD, Green=TXD, but RTS, CTS, DSR are not there on a cheap cables, from the chip inside the lines are not presented and are not needed for the PCB. Some current limit resistors are on the tx and rx lines for protection. You can do loopback test on the cable, so short out TX to RX (white green), typing anything.. It should echo back.

### Forth
Firth still wont fit in a 4k ROM mod (https://github.com/SteveJustin1963/tec-4krom-12kram-mod) but is not far off. John H os working on another
but MINT will fit in 1k !


### Journal
- Wiki in https://github.com/SteveJustin1963/tec-APUS/wiki
- Docs in https://github.com/SteveJustin1963/tec-BOOKS/tree/master/tec-APUS




