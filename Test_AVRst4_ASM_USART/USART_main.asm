;-------------------------- ���������� � ��������� �����
main0:
error_ignor:

; �������� RS485 �� ����� ������
		cbi PORTD, PortX
; ����� ����� �������� ������ �����
		ldi metkaTX,1	
; ��������� �������� �������� ����
		clr cnt1
; ���������� ���� ����������� ����������
		sei
;-------------------------- ������ ��������� �����
main:

; ������ � ������ ����������������
;idle:
;		ldi temp, (1<<SE)
;		out MCUCR, temp
;		sleep
;------- �����������
;------- ��� ���������
;		rjmp idle

		rjmp answer

		;��������� ������
g0:		
		cpi metkaTX, 0
		brne g0

/*
; ������������� ������� ��������
; ������ �� ������ ��������
		ldi	zh, high(dataTX*2)
		ldi	zl, low(dataTX*2)
; ������������� ������� ������
; ���������� ������ � ����� ��������
		ldi	xh, high(dataTx_buf)
		ldi	xl, low(dataTx_buf)
; ������������� �������� ��������
		ldi	cnt1, 8
rer:
; ��������� ���� ������ ��������
		lpm
; ���������������� ������
		ld	temp, Z+
; ��������� ���������� ������
		mov	temp, r0
; �������� �������� ���������������� ������������
		st	X+, temp
; ��������� �������� �� �� ��� ���������
		dec	cnt1
		brne	rer
; ���������������� ������� �������� ����
		ldi	cnt1, 8
*/

; �������� ��� �� ������ ���� ���� ����?
		cpi	cnt1, 0
		breq	main
		
;---------------
; ��������� ���������� ������
	;--------
	;1 ������������� �������
	;--------
	;--------
	;2 �������� ������ ������
	;--------
	;--------
	;3 ������ ������ � ������������� ��
	;--------
	;--------
	;4 ������������ ������
	;--------
;1 ���� �������������
; �������� ������� ���������� ������
		ldi	xh, high(dataRx_buf)
		ldi	xl, low(dataRx_buf)
		inc	xl
		clr	tempL
		adc	xh, tempL
		ld	tempL, X+
		ld	tempH, X+
; �������� ������ ID
		ldi	zh, high(dataID*2)
		ldi	zl, low(dataID*2)
		rcall	byte2creg
; ��������������� ����������
		cp	temp, tempL
		brne error_ignor
		cp	temp1, tempH
		brne error_ignor
; �������� ��������� ���� ���������� ��� ���������
		ld	tempL, X+
		ld	tempH, X+
; ��������� 3� � 4� ���� ��������������
		ld	temp, Z+
		lpm
		mov	temp, r0
		ld	temp1, Z+
		lpm
		mov	temp1, r0
; ��������������� ����������
		cp	temp, tempL
		brne error_ignor
		cp	temp1, tempH
		brne error_ignor
; ���� ������������� ������ �������...������� ����..������������

;2 ���� ����� ������
; �������� ������ ������ ������ �� ����������(���������������)
	;1 ������ �� ���� �� ������ ��������
		ld	temp, Z+
		rcall	byte2creg
; �������� ��������� ���� ���������� ��� ���������
		ld	tempL, X+
		ld	tempH, X+
; ��������������� ����������
		cp	temp, tempL
		brne other1
		cp	temp1, tempH
		brne other1
; � ������ ��������� ���������
		rcall hex_work
		rjmp work1
other1:
	;2 ������ �� ���� �� ������������ ����� ��� I/O
		ld	temp, Z+
		rcall	byte2creg
; ��������������� ����������
		cp	temp, tempL
		brne other2
		cp	temp1, tempH
		brne other2
; � ������ ��������� ���������
		rcall hex_work
		rjmp work2
other2:
	;3 ����������� �����
		ld	temp, Z+
		rcall	byte2creg
; ��������������� ����������
		cp	temp, tempL
		brne other3
		cp	temp1, tempH
		brne other3
; � ������ ��������� ���������
		rcall hex_work
		rjmp work3
other3:
; ����� �� ��� ���������������
; ������....
		rjmp error_ignor

;3 ���� ������ ������ � ������������� ��
work1:
		cpi	temp, 0x00
		breq	error_ignor
		mov zl, temp
		clr zh
		rol zl
		rol zh
		lpm
		mov	temp, r0
		rjmp answer
work2:
		cpi	temp, 0x00
		breq	other3;error_ignor
		mov	zl, temp
		clr	zh
		ld	temp, Z
		rjmp answer
