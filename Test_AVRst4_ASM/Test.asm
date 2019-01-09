;**************************************
;**	Test Programm
;**	12 Jan 2013
;** Test List for Study
;**	Mega8	1MHz
;** Blackveolet
;**************************************

.nolist
; ����������� ������������ ������
#include"m8def.inc"
.list
; ��������� DEVICE ��������� ������� ��� ������ ���������� ������������� ���������.
; ��� ������������� ������ ��������� ���������� ������ ��������������, ���� ����� 
; ������� ����������, ������� �� ������������ ������ ���������������. ����� ����� ������
; ��������������, ���� ����������� �������, ���� ������� EEPROM �������� ������ ����������� �����������. 
; ���� �� ��������� �� ������������ �� ��� ���������� ��������� �����������, � ����������� ����������� �� ������ ���������.
.device ATmega8


; �������� ������� ����������

; ����� �������� ������ ��������
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


;�������� ���� �����
.def tmpL	= r16	;������� ������� �������(�������)
.def tmpH	= r17	;������� ������� �������(�������)
.def tmpL2	= r18	;��������������� ������� �������(�������)
.def tmpH2	= r19	;��������������� ������� �������(�������)
.def tmp1	= r20	;���������������� 1 �������
.def tmp2	= r21	;���������������� 1 �������
.def tmp3	= r22	;���������������� 1 �������
.def DataL	= r23	;������� ������(�������)
.def DataH	= r24	;������� ������(�������)
.def cnt1	= r25	;������� ������� �������
.def Flags	= r26	;������� ������

// ���������� ����������� ���� ������ �������
#include"DSEG.inc"		;���� �������������� ���������� � ��� � ������������� �������� � ������
#include"EEPROM.inc"	;���� ������ � ����������������� �������
#include"RESET.inc" 	;���� �������������(������)
#include"EXT_INT.inc"	;���� ��������� ������� ����������
#include"TIM0.inc"		;���� ������ � ��������0
#include"ANA_COMP.inc"	;���� ������ � ���������� ������������
#include"Delay.inc"		;���� ����������� ��������
#include"SubRouters.inc"

//���������� ����������� ����
main:	
; ��� ����������� ��� ������� ����� ���������	

	rjmp main


; ���� ��
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
