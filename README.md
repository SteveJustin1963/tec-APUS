# tec-APUS - AM9511 + MC6850 Integration

My goal has been to combine the AM9511 APU and MC6850 Serial Interface into a single small PCB and called it APUS.  My design allows for efficient integration of the two components into a single TEC-APUS project. The TEC-APUS project aims to enhance the mathematical processing capabilities of the TEC-1 computer and Southern Cross Computer by incorporating these components.

work carried out by SJ and Craig Jones. SJ's work focuses on combining the components into a single small PCB, while CJ has developed two separate PCBs for the AM9511 APU and the MC6850 serial interface to work with both the SBC and TEC1 with supporting software.

This report provides an overview of their work, including schematic designs, images, and code snippets. John Hardy also provided advice and test code.




 

## 6850 code 
- JH, `simple-echo.z80` . "...It echoes back what you sent to it. set your RAM and ROM values. downloaded as intel hex or binary. load hex into rom with burner (covets to binary) or bin to EMU. clocks speed determines baud rate, a &.3728 Mhz clk gives standard baud rates 4800, 9600... The code divides this down  `/64 = 115,200` baud or `/16 =  460,800` baud, but a standard clock is not required to operate such as 4Mhz. simply adjust the terminal speed to acquire the right baud rate with Tera-Term. handles the control registers and with INT control, rx buffer sends a INT when the buffer is full. 
- "see...Grant Searl solution. look at the loader in Searls msbasic rom. It sets up a sort of bios based on the 6850 serial io 

## 9511 code
- https://github.com/z88dk/z88dk/tree/master/libsrc/_DEVELOPMENT/math/float/am9511
 


## HW
- https://easyeda.com/editor#id=8384393150b147a79c794b78886917d1%7Cc5e3f76b1960488e92af095fc1e68dca

