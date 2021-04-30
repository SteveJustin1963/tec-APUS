# draft doc

# tec-APUS



![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/mc6850.png) 
SERIAL
![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/am9511%20logo.png)

The TEC-1 has existing IO options like 
* https://github.com/SteveJustin1963/tec-IO
* https://github.com/SteveJustin1963/tec-RELAY
* https://github.com/SteveJustin1963/tec-DAT
* https://github.com/SteveJustin1963/tec-SERIAL-BG 
* https://github.com/SteveJustin1963/tec-SIO-BC

## tec-APUS, serial + maths, with Forth in mind. 
goal to run two separate systems on one pcb. 
the serial part uses a 6850 chip that can do up to 1.0 Mbps serial transmission, 
we only need a fraction of that, with a baud rated 7.3728 Mhz crystal and setting the divisor in software to /64 in results in 115,200 baud 
or /16 to 460,800 baud. 
running this high clock rate wont work with the 9511 unless we divide down or drop down to a slower crystal say 3.6864 Mhz /64 = 57600 baud or lower. 
to test serial works either echo to a buffer or write out to TX from .db. 
later integrate into apps and forth. 

the AM9511 math chip was added with Forth in mind, 
it can do 32 bit floating point operations and transcendental function, eg sin(x), sqrt(x). 
its speed is questionable.

the 6850 circuit comes form grant searl, see https://github.com/jhlagado/firth 

looking at the input control lines we have, /M1, A7,6,0 and /WR, for output control is /INT

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/chip%20select%206850.png)




the 9511 circuit come from doc folder 


the two systems together result is https://easyeda.com/editor#id=f38afcc535a449c0b98ccadf3163fde4

image



## 6850
we want to get an echo back from buffer and a message out from buffer. code is compile from .org 0000
pcb is plugged into the expansion socket, jumper cable is attached also.
emu board is in rom socket, code is uploaded to emu via another usb cable.

run terminal app on pc https://www.putty.org/    https://www.chiark.greenend.org.uk/~sgtatham/putty/ .
connect USB-TTL cable from pc-usb to RX TX and GND on tec-apus.
there is a FT232R or PL2303TA chip inside cable moulding it converts usb to ttl serial, another chips would be needed to turn it to rs232 voltages which are mch higher but needed here as ttl 5v will do. a driver will auto load in windows activated by pnp that will present a virtual serial port to the pc end. the cable end has Red=+5V, Black=GND, White=RXD, Green=TXD, but RTS, CTS, DSR are presented on the cheap cable i used. for safety current limit resistors can be added but for ttl-ttl they are not needed. 
plug cable into pc usb then pnp auto loads drivers, message COMxx appears, eg COM11. can also check port number on pc, run C:\cmd then C:\mode
do loopback test on cable, short TX to RX (white green), typing anything.. character should echo back

compiled thr test program https://github.com/jhlagado/echo-Z80 with SERIALMODE equ 6850.
compile creates .lst and .hex file, its intel format, http://www.keil.com/support/docs/1584/ 
- need .bin file, select Download BIN, then file "main.z80.bin" downloads to pc, must white list the site asm80.com
- powerup EMU

