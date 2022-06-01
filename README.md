 MC6850+ AM9511, use in MINT/ASM etc.

### simple-echo.z80. 
- it echoes back what you sent to it. set your RAM and ROM values. downloaded as intel hex or binary. load hex into into rom with burner (covets to binary) or bin to EMU.
- clocks speed determines baud rate, a &.3728 Mhz clk gives standard baud rates 4800, 9600... The code divides this down  `/64 = 115,200` baud or `/16 =  460,800` baud 
- but a standard clock is not required to operate such as 4Mhz. simply adjust the terminal speed to aquire the right baud rate with Tera-Term. 
- handles the control registers and with INT control, 
  - rx buffer sends a INT when the buffer is full. 


### 9511 code
- see CJ code, url ?
- https://github.com/z88dk/z88dk/tree/master/libsrc/_DEVELOPMENT/math/float/am9511
- https://easyeda.com/Little_Arc/MT3608


## old cct  
- https://github.com/SteveJustin1963/tec-APUS/wiki

