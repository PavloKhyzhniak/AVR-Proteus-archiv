@ECHO OFF
"C:\Program Files\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "C:\FPC\Work_AVR\labels.tmp" -fI -W+ie -o "C:\FPC\Work_AVR\TestComporator.hex" -d "C:\FPC\Work_AVR\TestComporator.obj" -e "C:\FPC\Work_AVR\TestComporator.eep" -m "C:\FPC\Work_AVR\TestComporator.map" "C:\FPC\Work_AVR\TestComporator.asm"
