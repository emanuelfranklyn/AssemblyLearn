[org 0x7c00]
; Disables the cursor
mov ah, 0x01
mov ch, 0x3f
int 0x10

; Get cursor position
mov ah, 0x03
mov bh, 0x00
int 0x10

jmp start

messages:
    hexAsString:
        db "0123456789"
    sunday:
        db "Sunday", 0
    monday:
        db "Monday", 0
    tuesday:
        db "Tuesday", 0
    wednesday:
        db "Wednesday", 0
    thursday:
        db "Thursday", 0
    friday:
        db "Friday", 0
    saturday:
        db "Saturday", 0

header:
    db "Current time in gmt-3 is:", 0

start:
    ; Moves the cursor back to the start of the line
    mov bx, 0
    mov ah, 0x02
    mov bh, 0x00
    int 0x10
    
    call writeHeader
    call writeHours
    
    mov al, ':'
    int 0x10
    
    ; Writes the minutes
    mov al, 0x02
    call writeTime

    mov al, ':'
    int 0x10

    ; Writes the secounds
    mov al, 0x00
    call writeTime

    mov al, ' '
    int 0x10
    
    ; Writes the day
    mov al, 0x07
    call writeTime
    
    mov al, '/'
    int 0x10

    ; Writes the Month
    mov al, 0x08
    call writeTime

    mov al, '/'
    int 0x10

    ; Writes the Year
    mov al, 0x09
    call writeTime

    mov al, ' '
    int 0x10

    ; Writes the day of the week
    call writeDayOfWeek

    jmp start

writeHeader:
    mov ah, 0x0e
    mov al, [header + bx]
    int 0x10
    inc bx
    cmp al, 0
    jne writeHeader
    ret

writeDayOfWeek:
    mov bx, 0 ; index of the string
    mov ah, 0x0e
    cli
    mov al, 0x06
    out 0x70, al
    in al, 0x71
    sti

    cmp al, 0x01
    je writeSunday
    cmp al, 0x02
    je writeMonday
    cmp al, 0x03
    je writeTuesday
    cmp al, 0x04
    je writeWednesday
    cmp al, 0x05
    je writeThursday
    cmp al, 0x06
    je writeFriday
    cmp al, 0x07
    je writeSaturday
    
    jmp start

    writeTextOfDay:
        int 0x10
        inc bx
        cmp al, 0
        ret

    writeSunday:
        mov al, [sunday + bx]
        call writeTextOfDay
        jne writeSunday
        jmp start
    writeMonday:
        mov al, [monday + bx]
        call writeTextOfDay
        jne writeMonday
        jmp start
    writeTuesday:
        mov al, [tuesday + bx]
        call writeTextOfDay
        jne writeTuesday
        jmp start
    writeWednesday:
        mov al, [wednesday + bx]
        call writeTextOfDay
        jne writeWednesday
        jmp start
    writeThursday:
        mov al, [thursday + bx]
        call writeTextOfDay
        jne writeThursday
        jmp start
    writeFriday:
        mov al, [friday + bx]
        call writeTextOfDay
        jne writeFriday
        jmp start
    writeSaturday:
        mov al, [saturday + bx]
        call writeTextOfDay
        jne writeSaturday
        jmp start

    ret

writeTime:
    mov bx, 0 ; index of the string
    mov ah, 0x0e
    cli
    ; mov al, 0x02
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

    ret
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
    ret
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