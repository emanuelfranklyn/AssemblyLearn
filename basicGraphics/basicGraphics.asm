[org 0x7c00]

CODE_SEG equ code_descriptor - GDT_Start
DATA_SEG equ data_descriptor - GDT_Start
; equ set constant

; Change to protected mode
cli
lgdt [GDT_Descriptor]
; change cr0 last bit to 1
mov eax, cr0
or eax, 1
mov cr0, eax ; 32 bit mode
; far jump to protected mode
jmp CODE_SEG:start_protected_mode

GDT_Start: ; At the end of real mode code
    null_descriptor:
        dd 0 ; 4*0
        dd 0 ; 4*0
    code_descriptor:
        dw 0xffff ; The Limit
        dw 0 ; 16 bits of base address
        db 0 ; 8 bits of base address Total 24 bits
        db 0b10011010
        ; pres, priv, type, type Flags
        db 0b11001111
        ; Other flags + last four bits of the limit
        db 0 ; 8 bits of base address Total 32 bits
    data_descriptor:
        dw 0xffff ; The Limit
        dw 0 ; 16 bits of base address
        db 0 ; 8 bits of base address Total 24 bits
        db 0b10010010
        ; pres, priv, type, type Flags
        db 0b11001111
        ; Other flags + last four bits of the limit
        db 0 ; 8 bits of base address Total 32 bits
GDT_End:

GDT_Descriptor:
    dw GDT_End - GDT_Start - 1 ; size
    dd GDT_Start ; start

[bits 32]
msg:
    times (80 - 12) / 2 db ' '
    db "MugOS Coming", 0

start_protected_mode:
    mov bx, 0 ; index of the string
    mov ecx, 0xb8000 ; address of the video memory
    mov dx, 0
    cleanScreen:
        mov ah, 0xa0 ; Black text on black background
        mov al, ' ' ; writes space bar
        cmp dx, 1999 ; the size of the screen
        jg finishClean ; if the index is bigger than the size of the screen goto finishClean
        inc dx ; increment the clean index
        mov [ecx], ax ; writes the character to the video buffer
        inc ecx ; increment the video buffer index
        inc ecx ; increment the video buffer index
        jmp cleanScreen ; jump to cleanScreen restarting the loop
    finishClean:
        mov ecx, 0xb86E0 ; address of the video memory
        mov ah, 0xa0 ; sets the background color to black and foreground color to light green
        jmp writer
    writer:
        mov al, [msg + bx]
        cmp al, 0
        je end
        mov [ecx], ax ; writes the letter P to the screen
        inc bx
        inc ecx
        inc ecx
        jmp writer
    end:
        ; https://wiki.osdev.org/Text_Mode_Cursor
        pushf
        push eax
        push edx
    
        mov dx, 0x3D4
        mov al, 0xA	; low cursor shape register
        out dx, al
    
        inc dx
        mov al, 0x20	; bits 6-7 unused, bit 5 disables the cursor, bits 0-4 control the cursor shape
        out dx, al
    
        pop edx
        pop eax
        popf
        ret
    jmp $

; Boot
times 510 - ($ - $$) db 0
db 0x55, 0xaa