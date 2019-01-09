@ECHO OFF
"C:\Program Files\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "C:\FPC\Work_AVR\TestLed\labels.tmp" -fI -W+ie -o "C:\FPC\Work_AVR\TestLed\TestLed.hex" -d "C:\FPC\Work_AVR\TestLed\TestLed.obj" -e "C:\FPC\Work_AVR\TestLed\TestLed.eep" -m "C:\FPC\Work_AVR\TestLed\TestLed.map" "C:\FPC\Work_AVR\TestLed\TestLed.asm"
