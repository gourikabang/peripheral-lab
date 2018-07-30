CPU "8085.TBL"
HOF "INT8"
GTHEX: EQU 030EH
MEMORY: EQU 0b000H
OUTPUT: EQU 0389H
HXDSP: EQU 034FH
ORG 0c000H

mvi a, 00H  
mvi b, 00H

CALL GTHEX        ;get number into DE			

lxi h, MEMORY     ;HL points to memory location			
mov M, d          ;move d to memory loc pointed by H
INR L	          ;Increment L	
mov M, e          ;move e to memory loc pointed by L
 
mvi a, 00H
mvi b, 00H

CALL GTHEX            ;get second number 		


lxi h, MEMORY		   ;HL points to memory location	
mov b, M               ;move from memory loc pointed by H to register B
INR L                  ;increment L
mov c, M               ;move from memory loc pointed by L to register C

mov a, c	    ;move from register C to Accumulator			
sub e           ;substract e
mov e, a        ;move from accumulator to E

mov a, b        ;move from B to accumulator
sbb d           ;substract with borrow from Accumulator
mov d, a        ;move from acc to d

CALL HXDSP      ;Hexadecimal display

mvi a, 00H
mvi b, 00H
CALL OUTPUT					
HLT             ;Halts the process
