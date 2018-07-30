CPU "8085.TBL"       ;monitor routines accessible to users
HOF "INT8"
GTHEX: EQU 030EH
MEMORY: EQU 0b000H
OUTPUT: EQU 0389H
HXDSP: EQU 034FH
ORG 0c000H

mvi a, 00H
mvi b, 00H
CALL GTHEX					;get input from user from keyboard in DE pair
lxi h, MEMORY				;HL register pair now points to memory location
mov M, d                    ;move the value of register D to memory location pointed by H
INR L                       ;increment L to point to nxt location in memory
MOV M, E                    ;move the value of register E to memory location pointed by L
mvi a, 00H
mvi b, 00H
CALL GTHEX					;get input from user from keyboard in DE pair

	LXI H,MEMORY			;HL register pair again points to memory location
	MOV B,M                 ;moves the value stored at memory location pointed by H to register B
	INR L                   ;increment L to point to nxt location in memory
	MOV C,M                 ;moves the value stored at memory location pointed by L to register C
	LXI H,0000H             ;store zero value at register pair HL


	LOOP_2:							;division using repetitive subtraction
		MOV A,C                     ;move value of register C to Accumulator
		SUB E                       ;subtract the value stored at E from accumulator
		MOV C,A                     ;move value from Accumulator to register C
		MOV A,B                     ;move value of register B to Accumulator
		SBB D                       ;subtract with borrow the value stored at D from accumulator
		MOV B,A                     ;move value of Accumulator to register B
		JC D_LOOP_END               ;The program sequence is transferred to a particular level or a 16-bit address if C=1 (or carry is 1)
		MOV A,L                     ;move value of register L to Accumulator
		ADI 01H                     ;Add 1 to Accumulator 
		MOV L,A                     ;move value of Accumulator to register L
		MOV A,H                     ;move value of register H to Accumulator
		ADC 00H                     ;Add with carry to Accumulator
		MOV H,A                     ;move value of Accumulator to register H
		JMP LOOP_2                  ;Jump to LOOP_2

	D_LOOP_END:					;stores output in H and L registers
	MOV D,H                     ;Stores final value from HL to DE for display
	MOV E,L
	
	CALL HXDSP                  ;Displays the value stored in DE on the display
	MVI B, 00H
	MVI A, 00H
	CALL OUTPUT 				; print result
	HLT                          ;Halts the process
