![mathsymbols](https://user-images.githubusercontent.com/58069246/171838135-cd012e8d-3afc-4fee-a1ad-d262325995d7.png)
![mc6850 logo](https://user-images.githubusercontent.com/58069246/171838145-857c97a8-20f9-4f20-9e55-17a61abedeef.png)
![am9511 logo](https://user-images.githubusercontent.com/58069246/171838172-8b53f128-2d49-461c-bbdc-c0979105d213.png)



# (A_rithmetic P_rocessing U_nit) AM9511 + (S_erial) MC6850

- Goal...use with MINT and ASM code...
- "I played with it, Craig perfected it...John helped as well...thanks!"
- https://github.com/SteveJustin1963/tec-APUS/wiki



## AM9511 
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


## MC6850

