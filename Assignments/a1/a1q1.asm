;
; CSc 230 Assignment 1 
; Question 1
; Author: Jason Corless
; Modified: Sudhakar Ganti

; This program should calculate:
; R0 = R16 + R17 + R18
;
;--*1 Do not change anything between here and the line starting with *--
.cseg
	ldi	r16, 0x20
	ldi r17, 0x21
	ldi r18, 0x22
;*--1 Do not change anything above this line to the --*

;***
;-------------------------
; Question: Why did we use r16 to r18? Can we use r0 to 15?
; Answer: We used r16 r18 because only registers between 16 to 31 can load constants. Hence no, r0 to r15 can not be used for this.
;-------------------------
; Your code goes here:
;
	add r17,r18
	add r16,r17
	add r0,r16

;****

;--*2 Do not change anything between here and the line starting with *--
done:	jmp done
;*--2 Do not change anything above this line to the --*


