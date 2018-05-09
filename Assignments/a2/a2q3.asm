;
; a2q3.asm
;
; Write a main program that increments a counter when the buttons are pressed
;
; Use the subroutine you wrote in a2q2.asm to solve this problem.
;
;
; Definitions for PORTA and PORTL when using
; STS and LDS instructions (ie. memory mapped I/O)
;
.equ DDRB=0x24
.equ PORTB=0x25
.equ DDRL=0x10A
.equ PORTL=0x10B

;
; Definitions for using the Analog to Digital Conversion
.equ ADCSRA=0x7A
.equ ADMUX=0x7C
.equ ADCL=0x78
.equ ADCH=0x79


		; initialize the Analog to Digital conversion

		ldi r16, 0x87
		sts ADCSRA, r16
		ldi r16, 0x40
		sts ADMUX, r16

		; initialize PORTB and PORTL for ouput
		ldi	r16, 0xFF
		sts DDRB,r16
		sts DDRL,r16

; Your code here
; make sure your code is an infinite loop
	
	ldi r16,0x00
	mov r0,r16
	
main:
	rcall check_button
	cpi r24,0
	breq nope
	inc r0
	ldi r20,0x03
	rcall delay

nope:rcall display

	jmp main



done:		jmp done		; if you get here, you're doing it wrong
;
; the function tests to see if the button
; UP or SELECT has been pressed
;
; on return, r24 is set to be: 0 if not pressed, 1 if pressed
;
; this function uses registers:
;	r16
;	r17
;	r24
;
; This function could be made much better.  Notice that the a2d
; returns a 2 byte value (actually 12 bits).
; 
; if you consider the word:
;	 value = (ADCH << 8) +  ADCL
; then:
;
; value > 0x3E8 - no button pressed
;
; Otherwise:
; value < 0x032 - right button pressed
; value < 0x0C3 - up button pressed
; value < 0x17C - down button pressed
; value < 0x22B - left button pressed
; value < 0x316 - select button pressed
;
; This function 'cheats' because I observed
; that ADCH is 0 when the right or up button is
; pressed, and non-zero otherwise.
; 
check_button:
		; start a2d
		lds	r16, ADCSRA	
		ori r16, 0x40
		sts	ADCSRA, r16

		; wait for it to complete
wait:	lds r16, ADCSRA
		andi r16, 0x40
		brne wait

		; read the value
		lds r16, ADCL
		lds r17, ADCH

		clr r24
		cpi r17, 0
		brne skip		
		ldi r24,1
skip:	ret

;
; delay
;
; set r20 before calling this function
; r20 = 0x40 is approximately 1 second delay
;
; this function uses registers:
;
;	r20
;	r21
;	r22
;
delay:	
del1:		nop
		ldi r21,0xFF
del2:		nop
		ldi r22, 0xFF
del3:		nop
		dec r22
		brne del3
		dec r21
		brne del2
		dec r20
		brne del1	
		ret

;
; display
;
; copy your display subroutine from a2q2.asm here
 
; display the value in r0 on the 6 bit LED strip
;
; registers used:
;	r0 - value to display
;	r17 - value to write to PORTL
;	r18 - value to write to PORTB
;
;   r16 - scratch
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


