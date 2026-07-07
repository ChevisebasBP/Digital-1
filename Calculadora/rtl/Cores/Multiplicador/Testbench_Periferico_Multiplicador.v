`timescale 1ns / 1ps

module Testbench_Periferico_Multiplicador;

    reg clk;
    reg reset;
    reg [15:0] d_in;
    reg cs;
    reg [4:0] addr;
    reg rd;
    reg wr;

    wire [31:0] d_out;

    Periferico_Multiplicador uut (
        .clk(clk),
        .reset(reset),
        .d_in(d_in),
        .cs(cs),
        .addr(addr),
        .rd(rd),
        .wr(wr),
        .d_out(d_out)
    );

    always begin
        #5 clk = ~clk;
    end

    initial begin
        $dumpfile("Periferico_Multiplicador.vcd");
        $dumpvars(0, Testbench_Periferico_Multiplicador);

        clk = 0;
        reset = 1;
        d_in = 0;
        cs = 0;
        addr = 0;
        rd = 0;
        wr = 0;

        #20;
        reset = 0;

        // A = 13
        @(posedge clk);
        cs = 1; wr = 1; rd = 0;
        addr = 5'h04;
        d_in = 16'd13;

        @(posedge clk);
        cs = 0; wr = 0;

        // B = 16
        @(posedge clk);
        cs = 1; wr = 1; rd = 0;
        addr = 5'h08;
        d_in = 16'd16;

        @(posedge clk);
        cs = 0; wr = 0;

        // init = 1
        @(posedge clk);
        cs = 1; wr = 1; rd = 0;
        addr = 5'h0C;
        d_in = 16'd1;

        @(posedge clk);
        cs = 0; wr = 0;

        // mantener init unos ciclos
        repeat (3) @(posedge clk);

        // init = 0
        @(posedge clk);
        cs = 1; wr = 1; rd = 0;
        addr = 5'h0C;
        d_in = 16'd0;

        @(posedge clk);
        cs = 0; wr = 0;

        // Esperar hasta que el multiplicador termine
        wait (uut.DONE_status == 1);

        // Leer DONE
        @(posedge clk);
        cs = 1; rd = 1; wr = 0;
        addr = 5'h14;

        #1;
        $display("DONE leido = %d", d_out);

        @(posedge clk);
        cs = 0; rd = 0;

        // Leer Resultado inmediatamente
        @(posedge clk);
        cs = 1; rd = 1; wr = 0;
        addr = 5'h10;

        #1;
        $display("Resultado leido = %d", d_out);

        @(posedge clk);
        cs = 0; rd = 0;

        #20;
        $finish;
    end


    //iverilog -s Testbench_Periferico_Multiplicador -o sim *.v
    //gtkwave Periferico_Multiplicador.vcd
endmodule