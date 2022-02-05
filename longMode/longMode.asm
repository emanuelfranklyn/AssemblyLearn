freeSpace equ 0x9000

[org 0x7c00]
[bits 16]
jmp 0x0000:start

strings:
    longModeNotSupported:
        db "Long mode is not supported on this system", 0

teste:
    mov ah, 0x0e
    mov al, 'A'
    int 0x10
    ret

start:
    call teste
    mov ah, 0x0e
    mov al, 'B'
    int 0x10
    checkLongModeCompatibility:
    writeStringToScreen:
    changeToLongMode:
    longModeIncompatibleFallback:

; Boot
times 510 - ($ - $$) db 0
db 0x55, 0xaa