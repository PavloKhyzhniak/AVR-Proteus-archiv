;выбор сегмента программного кода

.cseg 	; Выбор сегмента программного кода
.org 	0x00	; Установка текущего адреса на ноль

;----------------------------- Вектор прерывний
		
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

;-------------------------- Окончание вектора прерываний


;-------------------------- Инициализация(сброс)
RESET:
		;---откалибруем внутренний генератор
		ldi temp, 0x48
		sts OSCCAL, temp
		;отключаем внутренние подтягивающие резисторы
		; неиспользованные ноги в третье состояние!!!
	;	in temp, MCUCR
	;	ldi temp, 1<<PUD
	;	out MCUCR, temp
;-------------------------- Инициализация стека

		ldi temp, high(RAMEND)	; Выбор адреса вершины стека(старший байт)
		out SPH, temp
		ldi temp, low(RAMEND)	; Выбор адреса вершины стека(младший байт)
		out SPL, temp

;-------------------------- Инициализация Портов ввода/вывода В и D

				; Px0 - a, вес разряда 1
				; Px1 - b, вес разряда 2
				; Px2 - c, вес разряда 4
				; Px3 - d, вес разряда 8
				; Px4 - e, вес разряда 16
				; Px5 - f, вес разряда 32
				; Px6 - g, вес разряда 64
				; Px7 - DP, вес разряда 128

		ldi		temp, 0x00	; Записываем число $00 в регистр temp
		out		DDRB, temp	; Записываем это число в DDRx (порт Px на ввод)
		ldi 	temp, 0xFF
		out		PORTB, temp	; Записываем нули в PORTx (потушить светодиоды с общим катодом)

				; PD7 - младший разряд индикации напряжения
				; PD6 - средний разряд индикации напряжения
				; PD5 - старший разряд индикации напряжения				
				; PD4 
				; PD3 
				; PD2 
				; PD1 
				; PD0 				
		ldi		temp, 0xFF	; Записываем число $FF в регистр temp
		out		DDRD, temp	; Записываем это число в DDRx (порт Px на вывод)
		ldi		temp, 0x00	
		out		PORTD, temp	; Записываем то же число в PORTx (потушить индикацию)

;-------------------------- Инициализация Порта ввода/вывода С

		ldi		temp, 0x00	; Записываем число $75 в регистр temp
		out		DDRC, temp	; Записываем это число в DDRС
		ldi		temp, 0x00	; Записываем число $00 в регистр temp
		out		PORTC, temp	; Записываем то  же число в PORTС
				; Отметим, что теперь порт С имеет такую конфигурацию:
				;РС2 вход напруги используем внешнее опорное!!!

;-------------------------- Подключение подтягивающих резисторов
		lds		temp, SFIOR
		ori		temp, 1<<PUD	
		out		SFIOR, temp	




;-------------------------- Настройка АЦП
;		ldi temp, 0x21			; берем регистр мультиплексирования АЦП	и		
;		sts ADMUX, temp			; на 1-й канал (от 0 до 7 у нас 8 каналов)
		; считываем восемь бит, внешнее опорное +5В от КРЕН!!!
;-----------
;		ldi r16, 0xDE			; запус однократного преобразования
;		sts ADCSRA, r16
;-------------------------- Инициализация Таймера 0	

;		ldi		temp, 0x05	; установить предделитель таймера0 в 1024,
;		out		TCCR0, temp	; теперь таймер будет считать в 1024 раз медленнее чем тактовая частота МК
;		; при внутреннем такте в 8МГц, частота счета 0,0078 МГц!!!
;		ldi		temp, T0PRE	; загрузим начальное значение таймера0
;		out		TCNT0, temp	; начать счет 8-ми битного таймера с числа 255-32
;							; прерывание происходит при переполнении, т.е. достижении числа 255
;
;		ldi		temp, 0x01	; разрешить прерывание по переполнению таймера0 и таймера2
;		sts		TIMSK, temp	; 
;-------------------------- Инициализация Таймера 2	

;		ldi		temp, 0x05	; установить предделитель таймера0 в 1024,
;		sts		TCCR2, temp	; теперь таймер будет считать в 1024 раз медленнее чем тактовая частота МК
;		; при внутреннем такте в 8МГц, частота счета 0,0078 МГц!!!
;		ldi		temp, T2PRE	; загрузим начальное значение таймера0
;		sts		TCNT2, temp	; начать счет 8-ми битного таймера с числа 255-32
;							; прерывание происходит при переполнении, т.е. достижении числа 255
;
;		ldi		temp, TIMSK	; разрешить прерывание по переполнению таймера0 и таймера2
;		ori		temp, TOIE2<<1
;		sts		TIMSK, temp	; 

;-------------------------- Инициализация компаратора
		ldi temp, 0x80		; выключение компаратора
		out ACSR, temp

;--------------------------- Выключение сторожевого таймера
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
