%include "asm_io.inc"

segment .data
    num1 dd 25          ; First integer
    num2 dd 17          ; Second integer

segment .text
    global asm_main

asm_main:
    enter 0, 0          ; Set up stack frame
    pusha               ; Save registers

    mov eax, [num1]     ; Load num1 into EAX
    add eax, [num2]     ; Add num2 to EAX

    call print_int      ; Print the integer in EAX
    call print_nl       ; Print a new line

    popa                ; Restore registers
    mov eax, 0          ; Return status 0
    leave               ; Clean up stack frame
    ret