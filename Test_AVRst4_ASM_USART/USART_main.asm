;-------------------------- Подготовка к основному циклу
main0:
error_ignor:

; включить RS485 на прием данных
		cbi PORTD, PortX
; взвод метки ожидание приема байта
		ldi metkaTX,1	
; обнуление счетчика принятых байт
		clr cnt1
; установить флаг глобального прерывания
		sei
;-------------------------- Начало основного цикла
main:

; работа в режиме энергосбережения
;idle:
;		ldi temp, (1<<SE)
;		out MCUCR, temp
;		sleep
;------- пробуждение
;------- код программы
;		rjmp idle

		rjmp answer

		;принимаем данные
g0:		
		cpi metkaTX, 0
		brne g0

/*
; инициализация адресса загрузки
; данных из памяти программ
		ldi	zh, high(dataTX*2)
		ldi	zl, low(dataTX*2)
; инициализация адресса записи
; полученных данных в буфер передачи
		ldi	xh, high(dataTx_buf)
		ldi	xl, low(dataTx_buf)
; инициализация счетчика повторов
		ldi	cnt1, 8
rer:
; загрузить байт памяти программ
		lpm
; инкрементировать адресс
		ld	temp, Z+
; сохранить полученные данные
		mov	temp, r0
; записать косвенно инкрементировать впоследствии
		st	X+, temp
; декремент счетчика до ну его обнуления
		dec	cnt1
		brne	rer
; инициализировать счетчик принятых байт
		ldi	cnt1, 8
*/

; проверим бал ли принят хоть один байт?
		cpi	cnt1, 0
		breq	main
		
;---------------
; обработка полученных данных
	;--------
	;1 инициализация посылки
	;--------
	;--------
	;2 проверка номера задачи
	;--------
	;--------
	;3 взятие данных и использование их
	;--------
	;--------
	;4 формирование ответа
	;--------
;1 этап инициализация
; загрузка адресса полученных данных
		ldi	xh, high(dataRx_buf)
		ldi	xl, low(dataRx_buf)
		inc	xl
		clr	tempL
		adc	xh, tempL
		ld	tempL, X+
		ld	tempH, X+
; загрузка адреса ID
		ldi	zh, high(dataID*2)
		ldi	zl, low(dataID*2)
		rcall	byte2creg
; непосредственно сравниваем
		cp	temp, tempL
		brne error_ignor
		cp	temp1, tempH
		brne error_ignor
; загрузка следующей пары полученных для сравнения
		ld	tempL, X+
		ld	tempH, X+
; загрузить 3й и 4й байт идентификатора
		ld	temp, Z+
		lpm
		mov	temp, r0
		ld	temp1, Z+
		lpm
		mov	temp1, r0
; непосредственно сравниваем
		cp	temp, tempL
		brne error_ignor
		cp	temp1, tempH
		brne error_ignor
; если идентификация прошла успешно...посылка наша..обрабатываем

;2 этап номер задачи
; загрузка адреса номера задачи по приоритету(последовательно)
	;1 запрос на байт из памяти программ
		ld	temp, Z+
		rcall	byte2creg
; загрузка следующей пары полученных для сравнения
		ld	tempL, X+
		ld	tempH, X+
; непосредственно сравниваем
		cp	temp, tempL
		brne other1
		cp	temp1, tempH
		brne other1
; в случае равенства обработка
		rcall hex_work
		rjmp work1
other1:
	;2 запрос на байт из регистрового файла или I/O
		ld	temp, Z+
		rcall	byte2creg
; непосредственно сравниваем
		cp	temp, tempL
		brne other2
		cp	temp1, tempH
		brne other2
; в случае равенства обработка
		rcall hex_work
		rjmp work2
other2:
	;3 специальный ответ
		ld	temp, Z+
		rcall	byte2creg
; непосредственно сравниваем
		cp	temp, tempL
		brne other3
		cp	temp1, tempH
		brne other3
; в случае равенства обработка
		rcall hex_work
		rjmp work3
other3:
; номер не был идентифицирован
; ошибка....
		rjmp error_ignor

;3 этап взятие данных и использование их
work1:
		cpi	temp, 0x00
		breq	error_ignor
		mov zl, temp
		clr zh
		rol zl
		rol zh
		lpm
		mov	temp, r0
		rjmp answer
work2:
		cpi	temp, 0x00
		breq	other3;error_ignor
		mov	zl, temp
		clr	zh
		ld	temp, Z
		rjmp answer
work3:
		out	PORTC, temp
		in	temp, PORTC
		rjmp answer

