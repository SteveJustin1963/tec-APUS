 

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
The given code appears to be an assembly language program for performing a 16-bit addition operation using the 9511 FPU (Floating Point Unit). Here are the steps explained:

1. Define Constants:
   - `DATA_PORT`, `COMMAND_PORT`, and `STATUS_PORT` are defined as equates to specific memory addresses.
   - `BUSY`, `SIGN`, `ZERO`, `ERROR_MASK`, and `CARRY` are defined as equates with specific bit values.

2. Set up Memory Organization:
   - The program is organized to start at address `$800`.
   - `RESULT` is defined as a word (16 bits) to store the result of the addition.
   - `ERROR` is defined as a byte (8 bits) to store the error code.

3. Start of the Program (`start` label):
   - Load the values `1` into registers HL and DE (arguments for addition).

4. Push Data:
   - Call the `pushData` subroutine to push the values of HL and DE onto the data port.
   - This subroutine sends the lower byte of HL, followed by the higher byte of HL, to the data port.

5. Perform Addition:
   - Load the value `SADD` into register A, which represents the command for 16-bit addition.
   - Output the value of A to the command port, indicating the operation to be performed.
   - Call the `awaitResult` subroutine to wait for the result.

6. Pop Data:
   - Call the `popData` subroutine to read the result from the data port.
   - The subroutine reads the lower byte of the result and stores it in register H, then reads the higher byte and stores it in register L.

7. Store Result and Error:
   - Store the result (HL) in the memory location `RESULT`.
   - Check the status byte obtained earlier to extract the error code.
   - Store the error code in the memory location `ERROR`.

8. Halt and Restart:
   - Halt execution to wait for a keypress.
   - If a key is pressed, jump back to the `start` label to restart the program.

9. Subroutines:
   - `pushData` subroutine:
     - Store the lower byte of the current register L in the data port.
     - Store the higher byte of the current register L in the data port.

   - `popData` subroutine:
     - Read a byte from the data port and store it in register A.
     - Move the value from register A to register H.
     - Read another byte from the data port and store it in register A.
     - Move the value from register A to register L.

   - `awaitResult` subroutine:
     - Read the status byte from the status port into register A.
     - Copy the value of A into register B for further processing.
     - Check if the BUSY bit (bit 7) is set (non-zero) using the logical AND operation with `BUSY`.
     - If the BUSY bit is set, jump back to the `awaitResult` subroutine to continue waiting.
     - Mask the status byte with `ERROR_MASK` to extract the error code bits (bits 4-1).
     - Rotate the error code left by 1 bit, effectively shifting it right by 1.
     - Store the resulting error code in the memory location `ERROR`.

These steps outline the flow of the program and how it performs the 16-bit addition using the 9511 FPU.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

// Define Constants
DATA_PORT = $10
COMMAND_PORT = $11
STATUS_PORT = $12

BUSY = $80
SIGN = $40
ZERO = $20
ERROR_MASK = $1E
CARRY = $01

SADD = $6C

// Start of the Program
start:
    // Initialize arguments for addition
    arg1 = 1
    arg2 = 1

    // Push arguments onto the data port
    pushData(arg1)
    pushData(arg2)

    // Perform 16-bit addition
    sendCommand(SADD)
    awaitResult()
    result = popData()

    // Halt and restart if keypress
    halt()
    restart()

// Subroutine to push data onto the data port
pushData(data):
    sendLowerByte(data)
    sendHigherByte(data)

// Subroutine to send the lower byte of data to the data port
sendLowerByte(data):
    lowerByte = getLowerByte(data)
    sendDataPort(lowerByte)

// Subroutine to send the higher byte of data to the data port
sendHigherByte(data):
    higherByte = getHigherByte(data)
    sendDataPort(higherByte)

// Subroutine to read data from the data port
popData():
    lowerByte = readDataPort()
    higherByte = readDataPort()
    return combineBytes(lowerByte, higherByte)

// Subroutine to await the result from the FPU
awaitResult():
    statusByte = readStatusPort()

    while (isBusy(statusByte)):
        statusByte = readStatusPort()

    errorCode = extractErrorCode(statusByte)
    storeErrorCode(errorCode)

// Helper function to check if the BUSY bit is set in the status byte
isBusy(statusByte):
    return (statusByte & BUSY) != 0

