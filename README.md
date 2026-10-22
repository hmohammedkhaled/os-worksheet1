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

* *Verification:* Press **Ctrl + S** to save `README.md`[cite: 10].

---

### Step 2: Commit and Push to GitHub

Save and push your progress to GitHub using your CSCTCloud terminal[cite: 22, 26]:

```bash
cd /home/hafiz2.khaled/os-worksheet1
git add .
git commit -m "Add Task 1 code and README documentation"
git push origin main