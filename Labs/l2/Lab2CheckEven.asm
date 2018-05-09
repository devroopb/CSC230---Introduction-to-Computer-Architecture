.cseg
.org 0

.def output =r19
.def input =r18

ldi output, 0x00
ldi input, 0x09

ANDI input, 0x01
CP input, 0x01

breq ODD
brne EVEN

ODD:

r19 : 0xFF
sez

EVEN:
