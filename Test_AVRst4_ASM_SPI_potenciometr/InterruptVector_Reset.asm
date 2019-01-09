;����� �������� ������������ ����

.cseg 	; ����� �������� ������������ ����
.org 	0x00	; ��������� �������� ������ �� ����

;----------------------------- ������ ���������
		
; Reset Handler
.org 0x00	rjmp  RESET          
; IRQ0 Handler
.org 0x01	reti	;rjmp  EXT_INT0       
; IRQ1 Handler
.org 0x02	reti	;rjmp  EXT_INT1       
; PCINT0 Handler
.org 0x03	reti	;rjmp  PCINT0         
; PCINT1 Handler
.org 0x04	reti	;rjmp  PCINT1         
; PCINT2 Handler
.org 0x05	reti	;rjmp  PCINT2         
; Watchdog Timer Handler
.org 0x06	reti	;rjmp  WDT 
; Timer2 Compare A Handler
.org 0x07	reti	;rjmp  TIM2_COMPA     
; Timer2 Compare B Handler
.org 0x08	reti	;rjmp  TIM2_COMPB     
; Timer2 Overflow Handler
.org 0x09	reti	;rjmp  TIM2_OVF       
; Timer1 Capture Handler
.org 0x0A	reti	;rjmp  TIM1_CAPT      
; Timer1 Compare A Handler
.org 0x0B	reti	;rjmp  TIM1_COMPA     
; Timer1 Compare B Handler
.org 0x0C	reti	;rjmp  TIM1_COMPB     
; Timer1 Overflow Handler
.org 0x0D	reti	;rjmp  TIM1_OVF       
; Timer0 Compare A Handler
.org 0x0E	reti	;rjmp  TIM0_COMPA     
; Timer0 Compare B Handler
.org 0x0F	reti	;rjmp  TIM0_COMPB     
; Timer0 Overflow Handler
.org 0x10	reti	;rjmp  TIM0_OVF       
; SPI Transfer Complete Handler
.org 0x11	reti	;rjmp  SPI_STC        
; USART, RX Complete Handler
.org 0x12	reti	;rjmp  USART_RXC      
; USART, UDR Empty Handler
.org 0x13	reti	;rjmp  USART_UDRE     
; USART, TX Complete Handler
.org 0x14	reti	;rjmp  USART_TXC      
; ADC Conversion Complete Handler
.org 0x15	reti	;rjmp  ADC_INT 
; EEPROM Ready Handler
.org 0x16	reti	;rjmp  EE_RDY         
; Analog Comparator Handler
.org 0x17	reti	;rjmp  ANA_COMP       
; 2-wire Serial Interface Handler
.org 0x18	reti	;rjmp  TWI 
; Store Program Memory Ready Handler
.org 0x19	reti	;rjmp  SPM_RDY   

;-------------------------- ��������� ������� ����������


;-------------------------- �������������(�����)
RESET:
		;---����������� ���������� ���������
		ldi temp, 0x48
		sts OSCCAL, temp
		;��������� ���������� ������������� ���������
		; ���������������� ���� � ������ ���������!!!
	;	in temp, MCUCR
	;	ldi temp, 1<<PUD
	;	out MCUCR, temp
;-------------------------- ������������� �����

		ldi temp, high(RAMEND)	; ����� ������ ������� �����(������� ����)
		out SPH, temp
		ldi temp, low(RAMEND)	; ����� ������ ������� �����(������� ����)
		out SPL, temp

