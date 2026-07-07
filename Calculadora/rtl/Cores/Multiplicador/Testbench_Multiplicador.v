`timescale 1ns / 1ps

module Testbench_Multiplicador;

    reg clk;
    reg reset;
    reg init;
    reg [15:0] A;
    reg [15:0] B;

    wire [31:0] Resultado;
    wire DONE;

    TOP_Multiplicador uut (
        .reset(reset),
        .clk(clk),
        .init(init),
        .A(A),
        .B(B),
        .Resultado(Resultado),
        .DONE(DONE)
    );

    // Generador de reloj
    always begin
        #5 clk = ~clk;
    end

    initial begin

        $dumpfile("Multiplicador.vcd");
        $dumpvars(0, Testbench_Multiplicador);

        clk = 0;
        reset = 1;
        init = 0;
        A = 16'd0;
        B = 16'd0;

        #20;
        reset = 0;

        // Prueba: 
        A = 16'd2;
        B = 16'd8;

        #10;
        init = 1;

        #10;
        init = 0;

        wait(DONE == 1);

        #20;

        $display("Resultado = %d", Resultado);

        $finish;
    end


//  iverilog -s Testbench_Multiplicador -o sim *.v
//  vvp sim
//  gtkwave Multiplicador.vcd




endmodule