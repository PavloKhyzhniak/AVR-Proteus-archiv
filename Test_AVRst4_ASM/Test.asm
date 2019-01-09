;**************************************
;**	Test Programm
;**	12 Jan 2013
;** Test List for Study
;**	Mega8	1MHz
;** Blackveolet
;**************************************

.nolist
; подключение библиотечных файлов
#include"m8def.inc"
.list
; Директива DEVICE позволяет указать для какого устройства компилируется программа.
; При использовании данной директивы компилятор выдаст предупреждение, если будет 
; найдена инструкция, которую не поддерживает данный микроконтроллер. Также будет выдано
; предупреждение, если программный сегмент, либо сегмент EEPROM превысят размер допускаемый устройством. 
; Если же директива не используется то все инструкции считаются допустимыми, и отсутствуют ограничения на размер сегментов.
.device ATmega8


; описание вектора прерываний

; выбор сегмента памяти программ
.cseg
; Reset Handler
.org 0x000 rjmp RESET ; Reset Handler
; IRQ0 Handler
.org 0x001 reti;rjmp EXT_INT0 ; IRQ0 Handler
; IRQ1 Handler
.org 0x002 reti;rjmp EXT_INT1 ; IRQ1 Handler
; Timer2 Compare Handler
.org 0x003 reti;rjmp TIM2_COMP ; Timer2 Compare Handler
; Timer2 Overflow Handler
.org 0x004 reti;rjmp TIM2_OVF ; Timer2 Overflow Handler
; Timer1 Capture Handler
.org 0x005 reti;rjmp TIM1_CAPT ; Timer1 Capture Handler
; Timer1 CompareA Handler
.org 0x006 reti;rjmp TIM1_COMPA ; Timer1 CompareA Handler
; Timer1 CompareB Handler
.org 0x007 reti;rjmp TIM1_COMPB ; Timer1 CompareB Handler
; Timer1 Overflow Handler
.org 0x008 reti;rjmp TIM1_OVF ; Timer1 Overflow Handler
; Timer0 Overflow Handler
.org 0x009 reti;rjmp TIM0_OVF ; Timer0 Overflow Handler
; SPI Transfer Complete Handler
.org 0x00a reti;rjmp SPI_STC ; SPI Transfer Complete Handler
; USART RX Complete Handler
.org 0x00b reti;rjmp USART_RXC ; USART RX Complete Handler
; UDR Empty Handler
.org 0x00c reti;rjmp USART_UDRE ; UDR Empty Handler
; USART TX Complete Handler
.org 0x00d reti;rjmp USART_TXC ; USART TX Complete Handler
; ADC Conversion Complete Handler
.org 0x00e reti;rjmp ADC ; ADC Conversion Complete Handler
; EEPROM Ready Handler
.org 0x00f reti;rjmp EE_RDY ; EEPROM Ready Handler
; Analog Comparator Handler
.org 0x010 reti;rjmp ANA_COMP ; Analog Comparator Handler
; Two-wire Serial Interface Handler
.org 0x011 reti;rjmp TWSI ; Two-wire Serial Interface Handler
; Store Program Memory Ready Handler
.org 0x012 reti;rjmp SPM_RDY ; Store Program Memory Ready Handler


;описание всех РОНов
.def tmpL	= r16	;главный рабочий регистр(младший)
.def tmpH	= r17	;главный рабочий регистр(старший)
.def tmpL2	= r18	;вспомогательный рабочий регистр(младший)
.def tmpH2	= r19	;вспомогательный рабочий регистр(старший)
.def tmp1	= r20	;пользовательский 1 регистр
.def tmp2	= r21	;пользовательский 1 регистр
.def tmp3	= r22	;пользовательский 1 регистр
.def DataL	= r23	;регистр данных(младший)
.def DataH	= r24	;регистр данных(старший)
.def cnt1	= r25	;главный счетчик регистр
.def Flags	= r26	;регистр флагов

// организуем подключение всех файлов проекта
#include"DSEG.inc"		;файл резервирования переменных в ОЗУ и инициализация констант и таблиц
#include"EEPROM.inc"	;файл работы с энергонезависимой памятью
#include"RESET.inc" 	;файл инициализации(сброса)
#include"EXT_INT.inc"	;файл обработки внешних прерываний
#include"TIM0.inc"		;файл работы с Таймером0
#include"ANA_COMP.inc"	;файл работы с Аналоговым компоратором
#include"Delay.inc"		;файл организации задержек
#include"SubRouters.inc"

//организуем бесконечный цикл
main:	
; тут распологаем все команды нашей программы	

	rjmp main


; тест МК
cli
ldi r16, 0xFF
;out DDRB, r16
out PORTB, r16
nop
nop
nop
nop
ldi r16, 0xFF
;out DDRB, r16
clr r16
out PORTB, r16
nop
nop
nop

		rjmp main