![](https://github.com/SteveJustin1963/tec-EMU-BG/blob/master/pics/load-drive.png)

- load driver for emu then transfer ECHO file..pass
- i place EMU board into RAM...oops, needs to go into ROM socket unless i don’t need RAM
  - "eprom socket is 0000-07FF, 
  - RAM is 800-0FFF, 
  - expansion socket is 1000-17FF, 
- you still need RAM, EMU only emulates eprom, 
- if EMU is in eprom socket, it will place your code from 0000, when you code in the assembler, you'll usually want to tell it where your code is originating. Default to MON1B/2 ROMS internally, and with reset line to EMU, after code loads it'll restart and load the new ROM image" (BG)
- reboot, load echo, run putty 9600, shows nothing 
- "It should print out "Echo 2020", not convinced the ACIA is working yet. use logic probe/oscilloscope, should see bits on the line. code does the right thing in emulator-simplified scenario. could write simpler program just wrote output some characters. too many variables. guess 6850 is good." (JH) 
- I press reset on the TEC-1, nothing ? hung code ? "It should do nothing. It doesn't have a monitor. We can add code to display stuff but the idea is to be really simple. One possible issue is the RAM_SIZE was set too big. Unless you changed it, it was set to 64K - ROM_SIZE. It should have been much lower like 2K. This is an issue because the stack pointer is set to the end of RAM, i.e that would be a crash. Set it for a 2K ROM and 2K RAM. i.e.  
  * ROM_SIZE        equ     $800
  * RAM_SIZE        equ     $800      

* [I would have seen a problem if I had set the emulation file correctly to reflect the memory map of the TEC-1. For emulation in asm.80, the mycomputer.emu file should have the lines 
  * memory.rom.from 0x0000
  * memory.rom.to     0x7FF
  * memory.ram.from 0x800
  * memory.ram.to     0x1000

* [This may not solve the problem but it's one source of bugs. Also I created another file in the same folder. It does one thing: prints "Hello World!" over and over. simple.z80
  * left:   main.z80
  * right: hello.z80" 

* Is the breadboard reliable? It has loose connections, inserting wires disturbes previous connections. If pin ends if different thickness it splays clamp to different width, causing thinner pins to be intermittent
* making veroboard version

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/IMG_4233.jpg)
 
* In GS design, CTS is GND, I am not using MAX232 but direct USB-TTL cable, output from 6850 RTS is floating. need to pull? 

http://www.summitdata.com/blog/uart-flow-control-rtscts-necessary-proper-operation-wireless-modules/

* says; "throughput that is lower than the throughput of the UART (baud rate, parity, and stop bits) setting or the risk of potential data loss or module reset is accepted by the developer, then the CTS input line can be pulled to 0v/Gnd [GS design] and RTS output line allowed to float ".. ok leave floating.

* retest same code, same result, no output.

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/143650.png)

* trying hello.z80
* C:\Users\steve>"C:\Users\steve\Documents\Talking Electronics\tec-EMU-BG\rar-file
s\z80upload.exe" "C:\Users\steve\Documents\Talking Electronics\tec-APUS\echo\hel
lo.z80.bin"

* Got error, USB Hardware not found…
* Ask BG; I don't know why the driver for emu wont load, I reload driver, says uptodate, but error says not working, Windows has stopped this device because it has reported problems. (Code 43) [BG What windows version? ] 7 64 bit, worked yesterday and this morning [What's it say in device manager? Did you change the firmware file at all? Yes you changed the firmware?] is that the driver for emu? [The firmware file I uploaded. If you didn't download it then that's not the issue] nope, I didn't, emu boots 0900 and 0800 [Same USB port? Usb2.0? ] yes [And the cable is fine / USB socket not torn off?] still sitting on bench, no mechanical stress [Perhaps unplug it from the PCB? Very unusual. The CPU is running so it must be the USB port or cable] ill uninstall and redoit, it just can't see hw. I noticed at some stage it would not reboot, I had to cycle the pc psu
[If it's not in device manager, the software won't talk to it. Try on another PC? You could also probe resistance from the USB cable to the maple board] ok trying [Oh dual power?, Power the emu first] power only coming into emu, try https://freeusbanalyzer.com/ or  http://www.sysnucleus.com/ disconnect usb hub and put emu direct to pc usb, it works! see usb message diver load ok. wtf. put hub back in, and it still works. omg. flaky. skip usb trace, trying hello.z80 again...fail

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/314953.png)

remove hub, same problem, put back in, power up emu, no boot, soft click in speaker, blue light flash then off on emu, no rom load, all leds off, pull all out, replace emu with standard rom, and standard power, 12v...pass, pull rom, put emu back with no connections, no usb, and standard power, 12v...pass..boots 0800, pull emu out, sit on bench and connect usb to pc, see if driver loads...nope.. not sure this is right.. ignore, put emu back with usb... "usb not recognised"..fail..don't trust anymore..BG to test..send back ? this is the microcontroller on the EMU, later hack in to see what's going on..

