;**************************************
;**	Test Programm
;**	19 Dec 2012
;** TestLed
;**	Mega8	1MHz
;**
;**************************************

.nolist
; подключение библиотечных файлов
#include"m8def.inc"

.list

; описание вектора прерываний
.cseg
.org 0x000

.org 0x000 rjmp RESET ; Reset Handler
.org 0x001 reti;rjmp EXT_INT0 ; IRQ0 Handler
.org 0x002 reti;rjmp EXT_INT1 ; IRQ1 Handler
.org 0x003 reti;rjmp TIM2_COMP ; Timer2 Compare Handler
.org 0x004 reti;rjmp TIM2_OVF ; Timer2 Overflow Handler
.org 0x005 reti;rjmp TIM1_CAPT ; Timer1 Capture Handler
.org 0x006 reti;rjmp TIM1_COMPA ; Timer1 CompareA Handler
.org 0x007 reti;rjmp TIM1_COMPB ; Timer1 CompareB Handler
.org 0x008 reti;rjmp TIM1_OVF ; Timer1 Overflow Handler
.org 0x009 rjmp TIM0_OVF ; Timer0 Overflow Handler
.org 0x00a reti;rjmp SPI_STC ; SPI Transfer Complete Handler
.org 0x00b reti;rjmp USART_RXC ; USART RX Complete Handler
.org 0x00c reti;rjmp USART_UDRE ; UDR Empty Handler
.org 0x00d reti;rjmp USART_TXC ; USART TX Complete Handler
.org 0x00e reti;rjmp ADC ; ADC Conversion Complete Handler
.org 0x00f reti;rjmp EE_RDY ; EEPROM Ready Handler
.org 0x010 rjmp ANA_COMP ; Analog Comparator Handler
.org 0x011 reti;rjmp TWSI ; Two-wire Serial Interface Handler
.org 0x012 reti;rjmp SPM_RDY ; Store Program Memory Ready Handler
;
;******************************

.dseg
Power: .byte 1


;******************************
.cseg

ANA_COMP:
;	sbic PIND,0
;	rjmp ReSetLed
;	rjmp SetLed
cli
	cbi PORTD,0

	sbi PORTD,1
	nop
	nop
	nop
;	ldi r19,10
;	rcall Delay
	cbi PORTD,1

	LDI ZH,High(2*TableTRIAC)
	LDI ZL,Low(2*TableTRIAC)
	lds r17, Power
	add ZL,r17
	clr r17
	adc ZH,r17
	lpm r16,Z

	;ldi r16,255-5000/64
	out TCNT0,r16
	in r16,TIMSK
	sbr r16,1<<TOIE0
	out TIMSK, r16
	ldi r16,(1<<CS00)+(1<<CS01)
	out TCCR0, r16

sei

;ldi r19,0xFF
;rcall Delay
	reti

TIM0_OVF:
; disable Timer0
	in r16,TIMSK
	cbr r16,0<<TOIE0
	out TIMSK, r16
	clr r16
	out TCCR0, r16

; impuls
	sbi PORTD,0
	ldi r19,1
	rcall Delay
	cbi PORTD,0

	reti


; первоначальный сброс
RESET:
; запрещаем прерывания
	cli

;	инициализация стека
	ldi r16,high(RAMEND); Main program start
	out SPH,r16 ; Set Stack Pointer to top of RAM
	ldi r16,low(RAMEND)
	out SPL,r16

; отключаем аналоговый компаратор для энерго сбережения
	in r16,ACSR
	sbr r16, (1<<ACIE);&(1<<ACBG)
	out ACSR, r16

; работа с портами Ввода/Вывода
	ldi r16, 1<<PUD
	out SFIOR, r16

	ldi r16,0x00
	out DDRB, r16
	ldi r16, 0xFF
	out PORTB, r16

	ldi r16,0b00111111
	out DDRD, r16
	ldi r16, 0x00
	out PORTD, r16

	ldi r16,0x00
	out DDRC, r16
	ldi r16, 0x01
	out PORTC, r16

	
; выключение сторожевого таймера
WDT_off:
; reset WDT
WDR
; Write logical one to WDCE and WDE
in r16, WDTCR
ori r16, (1<<WDCE)|(1<<WDE)
out WDTCR, r16
; Turn off WDT
ldi r16, (0<<WDE)
out WDTCR, r16

;*******************
; очистка всех рабочих регистров

	clr R16
	clr R17
	clr R18
	clr R19
	clr R20
	clr ZL
	clr ZH

	ldi r16,2
	sts Power, r16

; разрешение прерываний
	sei ; Enable interrupts

; основной цикл
main0:

//	sbic PINC,0
	rjmp main0

//	rcall DelayLong

	sbic PIND,7
	rjmp ReSetPower
	rjmp SetPower

SetPower:
	sbi PORTD,7
	rjmp TestPower
ReSetPower:
	cbi PORTD,7
	rjmp TestPower
TestPower:
	sbis PINC,0
	rjmp TestPower
	rjmp main0


; основной цикл
main1:

	LDI ZH,High(2*TableIndicator)
	LDI ZL,Low(2*TableIndicator)
	add ZL,r17
	lpm r18,Z

ldi r19,0xFF
rcall Delay
rcall Delay
rcall Delay
rcall Delay

cbr r18,0x80
out PORTD,r18


	in R16, PINC
	cbr R16, 0xFE
;	ldi r16,0x01
	add r17,r16

	cpi r17,10
	brne main1
	ldi r17,0

	rjmp main1


;
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



TableIndicator:
.db	0b00111111, 0b00000110
.db	0b01011011, 0b01001111
.db	0b01100110, 0b01101101
.db	0b01111101, 0b00000111
.db	0b01111111, 0b01101111

TableTRIAC:
.db 255-(0000/64), 255-(1000/64)
 ;полностью открыт ;90 % мощности
.db 255-(2000/64), 255-(3000/64) 
;80 % мощности	   ;70 % мощности
.db 255-(4000/64), 255-(5000/64) 
;60 % мощности	   ;50 % мощности
.db 255-(6000/64), 255-(7000/64)
;40 % мощности	   ;30 % мощности
.db 255-(8000/64), 255-(9000/64) 
;20 % мощности     ;10 % мощности



