.option norelax

.section .text
.globl calculator

calculator:

loopM:
    li   sp, 0x2000

    # PRIMER NUMERO
    la   a0, number
    call putstring
    call get_number
    call bcd2bin_hw
    add  s0, a0, zero

    # OPERADOR
    la   a0, operator
    call putstring
    call getchar
    add  s2, a0, zero

    # Eco del operador
    add  a0, s2, zero
    call putchar

    # Raiz cuadrada: operador '$'
    li   t4, 36
    beq  s2, t4, OP_SQRT

    # SEGUNDO NUMERO
    la   a0, number
    call putstring
    call get_number
    call bcd2bin_hw
    add  s3, a0, zero

    # Seleccion de operacion
    li   t4, 42              # '*'
    beq  s2, t4, OP_MUL

    li   t4, 47              # '/'
    beq  s2, t4, OP_DIV

    li   t4, 43              # '+'
    beq  s2, t4, OP_ADD

    li   t4, 45              # '-'
    beq  s2, t4, OP_SUB

    j    loopM

OP_MUL:
    add  a0, s0, zero
    add  a1, s3, zero
    call mult_hw
    add  s1, a0, zero
    j    print_result

OP_DIV:
    beqz s3, error_div_zero
    add  a0, s0, zero
    add  a1, s3, zero
    call div_hw
    add  s1, a0, zero
    j    print_result

OP_ADD:
    add  s1, s0, s3
    j    print_result

OP_SUB:
    bltu s0, s3, error_unsigned_sub
    sub  s1, s0, s3
    j    print_result

OP_SQRT:
    add  a0, s0, zero
    call sqrt_hw
    add  s1, a0, zero
    j    print_result

error_div_zero:
    la   a0, msg_div_zero
    call putstring
    j    loopM

error_unsigned_sub:
    la   a0, msg_unsigned_sub
    call putstring
    j    loopM

print_result:
    la   a0, result
    call putstring

    add  a0, s1, zero
    call bin2bcd_hw
    add  s1, a0, zero

    li   t3, 8

print_loop:
    srli t0, s1, 28
    andi t0, t0, 0x0F
    addi t0, t0, 0x30
    add  a0, t0, zero
    call putchar

    slli s1, s1, 4
    addi t3, t3, -1
    bnez t3, print_loop

    j    loopM

.section .data

number:
    .asciz "\n\rNumber: "

operator:
    .asciz "\n\rOperator: "

result:
    .asciz "\n\rResult = "

msg_div_zero:
    .asciz "\n\rError: division por cero\n\r"

msg_unsigned_sub:
    .asciz "\n\rError: resultado negativo no permitido\n\r"
    