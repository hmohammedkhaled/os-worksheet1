%include "asm_io.inc"

segment .data
    prompt_start db "Enter start number (1 to 100): ", 0
    prompt_end   db "Enter end number (1 to 100): ", 0
    out_msg      db "The sum of the range is: ", 0
    err_msg      db "Error: Invalid range! Ensure 1 <= start <= end <= 100.", 0

segment .bss
    array     resd 100          ; Reserve space for 100 integers
    start_val resd 1            ; Store start bound
    end_val   resd 1            ; Store end bound

segment .text
    global asm_main

asm_main:
    enter 0, 0                  ; Set up stack frame
    pusha                       ; Save registers

    ; 1. Initialize array with values 1 to 100
    mov ecx, 100
    mov ebx, 0
    mov eax, 1

init_loop:
    mov [array + ebx], eax
    add ebx, 4
    inc eax
    loop init_loop

    ; 2. Prompt and read start bound
    mov eax, prompt_start
    call print_string
    call read_int
    mov [start_val], eax

    ; 3. Prompt and read end bound
    mov eax, prompt_end
    call print_string
    call read_int
    mov [end_val], eax

    ; 4. Validate range: 1 <= start <= end <= 100
    mov eax, [start_val]
    mov ebx, [end_val]

    cmp eax, 1
    jl invalid_range            ; start < 1
    cmp eax, 100
    jg invalid_range            ; start > 100
    cmp ebx, eax
    jl invalid_range            ; end < start
    cmp ebx, 100
    jg invalid_range            ; end > 100

    ; 5. Calculate range sum
    ; Loop counter ECX = (end - start + 1)
    mov ecx, ebx
    sub ecx, eax
    inc ecx

    ; Initial byte offset EBX = (start - 1) * 4
    dec eax
    shl eax, 2                  ; Multiply by 4
    mov ebx, eax

    mov eax, 0                  ; Clear accumulator for sum

gcc -m32 driver.o task2_3.o asm_io.o -o task2_3 -no-pierange_sum_loop:
    add eax, [array + ebx]
    add ebx, 4
    loop range_sum_loop

    ; 6. Print result
    mov edx, eax                ; Save total sum temporarily
    mov eax, out_msg
    call print_string
    mov eax, edx                ; Restore sum for print_int
    call print_int
    call print_nl
    jmp program_end

invalid_range:
    mov eax, err_msg
    call print_string
    call print_nl

program_end:
    popa                        ; Restore registers
    mov eax, 0                  ; Return status 0
    leave                       ; Clean up stack frame
    ret