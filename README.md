# tec-APUS

Arithmetic Processing Unit with AM9511 and Serial IO MC68B50P for the TEC-1

# Wiki
https://github.com/SteveJustin1963/tec-APUS/wiki

# Circuit
https://easyeda.com/editor#id=6a84959be4ed48d0b693eae5d268a4dd

https://easyeda.com/editor#id=6a84959be4ed48d0b693eae5d268a4dd|f83d6e4345f549a7bd7ee7b231e8b4e3

# Software
https://gist.github.com/jhlagado/1e13592eb960ebf51b1f03d92b513d65?fbclid=IwAR3TMQrLdt7XEVX5LBaR_A39m542dwm0wIp5AXCRv4Ern9mq87VFVXVwxx0

# Chat

HI John. How are you? I am bread boarding this tecAPUS this weekend, could u write me a small test asm code to test it pls?


or give some clues so i can do it myself. thx


5:40 PM

Hi for sure. I'll try


I guess we can start with the 6850, I'm not familiar with the AM9511



i guess controlling the APU is not too hard. It looks a bit like Forth machine but you control it via an I/O port. That looks the simplest approach, there is another which uses direct-memory access but that is harder to do.





the APU needs to report back to the CPU by an interrupt, probably the normal INT line. Also it needs to be addressable by an I/O port. We need to share the interrupt line with the 6850, or use the NMI line. If you are going to use the Grant Searle wiring for the 6850 then we need to reserve ports $80 and $81 for serial.


ok. ill mod it. am blind but am guided by all those old docs i could find. even paid for ieee doc as well. 9511 is old but a goodie.



For sure. You need to decode two address ports, one for data, the other for commands.


It works like a stack machine, like Forth. We need to know when the operation is complete so we could use an interrrupt like connected to the END pin (24), or alternatively I think we could keep checking a bit using a polling process.


9:47 PM

No idea if this will work but here's a start

DATA_PORT equ $10
COMMAND_PORT equ $11
STATUS_PORT equ $12

BUSY equ $80
SIGN equ $40
ZERO equ $20
ERROR equ $1E    ; mask for error
CARRY equ $01

SADD equ $6C

        org $800
start:
        ld HL, 1
        ld DE, 1

        call pushData
        ex DE,HL
        call pushData
        ld A, SADD
        call pushCommand
        call awaitResult    
        call popData        
        ld (RESULT), HL
        halt                ;wait here
        jp start            ;restarts if keypress

RESULT: dw 0
    
pushData:
        ld A,L
        out (DATA_PORT),A
        ld A,H
        out (DATA_PORT),A
        ret
    
popData:
        in A,(DATA_PORT)
        ld H,A
        in A,(DATA_PORT)
        ld L,A
        ret
    
pushCommand:
        ld A,L
        out (COMMAND_PORT),A
        ld A,H
        out (DATA_PORT),A
        ret

awaitResult:
        in A,(STATUS_PORT)
        ld B, A
        and BUSY
        jr nz, awaitResult
        ret



you'll need to work out what the ports should be. I just made them up


also I just polled the chip to see if it was not busy. i.e. didn't use an interrupt


Don't expect this code to work 😉 it's just a starting point for thinking about how to use this chip. I used this datasheet https://datasheet.octopart.com/C8231A-Intel-datasheet-38975267.pdf and this one https://www.hartetechnologies.com/manuals/AMD/AMD%209511%20FPU.pdf
datasheet.octopart.com
datasheet.octopart.com


This might clearer plus I can edit it to fix bugs

https://gist.github.com/jhlagado/1e13592eb960ebf51b1f03d92b513d65
example code to program a 9511
example code to program a 9511. GitHub Gist: instantly share code, notes, and snippets.
gist.github.com


I wll hurry to make the changes in hw and try ur code. i have also put alot of docs in my git as well


right, yeah I probably could have save some effort by reading some of those. There seems to be a shortage of good code listings for the Z80. I noticed some for the 6502


This article seems pretty good, needs to be converted to Z80 from 6502 https://github.com/SteveJustin1963/tec-APUS/blob/master/Compute!%20The%20Journal%20of%20Progressive%20Computing%20-%20Nov%20Dec%201980%20124-129.pdf

there are a few useful things here. the basic listing seems all you need to know. port numbers vary . i think its going to take a few goes to get this right.

yep its not too hard. it'll mainly be about waiting until the chip is ready before reading or writing to it. ie check the busy flag of the status port


