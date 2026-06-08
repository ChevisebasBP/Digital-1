TOP=SOC
TB=bench_quark

OBJS = SOC.v
OBJS += Cores/CPU/femtorv32_quark.v
OBJS += Cores/Bram/bram.v
OBJS += Cores/Uart/uart.v
OBJS += Cores/Uart/perip_uart.v

OBJS += Cores/Multiplicador/A_process_Multiplicador.v
OBJS += Cores/Multiplicador/B_process_Multiplicador.v
OBJS += Cores/Multiplicador/Comp_count_Multiplicador.v
OBJS += Cores/Multiplicador/Control_Multiplicador.v
OBJS += Cores/Multiplicador/Count_Mulplicador.v
OBJS += Cores/Multiplicador/Periferico_Multiplicador.v
OBJS += Cores/Multiplicador/TOP_Multiplicador.v
OBJS += Cores/Multiplicador/Z.v

OBJS += Cores/Divisor/A_process_Divisor.v
OBJS += Cores/Divisor/B_process_Divisor.v
OBJS += Cores/Divisor/Comp_count_Divisor.v
OBJS += Cores/Divisor/Control_Divisor.v
OBJS += Cores/Divisor/Count_Divisior.v
OBJS += Cores/Divisor/Periferico_Divisor.v
OBJS += Cores/Divisor/Restador.v
OBJS += Cores/Divisor/Resultado.v
OBJS += Cores/Divisor/TOP_Divisor.v
OBJS += Cores/Divisor/vAux.v

OBJS += Cores/Raiz/A_process_Raiz.v
OBJS += Cores/Raiz/B_process_Raiz.v
OBJS += Cores/Raiz/Comp_count_Raiz.v
OBJS += Cores/Raiz/Control_Raiz.v
OBJS += Cores/Raiz/Count_Raiz.v
OBJS += Cores/Raiz/Periferico_Raiz.v
OBJS += Cores/Raiz/Radicando_process.v
OBJS += Cores/Raiz/Restador.v
OBJS += Cores/Raiz/TMP.v
OBJS += Cores/Raiz/TOP_Raiz.v

OBJS += Cores/Binario\ a\ BCD/A_process_BinarioBCD.v
OBJS += Cores/Binario\ a\ BCD/BCD.v
OBJS += Cores/Binario\ a\ BCD/Comparador_BCD.v
OBJS += Cores/Binario\ a\ BCD/Comp_count_BinarioBCD.v
OBJS += Cores/Binario\ a\ BCD/Control_BinarioBCD.v
OBJS += Cores/Binario\ a\ BCD/Count_BinarioBCD.v
OBJS += Cores/Binario\ a\ BCD/Periferico_BinarioBCD.v
OBJS += Cores/Binario\ a\ BCD/TOP_BinarioBCD.v

OBJS += Cores/BCD\ a\ Binario/BCD_process_BCDbinario.v
OBJS += Cores/BCD\ a\ Binario/Binario_BCDbinario.v
OBJS += Cores/BCD\ a\ Binario/Comparador_BCDbinario.v
OBJS += Cores/BCD\ a\ Binario/Comp_count_BCDbinario.v
OBJS += Cores/BCD\ a\ Binario/Control_BCDbinario.v
OBJS += Cores/BCD\ a\ Binario/Count_BCDbinario.v
OBJS += Cores/BCD\ a\ Binario/Periferico_BCDbinario.v
OBJS += Cores/BCD\ a\ Binario/TOP_BCDbinario.v

all: sim_quark

sim_quark:
	rm -f a.out *.vcd
	iverilog -DBENCH $(TB).v $(OBJS)
	vvp a.out
	gtkwave bench.vcd

compile:
	iverilog -s $(TOP) -o sim_soc $(OBJS)

clean:
	rm -f a.out sim_soc *.vcd