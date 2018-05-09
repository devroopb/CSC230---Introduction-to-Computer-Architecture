;
; lab6.asm
;
.include "m2560def.inc"

;SPH, SPL etc are defined in "m2560def.inc"

.cseg
	; initialize the stack pointer
	ldi r16, 0xFF
	out SPL, r16
	ldi r16, 0x21
	out SPH, r16
		
	;call subroutine void strcpy(src, dest)
	;push 1st parameter - src address
	ldi r16, high(src << 1)
	push r16
	ldi r16, low(src <<1)
	push r16

	;push 2nd parameter - des address
	ldi r16, high(dest)
	push r16
	ldi r16, low(dest)
	push r16

	call strcpy

	; clean up the stack
	pop ZL
	pop ZH
	pop r16
	pop r16

	;call subroutine: int strlen(string dest)
	;return value is in r24
	;push parameter dest, note it is in register Z already
	;call the method
	;clear the stack and write the result to length in SRAM
	;write your code here
	ldi r16, high(length)
	push r16
	ldi r16 low(length)
	push r16
	call strlength
	pop r16
	pop r16


done: jmp done

; This subroutine (function) copies a null-terminated string
; starting at some (source) memory address to a location starting at 
; some (destination) memory address.
; The memory addresses are passed to the subroutine via the stack
; WARNING: does not test if source and destination are the same.
strcpy:
	; protect the registers this subroutine uses
	push r30
	push r31
	push r29
	push r28
	push r26
	push r27
	push r23

	; retrieve parameters from the stack
	IN YH, SPH ;SP in Y
	IN YL, SPL
	ldd ZH, Y + 14	; source
	ldd ZL, Y + 13
	ldd XH, Y + 12 ; destination
	ldd XL, Y + 11

	; copy the string from source (Z) to destination (X)
next_char:
	lpm r23, Z+
	st X+, r23
	tst r23
	brne next_char

	; restore the registers that were protected earlier
	pop r23
	pop r27
	pop r26
	pop r28
	pop r29
	pop r31
	pop r30
	ret
	
;One parameter - the address of the string, could be in 
;flash or SRAM (chose one). The length of the string is
;going to be stored in r24
strlength:
	push r24
	ldi r24, -1
inc:inc r24
	ldi r16,Z+
	cpi r16, 0
	brne inc
	ldd XH, X+5
	ldd XL, X+4
	sts x, r24
	pop XL
	pop XH
	pop r24

loop:
	ret

src: .db "Hello, world!", 0 ; c-string format

.dseg
.org 0x200
dest: .byte 14
length: .byte 1
