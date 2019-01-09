init:
;-------------------------- Инициализация стека

		ldi temp, high(RAMEND)
		out SPH, temp
		ldi temp, low(RAMEND)
		out SPL, temp

;-------------------------- Инициализация Портов ввода/вывода В

		in temp, SFIOR
		ldi temp, 1<<PUD	; отключение внутренних подтягивающих резисторов
		out SFIOR, temp
	
		ldi		temp, 0x0F	; Записываем число $0F в регистр temp
		out		DDRB, temp	; Записываем это число в DDRB (порт PB0..3 на вывод)
		ldi		temp, 0x00	; Записываем число $00 в регистр temp 
		out		PORTB, temp	; Записываем то же число в PORTB 

;-------------------------- Инициализация Портов ввода/вывода D
	
		ldi		temp, 0x07
		out		DDRD, temp	
		ldi		temp, 0x00
		out		PORTD, temp

;-------------------------- Инициализация Портов ввода/вывода C
	
		ldi		temp, 0x0F
		out		DDRC, temp
		ldi		temp, 0x00
		out		PORTC, temp

;-------------------------- Инициализация Timer0
	
		ldi 	temp, (1<<CS02)|(1<<CS00)
		out 	TCCR0, temp
		;ldi 	temp, 0x87
		;out 	TCNT0, temp
		;ldi 	temp, 0x01
		;out 	TIMSK, temp

;-------------------------- Инициализация компаратора
		ldi temp, 0x80		; выключение компаратора
		out ACSR, temp

;-------------------------- Инициализация прерываний внешних INT0/INT1
		
		;ldi temp, 0b00001000
		;out MCUCR, temp
		;ldi temp,0b10000000
		;out GIMSK, temp

;-------------------------- Инициализация USARTa

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
		
;--------------------------- Выключение сторожевого таймера
WDT_off:				
		WDR		; reset WDT
		in  temp, WDTCR; Write logical one to WDTOE and WDE
		ori  temp, (1<<WDTOE)|(1<<WDE)
		out  WDTCR, temp
		ldi  temp, (0<<WDE)	; Turn off WDT
		out  WDTCR, temp
