; The program appears to be performing a series of arithmetic operations using a device called the AMD 9511 
; floating-point unit (FPU). The FPU is a separate chip that is designed to perform high-precision 
; floating-point arithmetic operations, which are commonly used in scientific and engineering applications.
;
; The program begins by loading the values 1 and 1 into the HL and DE registers, respectively. 
; These values are then passed as arguments to the "pushData" subroutine, which stores them in the data port of the FPU. 
; Next, the program sends the command for a 16-bit add operation to the FPU via the command port, and waits for the result
; by calling the "awaitResult" subroutine. 
; Finally, the program retrieves the result from the FPU's data port and stores it in the "RESULT" memory location. 
; The program then enters a loop where it repeatedly performs these operations and displays the result.

; https://gist.github.com/jhlagado/1e13592eb960ebf51b1f03d92b513d65
; https://datasheet.octopart.com/C8231A-Intel-datasheet-38975267.pdf 
; https://www.hartetechnologies.com/manuals/AMD/AMD%209511%20FPU.pdf

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
