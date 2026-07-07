.equ SQRT_BASE,      0x00420000
.equ SQRT_OP_A,      0x04
.equ SQRT_INIT,      0x08
.equ SQRT_RESULTADO, 0x0C
.equ SQRT_RESIDUO,   0x10
.equ SQRT_DONE,      0x14

.section .text
.globl sqrt_hw

# Entrada:  a0 = Radicando unsigned 32-bit
# Salida:   a0 = Raiz
#           a1 = Residuo

sqrt_hw:
    li   t0, SQRT_BASE

    sw   a0, SQRT_OP_A(t0)

    li   t1, 1
    sw   t1, SQRT_INIT(t0)
    sw   zero, SQRT_INIT(t0)

.wait_sqrt:

    lw   t2, SQRT_DONE(t0)
    andi t2, t2, 1
    beqz t2, .wait_sqrt

    lw   a0, SQRT_RESULTADO(t0)
    lw   a1, SQRT_RESIDUO(t0)

    ret