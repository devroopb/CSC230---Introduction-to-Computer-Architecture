;
; lab 5
; 

.include "m2560def.inc"

.cseg

	ldi ZH,high(msg<<1)	; initialize index register Z to point to msg in flash memory
	ldi ZL,low(msg<<1) ;why msg<<1

	;write your code here, initialize index register X to point to msg_copy in SRAM

	ldi r16, -1		;initialize counter to -1
	ldi XH,high(msg_copy)
	ldi XL,low(msg_copy)		

next_char:
	;write your code here
	;get the length of the string, store it at str_len in SRAM
  ;write a loop, copy each character from flash memory to at msg_copy in SRAM
	
	ld r27,X
	lpm r17,Z+
	st X+,r17
	inc r16
	cpi r17,0
	breq length
	jmp next_char
length:	sts str_len, r16
	

done:	jmp done

msg: .db "Hello, world!", 0 ; c-string format

.dseg
.org 0x200
msg_copy: .byte 14
str_len: .byte 1

