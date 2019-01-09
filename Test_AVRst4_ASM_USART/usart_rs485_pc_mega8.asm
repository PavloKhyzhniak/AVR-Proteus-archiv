;##############################################
;##               ������� 1                  ##
;##                �����  1                  ##
;##     ��������� USART-RS485-COM            ##
;##  ATMega8 (DIP) - 16 Mhz            	 ##
;##############################################

;------------------------- ������������� ����������

; ����������� ������������� ����� ��
.include "m8def.inc"
; ��������� ��������1
.list
.device ATmega8

;------------------------- ������ ������������ ����

.def temp	= r16	; ����������� ������� 2-� ��� ������� ���������
.def temp1	= r17	; 
.def tempH	= r18	; ��� ��������������� ��������
.def tempL	= r19	;
.def metkaTx= r20	; ����� ������ ������
.def data	= r21	; ������� ������
.def loop	= r22	; ������� ��������
.def pausa	= r23	; ���������� �������� �����
.def cnt1	= r24
.def flagRX	= r25
;-------------------
.equ END_DATA = '+'
.equ START_DATA = ':'
; ����� Tx/Rx
.set PortX = PD2
; �����a 
.set tempKey1 = PD3
;-------------------

;����� �������� ������������ ����
.dseg		;����� �������� ���
.org 0x060
dataRx_buf: .BYTE 32;������ �� �����
dataTx_buf: .BYTE 32;������ �� ��������

.cseg 	; ����� �������� ������������ ����
.org 	0x00	; ��������� �������� ������ �� ����

start:
;----------------------------- ������ ����������
		
	.org 0x000						; Reset Handler
	rjmp init 
	.org 0x001			; EXT_INT0    	; IRQ0 Handler
	reti 
	.org 0x002			; EXT_INT1   	; IRQ1 Handler
	rjmp EXT_INT1 	
	.org 0x003			; TIM2_COMP		; Timer2 Compare Handler
	reti 
	.org 0x004
	reti 				; TIM2_OVF    	; Timer2 Overflow Handler
	.org 0x005	
	reti 				; TIM1_CAPT   	; Timer1 Capture Handler
	.org 0x006   		; TIM1_COMPA	; Timer1 CompareA Handler    
	reti 
	.org 0x007   		; TIM1_COMPB    ; Timer1 CompareB Handler
	reti 
	.org 0x008     		; TIM1_OVF      ; Timer1 Overflow Handler
	reti 	                                                                                                                                                                                                                                                                                         
	.org 0x009       					; Timer0 Overflow Handler	
	rjmp TIM0_OVF       		
	.org 0x00a     		; SPI_STC     	; SPI Transfer Complete Handler
	reti 
	.org 0x00b     		; USART_RXC    	; USART RX Complete Handler
	rjmp USART_RXC 
	.org 0x00c      	; USART_UDRE    ; UDR Empty Handler
	rjmp USART_UDRE
	.org 0x00d      	; USART_TXC    	; USART TX Complete Handler
	reti 
	.org 0x00e      					; ADC Conversion Complete Handler
	reti;  ADC_INT		 			
	.org 0x00f    	    ; EE_RDY      	; EEPROM Ready Handler
	reti	
	.org 0x010    		; ANA_COMP     	; Analog Comparator Handler
	reti 
	.org 0x011      	; TWSI 			; Two-wire Serial Interface Handler
	reti 
	.org 0x012     		; SPM_RDY      	; Store Program Memory Ready Handler
	reti 
;-------------------------- ��������� ������� ����������

;-------------------------- ������������� ����������������
.include "USART_init_mega8.asm"
;-------------------------- ���������� ������������� ����������������

;-------------------------- ������ ��������� �����
.include "USART_main.asm"
;-------------------------- ��������� ��������� �����

;-------------------------- ������������ ��������� ����������
.include "TIM0_OVF.asm"
.include "EXT_INT1.asm"
.include "USART_UDRE.asm"
.include "USART_RXC.asm"

;-------------------------- �������
.include "USART_creg_data.asm"
				
;-------------------------- ������������

Delay:
		push loop
		ldi loop, 255
delay_loop:
		nop
		dec loop
		brne delay_loop
		pop loop
		ret
;-------------------------- 
