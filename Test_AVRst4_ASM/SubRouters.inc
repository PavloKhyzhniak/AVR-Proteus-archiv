;************************************
;** ���� ��������������� �����������
;**
;**
;************************************

		;-------------------------- ������������

;������ ������������ ���������� ������ �� �����
; ���� �� �����������, ����������, �������� ���� ��� ������ �������� ����������(�� ���������)
; ��� ������������� ���������� ������� ����� �� ������ ���� �������� � ����������� ���������

NumberTC:
; ������������ ����������� ���� ��� �����������
; ������� ���� ����������� �� 
;	tmpL2 ��� ������� ����
; 	tmpH2 ��� ������� ����
		
		ldi tmpL, low(100)
		ldi tmpH, high(100)
		rcall digit
		sts TT2, r0

		ldi tmpL, low(10)
		ldi tmpH, high(10)
		rcall digit
		sts TT1, r0
		
		mov cnt1, tmpL
		rcall number_init
		sts TT0, r0
		
		ret

; ������������ ���������� ����� �� �������
digit:	ldi cnt1, -1	; ����� �������������� -1
digit_1:inc cnt1		; ��������������, �.�. ������� ��� �������� � ����!!!
		sub tmpL2, tmpL	; ��������� �������� �����
		sbc tmpH2, tmpH	; ��������� � ��������� �������� �����
		brsh digit_1	; � ������ ���� �� ������������� ���������
		add tmpL2, tmpL	; ����� ��������������� ��������� ��������
		adc tmpH2, tmpH	; � ����� �������� ��� ��� ������ �����������
						; �.�. ������� 10 ������� �������!!!
;		ret

; ������������ ���������� ��������� ��� ���������� �� �������
number_init:
		ldi zh, high(TableIndicator*2)
		ldi zl, low(TableIndicator*2)
		add zl, cnt1
		clr cnt1
		adc zh, cnt1
		lpm	; ��������� � R0
		ret