ORG 00H		; Set the origin to 00H
AJMP MAIN	 ; Jump to MAIN label to start the program

MAIN: 
      MOV A, #00H       	; move value 0 into register A
      MOV P1, A         	; set P1 as 0 (output for led)
      MOV A, #0FFH      	; move value 1 into register A
      MOV P3, A         	; set P3 as 1 (input for tactile switch - lock/unlock)
      MOV A, #0FFH      	; move value 1 into register A
      MOV P2, A         	; set P2 as 1 (input for dip switch - password)
      
START:
RESET:
	MOV A, #02H 		; Move value 0x02 into register A
      	MOV P1, A		; Set P1 to 0x02, which lights up yellow LED 

      	MOV A,P2		; Move the value of P2 into register A
	MOV P0,A		; Transfer the value from Register A to Port 0 (P0)

	JNB P3.0,LOCKED		; If lock button (P3.0) is pressed, jump to LOCKED state
	AJMP RESET
	
LOCKED:
	MOV A,#01H		 ; Move value 0x01 into register A
	MOV P1,A		 ; Set P1 to 0x01, which lights up red LED 

	JNB P3.1 ,CHECKPASSWORD	; If P3.1 (unlock button) is pressed, jump to CHECKPASSWORD	
	AJMP LOCKED		 ; If unlock button is not pressed, stay in LOCKED state

CHECKPASSWORD:
	MOV A,P0		 ; Move the value of P0 into A (the input from the password switch)
	CJNE A, P2, BLINK 	; Compare A with stored password (P2); if different, jump to BLINK
	AJMP UNLOCKED		 ; If passwords match, jump to UNLOCKED state

UNLOCKED:
	MOV A,#04H	 ; Move value 0x04 into register A
	MOV P1,A	; Set P1 to 0x04, which lights up green LED 

	JNB P3.0,BOTHPRESSED	; If  P3.0 (lock button is pressed, jump to BOTHPRESSED)
	AJMP UNLOCKED		; If both buttons are not pressed, stay in UNLOCKED state
	

BOTHPRESSED:
	ACALL DELAY		; Call the delay subroutine
	JNB P3.1,RESET         ;if both lock and unlock are being pressed ,jump to RESET
	JNB P3.0,LOCKED        ;if only lock button is being pressed jump to LOCKED



BLINK:
   	MOV R7, #03H     ; Move 03H to R7 to Blink LED 3 times 
BLINK_LOOP:
    	CPL P1.0         	 ; Toggle Red LED (P1.0)
    	ACALL DELAY     	 ; Call the delay subroutine
    	DJNZ R7, BLINK_LOOP  	 ; Derement R7,jump to BLINK LOOP IF NOT EQUAL TO ZERO(Repeat 3 times)
   	AJMP LOCKED     	 ; Return to LOCKED state after blinking

  
DELAY: 
      MOV R1, #0FFH      ;Set R1 for outer delay loop
DELAY1: 
      MOV R2, #0FFH     ;; Set R2 for inner delay loop
DELAY2: 
     DJNZ R2, DELAY2	; Decrement R2 and repeat until zero
      DJNZ R1, DELAY1	; Decrement R1 and repeat outer loop until zero
      RET		; Return from subroutine

END			 ; End of program


