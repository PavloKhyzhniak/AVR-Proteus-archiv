;************************************
;**
;**
;**
;************************************
EXT_INT0:

		inc Flags; увеличить номер режима
		cpi Flags,7 // проверяем не стал ли номер режима больше, чем их вообще существует
		brsh cc1
int0_fin:
		ldi cnt1,10
dec_int0:
		ldi cnt1,255
		rcall DelaySmall
		dec cnt1
		brne dec_int0

; организуем программный сброс
; флага внешнего прерывания INT0
		in r16, GIFR
		ori r16,0b01000000
		out GIFR, r16
		reti

cc1: 
		clr Flags // тогда обнуляем его(закольцовка)
		rjmp int0_fin

EXT_INT1:

		dec Flags; уменьшить номер режима
		cpi Flags,255 // проверяем не стал ли номер режима меньше нуля
		brsh cc
int1_fin:
		ldi cnt1,10
dec_int1:
		ldi cnt1,255
		rcall DelaySmall
		dec cnt1
		brne dec_int1

; организуем программный сброс
; флага внешнего прерывания INT1
		in r16, GIFR
		ori r16,0b10000000
		out GIFR, r16
		reti

cc: 
		ldi Flags,6 // тогда присваеваем ему максимум режима(закольцовка)
		rjmp int1_fin
