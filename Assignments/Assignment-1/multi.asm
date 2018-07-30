CPU "8085.TBL"                ;monitor routines accessible to users
HOF "INT8" 
GTHEX: EQU 030EH
MEMORY: EQU 0b000H
OUTPUT: EQU 0389H
HXDSP: EQU 034FH
ORG 0c000H                    ;starting address

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


	LXI H,MEMORY					;HL register pair again points to memory location
	MOV B,M                         ;moves the value stored at memory location pointed by H to register B 
	INR L                           ;increment L to point to nxt location in memory
	MOV C,M 						;moves the value stored at memory location pointed by L to register C
	MVI H,00H                       ;store zero value at register pair HL
	MVI L,00H
	PUSH D                          ;push the register pair DE into the stack

	LOOP:							;multiplication proceeds by repetative addition
		POP D	           
		MOV A,L                     ;move value of register L to Accumulator
		ADD E                       ;add the value stored at E to accumulator
		MOV L,A                     ;move value of Accumulator to register L
		MOV A,H                     ;move value of register H to Accumulator
		ADC D                       ;add with carry the value stored at D to accumulator
		MOV H,A                     ;move value of Accumulator to register H
		
		PUSH D
		
		MVI D,00H						;SUBTRACT 1 FROM BC NOW
		MVI E,01H                       
		
		MOV A,C                     ;move value of register C to Accumulator
		SUB E                       ;subtract the value stored at E from accumulator
		MOV C,A                     ;move value of Accumulator to register C
		MOV A,B                     ;move value of register B to Accumulator
		SBB D                       ;subtract with borrow the value stored at D from accumulator
		MOV B,A                     ;move value of Accumulator to register B

		MVI A,00H                   
		CMP C                       ;check if C is zero
		JNZ LOOP                    ;if yes exit loop  
		CMP B                       ;check if B is zero
		JNZ LOOP                    ;if yes,exit loop
	POP D 						
	MOV D,H                         ;final output which is in HL is moved to DE
	MOV E,L
	
	CALL HXDSP                      ;hexadecimal for display
	MVI B, 00H                  
	MVI A, 00H
	CALL OUTPUT						;print result stored in DE
	HLT                             ;halt the program