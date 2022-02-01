[org 0x7c00]
jmp start

hexAsString:
    db "0123456789"

header:
    db "Current time in gmt-3 is: ", 0

start:
    mov ah, 0x01
    mov ch, 0x3f
    int 0x10
    mov ah, 0x03
    mov bh, 0x00
    int 0x10
    jmp writeHeader

writeHeader:
    mov ah, 0x0e
    mov al, [header + bx]
    cmp al, 0
    je writeHours
    int 0x10
    inc bx
    jmp writeHeader

writeMinutes:
    mov bx, 0 ; index of the string
    mov ah, 0x0e
    mov bx, 0
    cli
    mov al, 0x02
    out 0x70, al
    in al, 0x71
    sti
    
    mov cl, al
    
    shr al, 4
    
    mov bl, al
    mov al, [hexAsString + bx]
    int 0x10

    mov al, cl

    and al, 0x0f
    
    mov bl, al
    mov al, [hexAsString + bx]
    int 0x10
    
    mov bx, 0
    mov ah, 0x0e

    mov ah, 0x02
    mov bh, 0x00
    int 0x10
    jmp start
writeHours:
    mov bx, 0 ; index of the string
    mov ah, 0x0e
    mov bx, 0
    cli
    mov al, 0x04
    out 0x70, al
    in al, 0x71
    sti
    dec al
    dec al
    dec al
    ; al its now the hours in gmt -3
    mov cx, $
    cmp al, 0xff
    je AlTTh
    cmp al, 0xfe
    je AlTT
    cmp al, 0xfd
    je AlTO
    mov cl, al
    shr al, 4
    mov bl, al
    mov al, [hexAsString + bx]
    int 0x10
    mov al, cl
    and al, 0x0f
    mov bl, al
    mov al, [hexAsString + bx]
    int 0x10

    mov al, ':'
    int 0x10

    jmp writeMinutes
end:
    int 0x10

AlTTh:
    mov al, 0x23
    jmp cx
AlTT:
    mov al, 0x22
    jmp cx
AlTO:
    mov al, 0x21
    jmp cx

; Boot
times 510 - ($ - $$) db 0
db 0x55, 0xaa