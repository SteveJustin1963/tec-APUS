
## tec-APUS, serial + maths, with Forth in mind. 
cct so far, work in progress

https://easyeda.com/editor#id=f38afcc535a449c0b98ccadf3163fde4

one part is serial using the MC6850 chip that can do up to 1.0 Mbps serial transmission, 
we only need a fraction of that, with a 7.3728 Mhz baud rate crystal and setting the divisor in software to /64, results in 115,200 baud rate 
or with /16 we get 460,800 baud. the other part uses the AM9511 maths chip. we send commmands and data and it executes the result and places on its internal stack to be read out. 

## todo 
* motherboard
  * cascade another 74138 for low order io
  * check io map, account for current used io's, allocate new io's for tec-apus etc
  * address and select line for 4k rom not 2k, try to fit forth, adjust ram select
* 9511; divide clock 6 for 9511, 7.3728/6 = 1.2288, oe use /m1 as slow clock



## MC6850
looking at Grant Searl cct https://github.com/jhlagado/firth for for MC6850 circuit uses /M1, A7,A6,A0 and /WR with /INT.
we know "the /M1 signal goes low only on instruction fetch cycles and interupt acknowledge cycles, it does not go low on I/O and memory read/write cycles that follows the instructions." so when we /WR to the chip /M1 will be high and that actives CS0 on. we can leave A7 active high to get to 80h range, then split this down to 82 and 83 with active low A1 and active high A0 to control the register select. to tx we select and send, when rx arrives the /irq drives /int to the z80 and we service the request.

we want to get an echo back from buffer and a message out from buffer. code is compile from .org 0000
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
