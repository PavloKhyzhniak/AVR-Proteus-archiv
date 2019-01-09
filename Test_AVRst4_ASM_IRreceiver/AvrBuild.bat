@ECHO OFF
"C:\Program Files\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "C:\FPC\Work_AVR\TestIR\labels.tmp" -fI -W+ie -o "C:\FPC\Work_AVR\TestIR\TestIR.hex" -d "C:\FPC\Work_AVR\TestIR\TestIR.obj" -e "C:\FPC\Work_AVR\TestIR\TestIR.eep" -m "C:\FPC\Work_AVR\TestIR\TestIR.map" "C:\FPC\Work_AVR\TestIR\TestIR.asm"