work3:
		out	PORTC, temp
		in	temp, PORTC
		rjmp answer

/*
error_ignor:
; �������� RS485 �� ����� ������
		cbi PORTD, PortX
; ����� ����� �������� ������ �����
		ldi metkaTX,1	
; ��������� �������� �������� ����
		clr cnt1
		rjmp main
*/
answer:
; �������� ������� ������
		ldi	xh, high(dataTx_buf)
		ldi	xl, low(dataTx_buf)

		ldi	temp1, START_DATA
		st	X+, temp1
; �������� ������ ID
		ldi	zh, high(dataID*2)
		ldi	zl, low(dataID*2)
		mov	tempH, temp
		rcall	byte2creg
		st	X+, temp
		st	X+, temp1
; ��������� 3� � 4� ���� ��������������
		ld	temp, Z+
		lpm
		mov	temp, r0
		ld	temp1, Z+
		lpm
		mov	temp1, r0
		
		st	X+, temp
		st	X+, temp1

		rcall nibl_bin
		mov	temp, tempH
		rcall bin_ASCII
		mov	tempH, temp
		mov	temp, tempL
		rcall bin_ASCII
		mov tempL, temp
		st	X+, tempH
		st	X+, tempL

		ldi	temp, END_DATA
		st	X, temp
		
		rjmp	return_answer 
;----------
nibl_bin:
		mov	tempL, tempH
		swap	tempH
		andi	tempL, 0x0F
		andi	tempH, 0x0F
		ret
;----------
bin_ASCII:
		cpi	temp, 10
		brsh ASCII_number
ASCII_alfavit:
		ldi	temp1, 0x30
		add temp,temp1
		ret
ASCII_number:
		ldi	temp1, 0x37
		add temp, temp1 
		ret
;----------

hex_work:
; �������� ���� ��� �������� ����� � 16 ��
		ld	temp1, X+
		rcall	ASCII_hex
		cpi temp, 0xFF
		breq error_number
		lsl	temp
		lsl	temp
		lsl	temp
		lsl	temp
		mov	tempL, temp
		
		ld	temp1, X+
		rcall	ASCII_hex
		cpi temp, 0xFF
		breq error_number
		mov tempH, temp

		add tempL, tempH
		mov temp, tempL
		ret
error_number:
		clr temp
		ret
;-----------
ASCII_hex:
		cpi temp1, 47
		brlo error_hex
		cpi temp1, 58
		brsh hex1
		subi temp1, 48
		mov	temp, temp1
		ret
hex1:
		cpi temp1, 91
		brsh hex2
		cpi temp1, 64
		brlo error_hex
		subi temp1, 64
		rjmp fin_hex
hex2:
		cpi temp1, 123
		brsh error_hex
		cpi temp1, 96
		brlo error_hex
		subi temp1, 96
fin_hex:
		cpi temp1, 7
		brsh error_hex
		ldi temp, 9
		add temp, temp1
		ret
error_hex:
		ldi	temp, 0xFF
		ret

; ������ ���� ���� �� ������ ��������
byte2creg:
		lpm
		mov	temp, r0
		ld	temp1, Z+
		lpm
		mov	temp1, r0
		ret

;----------------
return_answer:
/*
;-----------------
; ������������� ������� ������
; ���������� ������ � ����� ��������
		ldi	xh, high(dataTx_buf)
		ldi	xl, low(dataTx_buf)
; ������������� �������� ��������
		ldi	cnt1, 8
		ldi temp, 30
rer:
		
; �������� �������� ���������������� ������������
		st	X+, temp
		inc temp
; ��������� �������� �� �� ��� ���������
		dec	cnt1
		brne	rer
		ldi temp, END_DATA
		st	X+, temp
*/
;--------------
; ���������� �����...
;-----------
		ldi	pausa, 180
l5:		ldi	loop, 201
l6:		rcall	Delay
		dec	loop
		brne	l6
		dec	pausa
		brne	l5
		ldi	pausa, 180
l7:		ldi	loop, 201
l8:		rcall	Delay
		dec	loop
		brne	l8
		dec	pausa
		brne	l7
		ldi	pausa, 180
l9:		ldi	loop, 201
l10:	rcall	Delay
		dec	loop
		brne	l10
		dec	pausa
		brne	l9

;		clr temp
;		out PORTC, temp
;----------
		
;return_answer:
		;���������� ������
		sbi	PORTD, PortX
		ldi	temp, 0b00101000
		out	UCSRB, temp
		nop
g1:
		cpi	metkaTX, 0
		brne	g1

		rjmp	main0
;-------------------------- ���������� ��������� �����
