.equ MUL_BASE,          0x00440000
.equ MUL_A,             0x04
.equ MUL_B,             0x08
.equ MUL_INIT,          0x0C
.equ MUL_RESULTADO,     0x10
.equ MUL_DONE,          0x14

.section .text
.globl mult_hw

# Entrada: a0 = A, multiplicando sin signo de 16 bits
#          a1 = B, multiplicador sin signo de 16 bits
# Salida:  a0 = Resultado sin signo de 32 bits

mult_hw:
    li   gp, MUL_BASE

    sw   a0, MUL_A(gp)              # escribir A
    sw   a1, MUL_B(gp)              # escribir B

    li   t0, 1
    sw   t0, MUL_INIT(gp)           # init = 1
    sw   zero, MUL_INIT(gp)         # init = 0

.wait_mul:
    lw   t1, MUL_DONE(gp)           # leer DONE
    andi t1, t1, 1
    beqz t1, .wait_mul              # esperar DONE == 1

    lw   a0, MUL_RESULTADO(gp)      # leer resultado
    ret
    