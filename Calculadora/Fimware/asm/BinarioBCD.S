.equ BCD_BASE,    0x00410000
.equ BCD_OP_A,    0x04
.equ BCD_INIT,    0x08
.equ BCD_RESULT,  0x0C
.equ BCD_DONE,    0x10

.section .text
.globl bin2bcd_hw

# Entrada:  a0 = número binario unsigned de 32 bits
#           Rango válido de diseño: 0 a 99,999,999
#
# Salida:   a0 = resultado BCD empaquetado de 32 bits
#           {D7, D6, D5, D4, D3, D2, D1, D0}
#
# Ejemplo:
#           a0 = 20102238 decimal
#           salida a0 = 0x20102238

bin2bcd_hw:
    li   gp, BCD_BASE

    sw   a0, BCD_OP_A(gp)        # escribir número binario de entrada

    li   a0, 1
    sw   a0, BCD_INIT(gp)        # init = 1
    sw   zero, BCD_INIT(gp)      # init = 0, pulso de arranque

.wait_bcd:
    li   t0, 1
    lw   t1, BCD_DONE(gp)        # leer DONE_reg del periférico
    and  t1, t1, t0
    beqz t1, .wait_bcd           # esperar hasta DONE = 1

    lw   a0, BCD_RESULT(gp)      # leer BCD_reg del periférico
    ret
    