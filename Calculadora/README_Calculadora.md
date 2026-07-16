# 🧮 Calculadora

[⬅ Volver al README principal](../README.md)

## 📘 Descripción general

Esta carpeta contiene el desarrollo de una **calculadora digital modular implementada en Verilog** e integrada a un sistema basado en un procesador RISC-V.

La calculadora está compuesta por cuatro módulos principales:

1. Multiplicador.
2. Divisor.
3. Raíz cuadrada.
4. Conversor de binario a BCD.

Cada módulo cuenta con su propio camino de datos, unidad de control, módulo `TOP`, testbench e interfaz como periférico del procesador.

---

## 📂 Estructura de la carpeta

```text
Calculadora/
├── Diagramas/
│   ├── Diagramas_Multiplicador/
│   │   ├── Diagramas_Multiplicador_Flujo.png
│   │   └── Diagramas_Multiplicador_Datapath.png
│   │
│   ├── Diagramas_Divisor/
│   │   ├── Diagramas_Divisor_Flujo.png
│   │   ├── Diagramas_Divisor_Datapath.png
│   │   └── Diagramas_Divisor_Estados.png
│   │
│   ├── Diagramas_Raiz/
│   │   ├── Diagramas_Raiz_Flujo.png
│   │   ├── Diagramas_Raiz_Datapath.png
│   │   └── Diagramas_Raiz_Estados.png
│   │
│   └── Diagramas_BinarioBCD/
│       ├── Diagramas_BinarioBCD_Flujo.png
│       ├── Diagramas_BinarioBCD_Datapath.png
│       └── Diagramas_BinarioBCD_Estados.png
│
├── Fimware/
│   ├── asm/
│   │   ├── Multiplicador.S
│   │   ├── Divisor.S
│   │   ├── Raiz.S
│   │   ├── BinarioBCD.S
│   │   ├── calculator.S
│   │   ├── bram.ld
│   │   └── Makefile
│   │
│   └── firmware_words_src/
│
├── rtl/
│   ├── Cores/
│   │   ├── Multiplicador/
│   │   ├── Divisor/
│   │   ├── Raiz/
│   │   ├── Binario_BCD/
│   │   ├── BCD_Binario/
│   │   ├── Bram/
│   │   ├── CPU/
│   │   └── Uart/
│   │
│   ├── Build/
│   ├── bench_quark.v
│   ├── firmware.hex
│   ├── firmware_flash.hex
│   ├── Makefile
│   ├── SOC_i9.lpf
│   └── SOC.v
│
└── README_Calculadora.md
```

---

# 📦 Módulos de la calculadora

## ✖️ 1. [Multiplicador](rtl/Cores/Multiplicador/README.md)

El multiplicador realiza una multiplicación binaria secuencial mediante corrimientos y sumas parciales.

Durante cada iteración se revisa el bit menos significativo del multiplicador. Cuando este bit vale `1`, el multiplicando se suma al producto parcial. Después, el multiplicando se desplaza a la izquierda y el multiplicador a la derecha. El proceso continúa hasta completar las iteraciones definidas por el contador.

<table>
  <tr>
    <th>Diagrama de flujo</th>
    <th>Datapath y diagrama de estados</th>
  </tr>
  <tr>
    <td><img src="./Diagramas/Diagramas_Multiplicador/Diagramas_Multiplicador_Flujo.png" width="360"></td>
    <td><img src="./Diagramas/Diagramas_Multiplicador/Diagramas_Multiplicador_Datapath.png" width="520"></td>
  </tr>
</table>

La explicación detallada de sus señales, componentes y archivos se encuentra en el [README del Multiplicador](rtl/Cores/Multiplicador/README.md).

---

## ➗ 2. [Divisor](rtl/Cores/Divisor/README.md)

El divisor implementa una división binaria secuencial sin signo mediante corrimientos, comparaciones y restas sucesivas.

En cada iteración se desplazan los registros que contienen el dividendo y el residuo parcial. Luego se compara el residuo con el divisor. Cuando la resta es válida, el resultado se conserva y se agrega un `1` al cociente; de lo contrario, se agrega un `0`. Al finalizar se entregan el cociente y el residuo.

