.equ BCDBIN_BASE,    0x00450000
.equ BCDBIN_BCD,     0x04
.equ BCDBIN_INIT,    0x08
.equ BCDBIN_RESULT,  0x0C
.equ BCDBIN_DONE,    0x10

.section .text
.globl bcd2bin_hw

# Entrada:  a0 = número BCD empaquetado de 32 bits
# Salida:   a0 = resultado binario de 32 bits

bcd2bin_hw:
    li   gp, BCDBIN_BASE

    sw   a0, BCDBIN_BCD(gp)       # escribir BCD de entrada

    li   a0, 1
    sw   a0, BCDBIN_INIT(gp)      # init = 1
    sw   zero, BCDBIN_INIT(gp)    # init = 0



.wait_done_bcd2bin:
    lw   t1, BCDBIN_DONE(gp)      # leer DONE
    andi t1, t1, 1
    beqz t1, .wait_done_bcd2bin

    lw   a0, BCDBIN_RESULT(gp)    # leer resultado binario

    ret
    