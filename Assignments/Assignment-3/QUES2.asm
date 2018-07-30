CPU "8085.TBL"
HOF "INT8"


HXDSP: EQU 034FH
OUTPUT: EQU 0389H

ORG 9000H
	
START: ; set ports for controlling LED
	MVI A,08BH
	OUT 43H
	MVI A,80H ; set initial value to 80h appear like ground floor
	OUT 40H
	MOV C,A ; the current floor is always stored in C reg.
	
UPWARD: ; when going upwards

	CALL WAIT
	IN 41H
	ANA C ; compare if present floor is being occupied and held, restricting furhter movement
	JZ CHECK1 ; check if there is a need to move upward any further

	MVI A,00H ; blink the elevator if current floor occupied
	OUT 40H
	CALL WAIT
	MOV A,C
	OUT 40H
	CALL WAIT
	JMP UPWARD ; loop back
	 
CHECK1: 
	MOV A,C
	SUI 01H
	MOV D,A
	IN 41H
	ANA D
	JZ DOWNWARD ; in case no floor above is requested, go downwards
	MOV A,C
	RRC ; move to next floor
	OUT 40H 
	MOV C,A ; store new floor in C
	JMP UPWARD

		

DOWNWARD: ; indicate going down state
	CALL WAIT
	MVI A,80H
	CMP C ; if on ground floor, go back to upward state

	JZ UPWARD
	MOV A,C 
	RLC ; go down by 1 floor
	OUT 40H
	MOV C,A
CHECK2:	
	IN 41H ; compare if cuurent floor is occupied and blink if it is
	ANA C
	JZ DOWNWARD
	MVI A,00H
	OUT 40H
	CALL WAIT
	MOV A,C
	OUT 40H
	CALL WAIT
	JMP CHECK2
	


WAIT: ; wait funciton available online
	MVI B,02H

OUTLOOP:
	LXI D, 0FFFFH

INLOOP:
	DCX D
	MOV A,D
	ORA E
	JNZ INLOOP
	DCR B
	JNZ OUTLOOP
	RET


	