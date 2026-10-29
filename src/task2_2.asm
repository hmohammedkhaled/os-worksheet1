%include "asm_io.inc"

segment .data
    out_msg db "The sum of array elements from 1 to 100 is: ", 0

segment .bss
    array resd 100          ; Reserve space for 100 integers (4 bytes each)

segment .text
    global asm_main

asm_main:
    enter 0, 0              ; Set up stack frame
    pusha                   ; Save registers

    ; 1. Initialize array with numbers 1 to 100
    mov ecx, 100            ; Set loop counter to 100
    mov ebx, 0              ; Byte offset (0, 4, 8, ...)
    mov eax, 1              ; Initial value to store

init_loop:
    mov [array + ebx], eax  ; Store current value into array element
    add ebx, 4              ; Move offset to next 32-bit dword
    inc eax                 ; Next number (1 -> 2 -> ... -> 100)
    loop init_loop

    ; 2. Sum all elements in the array
    mov ecx, 100            ; Reset loop counter
    mov ebx, 0              ; Reset byte offset
    mov eax, 0              ; Clear accumulator for sum

sum_loop:
    add eax, [array + ebx]  ; Add current element to EAX
    add ebx, 4              ; Move offset to next dword
    loop sum_loop

    ; 3. Output the result message and total sum
    mov ebx, eax            ; Save total sum temporarily
    mov eax, out_msg
    call print_string
    mov eax, ebx            ; Restore total sum for print_int
    call print_int
    call print_nl

    popa                    ; Restore registers
    mov eax, 0              ; Return status 0
    leave                   ; Clean up stack frame
    ret