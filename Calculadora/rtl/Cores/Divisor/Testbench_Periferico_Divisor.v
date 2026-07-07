`timescale 1ns/1ps

module Testbench_Periferico_Divisor;

    reg clk;
    reg reset;
    reg [31:0] d_in;
    reg cs;
    reg [4:0] addr;
    reg rd;
    reg wr;

    wire [31:0] d_out;

    Periferico_Divisor DUT (
        .clk(clk),
        .reset(reset),
        .d_in(d_in),
        .cs(cs),
        .addr(addr),
        .rd(rd),
        .wr(wr),
        .d_out(d_out)
    );

    always #5 clk = ~clk;

    task escribir;
        input [4:0] direccion;
        input [31:0] dato;
        begin
            @(negedge clk);
            cs   = 1;
            wr   = 1;
            rd   = 0;
            addr = direccion;
            d_in = dato;

            @(negedge clk);
            wr = 0;
        end
    endtask

    task leer;
        input [4:0] direccion;
        begin
            @(negedge clk);
            cs   = 1;
            rd   = 1;
            wr   = 0;
            addr = direccion;

            #1;
        end
    endtask

    initial begin

        $dumpfile("Periferico_Divisor.vcd");
        $dumpvars(0, Testbench_Periferico_Divisor);

        clk   = 0;
        reset = 1;
        d_in  = 0;
        cs    = 0;
        addr  = 0;
        rd    = 0;
        wr    = 0;

        #20;
        reset = 0;

        // =========================
        // Operacion 1: 100 / 12
        // Esperado: cociente 8, residuo 4
        // =========================

        escribir(5'h04, 32'd100);
        escribir(5'h08, 32'd12);

        escribir(5'h0C, 32'd1);
        escribir(5'h0C, 32'd0);

        wait(DUT.DONE_reg);

        leer(5'h18);
        $display("Operacion 1 - DONE = %d", d_out);

        leer(5'h10);
        $display("Operacion 1 - Resultado / Cociente = %d", d_out);

        leer(5'h14);
        $display("Operacion 1 - Residuo = %d", d_out);

        // =========================
        // Operacion 2: 25 / 5
        // Esperado: cociente 5, residuo 0
        // Sin resetear el sistema
        // =========================

        escribir(5'h04, 32'd25);
        escribir(5'h08, 32'd5);

        escribir(5'h0C, 32'd1);

        #1;
        $display("Despues de nuevo init=1:");
        $display("DONE_reg      = %d", DUT.DONE_reg);
        $display("Resultado_reg = %d", DUT.Resultado_reg);
        $display("Residuo_reg   = %d", DUT.Residuo_reg);

        escribir(5'h0C, 32'd0);

        wait(DUT.DONE_reg);

        leer(5'h18);
        $display("Operacion 2 - DONE = %d", d_out);

        leer(5'h10);
        $display("Operacion 2 - Resultado / Cociente = %d", d_out);

        leer(5'h14);
        $display("Operacion 2 - Residuo = %d", d_out);

        rd = 0;
        cs = 0;

        #20;
        $finish;

    end

endmodule

//iverilog -s Testbench_Periferico_Divisor -o sim *.v
//gtkwave Periferico_Divisor.vcd