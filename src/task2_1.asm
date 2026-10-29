%include "asm_io.inc"

segment .data
    prompt_name    db "Enter your name: ", 0
    prompt_count   db "Enter a number (greater than 50 and less than 100): ", 0
    welcome_prefix db "Welcome, ", 0
    err_msg        db "Error: Number must be greater than 50 and less than 100!", 0

segment .bss
    name_buf resb 64            ; Reserve 64 bytes for user's name

segment .text
    global asm_main

asm_main:
    enter 0, 0                  ; Set up stack frame
    pusha                       ; Save registers

    ; 1. Prompt and read user's name character by character
    mov eax, prompt_name
    call print_string

    mov edi, name_buf
read_name_loop:
    call read_char
    cmp al, 10                  ; Check for newline (\n)
    je end_name_read
    cmp al, 13                  ; Check for carriage return (\r)
    je end_name_read
    mov [edi], al
    inc edi
    jmp read_name_loop

end_name_read:
    mov byte [edi], 0           ; Null-terminate string

    ; 2. Prompt and read iteration count
    mov eax, prompt_count
    call print_string
    call read_int               ; EAX holds the input integer

    ; 3. Validate condition: 50 < EAX < 100
    cmp eax, 50
    jle invalid_number          ; Error if count <= 50
    cmp eax, 100
    jge invalid_number          ; Error if count >= 100

    ; 4. Print welcome string EAX times using loop
    mov ecx, eax                ; Set ECX = loop counter
welcome_loop:
    push ecx                    ; Preserve loop counter across function calls
    mov eax, welcome_prefix
    call print_string
    mov eax, name_buf
    call print_string
    call print_nl
    pop ecx                     ; Restore loop counter
    loop welcome_loop
    jmp done

invalid_number:
    mov eax, err_msg
    call print_string
    call print_nl

done:
    popa                        ; Restore registers
    mov eax, 0                  ; Return status 0
    leave                       ; Clean up stack frame
    ret