![](https://github.com/SteveJustin1963/tec-EMU-BG/blob/master/pics/IMG_4236.jpg)

see https://github.com/OliviliK/STM32F103/wiki/F103CB

pull all out, replace emu with standard rom, and standard power, 12v...fail !!!! omg.. something else, buzz out usb sock...pass, power up 12v, now works. wtf. ic sockets and push in wires fall out, rewire breadboard, at least it's spring clamps the wire tip

ask [BG]; I cant get my standard rom to boot, I think i've cooked something. if I pull the rom aram clock runs4mz, put back in clock is 2.00538. Do you have a diagnostic I can run on the emu to see if it's ok ? If you are willing [do you have an EPROM? Rom should have no effect on the clock. How's your 5v looking? ] yes got 5v, changed another rom, ram and z80, all no effect, must have burnt something out. with them clock drops to half weird. [What are you measuring with] the clock ? [Yeah]
oh, right, my cro has clock measure built in, set trig so smooth and then it gives value [And you're sure it's halving? Confirmed visually? Via waveform]

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/89837910_604757340079419_6422182843006320640_n.png)

[That's my clock board?] pin 6 z80 [But using my oscillator? Or TEC original] ur 4mg xtl [And without the CPU?] pull cpu out ? [Yeah] 3.99977mhz [Very odd! And your TEC is dead?] yep, no go with orig rom and no go emu [What's on the 7seg?] blank, hit rest, no 0800 or 0900, with cpu in of cors , I thought I cooked the emu, but after try orig rom, weird [Best guess KB IC or address decoder , KB has the clk going to it] which pin ? [ Not sure, in bed. Should be in the schematics? Or maybe not... I remember cap pads for low and high speed clks] pin 5 6 has caps, 7 is bounce mask [Ok It's confusing why the clock is halving, Unless....An address line is shorted. Is the clk still a square wave?] yes with cpu out or in- is square, 5 p-p [Sooooo weird! A xtal doesn't usually just change its freq. Either way, it's not the issue] ok so buzz out the address lines ? i'll pull the ram and rom and put in my NOP chip with the cpu [Sounds like a plan. With NOPs you should see freq /2 4,8 etc, Check RST, NMI, int, halt]

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/89913630_1425447987631079_9043715582087659520_n.png)

[Should all be high .Nice!] omg...the clock wire I soldered to the back to take to the 6850; its insulation was impaled by another pin from the z80, I removed the spike thru and glued the wire not moved around, and the clock jumped up to 4mhz!! the nop shows freq doubling. seems good [thumbs up] new day.. mornin, it boots rom from emu but it wont register in device manager. I cycle the connection to the usb [ via a usb extender- I don't touch the emu end] in and out and watch device mgr, it appeared only once in 50 tries and no more. [have you probed continuity between the middle two pins of the usb cable end, and the pins labeled DP and DM? ] not yet, i'll try [and have you added any wiring to your tec which could affect the eprom socket?] all wires stripped off, its vanilla [ok] buzz the line in usb... all ok. I eliminated the usb hub so direct usb cable to pc. got this.. 

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/89789539_1132245403805066_3364674021021974528_n.png) 

then tried upload got this...

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/89487915_543395129938896_6445054823757774848_n.png)
 
going to work now so have to leave it here. as always BIG thankyou for ur help!! later....[It's On a usb2 port, not 3?] yes

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/90432001_624784698078698_1472059470442921984_n.png)

no usb 3 in this motherboard [it could  have been damaged, or the usb port is broken, or cable is bad, either way, send it back and I'll take a look, or if you can desolder that mcu board, I can send another programmed board] {thanks} so usb 1.1 no good, must be 2.0 and never 3.0, just now driver selfloaded ok, then I tried send file said ok. JH code took over, then reboot TEC-1 by psu cycle, but now cant repeat it, weird, now this

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/89837914_637419460374686_4924841966698496000_n.png)

[have you tried another usb cable?] not yet. do that now, just took out external hub [ok] can't find another so instead I uninstall "unknown driver" reinstall per ur .rar, then reboot and look

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/89734863_210309730063959_5004646303053905920_n.png)

if I do one upload it will work then kill the driver off, here goes, nope failed 

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/89692128_198631294752868_507530491457437696_n.png)

[I'd suggest swap cables as a good first step, data cable, not charge cable! no data lines on a charge cable] ok.. all 4 pins active. found one in junk box, near new. trying...look mum

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/89789089_143927083603501_6027488954960314368_n.png)

[happy face, throw that other one away!] acid test see if repeatable, ok, 5 times both usb ports on pc. 

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/89721962_219255152463685_5231738086035030016_n.png)
...now fixed [BG back on track!] Finally, lol, thanks for your help. 

===
* Ques, any ideas to check if 6850 chip I got is real or fake ? that's the other issue working up to testing then wasting time on a fake 
* [BG clean it with acetone / nail polish remover, if it all comes off, then its fake, or at least re-branded.
* [Is your xtal a baud freq?] not sure, my clock 4mhz goes into 6850 direct, JH said his code not dependant on clock, I ques thats weird. putty set to 9600, so maybe his code auto bauds, no idea 
* [that chip im 99% sure needs a baud Z80 clock, ill look, his design must use the baud xtal...first hit was how to implement it in FPGA, clock must be 1,16 or 64 times the baud freq, so 4mhz will not work, or at least the freq will be so far out of whack the pc wont know whats going on] . GS circuit shows 

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/89767375_482465632631749_5902936123147026432_n.png)

