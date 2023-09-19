 

; https://gist.github.com/jhlagado/1e13592eb960ebf51b1f03d92b513d65
; https://datasheet.octopart.com/C8231A-Intel-datasheet-38975267.pdf 
; https://www.hartetechnologies.com/manuals/AMD/AMD%209511%20FPU.pdf

; coded by John Hardy


DATA_PORT equ $10
COMMAND_PORT equ $11
STATUS_PORT equ $12

BUSY equ $80
SIGN equ $40
ZERO equ $20
ERROR_MASK equ $1E    ; mask for error
CARRY equ $01

SADD equ $6C

        org $800
start:
        ld HL, 1                ; arg1
        ld DE, 1                ; arg2

        call pushData           ; push arg1
        ex DE,HL
        call pushData           ; push arg2
        
        ld A, SADD              ; 16 bit add operation
        out (COMMAND_PORT),A    ; send to 9511
        call awaitResult           
        call popData            ; result in HL
        ld (RESULT), HL         ; store result
        
        halt                    ;wait here
        jp start                ;restart if keypress

        org $900       
RESULT: dw 0
ERROR:  db 0

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
    
awaitResult:
        in A,(STATUS_PORT)      ; loop until busy=0
        ld B, A
        and BUSY
        jr nz, awaitResult
        
        ld A,ERROR_MASK         
        and B                   ; mask status to get error code
        rl A                    ; shift right 1 bit
        ld (ERROR),A            ; store error code 
        ret



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
START
├─ Initialize Constants
│   ├─ DATA_PORT = $10
│   ├─ COMMAND_PORT = $11
│   ├─ STATUS_PORT = $12
│   ├─ BUSY = $80
│   ├─ SIGN = $40
│   ├─ ZERO = $20
│   └─ ERROR_MASK = $1E
│
├─ Define SADD = $6C
│
├─ Load HL with arg1
│   └─ HL = 1
│
├─ Load DE with arg2
│   └─ DE = 1
│
├─ Call pushData for arg1
│   └─ pushData(arg1)
│
├─ Exchange DE and HL
│   └─ Swap DE and HL
│
├─ Call pushData for arg2
│   └─ pushData(arg2)
│
├─ Load A with SADD
│   └─ A = SADD
│
├─ Send A to COMMAND_PORT
│   └─ Send A to COMMAND_PORT
│
├─ Call awaitResult
│   └─ awaitResult()
│      ├─ Loop until BUSY flag in STATUS_PORT is clear
│      └─ Error Handling:
│         ├─ Load A with STATUS_PORT
│         ├─ Apply ERROR_MASK to A
│         ├─ Rotate A right by 1 bit
│         └─ Store A into ERROR
│
├─ Call popData to get the result into HL
│   └─ popData()
│      └─ Read data from DATA_PORT into HL
│
├─ Store HL into RESULT
│   └─ RESULT = HL
│
├─ Halt execution (Wait here)
│
├─ Restart at START if keypress detected
│   └─ Restart at START
│
└─ Define RESULT = 0
    └─ RESULT = 0
