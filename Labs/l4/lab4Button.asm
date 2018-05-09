; Modified by: Sudhakar Ganti, Fall 2016
; button.asm
;
; A program that demonstrates reading the buttons
; This programs turns off the LED on pin 52 for
; a delay duration and turns it on again if 
; "right" or "up" button is pressed. Otherwise
; LED is on continously
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


  ;First Initilize built-in Analog to Digital Converter
		; initialize the Analog to Digital converter
		ldi r16, 0x87
		sts ADCSRA, r16
		ldi r16, 0x40
		sts ADMUX, r16

		; initialize PORTB and PORTL for ouput
		ldi	r16, 0xFF
		sts DDRB,r16
		sts DDRL,r16



lp:
		ldi r19, 0b00000010 ; turn on LED on pin 52
		sts PORTB, r19

		call check_button   ; check to see if a button is pressed 
		cpi  r24, 1         ; Register R24 is set to 1 if "right" or "up" pressed
		brne lp

		ldi r19, 0x00       ; turn off LED if "right" or "up" pressed
		sts PORTB, r19
		ldi	r20, 0x40
		call delay
		rjmp lp             ; Go back to main loop after a short delay

;
; the function tests to see if the button
; UP or RIGHT has been pressed
;
; on return, r24 is set to be: 0 if not pressed, 1 if pressed
;
; this function uses registers:
;	r16
;	r17
;	r24
;
; This function could be made much better.  Notice that the a2d
; returns a 2 byte value (actually 10 bits).
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
; pressed, and non-zero otherwise.  Hence this
; works only for these buttons. Need to modify
; to take care of all button presses

check_button:
		; start a2d conversion
		lds	r16, ADCSRA	  ; get the current value of SDRA
		ori r16, 0x40     ; set the ADSC bit to 1 to initiate conversion
		sts	ADCSRA, r16

		; wait for A2D conversion to complete
wait:	lds r16, ADCSRA
		andi r16, 0x40     ; see if conversion is over by checking ADSC bit
		brne wait          ; ADSC will be reset to 0 is finished

		; read the value avialble as 10 bits in ADCH:ADCL
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

		ldi r20, 0x40
del1_2:	nop
		ldi r21,0xFF
del2_2:	nop
		ldi r22, 0xFF
del3_2:	nop
		dec r22
		brne del3_2
		dec r21
		brne del2_2
		dec r20
		brne del1_2

		ret
				
;write the delay function here
