
.equ PORTB = 0x25
.equ DDRB = 0x24
.equ PORTL = 0x10B
.equ DDRL = 0x10A
.equ SPH=0x5E
.equ SPL=0x5D

; timer/counter 1
.equ TCCR1A = 0x80
.equ TCCR1B = 0x81
.equ TCCR1C = 0x82
.equ TCNT1H = 0x85
.equ TCNT1L = 0x84
.equ TIFR1  = 0x36
.equ TIMSK1 = 0x6F
.equ SREG	= 0x5F

.org 0x0000
		jmp setup

.org 0x0028
		jmp timer1_isr
    
.org 0x0050
	
setup:
		ldi r16, high(0x21FF)
		sts SPH, r16
		ldi r16, low(0x21FF)
		sts SPL, r16
		ldi r17, 0xFF
		sts DDRB, r17
		sts DDRL, r17

		call timer_init

lp:		rjmp lp



timer_init:
	
		; reset timer counter to 0
		ldi r16, 0x00
		sts TCNT1H, r16 	; must WRITE high byte first 
		sts TCNT1L, r16		; low byte
		; timer mode
		
		sts TCCR1A, r16
		; prescale 
		; Our clock is 16 MHz, which is 16,000,000 per second
		;
		; scale values are the last 3 bits of TCCR1B:
		;
		; 000 - timer disabled
		; 001 - clock (no scaling)
		; 010 - clock / 8
		; 011 - clock / 64
		; 100 - clock / 256
		; 101 - clock / 1024
		; 110 - external pin Tx falling edge
		; 111 - external pin Tx rising edge

		ldi r16, 0b00000100	; clock / 256
		sts TCCR1B, r16

		; Write your code here: enable timer interrupts
		ldi r16, 0x01
		sts TIMSK1, r16
		sei
		
		ret

timer1_isr:
		push r16
		push r17
		push r18
		lds r16, SREG
		push r16

		;Write your code here: reverse the bits which control the bottom two LEDs, 
    ;thus flashing them alternately -- hint PORTB

		c1:	mov r17, r16
		andi r17, 1
		cpi r17, 1
		brne c2
		ori r17,0b00001000

		c2:	mov r17, r16
		andi r17, 0
		cpi r17, 0
		brne c3
		ori r17,0b00001010
	
		c3:	sts PORTB, r17
	
		; timer interrupt flag is automatically
		; cleared when this ISR is executed
		; per page 168 ATmega datasheet

		pop r16
		sts SREG, r16
		pop r18
		pop r17
		pop r16
		reti
