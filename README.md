
## tec-APUS

Serial + Maths+ Firth of Forth in mind. 

The circuit is still work in progress at   https://easyeda.com/editor#id=f38afcc535a449c0b98ccadf3163fde4
The pcb can be connected 2 ways; the expansion socket with ribbon or a 2x22 socket.

This addon has 2 parts, async serial using the MC6850, amx rate of 1.0 Mbps.
We only need a fraction of that, with a clock of 7.3728 Mhz, which is a special baud rated freq, then by dividing down with reg settings divisor; ie /64 = 115,200 baud or /16 =  460,800 baud. We set up the control registers and then can tx and rx, with INT control as needed, ie rx buffer > INT.

The second part adds a maths calculator using the AM9511. We setup the control registers then send maths commands or data; it executes and the result is placed on its internals stack, then it  signals with an INT call.

## MC6850
The MC6850 is active high enabled on E with /IORQ inverted to IORQ high and write or read to IO ports 82, 83 with M1, A7,A1,A0.

The test code is
- mycomputer.emu
- simple-echo.z80

Using asm80.com IDE the default binary file size is 64k, way to large. Trim with
- .binfrom 0000h 
- .binto 0130h

Using OshonSoft IDE, assembler will trim to code length, if using basic to make asm, then insert eg 
- Define RAMEND = 4095

Also code constants will depend if it runs in RAM or ROM space. ROM can be EPROM or emulated  ie with Bens' https://github.com/SteveJustin1963/tec-EMU-BG the monitor and ROM space is emulated side by side, as OR. When system is reset it reverts back. 
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






