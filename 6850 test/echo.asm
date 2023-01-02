;-------------------------------------------------
;Z80 DISASSEMBLER LISTING
;Label  Instruction
;-------------------------------------------------

        DI
        JP L0001
         
        NOP
        JP L0002
        
        RET
L0001:  LD SP,0000H
        LD IX,0845H
        CALL L0003
        LD HL,016EH
        CALL L0004
        JR L0005
L0011:  JP L0006
L0005:  CALL L0007
        CALL L0008
        CP 0DH
        JP Z,L0009
        JP L0010
L0009:  LD A,0AH
        CALL L0008
L0010:  CP 03H
        JP Z,L0011
        JP L0005
L0006:  LD HL,017CH
        CALL L0004
        DI
        HALT
L0004:  LD C,(HL)
        LD B,00H
        INC HL
        JR L0012
L0014:  JP L0013
L0012:  LD A,(HL)
        CALL L0008
        INC HL
        DEC BC
        LD A,C
        OR B
        JP Z,L0014
        JP L0012
L0013:  RET
L0003:  LD HL,0000H
        LD (0804H),HL
        LD HL,0806H
        LD (0800H),HL
        LD (0802H),HL
        LD A,96H
        OUT (80H),A
        IM 1
        EI
        RET
L0002:  PUSH AF
        PUSH HL
        IN A,(80H)
        AND 01H
        JP NZ,L0015
        JP L0016
L0015:  IN A,(81H)
        CALL L0017
L0016:  POP HL
        POP AF
        EI
        RET
L0017:  PUSH AF
        LD A,(0804H)
        CP 3FH
        JP Z,L0018
        JP L0019
L0018:  POP AF
        RET
L0019:  LD HL,(0800H)
        INC HL
        LD A,L
        CP 45H
        JP Z,L0020
        JP L0021
L0020:  LD HL,0806H
L0021:  LD (0800H),HL
        POP AF
        LD (HL),A
        LD A,(0804H)
        INC A
        LD (0804H),A
        CP 30H
        JP NC,L0022
        JP L0023
L0022:  LD A,0D6H
        OUT (80H),A
L0023:  RET
L0008:  PUSH AF
        JR L0024
L0026:  JP L0025
L0024:  IN A,(80H)
        BIT 1,A
        JP NZ,L0026
        JP L0024
L0025:  POP AF
        OUT (81H),A
        RET
L0029:  LD A,(0804H)
        CP 00H
        RET
L0007:  PUSH HL
        JR L0027
L0030:  JP L0028
L0027:  CALL L0029
        JP NZ,L0030
        JP L0027
L0028:  LD HL,(0802H)
        INC HL
        LD A,L
        CP 45H
        JP Z,L0031
        JP L0032
L0031:  LD HL,0806H
L0032:  DI
        LD (0802H),HL
        LD A,(0804H)
        DEC A
        LD (0804H),A
        CP 05H
        JP C,L0033
        JP L0034
L0033:  LD A,96H
        OUT (80H),A
L0034:  LD A,(HL)
        EI
        POP HL
        RET
        DEC C
        LD B,L
        LD H,E
        LD L,B
        LD L,A
        JR NZ,L0035
        JR NC,L0036
        JR NC,L0037
        LD A,(BC)
        DEC C
        LD A,(BC)
        LD A,(BC)
        DEC C
        LD A,(BC)
        DEC C
        LD A,(BC)
        LD H,H
        LD L,A
        LD L,(HL)
        LD H,L
        DEC C
L0037:  LD A,(BC)
         
L0035:  NOP
        NOP
L0036:  NOP
        
         
      
