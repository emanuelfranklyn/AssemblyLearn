[org 0x7c00]
mov bx, 0 ; index of the string
mov ah, 0x0e

msg:
    db "Hello World!", 0

writer:
    mov al, [msg + bx]
    cmp al, 0
    je end
    int 0x10
    inc bx
    jmp writer

end:

; Boot
times 510 - ($ - $$) db 0
db 0x55, 0xaa