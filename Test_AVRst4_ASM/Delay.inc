;************************************
;** Файл организациии задержек программным способом
;**
;**
;************************************

; r19 =0 519 тактов
; r19 =1 519 тактов
; r19 =2 519+501 татов
Delay:
	push r20
	push r19

	cpi r19,0
	brne loop0
	ldi r19,1
loop0:
	ldi r20,0xA6
loop1:
	dec r20
	brne loop1
	dec r19
	brne loop0

	pop r19
	pop r20
	ret

;************************************
DelaySmall:
		push r16
		ldi r16, 255
delay_loop:
		nop
		dec r16
		brne delay_loop
		pop r16
		ret
;************************************
DelayLong:
	push r20
	push r21
	push r22

	ldi r22, 0xFF
loopL2:
	ldi r21, 0xFF
loopL1:
	ldi r20,0xFF
loopL0:
	dec r20
	brne loopL0
	dec r21
	brne LoopL1
	dec r22
	brne LoopL2

	pop r22
	pop r21
	pop r20
	ret
