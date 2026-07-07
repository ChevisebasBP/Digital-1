.equ DIV_BASE,      0x00430000
.equ DIV_DIVIDENDO, 0x04
.equ DIV_DR,        0x08
.equ DIV_INIT,      0x0C
.equ DIV_RESULTADO, 0x10
.equ DIV_RESIDUO,   0x14
.equ DIV_DONE,      0x18

.section .text
.globl div_hw

# Entrada:  a0 = Dividendo unsigned 32-bit
#           a1 = Divisor   unsigned 32-bit
# Salida:   a0 = Cociente  unsigned 32-bit

div_hw:
    li   gp, DIV_BASE

    sw   a0, DIV_DIVIDENDO(gp)
    sw   a1, DIV_DR(gp)

    li   t0, 1
    sw   t0, DIV_INIT(gp)
    sw   zero, DIV_INIT(gp)

.wait_div:
    lw   t1, DIV_DONE(gp)
    andi t1, t1, 1
    beqz t1, .wait_div

    lw   a0, DIV_RESULTADO(gp)
    ret
    