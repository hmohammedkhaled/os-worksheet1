%include "asm_io.inc"

segment .data
    prompt1 db "Enter a number: ", 0
    prompt2 db "Enter another number: ", 0
    out_msg db "The sum is: ", 0

segment .bss
    num1 resd 1             ; Reserve 4 bytes (1 double word) for first integer

segment .text
    global asm_main

asm_main:
    enter 0, 0              ; Set up stack frame
    pusha                   ; Save general-purpose registers

    ; Prompt and read first integer
    mov eax, prompt1
    call print_string
    call read_int
    mov [num1], eax         ; Store first integer in memory

    ; Prompt and read second integer
    mov eax, prompt2
    call print_string
    call read_int           ; EAX now holds the second integer

    ; Add stored num1 to EAX
    add eax, [num1]

    ; Print output message and final sum
    mov ebx, eax            ; Save sum in EBX temporarily
    mov eax, out_msg
    call print_string
    mov eax, ebx            ; Restore sum to EAX for print_int
    call print_int
    call print_nl

    popa                    ; Restore general-purpose registers
    mov eax, 0              ; Return status 0
    leave                   ; Clean up stack frame
    ret