
## 📘 Introducción

Este módulo implementa un multiplicador binario secuencial basado en el algoritmo de productos parciales. El diseño sigue el enfoque trabajado en clase, donde primero se define el funcionamiento del algoritmo de manera conceptual y luego se traduce a una estructura más cercana a la implementación en Verilog, separando claramente el comportamiento lógico del sistema y su arquitectura final.

---

# 📊 1. Diagrama Algorítmico

![Diagrama Algorítmico](Diagrama.jpg)

Este primer diagrama representa el funcionamiento del algoritmo de manera escrita y secuencial. En él se describe paso a paso cómo se realiza la multiplicación binaria, comenzando con la inicialización del acumulador, la verificación del bit menos significativo del multiplicador y la ejecución de los corrimientos correspondientes.

Este esquema permite entender claramente cómo debe comportarse el sistema antes de implementarlo en código, e incluye los puntos clave discutidos en clase.

---

# 🏗 2. Diagrama Definitivo del Sistema

![Diagrama Definitivo](Diagrama_2.png)

Este segundo diagrama representa la versión estructurada del sistema, ya muy cercana a la implementación final en código Verilog.

A continuación se describe el significado de las principales señales y elementos del diagrama:

- **A_process**: Registro que almacena el multiplicando y se desplaza a la izquierda en cada iteración.
- **B_process**: Registro que almacena el multiplicador y se desplaza a la derecha para evaluar el bit menos significativo.
- **Z**: Acumulador donde se almacenan los productos parciales. Contiene el resultado final de la multiplicación.
- **count**: Contador que controla el número de iteraciones del algoritmo.
- **LSB(B_process)**: Bit menos significativo del multiplicador, utilizado para decidir si se realiza la suma parcial.
- **DONE**: Señal que indica que el proceso de multiplicación ha finalizado y que el resultado está disponible.
- **<< 1**: Operación de corrimiento lógico a la izquierda.
- **>> 1**: Operación de corrimiento lógico a la derecha.

Este diagrama ya refleja directamente la estructura que posteriormente será implementada en el módulo en Verilog.