;-------------------------- ������������� ������ �����/������ � � D

				; Px0 - a, ��� ������� 1
				; Px1 - b, ��� ������� 2
				; Px2 - c, ��� ������� 4
				; Px3 - d, ��� ������� 8
				; Px4 - e, ��� ������� 16
				; Px5 - f, ��� ������� 32
				; Px6 - g, ��� ������� 64
				; Px7 - DP, ��� ������� 128

		ldi		temp, 0x00	; ���������� ����� $00 � ������� temp
		out		DDRB, temp	; ���������� ��� ����� � DDRx (���� Px �� ����)
		ldi 	temp, 0xFF
		out		PORTB, temp	; ���������� ���� � PORTx (�������� ���������� � ����� �������)

				; PD7 - ������� ������ ��������� ����������
				; PD6 - ������� ������ ��������� ����������
				; PD5 - ������� ������ ��������� ����������				
				; PD4 
				; PD3 
				; PD2 
				; PD1 
				; PD0 				
		ldi		temp, 0xFF	; ���������� ����� $FF � ������� temp
		out		DDRD, temp	; ���������� ��� ����� � DDRx (���� Px �� �����)
		ldi		temp, 0x00	
		out		PORTD, temp	; ���������� �� �� ����� � PORTx (�������� ���������)

;-------------------------- ������������� ����� �����/������ �

		ldi		temp, 0x00	; ���������� ����� $75 � ������� temp
		out		DDRC, temp	; ���������� ��� ����� � DDR�
		ldi		temp, 0x00	; ���������� ����� $00 � ������� temp
		out		PORTC, temp	; ���������� ��  �� ����� � PORT�
				; �������, ��� ������ ���� � ����� ����� ������������:
				;��2 ���� ������� ���������� ������� �������!!!

;-------------------------- ����������� ������������� ����������
		lds		temp, SFIOR
		ori		temp, 1<<PUD	
		out		SFIOR, temp	




;-------------------------- ��������� ���
;		ldi temp, 0x21			; ����� ������� ������������������� ���	�		
;		sts ADMUX, temp			; �� 1-� ����� (�� 0 �� 7 � ��� 8 �������)
		; ��������� ������ ���, ������� ������� +5� �� ����!!!
;-----------
;		ldi r16, 0xDE			; ����� ������������ ��������������
;		sts ADCSRA, r16
;-------------------------- ������������� ������� 0	

;		ldi		temp, 0x05	; ���������� ������������ �������0 � 1024,
;		out		TCCR0, temp	; ������ ������ ����� ������� � 1024 ��� ��������� ��� �������� ������� ��
;		; ��� ���������� ����� � 8���, ������� ����� 0,0078 ���!!!
;		ldi		temp, T0PRE	; �������� ��������� �������� �������0
;		out		TCNT0, temp	; ������ ���� 8-�� ������� ������� � ����� 255-32
;							; ���������� ���������� ��� ������������, �.�. ���������� ����� 255
;
;		ldi		temp, 0x01	; ��������� ���������� �� ������������ �������0 � �������2
;		sts		TIMSK, temp	; 
;-------------------------- ������������� ������� 2	

;		ldi		temp, 0x05	; ���������� ������������ �������0 � 1024,
;		sts		TCCR2, temp	; ������ ������ ����� ������� � 1024 ��� ��������� ��� �������� ������� ��
;		; ��� ���������� ����� � 8���, ������� ����� 0,0078 ���!!!
;		ldi		temp, T2PRE	; �������� ��������� �������� �������0
;		sts		TCNT2, temp	; ������ ���� 8-�� ������� ������� � ����� 255-32
;							; ���������� ���������� ��� ������������, �.�. ���������� ����� 255
;
;		ldi		temp, TIMSK	; ��������� ���������� �� ������������ �������0 � �������2
;		ori		temp, TOIE2<<1
;		sts		TIMSK, temp	; 

;-------------------------- ������������� �����������
		ldi temp, 0x80		; ���������� �����������
		out ACSR, temp

;--------------------------- ���������� ����������� �������
WDT_off:
; Turn off global interrupt
cli
; Reset Watchdog Timer
wdr
; Clear WDRF in MCUSR
in    temp, MCUSR
andi  temp, (0xff & (0<<WDRF))
out   MCUSR, r16
; Write logical one to WDCE and WDE
; Keep old prescaler setting to prevent unintentional time-out
lds r16, WDTCSR
ori   temp, (1<<WDCE) | (1<<WDE)
sts WDTCSR, r16
; Turn off WDT
ldi   temp, (0<<WDE)
sts WDTCSR, r16
