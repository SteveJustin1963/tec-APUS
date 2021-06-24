
## tec-APUS, serial + maths, with Forth in mind. 

This addon has 2 parts, async serial using the MC6850, amx rate of 1.0 Mbps.
We only need a fraction of that, with a clock of 7.3728 Mhz, which is a special baud rated freq, then dividing down with reg setting divisor;  /64 = 115,200 baud or /16 =  460,800 baud. We set up the control registers then can tx and rx, with INT control as needed.

Second part adds a maths calculator using the AM9511. We setup control registers send maths commands and data, it executes with result on stack, then calls back on INT.

The circuit is WIP still;  https://easyeda.com/editor#id=f38afcc535a449c0b98ccadf3163fde4
The pcb can be connect 2 ways expansion socket with ribbon or a 2x22 socket.

## MC6850
The MC6850 circuit is similar to Grant Searl’s; https://github.com/jhlagado/firth, we use /M1, A7,A1,A0  for IO ports 82, 83.

The test code is 
-mycomputer.emu
-simple-echo.z80
You can compile it in asm80.com

echo.asm; to get an echo back from buffer and a message out from buffer
pcb is plugged into the expansion socket, jumper cable is attached also.
emu board is in rom socket, code is uploaded to emu via another usb cable.

run terminal app on pc https://www.putty.org/    https://www.chiark.greenend.org.uk/~sgtatham/putty/ .
connect USB-TTL cable from pc-usb to RX TX and GND on tec-apus.
there is a FT232R or PL2303TA chip inside cable moulding it converts usb to ttl serial, another chips would be needed to turn it to rs232 voltages which are mch higher but needed here as ttl 5v will do. a driver will auto load in windows activated by pnp that will present a virtual serial port to the pc end. the cable end has Red=+5V, Black=GND, White=RXD, Green=TXD, but RTS, CTS, DSR are presented on the cheap cable i used. for safety current limit resistors can be added but for ttl-ttl they are not needed. 
plug cable into pc usb then pnp auto loads drivers, eg message appears COM11. can also check port number on pc, run C:\cmd then C:\mode
do loopback test on cable, short TX to RX (white green), typing anything.. character should echo back

compiled the test program https://github.com/jhlagado/echo-Z80 with SERIALMODE equ 6850.
compile creates .lst and .hex file, its intel format, http://www.keil.com/support/docs/1584/ 
- need .bin file, select Download BIN, then file "main.z80.bin" downloads to pc, must white list the site asm80.com
- powerup EMU

## AM9511

## Journal
https://github.com/SteveJustin1963/tec-APUS/wiki


