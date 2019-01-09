@ECHO OFF
"C:\Program Files\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "C:\FPC\Work_AVR\test_Lesson1\labels.tmp" -fI -W+ie -o "C:\FPC\Work_AVR\test_Lesson1\test_Lesson1.hex" -d "C:\FPC\Work_AVR\test_Lesson1\test_Lesson1.obj" -e "C:\FPC\Work_AVR\test_Lesson1\test_Lesson1.eep" -m "C:\FPC\Work_AVR\test_Lesson1\test_Lesson1.map" "C:\FPC\Work_AVR\test_Lesson1\test_Lesson1.asm"
