cpu "8085.tbl"
hof "int8"

org 9000H

MVI A,80H
OUT 43H             ; port set to A

LOOP:
MVI A, 0FFH      ; FF maps to 5V 
OUT 40H
CALL WAIT1
MVI A, 00H
OUT 40H
CALL WAIT1


MVI A, 0FFH      ; FF maps to 5V 
OUT 40H
CALL WAIT1
MVI A, 00H
OUT 40H
CALL WAIT1


MVI A, 0FFH      ; FF maps to 5V 
OUT 40H
CALL WAIT1
MVI A, 00H
OUT 40H
CALL WAIT1


MVI A, 0FFH      ; FF maps to 5V 
OUT 40H
CALL WAIT1
MVI A, 00H
OUT 40H
CALL WAIT1


MVI A, 0FFH           ; drops to ground
OUT 40H
CALL WAIT1
CALL WAIT1
MVI A,00H
OUT 40H
CALL WAIT1
CALL WAIT1


MVI A, 0FFH           ; drops to ground
OUT 40H
CALL WAIT1
CALL WAIT1
MVI A,00H
OUT 40H
CALL WAIT1
CALL WAIT1

MVI A, 0FFH           ; drops to ground
OUT 40H
CALL WAIT1
CALL WAIT1
MVI A,00H
OUT 40H
CALL WAIT1
CALL WAIT1

JMP LOOP               ; repeat the pattern

WAIT1:
	MVI D,01FFFH
	LOOP1:
		DCX D
		MOV A,D
		ORA E
		JNZ LOOP1
	RET
