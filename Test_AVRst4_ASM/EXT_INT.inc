;************************************
;**
;**
;**
;************************************
EXT_INT0:

		inc Flags; ��������� ����� ������
		cpi Flags,7 // ��������� �� ���� �� ����� ������ ������, ��� �� ������ ����������
		brsh cc1
int0_fin:
		ldi cnt1,10
dec_int0:
		ldi cnt1,255
		rcall DelaySmall
		dec cnt1
		brne dec_int0

; ���������� ����������� �����
; ����� �������� ���������� INT0
		in r16, GIFR
		ori r16,0b01000000
		out GIFR, r16
		reti

cc1: 
		clr Flags // ����� �������� ���(�����������)
		rjmp int0_fin

EXT_INT1:

		dec Flags; ��������� ����� ������
		cpi Flags,255 // ��������� �� ���� �� ����� ������ ������ ����
		brsh cc
int1_fin:
		ldi cnt1,10
dec_int1:
		ldi cnt1,255
		rcall DelaySmall
		dec cnt1
		brne dec_int1

; ���������� ����������� �����
; ����� �������� ���������� INT1
		in r16, GIFR
		ori r16,0b10000000
		out GIFR, r16
		reti

cc: 
		ldi Flags,6 // ����� ����������� ��� �������� ������(�����������)
		rjmp int1_fin
