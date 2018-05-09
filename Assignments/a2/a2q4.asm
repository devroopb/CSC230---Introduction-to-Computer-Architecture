;
; a2q4.asm
;
; Fix the button subroutine program so that it returns
; a different value for each button
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


		clr r0
		call display
lp:
		call check_button
		tst r24
		breq lp
		mov	r0, r24

		call display
		ldi r20, 99
		call delay
		ldi r20, 0
		mov r0, r20
		call display
		rjmp lp

;
; An improved version of the button test subroutine
;
; Returns in r24:
;	0 - no button pressed
;	1 - right button pressed
;	2 - up button pressed
;	4 - down button pressed
;	8 - left button pressed
;	16- select button pressed
;
; this function uses registers:
;	r24
;
; if you consider the word:
;	 value = (ADCH << 8) +  ADCL
; then:
;
; value > 0x3E8 - no button pressed
;
; Otherwise:
; value < 0x032 - right button pressed (first part is r17, second part is r16)
; value < 0x0C3 - up button pressed
; value < 0x17C - down button pressed
; value < 0x22B - left button pressed
; value < 0x316 - select button pressed
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

		; put your new logic here:
	
		clr r24

right:  cpi r17,0
		brne down1
		cpi r16,0x32
		brsh up
		ldi r24,1
		ret

		
up:		cpi r17,0
		brne down1
		cpi r16,0xC3
		brsh down0
		ldi r24,2
		ret

down0:	cpi r17,0
		brne down1
		ldi r24,4
		ret

down1:	cpi r17,1
		brne left2
		cpi r16,0x7C
		brsh left1
		ldi r24,4
		ret

left1:	cpi r17,1
		brne left2
		ldi r24,8
		ret

left2:	cpi r17,2
		brne select3
		cpi r16,0x2B
		brsh select2
		ldi r24,8
		ret

select2:cpi r17,2
		brne select3
		ldi r24,16
		ret

select3:cpi r17,3
		brne skip
		cpi r16,0x16
		brsh skip
		ldi r24,16
	


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

