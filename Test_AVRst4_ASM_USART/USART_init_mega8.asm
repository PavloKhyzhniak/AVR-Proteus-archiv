init:
;-------------------------- ������������� �����

		ldi temp, high(RAMEND)
		out SPH, temp
		ldi temp, low(RAMEND)
		out SPL, temp

;-------------------------- ������������� ������ �����/������ �

		in temp, SFIOR
		ldi temp, 1<<PUD	; ���������� ���������� ������������� ����������
		out SFIOR, temp
	
		ldi		temp, 0x0F	; ���������� ����� $0F � ������� temp
		out		DDRB, temp	; ���������� ��� ����� � DDRB (���� PB0..3 �� �����)
		ldi		temp, 0x00	; ���������� ����� $00 � ������� temp 
		out		PORTB, temp	; ���������� �� �� ����� � PORTB 

;-------------------------- ������������� ������ �����/������ D
	
		ldi		temp, 0x07
		out		DDRD, temp	
		ldi		temp, 0x00
		out		PORTD, temp

;-------------------------- ������������� ������ �����/������ C
	
		ldi		temp, 0x0F
		out		DDRC, temp
		ldi		temp, 0x00
		out		PORTC, temp

;-------------------------- ������������� Timer0
	
		ldi 	temp, (1<<CS02)|(1<<CS00)
		out 	TCCR0, temp
		;ldi 	temp, 0x87
		;out 	TCNT0, temp
		;ldi 	temp, 0x01
		;out 	TIMSK, temp

;-------------------------- ������������� �����������
		ldi temp, 0x80		; ���������� �����������
		out ACSR, temp

;-------------------------- ������������� ���������� ������� INT0/INT1
		
		;ldi temp, 0b00001000
		;out MCUCR, temp
		;ldi temp,0b10000000
		;out GIMSK, temp

;-------------------------- ������������� USARTa

		;ldi temp, 0x0d;300 baud
		;out UBRRH, temp
		ldi temp, 0x67;9600
		out UBRRL, temp
		;ldi temp, 0b00000010
		;out UCSRA, temp
		ldi temp, 0b10011000
		out UCSRB, temp
		ldi temp, 0b10000111
		out UCSRC, temp
		
;--------------------------- ���������� ����������� �������
WDT_off:				
		WDR		; reset WDT
		in  temp, WDTCR; Write logical one to WDTOE and WDE
		ori  temp, (1<<WDTOE)|(1<<WDE)
		out  WDTCR, temp
		ldi  temp, (0<<WDE)	; Turn off WDT
		out  WDTCR, temp