// Helper function to extract the error code from the status byte
extractErrorCode(statusByte):
    errorCode = (statusByte & ERROR_MASK) >> 1
    return errorCode

// Subroutine to send a command to the command port
sendCommand(command):
    sendDataPort(command)

// Subroutine to read a byte from the data port
readDataPort():
    byte = readByteFromPort(DATA_PORT)
    return byte

// Subroutine to read a byte from the status port
readStatusPort():
    byte = readByteFromPort(STATUS_PORT)
    return byte

// Subroutine to send a byte to the specified port
sendDataPort(byte):
    sendByteToPort(DATA_PORT, byte)

// Helper function to get the lower byte of a 16-bit value
getLowerByte(value):
    return value & 0xFF

// Helper function to get the higher byte of a 16-bit value
getHigherByte(value):
    return (value >> 8) & 0xFF

// Helper function to combine two bytes into a 16-bit value
combineBytes(lowerByte, higherByte):
    return (higherByte << 8) | lowerByte

// Subroutine to store the error code in memory
storeErrorCode(errorCode):
    ERROR = errorCode

// Halt the program execution
halt():
    // Wait for a keypress or any other desired method

// Restart the program execution
restart():
    goto start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

The actual implementation of `readByteFromPort` and `sendByteToPort` is heavily dependent on the specifics 
of your Forth environment, hardware, and/or operating system. 
Forth doesn't provide a standardized way to perform direct hardware I/O operations 
as it's a very low-level task that's typically done in assembly or in a platform-specific manner.

However, hypothetical scenario where we simulate these operations using a memory area, 
assuming that every memory cell corresponds to a port. 
In a real-world situation, you would need to replace these with actual hardware access primitives 
provided by your Forth system or the underlying hardware or operating system.

```forth
\ Constants
decimal
16 base ! \ switch to hexadecimal notation
10 constant DATA_PORT
11 constant COMMAND_PORT
12 constant STATUS_PORT

80 constant BUSY
40 constant SIGN
20 constant ZERO
1E constant ERROR_MASK
01 constant CARRY

6C constant SADD

\ Variables
variable arg1
variable arg2
variable result
variable errorCode
create ports 1000 allot \ This reserves space for 1000 ports.

\ Define new words
: readByteFromPort ( port -- byte ) \ Reads a byte from a specific port
    ports + @ ;

: sendByteToPort ( byte port -- ) \ Sends a byte to a specific port
    over ports + ! ;

: lowbyte ( n -- byte ) \ Get the lower byte of a 16-bit value
    255 and ;

: highbyte ( n -- byte ) \ Get the higher byte of a 16-bit value
    8 rshift ;

\ Main words
: pushData ( n -- )  \ Subroutine to push data onto the data port
    dup lowbyte sendDataPort
    highbyte sendDataPort ;

: popData ( -- n ) \ Subroutine to read data from the data port
    readDataPort 
    readDataPort 256 * + ;

: awaitResult ( -- ) \ Subroutine to await the result from the FPU
    readStatusPort
    begin
        dup BUSY and
    while
        drop readStatusPort
    repeat
    ERROR_MASK and 1 rshift errorCode ! ;

: start \ Start of the Program
    decimal 1 arg1 !
    1 arg2 !
    arg1 @ pushData
    arg2 @ pushData
    SADD sendCommand
    awaitResult
    popData result !
    \ Note: There are no direct analogues for "halt" and "restart" in Forth. 
    It would need to be implemented depending on the specific system.
;

: readDataPort ( -- byte ) DATA_PORT readByteFromPort ;
: readStatusPort ( -- byte ) STATUS_PORT readByteFromPort ;
: sendDataPort ( byte -- ) DATA_PORT swap sendByteToPort ;
: getLowerByte ( n -- byte ) 255 and ;
: getHighByte ( n -- byte ) 255 rshift ;
: combineBytes ( lowerByte higherByte -- word ) 256 * + ;

\ Start execution
start
```

In this scenario, the `ports` memory area serves as our "I/O ports". 
`readByteFromPort` reads a value from the corresponding "port" (actually a memory cell), 
and `sendByteToPort` stores a value into the corresponding "port" (again, actually a memory cell). 
This is just a simulation and does not represent actual hardware I/O operations.

Please be aware that you would need to replace this simulation with actual I/O operations 
depending on your Forth environment or underlying hardware or operating system.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