* [yup, thats a baud xtal, 11.059mhz, 1.384mhz, my serial board comes with a 1.384mhz xtal for that exact reason, ] 
* what should I do considering my TEC1 runs your 4Mhz board. 
* [John’s stuff works on a simulator because its simulated, use my serial board 🙂, or drop in a baud xtal].

* I ordered your serial board, pls send when you can, but GS design freq is 7.3728, faster than current 4Mhz, is that ok ? 
* [hmmmm. yes and no, it depends on what chips you have fitted, for example, if your Z80 is a 6PEC it won't run reliably past 6Mhz, likewise for your eprom / sram / logic decoding] 

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/90470483_3003618259658629_4999888711945551872_n.png)

* Do all other chips need to match ? [if thats genuine, that'll be fine, eeprom emu is fast enough for 50mhz] I have a ram in there as well [sram should be fine I think] 

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/89374721_196179325152221_1237691110919241728_n.png) 

* [70ns should be ok, ~15mhz] so keep the 4mhz main clock and feed baud clk to 6850 indepently? 

* [you can't with that chip, the entire system must run at the same frequency, which is why I prefer a CPLD implementation, there is no way for you to run slower clock speeds without breaking serial comms]
* can you make me an upgraded xtal drop in for that baud freq ? 
* [I have 14.7456mhz xtals here I could pop on a board, which would double the baud of whatever the code you're running is supposed to output] 
* will the tec1 will die at high rate ? 
* [ill try one here see if the tec boots, it won't die, it just wont boot if there's an issue, i'll pop in a 10pec, and test it….Success, 10pec CPU, 70ns sram, emulator board..(works)] 

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/89693502_188955612528196_3403526402555772928_n.jpg)

* [now we know!] where did you plug that xtl in ? 

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/89666142_206106090626606_4776108666577223680_n.jpg)

* JH advocates 7.3728 , shud I stick to that ? or just assume 2x baud 
* [what is his baud?] don't know [on the serial port? the code? doesn't specify? as long as 2x the baud is a real baud, then it's fine. and the extra cpu speed is always welcome 115k] 
* url? [http://searle.x10host.com/cpm/index.html ,230k is valid on most serial ports, I wonder if they're using the /64 divisor in the code, Yeah they are, you can also use a 1.8432 mhz using the /16 divisor in software for 115k or existing code and it'll be 28800bps] 
* thanks, ok, so what do I do next? [up to you really, if you're set on using that chip
you can either grab a 7.3728 Mhz xtal or I can provide the 14mhz or a 1.8mhz one or both! if you're set on the 7.3728 I can order one from RS] 
* so weight this up, 1.8 is going backwards in speed so not that, 14 depends on chp compatibility, 7 is mid way, ok can I order 7 ? 
* [let me see if RS stocks them ic’s...yeah, nothing on RS, not the right size anyway, element14 has them https://au.element14.com/w/c/crystals-oscillators/oscillators/prl/results?oscillator-case=smd-3.2mm-x-2.5mm&st=7.3728 6.14$ a piece plus postage] 
* ok can I order then xtal drop in with that freq ? [yeah, you're ok with smd? ] nope. I meant make a whole xtl PCB droppin like you sent me last time. have a mini reflow heat gun but I know ill bugger it. or ill post my xtl PCB back 
* [ok well let me know if you need me to install it or anything ] have you sold out all ur xtl boards ? [no, 2 bare left, the rest are all 4mhz] 
* ill order chip from E14 and post to you then you can send me back a made up one, is that ok ? [yeah thats fine] case size = case=smd-3.2mm-x-2.5mm ?? I have just order 2 and will post to you [yes, ok]

* put emu in rom socket, boot. loads code, so it loads at 0000. Is monitor is knocked out. what if code calls monitor ? ask ben.... ur notes say it loads code at 0000, uploading code will start there, and this means the monitor stop being there ?
* [Yes] oh, ok, how to write code that calls the monitor ? [Use the EPROM emu in a different socket, with monitor in EPROM socket] 
* ask JH if echo uses monitor calls. ques, BG emu loads at 0000 from rom socket, once code loads it replaces monitor.. my ques is..does your echo-Z80 make any monitor calls? 
* [JH, Echo is a replacement for the monitor and starts at zero. It has no dependencies on anything else.
Whether it works is the problem to work out. It does in emulation but that's all I know so far. 
* [this book looks interesting. I hadn't read it before. It's from 1981 
https://ia800109.us.archive.org/4/items/BuildYourOwnZ80ComputerSteveCiarcia/mVQnFgWzX0AC_text.pdf  
* [It has an interest circuit in chapter 4 for single stepping the Z80. you wont be able to see the internal registers but it might help trace the program as it goes through the steps of setting up the 6850 ] 
* I tried clocking the TEC-1 below 19k and it crashes, the spec for Z80 says can handle down to DC steps, but not sure why mine has issues
* [Interesting. yeah I think you should be able to single step it. I think I did this way back in those days but I cant remember. Another possibility is to use JMON and I could change echo to run in RAM. I think it has single stepping] 
* I didn't think of that. The idea of single stepping, could also add LEDS on ADD and DATA bus, that book is like a digital school. 
* [I am pretty certain I did some single stepping on my code, pre the TEC-1, older prototypes]
* consider hand enter hello.z80 hex into TEC-1 and rather than use EMU
* [BG 7.3728 xtal board and BG Serial received.] Was nice to meet you at Altronics Lidcombe that day
* replace expansion port pins with  4 x 6 Pin 11mm Stackable Header Socket [Altronics - P5380]. ends need sandpaper reduction as last hole plastic casing full width, when butt together wont fit. if plug in to rhs covers z80 and signal pins--no good, if lhs, covers ram and 3mm over rom socket--better.

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/db1.png)
* cut tracks on pin header on tec1 so can make jumper points for z80 signals
![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/IMG_4478e.jpg)
![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/IMG_4478d.jpg)

proto board progress

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/IMG_4484b.jpg)
![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/IMG_4485b.jpg)

* add MAX3232 TTL-RS232 (5v-9v) Converter DB9 pcb, add 2 nuts
* add header male 2.52 2x10
* need 12 volt regulator for 9511, or MT3608 Step-Up Adjustable DC-DC Switching Power Module Boost Converter AU Stock
AU $5.99. go for later. 

https://easyeda.com/Little_Arc/MT3608

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/IMG_4478f.jpg)

3 may; buzzing out wiring on proto, its a rat nest. still missing wires. add on edge 5-12v upconverter.

4 may; made 3 versions of circuit
* expansion socket, no 12v, 2x10 header
https://easyeda.com/editor#id=f38afcc535a449c0b98ccadf3163fde4|168b2ab94c0d4a5989f5c65697ab6b62

* expansion socket, with 12v, 2x10 header
https://easyeda.com/editor#id=3f4140b2c93240a8af22c56c6d2cfec7|06d51f6f9d4a4724b41f7f9d1ab8b669

* expansion and z80 socket, with 12v, no 2x10 header
https://easyeda.com/editor#id=3d24ea11f2c34d8e9d85bcebfb973e56|ae71a3a950394ad6b027669fff718024

7 may

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/7-5.1.jpg)
![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/7-5.2.jpg)

* 11 may

i have made so many mistakes on the wiring its taking more effort to correct them than start again. so i cut off all orange wires. aaahhh! debating if just order a pcb, but my rule of thumb is always make a prototype before committing to pcb. will rewire this time power first in red and black on component side, as multi drop then data in orange avoiding star wiring. 

* 12 may
![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/12may-2.png)

* 23 may. 
been sick back to it now. adding d and a lines.
Is the IO range A0-A7? to go higher need the A reg? is that right ?. had A8 wired to 9511, shud i drop it down to A7 ?

https://maker.pro/pic/projects/z80-project-part-4-basic-io-and-writing-your-first-program

* 29 may. 
ff. r1=0. why. shd be 4k7.
found it, 5v each side.. now fixed

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/shrt1.png)

* 30 may
![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/30may-1.png)

* 2 june
FINISHED wiring
![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/fin-1.png)

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/fin-2.png)

* 8jun
tec-1 expansion port finished wiring. had them reversed on first ver, now swapped as ribbon goes on top not under.

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/8jun.png)

