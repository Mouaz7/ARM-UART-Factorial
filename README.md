# ARM-UART-Factorial

Simple ARM assembly program that computes factorials (1–10) using recursion and prints results via UART.

## Overview
This project contains an ARM assembly program that:
- Uses a recursive function to calculate factorials from 1 to 10.
- Outputs results over UART (base address `0xff201000`).
- Demonstrates UART communication, recursion, integer division, and printing routines in assembly.

## File
- `factorial_uart.s` — ARM assembly code.

## How It Works
1. Initializes the stack pointer.
2. Loops `n` from 1 to 10.
3. Calls the recursive factorial function.
4. Prints the result in the format:
   ```
   Fakulteten av n ar n!
   ```
   via UART.

## UART Configuration
- **Base Address:** `0xff201000`
- **Control Register Offset:** `4`
- The program waits until UART is ready before sending each character.

## How to Build and Run
You need an ARM toolchain such as `arm-none-eabi` and a board or emulator that matches the UART base address.

```bash
# Assemble
arm-none-eabi-as -o factorial_uart.o factorial_uart.s

# Link
arm-none-eabi-ld -Ttext=0x0 -o factorial_uart.elf factorial_uart.o

# (Optional) Convert to binary
arm-none-eabi-objcopy -O binary factorial_uart.elf factorial_uart.bin

# Load onto board/emulator
# Ensure UART base address matches your hardware setup
```

## Example Output
```
Fakulteten av 1 ar 1
Fakulteten av 2 ar 2
Fakulteten av 3 ar 6
...
Fakulteten av 10 ar 3628800
```

## License
This project is released under the MIT License.
