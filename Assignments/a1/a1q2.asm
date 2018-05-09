;
; CSc 230 Assignment 1 
; Question 2
; Author: Jason Corless
 ; Modified: Sudhakar Ganti
 
; This program should calculate:
; R0 = R16 + R17
; if the sum of R16 and R17 is > 255 (ie. there was a carry)
; then R1 = 1, otherwise R1 = 0
;

;--*1 Do not change anything between here and the line starting with *--
.cseg
	ldi	r16, 0xF0
	ldi r17, 0x21
;*--1 Do not change anything above this line to the --*

;***
;---------------------------
;Question: What are we trying to do in this program? What is the
;meaning of if sum > 255 then set R1=1?
;Why did we say that if sum > 255 then there was a carry?
;Answer: We are adding constants stored in r16 and r17 and storing that to r0. Since each register is 8 bits, it can hold any value between 0 and 255. Hence if the sum calculated exceeds 255, then we carry the 1 extra bit over to r1.
;---------------------------
; Your code goes here:
;	
	adc r16,r17
	brcc noCF

	add r0,r16
	ldi r17,0x01
	mov r1,r17

	noCF:	add r0,r16

;****
;--*2 Do not change anything between here and the line starting with *--
done:	jmp done
;*--2 Do not change anything above this line to the --*

