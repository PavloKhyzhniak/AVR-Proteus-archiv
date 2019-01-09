;**************************************
;**	Test Programm
;**	19 Dec 2012
;** TestLed
;**	Mega8	1MHz
;**
;**************************************


; ����������� ������������ ������
#include"m8def.inc"

.list


; �������� ������� ����������
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
.org 0x010 rjmp ANA_COMP ; Analog Comparator Handler
.org 0x011 reti;rjmp TWSI ; Two-wire Serial Interface Handler
.org 0x012 reti;rjmp SPM_RDY ; Store Program Memory Ready Handler
;
ANA_COMP:

	reti
; �������������� �����
RESET:
; ��������� ����������
	cli

;	������������� �����
	ldi r16,high(RAMEND); Main program start
	out SPH,r16 ; Set Stack Pointer to top of RAM
	ldi r16,low(RAMEND)
	out SPL,r16

; ��������� ���������� ���������� ��� ������ ����������
	in r16,ACSR
	sbr r16, (1<<ACIE);&(1<<ACBG)
	out ACSR, r16

; ������ � ������� �����/������
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

	
; ���������� ����������� �������
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
; ������� ���� ������� ���������

	clr R16
	clr R17
	clr R18
	clr R19
	clr R20
	clr ZL
	clr ZH



; ���������� ����������
	sei ; Enable interrupts

; �������� ����
main0:


	rjmp main0

