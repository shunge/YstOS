; GDT

gdt_start:
    
gdt_null:  ; the mandatory null descriptor
    dd 0x0 ; 'dd' means define double word (i.e 4 bytes)
    dd 0x0

gdt_code:  ; the code segment descriptor

    ; base = 0x0, limit = 0xfffff
    ; 1st flags: (present)1 (privilege) 00 (descriptor type) 1 -> 1001b
    ; type flags: (code)1 (conforming)0 (readable)1 (accessed)0 -> 101b
    ; 2nd flags: (granularity)1 (32-bit default)1 (64-bit seg)0 (AVL)0 -> 1100b

    dw 0xffff   ; Limit (bits 0 -15)
    dw 0x0      ; Base  (bits 0-15)
    db 0x0      ; Base (bits 16 - 23)
    db 10011010b; 1st flags, type flags
    db 11001111b; 2nd flags, Limit (bits 16-19)
    db 0x0      ; Base (bits 24-31)

gdt_data:   ; the data segment descriptor

    ; Same as the code segment except for the type flags
    ; type flags: (code)0 (expand down)0 (writeable)1 (accessed)0 -> 0010b

    dw 0xffff   ; Limit
    dw 0x0      ; Base
    db 0x0      ; Base
    db 10010010b; 1st flags, type flags
    db 11001111b; 2nd falgs, Limit
    db 0x0      ; Base

gdt_end:        ; The reason for putting a label at the end of the GDT
                ; is we can have the assembler calculate the size of the GDT
                ; fo the GDT descriptor

; GDT descriptor
gdt_descriptor:
    dw gdt_end - gdt_start - 1  ; Size pf our GDT, always less one of the true szize


    dd gdt_start                ; Start address of our GDT

; Define some constants
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

