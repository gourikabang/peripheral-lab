CPU "8085.TBL"
HOF "INT8"

MEM: EQU 0A000H ; memory location that act as memory of present state, halted or running

HXDSP: EQU 034FH
OUTPUT: EQU 0389H ; funciton for display

ORG 9000H

	MVI A,08BH
	OUT 43H
	MVI E,01H
	LXI H,MEM
	MVI M,01H

STOP: ; this state is looped if in halted state unless D6 is set low
	
	IN 41H
	MOV D,A
	ANI 04H ; 0 if D6 IS OFF, 0 BIT WILL BE HIGH
	JZ RUNNING
	
	;check for termination
	IN 41H
	MOV D,A
	ANI 40H ; IF D2 IS LOW, ZERO BIT IS HIGH
	JZ END

	JMP STOP




RUNNING: ; this state loops and revolves through LEDs unless D5 is set low
	; display led state in reg E
	LXI H,MEM
	MOV A,M
	OUT 40H
		
	MOV D,A
	CALL HXDSP
	MVI A,01H
	MVI B,00H
	CALL OUTPUT
	

	; change the state to next and store in E
	LXI H,MEM
	MOV A,M
	ADD A
	JNZ INC
	ADI 01H
INC:
	MOV M,A

	CALL WAIT ; calls wait function
	
	;check for termination
	IN 41H
	MOV D,A
	ANI 40H ; IF D2 IS LOW, ZERO BIT IS HIGH
	JZ END
	

	; check for pause
	MOV A,D
	ANI 08H ; IF D5 IS LOW, ZERO BIT WILL BE HIGH
	JZ STOP
	JMP RUNNING
	


END:
	MVI A,00H
	OUT 40H
	RST 5




WAIT: ; delay function
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