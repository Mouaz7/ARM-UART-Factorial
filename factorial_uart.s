// Konstantdefinitioner
.equ UART_BASE, 0xff201000          // Basadress för UART
.equ UART_CONTROL_REG_OFFSET, 4     // UART kontrollregister offset
.equ STACK_BASE, 0x10000000         // Startadress för stacken
.equ NEW_LINE, 0x0A                 // ASCII-kod för ny rad

.global _start

.text

/*******************************************************************
  Rekursiv funktion för att beräkna fakulteten
  Parametrar:
    R0 - n (talet att beräkna fakultet av)
  Returnerar:
    R0 - n!
*******************************************************************/
factorial:
    CMP R0, #1
    BLE factorial_base_case
    PUSH {R0, LR}
    SUB R0, R0, #1
    BL factorial
    POP {R1, LR}
    MUL R0, R0, R1
    BX LR

factorial_base_case:
    MOV R0, #1
    BX LR

/*******************************************************************
  Funktion för att skriva ut resultatet
*******************************************************************/
print_result:
    PUSH {R0, R1, LR}
    LDR R1, =string1
    BL print_string
    MOV R0, R2
    BL print_number
    LDR R1, =string2
    BL print_string
    MOV R0, R3
    BL print_number
    MOV R0, #NEW_LINE
    BL print_char
    POP {R0, R1, LR}
    BX LR

/*******************************************************************
  Funktion för att skriva ut ett tecken
*******************************************************************/
print_char:
    PUSH {R1-R4, LR}
    LDR R1, =UART_BASE
wait_for_uart:
    LDR R2, [R1, #UART_CONTROL_REG_OFFSET]
    MOV R3, #0xFFFF
    LSL R3, R3, #16
    ANDS R4, R2, R3
    BEQ wait_for_uart
    STR R0, [R1]
    POP {R1-R4, LR}
    BX LR

/*******************************************************************
  Funktion för att skriva ut en sträng
*******************************************************************/
print_string:
    PUSH {R0, R1, LR}
print_string_loop:
    LDRB R0, [R1], #1
    CMP R0, #0
    BEQ print_string_end
    BL print_char
    B print_string_loop
print_string_end:
    POP {R0, R1, LR}
    BX LR

/*******************************************************************
  Funktion för att skriva ut ett heltal
*******************************************************************/
print_number:
    PUSH {R0-R5, LR}
    MOV R5, #0
    CMP R0, #0
    BNE number_loop_start
    MOV R1, #0x30
    BL print_char
    B number_done

number_loop_start:
number_loop:
    ADD R5, R5, #1
    MOV R1, #10
    BL idiv
    PUSH {R1}
    CMP R0, #0
    BNE number_loop

print_digits:
    POP {R0}
    ADD R0, R0, #0x30
    BL print_char
    SUB R5, R5, #1
    CMP R5, #0
    BNE print_digits
number_done:
    POP {R0-R5, LR}
    BX LR

/*******************************************************************
  Funktion för heltalsdivision
*******************************************************************/
idiv:
    PUSH {R2, R3, LR}
    MOV R2, R0
    MOV R3, R1
    MOV R0, #0
div_loop:
    CMP R2, R3
    BLO div_end
    SUB R2, R2, R3
    ADD R0, R0, #1
    B div_loop
div_end:
    MOV R1, R2
    POP {R2, R3, LR}
    BX LR

/*******************************************************************
  Huvudprogram
*******************************************************************/
_start:
    LDR SP, =STACK_BASE
    MOV R4, #1

loop:
    CMP R4, #11
    BEQ end_program
    MOV R2, R4
    MOV R0, R4
    BL factorial
    MOV R3, R0
    BL print_result
    ADD R4, R4, #1
    B loop

end_program:
    B end_program

/*******************************************************************
  Data-sektion för strängar
*******************************************************************/
.data
string1: .asciz "Fakulteten av "
string2: .asciz " ar "
