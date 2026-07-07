`timescale 1ns / 1ps

module Testbench_Periferico_Raiz();

    reg clk;
    reg reset;

    reg [31:0] d_in;
    reg cs;
    reg [4:0] addr;
    reg rd;
    reg wr;

    wire [31:0] d_out;

    Periferico_Raiz uut (
        .clk(clk),
        .reset(reset),
        .d_in(d_in),
        .cs(cs),
        .addr(addr),
        .rd(rd),
        .wr(wr),
        .d_out(d_out)
    );

    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    task escribir;
        input [4:0] direccion;
        input [31:0] dato;
        begin
            @(posedge clk);
            cs   = 1;
            wr   = 1;
            rd   = 0;
            addr = direccion;
            d_in = dato;

            @(posedge clk);
            wr = 0;
            cs = 0;
        end
    endtask

    task leer;
        input [4:0] direccion;
        output [31:0] dato_leido;
        begin
            @(posedge clk);
            cs   = 1;
            rd   = 1;
            wr   = 0;
            addr = direccion;

            #5;
            dato_leido = d_out;

            @(posedge clk);
            rd = 0;
            cs = 0;
        end
    endtask

    reg [31:0] done_leido;
    reg [31:0] resultado_leido;
    reg [31:0] residuo_leido;

    initial begin
        reset = 1;
        cs    = 0;
        rd    = 0;
        wr    = 0;
        addr  = 5'b0;
        d_in  = 32'b0;

        #30;
        reset = 0;

        escribir(5'h04, 32'd36);

        escribir(5'h08, 32'd1);
        escribir(5'h08, 32'd0);

        wait(uut.DONE_status == 1'b1);

        leer(5'h14, done_leido);
        leer(5'h0C, resultado_leido);
        leer(5'h10, residuo_leido);

        $display("DONE      = %d", done_leido);
        $display("Resultado = %d", resultado_leido);
        $display("Residuo   = %d", residuo_leido);

        #100;
        $finish;
    end

    initial begin
        $dumpfile("Periferico_Raiz.vcd");
        $dumpvars(0, Testbench_Periferico_Raiz);
    end

    // iverilog -s Testbench_Periferico_Raiz -o sim *.v
    // gtkwave Periferico_Raiz.vcd

endmodule


