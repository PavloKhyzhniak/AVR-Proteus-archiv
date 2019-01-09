;**************************************
;**	Test Programm
;**	19 Dec 2012
;** TestLed
;**	Mega8	1MHz
;**
;**************************************


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
.org 0x009 reti;rjmp TIM0_OVF ; Timer0 Overflow Handler
.org 0x00a reti;rjmp SPI_STC ; SPI Transfer Complete Handler
.org 0x00b reti;rjmp USART_RXC ; USART RX Complete Handler
.org 0x00c reti;rjmp USART_UDRE ; UDR Empty Handler
.org 0x00d reti;rjmp USART_TXC ; USART TX Complete Handler
.org 0x00e reti;rjmp ADC ; ADC Conversion Complete Handler
.org 0x00f reti;rjmp EE_RDY ; EEPROM Ready Handler
.org 0x010 reti;rjmp ANA_COMP ; Analog Comparator Handler
.org 0x011 reti;rjmp TWSI ; Two-wire Serial Interface Handler
.org 0x012 reti;rjmp SPM_RDY ; Store Program Memory Ready Handler
;

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
	ldi r16,0x80
	out ACSR, r16

; работа с портами Ввода/Вывода
	ldi r16, 1<<PUD
	out SFIOR, r16

	ldi r16,0x00
	out DDRB, r16
	ldi r16, 0xFF
	out PORTB, r16

	ldi r16,0xFF
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



; разрешение прерываний
	sei ; Enable interrupts

rjmp main0

; основной цикл
main0:

	sbic PINC,0
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

Delay:
	ldi r20,0xFF
loop1:
	dec r20
	brne loop1
	dec r19
	brne Delay
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
