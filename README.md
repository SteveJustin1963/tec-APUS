# tecAPUS


Title
TEC-1 Arithmetic Processing Unit AM9511 and Async MC68B50P Serial I/O

Abstract
TEC1, PC
AM9511-A (4Mhz)
UART, MAX232, DB-9
Oshonsoft
Forth code
Floating-point code
Maths code
Terminal


Introduction 
Now that we have Forth running on the TEC1 
it has become easier to do engineering and scientific projects. 
Iterating through long code to perform 
floating point transcendental subroutines 
in both assembler and Forth sap CPU time and RAM. 

Also using Scientific-Forth libraries 
makes heavy use of higher mathematics for scientific and engineering projects. 

Would offloading maths work to another cpu 
boost performance and reduce memory with less code? 

Is there a cheap and easy option available from the Z80 era? 

Well the “successful and famous Arithmetic Processing Unit the AM9511 from 1977 was. 
It has 14 floating point  instructions in hardware on a single chip.... 
Its a scientific calculator … 
32 bit double precision math (via 16 bit stack/registers) supports… 
ADD, SUB, MUL, DIV, SIN, COS, TAN, ASIN, ACOS, ATAN, LOG, LN, EXP, and PWR.  
Speeds run up to 4-MHz on -A version… 
it can interface with any cpu or mcu… 
designed as a peripheral 
so the cpu assigns a task 
while the AM9511 crunches the maths 
then returns via an interrupt or dma”. 

It’s a no boner for the AM9511 to outperform the Z80 running raw subroutines codes. 
After making the addon APU board, 
a side by test will show by how much its faster. 
The best part this chip is it’s still available and cheap. 
We will also build in a UART 
for dedicated serial to offload the bit banging overhead. 

Cct, use apple II design
Proto
Smoke test
Code it
Run
Code subs


Observe and Question 

Theory - testable

Prediction

Method 

Test

Report, figures, tables


Results

Discuss objectively, scientific significance 

Conclusion 

Acknowledgements

References
http://www.andreadrian.de/oldcpu/Z80_number_cruncher.html
http://www.cpushack.com/2010/09/23/arithmetic-processors-then-and-now/ 

Iterate, new hypotheses or predictions
