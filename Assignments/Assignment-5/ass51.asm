CPU "8085.TBL"
HOF "INT8"

HXDSP: EQU 034FH
OUTPUT: EQU 0389H
GTHEX: EQU 030EH
RDKBD: EQU 03BAH
CMD55: EQU 03H
PORTA: EQU 00H
MEM: EQU 8000H
ORG 9C00H
MVI A,80H
OUT 03H

MVI A,8BH
OUT 43H

MVI D,000H
MVI E,000H
CALL CONVERT
MOV E,A

LXI H,MEM
MOV M,E

MOV A,M
MVI B,040H
MVI C,001H
DIV:
	SUB B
	JC DIV_EXIT
	INR C
	JMP DIV
DIV_EXIT:
	MVI A,005H
	SUB C
	MOV M,A

MVI D,000H
CALL HXDSP
mvi a, 00H
mvi b, 00H
CALL OUTPUT

MVI A,88H
LOOP:
OUT 00H
CALL DELAY
RRC
JMP LOOP

DELAY:
	PUSH PSW
	LXI H,MEM
	MOV B,M
	MOV L,B
	MVI H,000H

DELAY20:
	LXI D,01111H
DELAY10:
	DCX D
	MOV A,D
	ORA E
	JNZ DELAY10
	DCX H
	MOV A,H
	ORA L
	JNZ DELAY20
	POP PSW
	RET


CONVERT:
	MVI A,000H
	ORA D
	OUT 40H
	MVI A,020H
	ORA D
	OUT 40H
	NOP
	NOP
	MVI A,000H
	ORA D
	OUT 40H

WAIT1:
	IN 42H
	ANI 001H
	JNZ WAIT1

WAIT2:
	IN 42H
	ANI 001H
	JZ WAIT2
	MVI A,040H
	ORA D
	OUT 40H
	OUT 40H
	NOP
	IN 41H
	PUSH PSW
	MVI A,000H
	ORA D
	OUT 40H
	POP PSW
	RET
