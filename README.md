
## tec-APUS

this add on os to support Serial + Maths + Forth or othe code
example
- https://github.com/jhlagado/firth  
- https://github.com/monsonite/MINT 
- https://github.com/yesco/ALForth

## circuit
https://easyeda.com/editor#id=8384393150b147a79c794b78886917d1|c5e3f76b1960488e92af095fc1e68dca

The pcb can be reconfigured to attach in different ways, at moment thru expansion port.

the 2 parts, both chips need port select linked

MC6850 needs a baud clock, am using 7.3728 Mhz. the code divids this down eg /64 = 115,200 baud or /16 =  460,800 baud and also handles control registers  with INT control eg rx buffer > INT.

the AM9511 setup the control registers then send maths commands or data; it executes and the result is placed on its internals stack, then it signals via NMI or INT call per jumper setting

## code
- mycomputer.emu
- simple-echo.z80

download the .bin then uploaded to EMU or burn rom with intel hex file 

## asm80.com
reduce code size  
- .binfrom 0000h 
- .binto 0130h
##  OshonSoft IDE
trim code length insert "Define RAMEND = 4095".
compile to .obj (binary) which = .hex file 

check and adjust code constants, will depend on RAM and ROM/EPROM space

EPROM emulation with Bens' https://github.com/SteveJustin1963/tec-EMU-BG the monitor and ROM space is emulated side by side


, as OR. When system is reset it reverts back. 
The EMU board goes in the ROM socket, code is uploaded via USB cable from the pc. When the USB end goes into pc, it will activate PnP and windows will auto install drivers for EMU that Bens app is a .bat DOS file when runs calls a python script to load the code. run C:\cmd and C:\mode.

You also need a special USB to TTL cable; it has a TTL to USB bridging chip ie the FT232R or PL2303TA and emulates a virtual com port. When the USB end goes into pc, It will activate PnP and windows will auto install drivers and create a virtual com port. Or use a TTL to RS-232 converter such the MAX232 chip on pcb. Then connect to TTL on tec-APUS and run a com cable to the com port on the pc. Bugt newer pcs and laptops don't always have com ports.
Then run a terminal app to generate ascii text such as 
- https://www.putty.org/    
- https://www.chiark.greenend.org.uk/~sgtatham/putty/ 

On the USB to TTL cable, the TTL end presents Red=+5V, Black=GND, White=RXD, Green=TXD, but RTS, CTS, DSR are not there on a cheap cables, from the chip inside the lines are not presented and are not needed for the PCB. Some current limit resistors are on the tx and rx lines for protection. You can do loopback test on the cable, so short out TX to RX (white green), typing anything.. It should echo back.

## AM9511
The AM9511 is active low enabled and port selected simultaneously on /CS (chip select) with A7,A3,IORQ and A0 toggling C/D (Command/Data) for write or read to IO ports 84, 85. The 9511 needs a really slow clock so rather than use a divide down we can use M1 as a psudo clock.

The test code is 
- 9511.asm, still a work in progress.

## Firth of Forth
Firth still wont fit in a 4k ROM mod (https://github.com/SteveJustin1963/tec-4krom-12kram-mod) but is not far off. 

## Journal
- Wiki in https://github.com/SteveJustin1963/tec-APUS/wiki
- Docs in https://github.com/SteveJustin1963/tec-BOOKS/tree/master/tec-APUS






