;
; a2q1.asm
;
; Write a program that displays the binary value in r16
; on the LEDs.
;
; See the assignment PDF for details on the pin numbers and ports.
;
;
;
; These definitions allow you to communicate with
; PORTB and PORTL using the LDS and STS instructions
;
.equ DDRB=0x24
.equ PORTB=0x25
.equ DDRL=0x10A
.equ PORTL=0x10B



		ldi r16, 0xFF
		sts DDRB, r16		; PORTB all output
		sts DDRL, r16		; PORTL all output

		ldi r16, 0x10		; display the value
		mov r0, r16			; in r0 on the LEDs

; Your code here
	ldi r17, 0b00000000
	ldi r18, 0b00000000

	mov r20, r0
	andi r20, 1
	cpi r20, 1
	brne c1
	ori r17,0b10000000

c1:	mov r20, r0
	andi r20, 2
	cpi r20, 2
	brne c2
	ori r17,0b00100000

c2:	mov r20, r0
	andi r20, 4
	cpi r20, 4
	brne c3
	ori r17,0b00001000

c3:	mov r20, r0
	andi r20, 8
	cpi r20, 8
	brne c4
	ori r17,0b00000010

c4:	mov r20, r0
	andi r20, 16
	cpi r20, 16
	brne c5
	ori r18,0b00001000

c5: mov r20, r0
	andi r20, 32
	cpi r20, 32
	brne c6
	ori r18, 0b00000010
	
c6:	sts PORTL, r17
	sts PORTB, r18

	
; Don't change anything below here
;
done:	jmp done