<table>
  <tr>
    <th>Diagrama de flujo</th>
    <th>Datapath</th>
    <th>Diagrama de estados</th>
  </tr>
  <tr>
    <td><img src="./Diagramas/Diagramas_Divisor/Diagramas_Divisor_Flujo.png" width="280"></td>
    <td><img src="./Diagramas/Diagramas_Divisor/Diagramas_Divisor_Datapath.png" width="400"></td>
    <td><img src="./Diagramas/Diagramas_Divisor/Diagramas_Divisor_Estados.png" width="350"></td>
  </tr>
</table>

La explicación detallada de sus señales, componentes y archivos se encuentra en el [README del Divisor](rtl/Cores/Divisor/README.md).

---

## √ 3. [Raíz cuadrada](rtl/Cores/Raiz/README.md)

El módulo calcula la raíz cuadrada entera de un número binario mediante un algoritmo iterativo similar a la división larga.

El radicando se procesa en parejas de bits. En cada iteración se forma un valor parcial, se realiza una comparación mediante una resta y se decide si el siguiente bit del resultado debe ser `0` o `1`. Una máquina de control coordina las cargas, corrimientos, restas y el contador.

<table>
  <tr>
    <th>Diagrama de flujo</th>
    <th>Datapath</th>
    <th>Diagrama de estados</th>
  </tr>
  <tr>
    <td><img src="./Diagramas/Diagramas_Raiz/Diagramas_Raiz_Flujo.png" width="280"></td>
    <td><img src="./Diagramas/Diagramas_Raiz/Diagramas_Raiz_Datapath.png" width="400"></td>
    <td><img src="./Diagramas/Diagramas_Raiz/Diagramas_Raiz_Estados.png" width="350"></td>
  </tr>
</table>

La explicación detallada de sus señales, componentes y archivos se encuentra en el [README de Raíz cuadrada](rtl/Cores/Raiz/README.md).

---

## 🔢 4. [Binario a BCD](rtl/Cores/Binario_BCD/README.md)

Este módulo convierte un número binario a su representación decimal codificada en BCD mediante el algoritmo **Double Dabble**.

El procedimiento revisa cada dígito BCD antes de realizar un corrimiento. Cuando un dígito es mayor o igual a cinco, se le suma tres. Después se desplaza el registro completo para incorporar el siguiente bit del número binario. El proceso se repite hasta convertir todos los bits de entrada.

<table>
  <tr>
    <th>Diagrama de flujo</th>
    <th>Datapath</th>
    <th>Diagrama de estados</th>
  </tr>
  <tr>
    <td><img src="./Diagramas/Diagramas_BinarioBCD/Diagramas_BinarioBCD_Flujo.png" width="280"></td>
    <td><img src="./Diagramas/Diagramas_BinarioBCD/Diagramas_BinarioBCD_Datapath.png" width="400"></td>
    <td><img src="./Diagramas/Diagramas_BinarioBCD/Diagramas_BinarioBCD_Estados.png" width="350"></td>
  </tr>
</table>

La explicación detallada de sus señales, componentes y archivos se encuentra en el [README de Binario a BCD](rtl/Cores/Binario_BCD/README.md).

---

## 🧩 Organización de los módulos

Cada carpeta de módulo contiene, según corresponda:

- Los bloques que forman el camino de datos.
- La máquina de control.
- El módulo `TOP`.
- Un testbench para verificar el módulo de manera independiente.
- Un periférico para conectarlo al procesador.
- Un testbench para verificar el periférico.
- Un `README.md` con la explicación detallada.

Los archivos ensamblador utilizados para acceder a los periféricos se encuentran en `Fimware/asm/`.

---

## 🔗 Integración con el procesador

Los módulos se conectan al procesador RISC-V como periféricos mediante el archivo [`SOC.v`](rtl/SOC.v).

El software almacenado en `Fimware/asm/` se encarga de:

1. Enviar los operandos al periférico.
2. Activar la señal de inicio.
3. Consultar la señal de finalización.
4. Leer el resultado de la operación.

El archivo [`calculator.S`](Fimware/asm/calculator.S) integra las operaciones de la calculadora, mientras que los archivos `Multiplicador.S`, `Divisor.S`, `Raiz.S` y `BinarioBCD.S` realizan la comunicación con cada periférico.