/*
error_ignor:
; включить RS485 на прием данных
		cbi PORTD, PortX
; взвод метки ожидание приема байта
		ldi metkaTX,1	
; обнуление счетчика принятых байт
		clr cnt1
		rjmp main
*/
answer:
; загрузка адресса ответа
		ldi	xh, high(dataTx_buf)
		ldi	xl, low(dataTx_buf)

		ldi	temp1, START_DATA
		st	X+, temp1
; загрузка адреса ID
		ldi	zh, high(dataID*2)
		ldi	zl, low(dataID*2)
		mov	tempH, temp
		rcall	byte2creg
		st	X+, temp
		st	X+, temp1
; загрузить 3й и 4й байт идентификатора
		ld	temp, Z+
		lpm
		mov	temp, r0
		ld	temp1, Z+
		lpm
		mov	temp1, r0
		
		st	X+, temp
		st	X+, temp1

		rcall nibl_bin
		mov	temp, tempH
		rcall bin_ASCII
		mov	tempH, temp
		mov	temp, tempL
		rcall bin_ASCII
		mov tempL, temp
		st	X+, tempH
		st	X+, tempL

		ldi	temp, END_DATA
		st	X, temp
		
		rjmp	return_answer 
;----------
nibl_bin:
		mov	tempL, tempH
		swap	tempH
		andi	tempL, 0x0F
		andi	tempH, 0x0F
		ret
;----------
bin_ASCII:
		cpi	temp, 10
		brsh ASCII_number
ASCII_alfavit:
		ldi	temp1, 0x30
		add temp,temp1
		ret
ASCII_number:
		ldi	temp1, 0x37
		add temp, temp1 
		ret
;----------

hex_work:
; загрузка пары для перевода чисто в 16 СЧ
		ld	temp1, X+
		rcall	ASCII_hex
		cpi temp, 0xFF
		breq error_number
		lsl	temp
		lsl	temp
		lsl	temp
		lsl	temp
		mov	tempL, temp
		
		ld	temp1, X+
		rcall	ASCII_hex
		cpi temp, 0xFF
		breq error_number
		mov tempH, temp

		add tempL, tempH
		mov temp, tempL
		ret
error_number:
		clr temp
		ret
;-----------
ASCII_hex:
		cpi temp1, 47
		brlo error_hex
		cpi temp1, 58
		brsh hex1
		subi temp1, 48
		mov	temp, temp1
		ret
hex1:
		cpi temp1, 91
		brsh hex2
		cpi temp1, 64
		brlo error_hex
		subi temp1, 64
		rjmp fin_hex
hex2:
		cpi temp1, 123
		brsh error_hex
		cpi temp1, 96
		brlo error_hex
		subi temp1, 96
fin_hex:
		cpi temp1, 7
		brsh error_hex
		ldi temp, 9
		add temp, temp1
		ret
error_hex:
		ldi	temp, 0xFF
		ret

; взятие двух байт из памяти программ
byte2creg:
		lpm
		mov	temp, r0
		ld	temp1, Z+
		lpm
		mov	temp1, r0
		ret

;----------------
return_answer:
/*
;-----------------
; инициализация адресса записи
; полученных данных в буфер передачи
		ldi	xh, high(dataTx_buf)
		ldi	xl, low(dataTx_buf)
; инициализация счетчика повторов
		ldi	cnt1, 8
		ldi temp, 30
rer:
		
; записать косвенно инкрементировать впоследствии
		st	X+, temp
		inc temp
; декремент счетчика до ну его обнуления
		dec	cnt1
		brne	rer
		ldi temp, END_DATA
		st	X+, temp
*/
;--------------
; организуем паузу...
;-----------
		ldi	pausa, 180
l5:		ldi	loop, 201
l6:		rcall	Delay
		dec	loop
		brne	l6
		dec	pausa
		brne	l5
		ldi	pausa, 180
l7:		ldi	loop, 201
l8:		rcall	Delay
		dec	loop
		brne	l8
		dec	pausa
		brne	l7
		ldi	pausa, 180
l9:		ldi	loop, 201
l10:	rcall	Delay
		dec	loop
		brne	l10
		dec	pausa
		brne	l9

;		clr temp
;		out PORTC, temp
;----------
		
;return_answer:
		;возвращаем данные
		sbi	PORTD, PortX
		ldi	temp, 0b00101000
		out	UCSRB, temp
		nop
g1:
		cpi	metkaTX, 0
		brne	g1

		rjmp	main0
;-------------------------- Завершение основного цикла
