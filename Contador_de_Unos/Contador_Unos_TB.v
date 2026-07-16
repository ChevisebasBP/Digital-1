`timescale 1ns / 1ps

module Contador_Unos_TB;

    reg         clk;
    reg         reset;
    reg         init;
    reg  [31:0] A;

    wire [31:0] P;
    wire        done;

    integer errores;


    // Módulo bajo prueba
    Contador_Unos uut (
        .clk   (clk),
        .reset (reset),
        .init  (init),
        .A     (A),
        .P     (P),
        .done  (done)
    );


    // Reloj de periodo de 20 ns
    initial begin
        clk = 1'b0;

        forever begin
            #10 clk = ~clk;
        end
    end


    // Tarea para realizar cada prueba
    task probar_contador;
        input [31:0] dato;
        input [31:0] esperado;

        integer ciclos;

        begin
            // Esperar un flanco negativo para cambiar las entradas
            @(negedge clk);

            A    = dato;
            init = 1'b1;

            ciclos = 0;

            // Esperar hasta que termine la operación
            while ((done !== 1'b1) && (ciclos < 200)) begin
                @(negedge clk);
                ciclos = ciclos + 1;
            end

            // Revisar si hubo timeout
            if (done !== 1'b1) begin
                $display(
                    "ERROR: timeout para A = %h",
                    dato
                );

                errores = errores + 1;
            end

            // Revisar el resultado
            else if (P === esperado) begin
                $display(
                    "OK: A = %h, unos esperados = %0d, resultado = %0d",
                    dato,
                    esperado,
                    P
                );
            end

            else begin
                $display(
                    "ERROR: A = %h, esperado = %0d, resultado = %0d",
                    dato,
                    esperado,
                    P
                );

                errores = errores + 1;
            end

            // Bajar init para salir del estado END1
            init = 1'b0;

            // Esperar a que el control regrese a START
            @(negedge clk);
        end
    endtask


    // Secuencia de pruebas
    initial begin

        reset   = 1'b1;
        init    = 1'b0;
        A       = 32'b0;
        errores = 0;

        // Mantener reset durante dos ciclos
        repeat (2) @(posedge clk);

        reset = 1'b0;


        // Ningún bit en 1
        probar_contador(
            32'h00000000,
            32'd0
        );

        // Un solo bit en 1
        probar_contador(
            32'h00000001,
            32'd1
        );

        // Bit más significativo en 1
        probar_contador(
            32'h80000000,
            32'd1
        );

        // Cuatro bits en 1
        probar_contador(
            32'h0000000F,
            32'd4
        );

        // Patrón alternado: 16 unos
        probar_contador(
            32'hAAAAAAAA,
            32'd16
        );

        // Todos los bits en 1
        probar_contador(
            32'hFFFFFFFF,
            32'd32
        );

        // Prueba adicional: contiene 13 unos
        probar_contador(
            32'h12345678,
            32'd13
        );


        if (errores == 0) begin
            $display("");
            $display("----------------------------------");
            $display("TODAS LAS PRUEBAS FUERON CORRECTAS");
            $display("----------------------------------");
        end

        else begin
            $display("");
            $display("----------------------------------");
            $display("PRUEBAS CON ERRORES: %0d", errores);
            $display("----------------------------------");
        end

        #20;
        $finish;
    end


    // Archivo para GTKWave
    initial begin
        $dumpfile("Contador_Unos_TB.vcd");
        $dumpvars(0, Contador_Unos_TB);
    end

endmodule