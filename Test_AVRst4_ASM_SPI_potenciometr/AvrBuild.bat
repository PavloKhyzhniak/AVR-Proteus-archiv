@ECHO OFF
"C:\Program Files (x86)\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "C:\FPC\!!!!\AVR\TestSPI\labels.tmp" -fI -W+ie -C V2E -o "C:\FPC\!!!!\AVR\TestSPI\TestSPI.hex" -d "C:\FPC\!!!!\AVR\TestSPI\TestSPI.obj" -e "C:\FPC\!!!!\AVR\TestSPI\TestSPI.eep" -m "C:\FPC\!!!!\AVR\TestSPI\TestSPI.map" "C:\FPC\!!!!\AVR\TestSPI\TestSPI.asm"
