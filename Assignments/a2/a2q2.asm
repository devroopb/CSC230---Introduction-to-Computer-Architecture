;
; a2q2.asm
;
;
; Turn the code you wrote in a2q1.asm into a subroutine
; and then use that subroutine with the delay subroutine
; to have the LEDs count up in binary.
;
;
; These definitions allow you to communicate with
; PORTB and PORTL using the LDS and STS instructions
;
.equ DDRB=0x24
.equ PORTB=0x25
.equ DDRL=0x10A
.equ PORTL=0x10B


; Your code here
; Be sure that your code is an infite loop
	
	ldi r16,0x00
	mov r0,r16
	
main:rcall display
	inc r0
	ldi r20,0x0A
	rcall delay
	jmp main

done:		jmp done	; if you get here, you're doing it wrong

;
; display
; 
; display the value in r0 on the 6 bit LED strip
;
; registers used:
;	r0 - value to display
;
display:ldi r17, 0b00000000
	ldi r18, 0b00000000
	
	mov r25, r0
	andi r25, 1
	cpi r25, 1
	brne c1
	ori r17,0b10000000

c1:	mov r25, r0
	andi r25, 2
	cpi r25, 2
	brne c2
	ori r17,0b00100000

c2:	mov r25, r0
	andi r25, 4
	cpi r25, 4
	brne c3
	ori r17,0b00001000

c3:	mov r25, r0
	andi r25, 8
	cpi r25, 8
	brne c4
	ori r17,0b00000010

c4:	mov r25, r0
	andi r25, 16
	cpi r25, 16
	brne c5
	ori r18,0b00001000

c5: mov r25, r0
	andi r25, 32
	cpi r25, 32
	brne c6
	ori r18, 0b00000010
	
c6:	sts PORTL, r17
	sts PORTB, r18

		ret
;
; delay
;
; set r20 before calling this function
; r20 = 0x40 is approximately 1 second delay
;
; registers used:
;	r20
;	r21
;	r22
;
delay:	
del1:	nop
		ldi r21,0xFF
del2:	nop
		ldi r22, 0xFF
del3:	nop
		dec r22
		brne del3
		dec r21
		brne del2
		dec r20
		brne del1	
		ret
