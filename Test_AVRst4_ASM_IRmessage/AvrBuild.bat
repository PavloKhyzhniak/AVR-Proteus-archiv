@ECHO OFF
"C:\Program Files\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "C:\FPC\Work_AVR\Test_IR_message\labels.tmp" -fI -W+ie -o "C:\FPC\Work_AVR\Test_IR_message\Test_IR_message.hex" -d "C:\FPC\Work_AVR\Test_IR_message\Test_IR_message.obj" -e "C:\FPC\Work_AVR\Test_IR_message\Test_IR_message.eep" -m "C:\FPC\Work_AVR\Test_IR_message\Test_IR_message.map" "C:\FPC\Work_AVR\Test_IR_message\Test_IR_message.asm"
