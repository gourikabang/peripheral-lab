CPU "8085.TBL"
HOF "INT8"

MEMORY: EQU 9600H
TUNNEL: EQU 8FBFH
HXDSP: EQU 034FH
OUTPUT: EQU 0389H
HHMM: EQU 0930H
SEC: EQU 00H
RDKBD: EQU 03BAH
GTHEX: EQU 030EH

TEMP_MEMORY: EQU 9605H



	ORG 09000H					;loads initially set hours, min and sec into registers for display
	LXI D, HHMM
	MVI C, SEC
	LXI H, MEMORY
	MOV M, D             ;sets hour in memory 
	INR L                   ;increment memory to access min
	MOV M, E               ;minute
	INR L               ;increment for second
	MOV M, C       ;second
	MVI A, 0BH
	INR L
	MVI M,00H
	SIM         ;set interuppt mask

DISPLAY:					;displays the time
	EI                        ;enable interrupt
	LXI H, MEMORY
	MVI A,00H
	MOV D, M           ;loads hour to d for leftmost display
	INR L                ;increment for  minute
	MOV E, M     ;loads minute for display 
	INR L               ;increment second
	MOV C, M                       ;loads second to rightmost for display
 
	
LOAD:	CALL HXDSP   ;converts hexadecimal for display
	MVI A, 00H   
	MVI B, 00H
	CALL OUTPUT    ;displays the time for hour and minute
	LXI H,MEMORY  
	INR L  
	INR L   ;twice increment to access second
	MOV D, M
	CALL HXDSP   ;readies for display
	MVI A, 01H
	CALL OUTPUT   ;outputs time for second

START:

	CALL DELAY					;calls a one sec delay
	CALL INC_SEC					;increments second

	JMP START    ;unconditional jump
	RST 5

INC_SEC:

	LXI H, MEMORY
	INR L
	INR L           ;twice increment for second
	MOV A, M
	ADI 01H          ;incrementing by one
	DAA        ;decimal adjust accumlator
	MOV D, A
	MVI A,60H    ;putting 60 in a to compare
	CMP D               ;compare
	JNZ NO_FULL_SEC          ;if it is 60 then put second to 0 
	CALL INC_MIN					;if sec is 60 calls increment minute
	MVI D, 00H   ;puts second to 0


NO_FULL_SEC:       

	LXI H, MEMORY
	INR L
	INR L    ;twice increment for second
	MOV M, D
	CALL HXDSP    ;converts hexadecimal for display
	MVI A, 01H
	MVI B, 00H      
	CALL OUTPUT
	RET            ;return unconditionally

INC_MIN:							;increments minute

	LXI H, MEMORY
	MOV D, M
	INR L          ;once increment for minute
	MOV A, M
	ADI 01H           ;incrementing by one
	DAA                 ;converting to BCD for display
	MOV E, A
	MVI A, 60H       ;stores 60 in accumulator
	CMP E               ;if it is 60
	JNZ NO_FULL_MIN		;increments minute if min < 60
	CALL INC_HOUR        ;increment hour
	MVI E, 00H           ;sets to 0

NO_FULL_MIN:							

	LXI H, MEMORY
	MOV D, M
	INR L      ;increment to access second
	MOV M, E
	CALL HXDSP   ;converts hexadecimal for display
	MVI A, 00H    
	MVI B, 00H
	CALL OUTPUT      ;displays the minute
	RET

INC_HOUR:							;increments hour

	LXI H, MEMORY
	MOV A, M
	ADI 01H      ;increment hour by 1
	DAA                ;converts to BCD for display
	MOV D, A       
	MVI A, 24H     ;stored to accumulator for display
	CMP D               ;checks if hour is 24
	JNZ NO_FULL_HOUR		;goes to the NO_FULL_HOUR
	MVI D, 00H

NO_FULL_HOUR:		;stores hour to memory

	MOV M, D
	RET

DELAY:     ;time delay so that it clocks one second

	MVI B,02H

