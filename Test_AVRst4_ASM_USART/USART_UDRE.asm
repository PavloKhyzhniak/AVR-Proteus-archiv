;-----------------------------
; ��� �������� ������ �� USART
; � ������� ����� ���������� �������� ���
; ����������� ����
; � ��� ������������ ���������� �� ����������� ������
; USARTa, ��������� ������ �����������
; ����� ������ �� ����� RS485
; ����� metkaTX ������ ���� �����������
; ��������� ����� � 0 �������� ��������� ��������
; ������ �� ������ �����������(������ �� ������)
;-----------------------------
;;���������� ������
;		sbi	PORTD, PortX
;		ldi	temp, 0b00101000
;		out	UCSRB, temp
;		nop
;g1:
;		cpi	metkaTX, 0
;		brne	g1
;-----------------------------

USART_UDRE:
; ��������� �������� �������� ��������� � �����
		push	temp
		in	temp, SREG
		push	temp
; ��������� �� ����� �� ����� ����
; �� ����� �� ������ �� ��������
		cpi	metkaTX, 0
		brne	TX_old
; ������������� ������ �������� ������
TX_new:
; ������������� ����� ��� �������� ��������
		ldi	metkaTX, 1
; �������� RS485
		sbi	PORTD, PortX
; ���������� ������������� ������� �������� ������ �� ���		
		ldi	zh, HIGH(dataTx_buf)
		ldi	zl, LOW(dataTx_buf)
TX_old:	
; ��������� �������� ��������������� ������������	
		ld	data, Z+ 
; ������ ������ �� USART
		out	UDR, data
		nop	
; ������� ����������� ������	
end_UDRE:
		sbis	UCSRA, UDRE
		rjmp	end_UDRE
; ���������, ��������� ���� �� ����� ��
; ��(����������� ������������������) ����� ��������
		cpi	data, END_DATA;
		brne	finTX
; ���� ��������� ��������, ���� ��������� ���� ��������
; �������� � ����� USARTa				
end_TXC:		
		sbis	UCSRA, TXC
		rjmp	end_TXC
; ����� ����� �������� ���������
		in	temp, UCSRA
		ori	temp, 1<<TXC
		out	UCSRA, temp	
; �������������� USATR �� �����		
		ldi temp, 0b10011000
		out UCSRB, temp
; ������ ������ ����� �� RS485
		cbi PORTD, PortX
; ����� �����, ������ �� ��������� ��������
		clr metkaTX		
; ���������� ����� 1���
; ��� ���������� �������
		ldi pausa, 8
l1:		ldi loop, 201
l2:		rcall Delay
		dec loop
		brne l2
		dec pausa
		brne l1
; ���������� ��������
finTX:	
; �������������� ��������� �� �����	
		pop temp
		out SREG, temp
		pop temp

		reti
;-------------------------------