need to mount tec-1 badly. screwed to wood with over hang coz pins stick out under 2cm. test with all chips in and slow clock 4049. fail. see tec1 group vid 6jly2020. took out 2 chips, tec1 running. put 6850 in, boots ok. 

* 12jun

have tried both programs in https://github.com/jhlagado/echo-Z80 with baud 115200 and cant get anything to come back in putty. am using baud rate chip 7.3728mhz, ideas next ? asm80 makes a 64k bin files, thats way to big. when i decompile it with oshonsoft, its got asm code as well as lots of nop. bens emu is hardwired for org 0000 ?
<pre><code>
SERIALMODE: EQU 6850
0000 ROM_SIZE: EQU $800
0000 RAM_SIZE: EQU $800 …See More
</code></pre>

this shud make a 2k bin not 64k ?

Břīåñ CHIHД ; I've been using ASM80 to debug and z80asm to compile. It creates a binary file with the actual size. I also use hexdump to give me the size in hex. I use a mac.

Hans Otten; ASM80 seems to dump all 64K as bin. Compile, download the hex file from the workspace and convert that to bin. Results in 89 byte bin file for hello.z80, load address 0000h

* 14 june

Martin Malý <tickets@webscript.uservoice.com>
I guess you are looking for the .binfrom and .binto directives. See https://manual.asm80.com/directives

.binfrom addr

Starting address for binary download, default is 0. (Only valid for "Download BIN" function in IDE)

.binto addr

Last address for binary download (this address WILL NOT BE INCLUDED in binary file) Default is 65536. (Only valid for "Download BIN" function in IDE)

* 26 june

need breakout pins to run datascope

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/IMG_4857-2.jpg)

* 11 july

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/110720a.jpg)

tried this code

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/110720b.png)

trace is https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/trace110720b.sr
PulseView - sigrok

looking at data bus, and checked tx out and pin 6 on uart all low, no pulses
i commented this out to try and compile at 0800, will this work ?


hello.z80 is the file

I think this is for the 6850, ports 80 and 81. I should work

yes thats right

The code originally came from asm80 manual

So you should be able to see it run on asm80 if you have the emulation file set up

See https://manual.asm80.com/generic-emulators
Generic Emulators
Barebone emulator, or “generic emulator”, is a customizable emulator of CPU + memory + serial terminal. You can configure it by simple config file. Let’s long story short…
manual.asm80.com


it worked in the emulator, then i commented out the orgs and re compiled at org 0800. i hand loaded it into the tec1, and hit run at 0800



Sounds good, so as long as the chip maps to the right ports of should work


It's basically the Grant Searl solution. You can also look at the loader in Searls msbasic rom. It sets up a sort of bios based on the 6850 serial io

 
---
making another board with copper ontop and going deadbug style, so i can get at the tracks, last cct to cramped up, fuk

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/120720a.png)

now tec-1 wont even boot goes haywire

ordered another 6850 this time not china but uk. https://www.ebay.com.au/usr/zanco-electronics. Price:GBP 4.24 / AU $7.60
Leek, United Kingdom

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/uk.jpg)




* 21july
buzz out wiring
found another error /int to pin17 z80. 

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/109933646_2747741138792587_6169882162472138810_n.jpg)

* 22july
found 4 errors, fixed

ordered a CM603 Gold / Ceramic Pravetz ACIA Interface Adapter 1MHz IC MC6850P Motorola. Never Used “Pulls from Unused Military Equipment”. 
US $8.79 / AU $12.36

advert says 
Genuine Vintage 80's Production
Made by DSO "Priborostroene Pravetz, Bulgaria", 
the same factory, that produced the famous Pravetz Personal Computer 
(Bulgarian clones of Apple-II and IBM PC/XT) during the communist era.

https://www.zdnet.com/article/how-these-communist-era-apple-ii-clones-helped-shape-central-europes-it-sector/

https://github.com/SteveJustin1963/tec-APUS/blob/master/docs/How%20these%20communist-era%20Apple%20II%20clones%20helped%20shape%20central%20Europe's%20IT%20sector%20_%20ZDNet.pdf


![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/bul2.jpg)

* 27july

review
http://searle.x10host.com/z80/SimpleZ80.html

found missing /IORQ to u4-3 and u4-2 to u2-14; added. put 6850 in boot ok not crazy. run music prog; ok.

connect tx rd gnd. keypad enter "hello world" code; nothing

Stephen Justin John Hardy; i redid the circuit dead bug, still cant make either program to work, hoping for even more simple test code. plz :-)

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/109804981_2753154521584582_7665994768432068855_n.jpg)

John reply see, try new code

9:17 PM
hi John, hope ur well, Melb is a tough place these days... can i ask u...i redid the circuit dead bug, still cant make either echo-Z80 program to work, hoping for even more simple test code. plz 🙂

Is this using the 6850 or Ben's serial circuit?

yes 6850

grant cct

its about time i wrote some code, sorry

It's just problem of not having both hardware and software on the same system. I haven't got anything working in hardware here. I think we need to go back to what Searle has written

ok no worries. ill park this, and read into GS work for clues.

this zip file contains initmini.asm which is a BIOS layer for his MSBASIC port, it basically talks to the 6850

Hmm Facebook is broken, hold on

http://searle.x10host.com/z80/sbc_NascomBasic.zip
searle.x10host.com
searle.x10host.com

In theory it should print out 
Z80 SBC By Grant Searle 
Cold or warm start (C or W)?

and then jump to COLDSTART or $0153 depending on the keystroke

Cold and Warm are just places in the basic.asm file, around $0150 in memory but you can ignore that part

so i cut and past that part

yes

you can see there are two .asm files, you really only need the stuff in the inimini.asm file

ok. ill try

we can test it in asm.80 first

ok

But code like this never just works. You need to try to read it.

Is it as simple as just writing to the port to switch it on and then telling its output of boat do I need to have a lengthy setup procedure for the chat

From memory the Grant Searle circuit uses ports $80 and $81 and an interrupt

sorry typo

It really should work immediately

I'll try to emulate it in asm80 and share the set up. I did this once before

yes asm80 works


so must still be in my hardware circuit doesn’t work I have ordered two new chips just in case


thanks for your help I’ll rest now



ok


10:58 PM

I've made a much simpler echo program based on the Grant Searle code


simpler-echo.z80.asm



thankyou John.



you can emulate it on asm80 if you have a file called mycomputer.emu in the same folder.


mycomputer.emu



Hopefully that will help you narrow down the problems to the hardware. We know that Searle's code runs very widely on lots of boards.


thanks



I just discovered that you can format code in Facebook

================================

; file name is simple-echo.z80

.engine mycomputer

; NON COMMERCIAL USE ONLY
; Modified from code by Grant Searle
; Minimum 6850 ACIA interrupt driven serial I/O
; Full input buffering with incoming data hardware handshaking
; Handshake shows full before the buffer is totally filled to allow run-on from the sender

SER_BUFSIZE     .EQU     3FH
SER_FULLSIZE    .EQU     30H
SER_EMPTYSIZE   .EQU     5

RTS_HIGH        .EQU     0D6H
RTS_LOW         .EQU     096H

serBuf          .EQU     $2000
serInPtr        .EQU     serBuf+SER_BUFSIZE
serRdPtr        .EQU     serInPtr+2
serBufUsed      .EQU     serRdPtr+2
TEMPSTACK       .EQU     $20ED ; Top of BASIC line input buffer so is "free ram" when BASIC resets

; Reset
                .ORG     $0000
                DI                       ;Disable interrupts
                JP       INIT            ;Initialize Hardware and go

; RST 38 - INTERRUPT VECTOR [ for IM 1 ]
                .ORG     $0038
serialInt:      PUSH     AF
                PUSH     HL

                IN       A,($80)
                AND      $01             ; Check if interupt due to read buffer full
                JR       Z,rts0          ; if not, ignore

                IN       A,($81)
                PUSH     AF
                LD       A,(serBufUsed)
                CP       SER_BUFSIZE     ; If full then ignore
                JR       NZ,notFull
                POP      AF
                JR       rts0

notFull:        LD       HL,(serInPtr)
                INC      HL
                LD       A,L             ; Only need to check low byte becasuse buffer<256 bytes
                CP       (serBuf+SER_BUFSIZE) & $FF
                JR       NZ, notWrap
                LD       HL,serBuf
notWrap:        LD       (serInPtr),HL
                POP      AF
                LD       (HL),A
                LD       A,(serBufUsed)
                INC      A
                LD       (serBufUsed),A
                CP       SER_FULLSIZE
                JR       C,rts0
                LD       A,RTS_HIGH
                OUT      ($80),A
rts0:           POP      HL
                POP      AF
                EI
                RETI

;------------------------------------------------------------------------------

RXA:
waitForChar:    LD       A,(serBufUsed)
                CP       $00
                JR       Z, waitForChar
                PUSH     HL
                LD       HL,(serRdPtr)
                INC      HL
                LD       A,L             ; Only need to check low byte becasuse buffer<256 bytes
                CP       (serBuf+SER_BUFSIZE) & $FF
                JR       NZ, notRdWrap
                LD       HL,serBuf
notRdWrap:      DI
                LD       (serRdPtr),HL
                LD       A,(serBufUsed)
                DEC      A
                LD       (serBufUsed),A
                CP       SER_EMPTYSIZE
                JR       NC,rts1
                LD       A,RTS_LOW
                OUT      ($80),A
rts1:
                LD       A,(HL)
                EI
                POP      HL
                RET                      ; Char ready in A

;------------------------------------------------------------------------------

