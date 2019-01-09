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
.org 0x09	rjmp  TIM2_OVF       
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
.org 0x10	rjmp  TIM0_OVF       
; SPI Transfer Complete Handler
.org 0x11	reti	;rjmp  SPI_STC        
; USART, RX Complete Handler
.org 0x12	reti	;rjmp  USART_RXC      
; USART, UDR Empty Handler
.org 0x13	reti	;rjmp  USART_UDRE     
; USART, TX Complete Handler
.org 0x14	reti	;rjmp  USART_TXC      
; ADC Conversion Complete Handler
.org 0x15	rjmp  ADC_INT 
; EEPROM Ready Handler
.org 0x16	reti	;rjmp  EE_RDY         
; Analog Comparator Handler
.org 0x17	reti	;rjmp  ANA_COMP       
; 2-wire Serial Interface Handler
.org 0x18	reti	;rjmp  TWI 
; Store Program Memory Ready Handler
.org 0x19	reti	;rjmp  SPM_RDY   