![image](https://user-images.githubusercontent.com/58069246/210191831-d5100c9a-1334-4b7c-b8c3-dd557def537f.png)
![image](https://user-images.githubusercontent.com/58069246/210191848-9db9e0ca-bc03-4901-93ea-28eeec302f86.png)

- 5 to 12v converter  https://easyeda.com/Little_Arc/MT3608

![image](https://github.com/SteveJustin1963/tec-APUS/assets/58069246/bc1c4090-e1f8-4fc2-b60c-74f882f986e9)

## SJ Ver 8
- ver8 minimal https://easyeda.com/editor#id=ace1308a3daa441a8ffa8288a8463d64|a5ec37e037f240f799832a3adec4c860
- ver8 with 688 https://easyeda.com/editor#id=ace1308a3daa441a8ffa8288a8463d64|90cb26627fc44a789cd6cd08ffa07c82
 

##  Craig Jones 
developed his two separate PCBs for the AM9511 APU and the MC6850 Serial Interface

- https://github.com/crsjones/Southern-Cross-Computer-z80/tree/main/SC-APU
- https://github.com/SteveJustin1963/tec-APUS/blob/master/schem/SC-APU-R1.pdf
- https://github.com/SteveJustin1963/tec-APUS/blob/master/schem/SCSerial10Schematic.pdf
 
![image](https://user-images.githubusercontent.com/58069246/210191787-76b410a8-015c-428c-a3b1-35388e360a57.png)
![image](https://user-images.githubusercontent.com/58069246/210191877-ea986286-5a5e-45a8-9075-d14b98f471b5.png)

 
https://github.com/crsjones/Southern-Cross-Computer-z80/tree/main/SC-APU

![296695661_423670749725283_5916979048714754944_n](https://user-images.githubusercontent.com/58069246/184461064-931d17f9-8fb9-4191-a095-ee8816cb7aa0.jpg)

![278338782_717753043011436_242673502688909166_n](https://user-images.githubusercontent.com/58069246/192073149-5f4fcb76-75de-4c24-807d-1306948ee3c8.jpg)


## update decoding 74HC688
https://github.com/crsjones/Southern-Cross-Computer-z80/tree/main/SC-APU


## update - Lawrence Livermore Labs Floating Point Library
https://github.com/feilipu/LLL-Floating-Point
 
LLL code is used to compute transcendental functions and then you can compare to apu results. 

https://github.com/crsjones/APU 

## 16.3.22 - Schematic  
- https://github.com/SteveJustin1963/tec-APUS/blob/master/schem/TEC-APU-cj-1.pdf


## Ver 1   9511 APU

![278437981_567070347974637_4839388550385817706_n](https://user-images.githubusercontent.com/58069246/192073087-16f5cb5a-2c6b-4522-bb13-a87070441a20.jpg)

## work on SJ's 7.1 board  - 6850 Serial

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/cg%201.jpg)
![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/cj-2.jpg)

 

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/260717599_280462014046158_384653013632846250_n.jpg)

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/261002318_280462027379490_7516334454848220787_n.jpg)

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/263019317_280462017379491_3466954581733273683_n.jpg)

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/262870855_463720035302369_3813373904138282086_n.jpg)


SC Serial board
![278781749_3084515785099816_6244488348577216924_n](https://user-images.githubusercontent.com/58069246/192073057-677a8e3a-c46c-4d5c-ad91-7f422b474628.jpg)

## code
See what's around. The RC2014 code looks promising. I might even start with the JH code just to get it working. It's not going to matter if the code for either the serial is in RAM or ROM.  Also will be able to use bit bang serial or 6850 serial.

![](https://github.com/SteveJustin1963/tec-APUS/blob/master/pics/271732275_4710190225767426_3493303551305514214_n.jpg)


## AM9511 software code loop

```       
       +---------------+
       |               |
       v               |
  start +------------> |
       |               |
       |               v
       |          while (1)
       |               |
       |               v
       |          arg1 = 1
       |          arg2 = 1
       |               |
       |               v
       |        pushData(arg1)
       |               |
       |               v
       |        pushData(arg2)
       |               |
       |               v
       |       command = SADD
       |       outb(COMMAND_PORT, command)
       |               |
       |               v
       |       awaitResult()
       |               |
       |               v
       |       result = popData()
       |               |
       |               v
       | *((short*) 0x900) = result
       |               |
       |               v
       |       return 0
       |               |
       +---------------+
```

## MC6850 software code loop

```
START
  |
  v
INITIALIZE HARDWARE
  |
  v
LOOP FOREVER
  |
  v
  CHECK FOR CHARACTER IN SERIAL BUFFER
  |
  v
  YES
  |
  v
  READ CHARACTER FROM SERIAL BUFFER
  |
  v
  PRINT "You typed: "
  |
  v
  TRANSMIT CHARACTER
  |
  v
  PRINT "\r\n"
  |
  v
  NO
  |
  v
END LOOP
 ```
## =======================end cj============================




### Integration of AM9511 with MINT
If you add an AM9511 (Arithmetic Processing Unit) to MINT, it can greatly enhance the capabilities of your system by offloading complex mathematical operations like floating-point arithmetic, trigonometric functions, and logarithms to the AM9511, which is more efficient than using software-based calculations in MINT. Here's how you could integrate and utilize the AM9511 with MINT:


1. **Set Up Communication**:
   - The AM9511 communicates with the CPU through specific I/O ports. You’ll need to set up these ports in MINT to read from and write to the AM9511.

2. **Define MINT Routines to Access the AM9511**:
   - Write MINT routines to send commands and data to the AM9511 and retrieve results.

### Example MINT Code for Using the AM9511

#### Step 1: Set Up the I/O Ports

```mint
VAR PORT-DATA   // Define the data port for communication
VAR PORT-STATUS // Define the status port to check the AM9511 state

:PORT-DATA 0x10 PORT-DATA !     // Assume 0x10 as data port
:PORT-STATUS 0x11 PORT-STATUS ! // Assume 0x11 as status port
```

- **`PORT-DATA`** and **`PORT-STATUS`**: These are placeholders for the ports used to communicate with the AM9511. Adjust these based on your actual setup.

#### Step 2: Define MINT Routines for Communication

```mint
:WRITE-TO-AM9511 ( n -- )
    /A PORT-DATA ! ;          // Write a value to the AM9511

:READ-FROM-AM9511 ( -- n )
    PORT-DATA ? /R ;          // Read a value from the AM9511

:CHECK-STATUS ( -- n )
    PORT-STATUS ? /R ;        // Check the status of the AM9511
```

- **`WRITE-TO-AM9511`**: Sends a value to the AM9511 through the data port.
- **`READ-FROM-AM9511`**: Reads a value from the AM9511 through the data port.
- **`CHECK-STATUS`**: Reads the status port to determine if the AM9511 is ready or busy.

#### Step 3: Implement Mathematical Operations

Here’s an example of how to use the AM9511 for a multiplication operation:

```mint
:MULTIPLY ( a b -- result )
    0x02 WRITE-TO-AM9511      // Send multiplication opcode (adjust based on AM9511’s opcodes)
    /S                        // Wait until the AM9511 is ready
    WRITE-TO-AM9511           // Send the first operand
    /S
    WRITE-TO-AM9511           // Send the second operand
    /S
    READ-FROM-AM9511 ;        // Retrieve the result
```

- **`MULTIPLY`**: Sends the multiplication opcode and the operands to the AM9511. The `/S` waits until the status port indicates that the AM9511 is ready to proceed before sending/receiving more data.

### Example Usage

```mint
:CALCULATE
    10 5 MULTIPLY /K          // Multiply 10 by 5 using the AM9511 and display the result
;
```

### Advantages of Integrating AM9511 with MINT

1. **Performance**: The AM9511 can perform arithmetic operations faster than MINT’s software-based solutions, especially for complex operations like floating-point math.
2. **Offloading Calculations**: Using the AM9511 allows MINT to handle other tasks while the arithmetic unit processes calculations in parallel.
3. **Precision**: The AM9511 supports higher precision for mathematical operations, enhancing the capabilities of your MINT programs.

/////////////
