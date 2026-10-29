# UFCFWK-15-2 Operating Systems: Worksheet 1

**Student Name:** Hafiz Khaled  
**Module:** UFCFWK-15-2 Operating Systems  
**Server:** CSCTCloud (`csctcloud.uwe.ac.uk`)  

---

## Directory Structure

```text
os-worksheet1/
├── README.md
└── src/
    ├── asm_io.asm
    ├── asm_io.inc
    ├── driver.c
    ├── task1.asm
    └── task1.o / driver.o / asm_io.o / task1

Task 1: Basic x86 Assembly and C Integration
Overview
In this task, an x86 assembly program (task1.asm) was implemented to perform basic arithmetic on integers stored in global memory and output the result using functions provided by asm_io.asm. The assembly program defines an entry point asm_main which is invoked from a standard C driver (driver.c).

Implementation Details
1. C Driver (src/driver.c)
The driver file serves as the main entry point for the C runtime system, declaring the external assembly function asm_main using the cdecl calling convention and returning its status code:
#include <stdio.h>

int __attribute__((cdecl)) asm_main(void);

int main() {
    int ret_status;
    ret_status = asm_main();
    return ret_status;
}

2. Assembly Program (src/task1.asm)
The assembly program defines two 32-bit double-word integers (num1 and num2) in the .data segment. The asm_main routine performs the following:

Sets up a standard stack frame (enter 0, 0) and saves general-purpose registers (pusha).

Moves num1 into the EAX register and adds num2 to EAX.

Calls print_int to display the sum in EAX, followed by print_nl for a line break.

Restores registers (popa), sets the exit code 0 in EAX, and cleans up the stack frame (leave, ret).

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

    call print_int      ; Print the result in EAX
    call print_nl       ; Print a newline character

    popa                ; Restore registers
    mov eax, 0          ; Return status 0
    leave               ; Clean up stack frame
    ret

Building and Running Task 1
To compile, assemble, link, and execute the program on CSCTCloud, run the following commands inside the src/ directory:
# Assemble assembly source files into 32-bit ELF object files
nasm -f elf task1.asm -o task1.o
nasm -f elf asm_io.asm -o asm_io.o

# Compile C driver into 32-bit object file
gcc -m32 -c driver.c -o driver.o

# Link object files into final executable (-no-pie disables position-independent execution)
gcc -m32 driver.o task1.o asm_io.o -o task1 -no-pie

# Run the program
./task1 

Results & Output
Running ./task1 outputs the sum of 25 and 17:
42

Task 2: Loops and Conditionals in x86 Assembly

Overview

Task 2 explores control flow constructs in 32-bit x86 assembly, focusing on conditional jumps (cmp, jle, jge, jl, jg), register-based looping (loop), buffer string manipulation, and array indexing using relative offset addressing.

Task 2.1: Input Validation and String Loops (task2_1.asm)

Description & Logic

This program prompts the user for their name and an iteration count $N$. It validates that $50 < N < 100$:

String Input: Reads individual characters via call read_char into a reserved 64-byte buffer in .bss until a newline (ASCII 10) or carriage return (ASCII 13) is encountered, appending a null terminator (0).

Range Validation: Uses cmp with conditional jump instructions (jle and jge) to enforce $50 < N < 100$. If $N \le 50$ or $N \ge 100$, execution jumps to invalid_range to display an error message.

Loop Execution: Stores $N$ into ECX and uses the x86 loop instruction to repeatedly output "Welcome, <Name>!". The ECX register is preserved on the stack (push ecx / pop ecx) around string I/O calls to prevent library functions from overwriting the counter.

Key Code Snippet

    ; Validate range: 50 < EAX < 100
    cmp eax, 50
    jle invalid_range           ; Jump if EAX <= 50
    cmp eax, 100
    jge invalid_range           ; Jump if EAX >= 100

    ; Print welcome string N times using ECX
    mov ecx, eax                ; Set loop counter
print_welcome_loop:
    push ecx                    ; Save loop counter
    mov eax, welcome_prefix
    call print_string
    mov eax, name_buf
    call print_string
    mov eax, welcome_suffix
    call print_string
    call print_nl
    pop ecx                     ; Restore loop counter
    loop print_welcome_loop     ; Decrement ECX and repeat if ECX > 0


Build & Run Commands

nasm -f elf task2_1.asm -o task2_1.o
gcc -m32 driver.o task2_1.o asm_io.o -o task2_1 -no-pie
./task2_1


Verification & Screenshots

Valid Case ($N = 55$): Prints "Welcome, <Name>!" 55 times.

Invalid Case ($N = 30$ or $N = 100$): Prints "Error: Number must be strictly greater than 50 and less than 100.".

Task 2.2: Array Allocation and Summation (task2_2.asm)

Description & Logic

This program demonstrates contiguous memory allocation, iterative array initialization, and element summation:

Memory Reservation: Reserves 100 double-word slots (400 bytes total) in the .bss section: array resd 100.

Initialization Loop: Uses EBX as a byte offset (incrementing by 4 each step for 32-bit integers) and ECX initialized to 100 as the loop counter, writing values 1 through 100 into [array + ebx].

Summation Loop: Iterates through the array offset locations, accumulating element values into EAX to compute $\sum_{i=1}^{100} i = 5050$.

Key Code Snippet

    ; Initialize array with values 1 to 100
    mov ecx, 100            ; Loop count
    mov ebx, 0              ; Byte offset (0, 4, 8, ...)
    mov eax, 1              ; Initial integer value

init_loop:
    mov [array + ebx], eax  ; Write value into array
    add ebx, 4              ; Move to next dword
    inc eax                 ; Next integer value
    loop init_loop

    ; Sum all elements in array
    mov ecx, 100            ; Reset counter
    mov ebx, 0              ; Reset byte offset
    mov eax, 0              ; Accumulator

sum_loop:
    add eax, [array + ebx]  ; Add element to total
    add ebx, 4              ; Advance offset
    loop sum_loop


Build & Run Commands

nasm -f elf task2_2.asm -o task2_2.o
gcc -m32 driver.o task2_2.o asm_io.o -o task2_2 -no-pie
./task2_2


Output

The sum of array elements from 1 to 100 is: 5050


Task 2.3: Dynamic Range Validation and Summation (task2_3.asm)

Description & Logic

This task extends Task 2.2 by allowing dynamic user-specified sum bounds ($S$ to $E$):

Input & Validation: Prompts for start index $S$ and end index $E$. Verifies $1 \le S \le E \le 100$ using cmp and conditional branches (jl, jg).

Offset & Iteration Calculation:

Initial Offset: Starting byte offset is calculated as $(S - 1) \times 4$ using bitwise shift left (shl eax, 2).

Loop Count: Number of iterations is computed as $\text{count} = E - S + 1$ and stored in ECX.

Summation: Accumulates elements from array offset address [array + ebx] across ECX iterations.

Key Code Snippet

    ; Calculate loop count: ECX = (end - start + 1)
    mov ecx, [end_val]
    sub ecx, [start_val]
    inc ecx

    ; Calculate starting byte offset: EBX = (start - 1) * 4
    mov eax, [start_val]
    dec eax
    shl eax, 2                  ; Multiply by 4
    mov ebx, eax

    mov eax, 0                  ; Clear accumulator

range_sum_loop:
    add eax, [array + ebx]
    add ebx, 4                  ; Next element offset
    loop range_sum_loop


Build & Run Commands

nasm -f elf task2_3.asm -o task2_3.o
gcc -m32 driver.o task2_3.o asm_io.o -o task2_3 -no-pie
./task2_3


Verification & Screenshots

Range 1 to 10: Outputs 55.

Range 1 to 100: Outputs 5050.

Invalid Range (e.g., $S=20, E=10$): Displays "Error: Invalid range! Ensure 1 <= start <= end <= 100.".