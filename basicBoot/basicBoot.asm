; Boot
times 510 - ($ - $$) db 0 ; Runs db 0 for 510 - (the current position - the start of the program) times making it 510 bytes long
db 0x55, 0xaa ; Adds the bytes 0x55 and 0xaa to the end of the program with make it 512 bytes long and a bootable disk