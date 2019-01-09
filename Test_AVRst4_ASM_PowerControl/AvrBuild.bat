@ECHO OFF
"C:\Program Files\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "C:\FPC\Work_AVR\TestPower\labels.tmp" -fI -W+ie -o "C:\FPC\Work_AVR\TestPower\TestPower.hex" -d "C:\FPC\Work_AVR\TestPower\TestPower.obj" -e "C:\FPC\Work_AVR\TestPower\TestPower.eep" -m "C:\FPC\Work_AVR\TestPower\TestPower.map" "C:\FPC\Work_AVR\TestPower\TestPower.asm"