TXA:            PUSH     AF              ; Store character
conout1:        IN       A,($80)         ; Status byte       
                BIT      1,A             ; Set Zero flag if still transmitting character       
                JR       Z,conout1       ; Loop until flag signals ready
                POP      AF              ; Retrieve character
                OUT      ($81),A         ; Output the character
                RET

;------------------------------------------------------------------------------

CKINCHAR        LD       A,(serBufUsed)
                CP       $0
                RET

PRINT:          LD       A,(HL)          ; Get character
                OR       A               ; Is it $00 ?
                RET      Z               ; Then RETurn on terminator
                CALL     TXA             ; Print it
                INC      HL              ; Next Character
                JR       PRINT           ; Continue until $00
                RET
;------------------------------------------------------------------------------

INIT:
               LD        HL,TEMPSTACK    ; Temp stack
               LD        SP,HL           ; Set up a temporary stack
               LD        HL,serBuf
               LD        (serInPtr),HL
               LD        (serRdPtr),HL
               XOR       A               ;0 to accumulator
               LD        (serBufUsed),A
               LD        A,RTS_LOW
               OUT       ($80),A         ; Initialise ACIA
               IM        1
               EI
               LD        HL,GREETING     ; Sign-on message
               CALL      PRINT           ; Output string
LOOP:
               CALL      RXA
               CALL      TXA
               JP        LOOP
              
GREETING:      .cstr     "Type something\r\n"
              
.END


========================================

;file name mycomputer.emu

cpu Z80

memory.rom.from 0x0000
memory.rom.to 0x0fff
memory.ram.from 0x1000
memory.ram.to 0xffff

serial 6850
serial.data 0x81
serial.control 0x80
serial.interrupt 1
terminal.caps 0
; end

========
chat with JH; cool howd u do that ? i can just compile that listing? You prefix code with ``` and close it with ```
Yes those listings will just work put them in files simple-echo.z80 and mycomputer.emu 

in the repo https://github.com/tec1group/software-repo/tree/master/misc
============


* 16aug
try with a 7.3728 xtal, simple-echo, dont work. need to write my own test code.

* 20sept
building 555 cct to control /M1, /WAIT to step thru instructions

https://z80project.wordpress.com/2014/02/16/single-step-instruction-circuit/

* 18oct

testing simple-echo.z80  
what is the terminal baud rate?


* 2nov
/IORQ check, 6850 pin 14 , 74138 pin 4 pulse yes, same now, corrected wiring


reading this

https://electronics.stackexchange.com/questions/164027/z80-simple-computer-troubleshooting-iorq-pin-not-going-low

http://www.z80.info/1653.htm

asked fb group if ok to hang multiple things off the one /iorq line

* 7feb2021 

thinking ill test serial by running firth...ask jh how to run firth in ram from 800-3000, 6 stacked 2k ram chips. what is the correct config for constants.z80 file ? 

JH; Hi Stephen I have a series of constants declared in a file. I guess it could be moved up into ram but there's still the serial communicated. Right now that's expecting a routine at 38h because of interrupt mode 1. Forth is written to start at 0 because that's where reset puts the PC but if you can jump to 800 then the code could be moved there. I can test all this but what about the interrupt vector problem? There are ways around then but interrupt mode 2 is fairly complicated.


9511

i dont know clock rating of chip version i have





## References

https://github.com/feilipu/yaz180

https://en.wikipedia.org/wiki/Instructions_per_second

https://retrocomputing.stackexchange.com/questions/6835/why-did-ti-8x-calculator-series-use-the-z80-processor

https://archive.is/2015.07.14-173053/http://sgate.emt.bme.hu/patai/publications/z80guide/part4.html

http://www.andreadrian.de/oldcpu/Z80_number_cruncher.html

http://www.cpushack.com/2010/09/23/arithmetic-processors-then-and-now/

https://sourceforge.net/projects/realterm/files/Realterm/2.0.0.70/

https://feilipu.me/2017/02/22/characterising-am9511a-1-apu/

https://github.com/z88dk/z88dk/tree/master/libsrc/_DEVELOPMENT/target/yaz180/device/am9511a

https://github.com/SteveJustin1963/z88dk/tree/master/libsrc/_DEVELOPMENT/target/yaz180/device/am9511a

## Iterate, new hypotheses or predictions
* The 9511 runs extremely hot, alternatives ? or add a thermocouple to recover power loss, temp sense to track heat.

* try qubit, p-bit or stochastic processing 
  * https://github.com/SteveJustin1963/tec-QUBIT
  * https://github.com/SteveJustin1963/tec-STOCH

https://github.com/SteveJustin1963/tec-BANG 

 



