;##############################################
;##               �������                    ##
;##     1MHz ����������                      ##
;##     ��������� ����8                      ##
;##############################################
;------------------------- ������������� ����������

; ����������� ������������� ����� ��
.include "m8def.inc"
; ��������� ��������
.list
.device ATmega8

;------------------------- ������ ������������ ����

.def temp	= r16	; ����������� ������� 2-� ��� ������� ���������
.def temp1	= r17	; 
.def temp2	= r18	;
.def temp3	= r19	;
.def cnt1 	= r20	; ��������������� ���������� ��� �����1
.def cnt2 	= r21	; ���������� ����� ������ ����...��������� ��� �������
.def cnt3 	= r22	; ��������������� ���������� ��� �����3


.equ	START = 0x08
.equ	MT_SLA_ACK = 0x18
.equ	MT_DATA_ACK = 0x28

.dseg
.org 0x100

cntU:	.BYTE 1; �����

SLA_W:	.BYTE 1
DATA:	.BYTE 1;

.cseg
// ����������� ����� ������� ���������� � ������(�������������)
#include "InterruptVector_Reset.asm"

;-------------------------- ������ ��������� �����

;---------- ������� ��� ��������
		clr r16
		clr r17
		clr r18
		clr r19
		clr r20
		clr r21
		clr r22
		
;--------------------------
	sei		; ���������� ���� ����������� ����������


	ldi r16,0x08
	sts DATA,r16
	ldi r16,0x58
	sts SLA_W,r16


main:			; ����������� ������������ �����, ������ ������ �� �����������


	rcall I2C_INIT
	rcall I2C_START

	ldi r16,0x58
	sts SLA_W,r16
	rcall I2C_ADDR

	ldi r16,0x08
	sts DATA,r16
	rcall I2C_DATA

	ldi r16,0x0f
	sts DATA,r16
	rcall I2C_DATA

	rcall I2C_STOP





	rcall I2C_START

	ldi r16,0x58
	sts SLA_W,r16
	rcall I2C_ADDR

	ldi r16,0x88
	sts DATA,r16
	rcall I2C_DATA

	ldi r16,0xf0
	sts DATA,r16
	rcall I2C_DATA

	rcall I2C_STOP

;	ldi cnt1,0xFF
;	rcall DELAY

	rjmp main

I2C_INIT:

	lds r16, SLA_W
	out TWDR, r16 
	ldi r16, (1<<TWINT)|(1<<TWEN)
	out TWCR, r16

	ret
		
I2C_START:

	ldi r16, (1<<TWINT)|(1<<TWSTA)|(1<<TWEN)
	out TWCR, r16

 wait1:
	in r16,TWCR
	sbrs r16,TWINT
	rjmp wait1


	in r16,TWSR
	andi r16, 0xF8
	cpi r16, START
	brne ERROR

	ret

I2C_ADDR:

	lds r16, SLA_W
	out TWDR, r16 
	ldi r16, (1<<TWINT)|(1<<TWEN)
	out TWCR, r16

wait2:
	in r16,TWCR
	sbrs r16,TWINT
	rjmp wait2

	in r16,TWSR
	andi r16, 0xF8
	cpi r16, MT_SLA_ACK
	brne ERROR

	ret

I2C_DATA:

	lds r16, DATA
	out TWDR, r16       
	ldi r16, (1<<TWINT)|(1<<TWEN)
	out TWCR, r16

wait3:
	in r16,TWCR
	sbrs r16,TWINT
	rjmp wait3

 	in r16,TWSR
	andi r16, 0xF8
	cpi r16, MT_DATA_ACK
	brne ERROR

	ret

ERROR:
I2C_STOP:

	ldi r16, (1<<TWINT)|(1<<TWEN)|(1<<TWSTO)
	out TWCR, r16 
	
	ret

;-------------------------- ���������� ��������� �����

delay:
	nop
	dec cnt1
	brne delay
	tst cnt2
	breq exit
	
	ldi cnt1,0xFF
	dec cnt2
	brne delay
	tst cnt3
	breq exit
	
	ldi cnt2, 0xFF
	dec cnt3
	brne delay
exit:
	nop
	nop
	nop
	
	ret

;-------------------------- ������������ ��������� ����������
;.include "TIM0_OVF.asm"
;.include "TIM2_OVF.asm"
;.include "ADC_INT.asm"

/*
;-------------------------- ������� BCD �������� ����� ��� �����������
.cseg			; ����� �������� ������ ��������

; for Anode
TableData: .db 0b11010111,0b00010001,0b10100111,0b10110101,0b01110001,0b11110100,0b11110110,0b11010001,0b11110111,0b11110101
; 					0			1		2			3			4			5		6			7			8			9		

;----------------------------- ������� �������� �����������
; for Anode
TableAddress: .db 0b11000000,0b10100000,0b01100000,0b00000000

*/
