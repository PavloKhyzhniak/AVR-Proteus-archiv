;##############################################
;##               �������                    ##
;##     1MHz ����������                      ##
;##     ��������� ����8                      ##
;##############################################
;----------
; ����8 ���������� ���������� �������� 8��� ���������� �� 8
; �� ���� �������� �� ������� 1 ���
; ��������� �� ������� ������� +5�
; ������ �� ����� � ����������� �������� ������� ���������� �� ����� 1 ���
; ������� �����...�� ������� cntU_const ��������
; ����� ������ ���������� ������� �� ���������� T2(��������� ����� T2PRE)
; ����� ����(������������ ���������) ��������� �������� 0 (T0PRE)
;------------
;------------------------- ������������� ����������

; ����������� ������������� ����� ��
.include "m8def.inc"
; ��������� ��������
.list
.device ATmega8

;------------------------- ������ ������������ ����

; ������� � ������������ ������� �� TableAddress
.equ DYNAMIC =7		; 128 ;������� �������
; ������� � ������������ ������� �� TableData
.equ DP = 7			; 128 ;������� �����

.equ cntU_const = 224;112;56;14	
;.equ deltaU=0x01	
.equ T0PRE=-5	
.equ T2PRE=-150;-125;2	

.def temp	= r16	; ����������� ������� 2-� ��� ������� ���������
.def temp1	= r17	; 
.def temp2	= r18	;
.def temp3	= r19	;
.def cnt1 	= r20	; ��������������� ���������� ��� �����1
.def cnt2 	= r21	; ���������� ����� ������ ����...��������� ��� �������
.def cnt3 	= r22	; ��������������� ���������� ��� �����3
.def set_regim 	= r23	
.def met1	= r24	
.def met2	= r25	


.dseg
.org 0x100

AD3H: .BYTE 1
AD3L: .BYTE 1

U2: .BYTE 1; �������� ��������� ������� �����
U1: .BYTE 1; �������� ���������
U0: .BYTE 1; �������� ��������� ������� �����

U_L:	.BYTE 1; �������� ���������� ���� ������� �������
U_H:	.BYTE 1; �������� ���������� ���� ������� �������
Uu_L:	.BYTE 1; �������� ���������� ���� ���������� �������
Uu_H:	.BYTE 1; �������� ���������� ���� ���������� �������

cntU:	.BYTE 1; �����

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
		clr r23
		clr r24
		clr r25
		clr r26
		clr r27
		clr r28
		
		ldi temp, 0
		sts AD3L, temp
		sts AD3H, temp
	
		sts U2, temp
		sts U1, temp
		sts U0, temp
	
;		ldi temp, deltaU*2
;		sts U_L, temp
;		sts Uu_L, temp
		clr temp
		sts Uu_H, temp
		sts U_H, temp
		
		
		ldi temp, cntU_const+1
		sts cntU, temp

	
;--------------------------



	sei		; ���������� ���� ����������� ����������
main:			; ����������� ������������ �����, ������ ������ �� �����������

	in temp,PINB
	andi temp, 0b01111111
	out PORTD,temp

	ldi cnt2,20
	rcall delay

	ori temp,0b10000000
	out PORTD,temp

	ldi cnt2,20
	rcall delay

	rjmp main


; ���� ��
cli
ldi temp, 0xFF
;out DDRB, temp
out PORTB, temp
nop
nop
nop
nop
ldi temp, 0xFF
;out DDRB, temp
clr temp
out PORTB, temp
nop
nop
nop

		rjmp main

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

;-------------------------- �������

;-------------------------- ������� BCD �������� ����� ��� �����������

.cseg			; ����� �������� ������ ��������

; �������� ��������� � ����� �������
; �������� ����� ��� ����� �� ���������� � �� ���� ��������� "maskDP"  � �����
; ������� ����� � ����!!!

; ���������� �������, ��� ��� ����������� ����� ���� �������� ������� ����� 
; for Anode
TableData: .db 0b11010111,0b00010001,0b10100111,0b10110101,0b01110001,0b11110100,0b11110110,0b11010001,0b11110111,0b11110101
; 					0			1		2			3			4			5		6			7			8			9		

;----------------------------- ������� �������� �����������
; for Anode
TableAddress: .db 0b11000000,0b10100000,0b01100000,0b00000000
				; ������� ������ 
				;
 				; ������� ������
 			