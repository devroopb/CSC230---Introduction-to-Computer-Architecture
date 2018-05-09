/*
Devroop Banerjee
V00837868
CSC 230
Assignment 3
*/

#define LCD_LIBONLY
.include"lcd.asm"

.cseg

	call lcd_init
	call lcd_clr
	call init_msg1_msg2_msg3

	ldi r16,3
	call big_loop


big_loop:
	call display_strings
	call delay
	call line_one_first_line
	call delay
	call line_one_second_line
	call delay
	call line_two_first_line
	call delay
	call line_two_second_line
	call delay

	dec r16
	cpi r16,0x00
	brne big_loop

lp:	call lcd_clr
	call delay
	call star
	call delay

	jmp lp

init_msg1_msg2_msg3:
	push r16
	ldi r16, high(msg1)	
	push r16
	ldi r16, low(msg1)
	push r16
	ldi r16, high(msg1_p << 1) 
	push r16
	ldi r16, low(msg1_p << 1)
	push r16
	call str_init		
	pop r16				
	pop r16
	pop r16
	pop r16

	ldi r16, high(msg2)
	push r16
	ldi r16, low(msg2)
	push r16
	ldi r16, high(msg2_p << 1)
	push r16
	ldi r16, low(msg2_p << 1)
	push r16
	call str_init
	pop r16
	pop r16
	pop r16
	pop r16
	
	ldi r16, high(msg3)
	push r16
	ldi r16, low(msg3)
	push r16
	ldi r16, high(msg3_p << 1)
	push r16
	ldi r16, low(msg3_p << 1)
	push r16
	call str_init
	pop r16
	pop r16
	pop r16
	pop r16


	pop r16
	ret

display_strings:
	push r16
	call lcd_clr
	
	call part1
	call l1
	call part2
	call l2

	pop r16
	ret

star:
	push r16
	call lcd_clr

	call part1
	call l3
	call part2
	call l3

	pop r16
	ret

line_one_first_line:				
 	push r16
	call lcd_clr
	ldi r25,0x00		
lp1:
	call m1
	inc r25

	call part1
	call l1
	call delay
	call lcd_clr

	cpi r25,0x11
	brne lp1
	pop r16
	ret

line_two_first_line:				 
 	push r16	
	call lcd_clr
	ldi r25,0x00	
lp3:	
 	call m1
	inc r25

	call part3
	call l1
	call delay
	call lcd_clr

	cpi r25,0x11
	brne lp3
	pop r16
	ret

line_one_second_line:				
 	push r16
	call lcd_clr
	ldi r25,0x00	
lp2:
	call m2
	inc r25

	call part1
	call l2
	call delay
	call lcd_clr

	cpi r25,0x13
	brne lp2
	pop r16
	ret

line_two_second_line:				 
 	push r16
	call lcd_clr
	ldi r25,0x00	
lp4:
	call m2
	inc r25

	call part3
	call l2
	call delay
	call lcd_clr

	cpi r25,0x13
	brne lp4
	pop r16
	ret

part1:
	ldi r17, 0x00
	push r17
	ldi r17, 0x00
	push r17
	call lcd_gotoxy
	pop r17
	pop r17
	ret

part2:
	ldi r18, 0x01
	push r18
	ldi r18, 0x00
	push r18
	call lcd_gotoxy
	pop r18
	pop r18
	ret

part3:
	ldi r19, 0x01
	push r19
	ldi r19, 0x01
	push r19
	call lcd_gotoxy
	pop r19
	pop r19
	ret

l1:
	ldi r17, high(msg1)
	push r17
	ldi r17, low(msg1)
	push r17
	call lcd_puts
	pop r17
	pop r17
	ret

m1:
	ldi r17, high(msg1)
	push r17
	ldi r17, low(msg1)
	push r17
	ldi r17, high(msg1_p << 1)
	push r17
	ldi r17, low(msg1_p << 1)
	add r17,r25
	push r17
	call str_init
	pop r17
	pop r17
	pop r17
	pop r17
	ret

l2:
	ldi r18, high(msg2)
	push r18
	ldi r18, low(msg2)
	push r18
	call lcd_puts
	pop r18
	pop r18
	ret

m2:
	ldi r18, high(msg2)
	push r18
	ldi r18, low(msg2)
	push r18
	ldi r18, high(msg2_p << 1)
	push r18
	ldi r18, low(msg2_p << 1)
	add r18,r25
	push r18
	call str_init
	pop r18
	pop r18
	pop r18
	pop r18
	ret

l3:
	ldi r19, high(msg3)
	push r19
	ldi r19, low(msg3)
	push r19
	call lcd_puts
	pop r19
	pop r19
	ret

;Taken from implementation of delay provided earlier in labs

delay:	
		ldi r20,0x10
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

;Taken from the Implementation help provided by instructor

	msg1_p: .db "Devroop Banerjee", 0
	msg2_p: .db "CSC 230: Fall 2016", 0
	msg3_p: .db "      ****", 0

.dseg
	msg1: .byte 200
	msg2: .byte 200
	msg3: .byte 200

	line1: .byte 17
	line2: .byte 17
	line3: .byte 17
