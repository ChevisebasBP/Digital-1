`timescale 1ns / 1ps

module Testbench_TOP_BinarioBCD;

    reg clk;
    reg reset;
    reg init;
    reg [31:0] A;

    wire [31:0] BCD;
    wire DONE;

    TOP_BinarioBCD uut (
        .clk(clk),
        .reset(reset),
        .init(init),
        .A(A),
        .BCD(BCD),
        .DONE(DONE)
    );

    always #10 clk = ~clk;

    task run_test;
        input [31:0] entrada;
        input [31:0] esperado;
        begin
            A = entrada;

            @(posedge clk);
            init = 1;
            @(posedge clk);
            init = 0;

            wait(DONE == 1);
            #5;

            $display("----------------------------------");
            $display("TOP");
            $display("Entrada decimal = %0d", entrada);
            $display("Entrada binaria = %032b", entrada);
            $display("Resultado BCD h = %h", BCD);
            $display("Resultado BCD b = %032b", BCD);
            $display("BCD esperado h  = %h", esperado);

            if (BCD == esperado)
                $display("PRUEBA TOP OK");
            else
                $display("PRUEBA TOP ERROR");

            @(posedge clk);
        end
    endtask

    initial begin
        $dumpfile("Testbench_TOP_BinarioBCD.vcd");
        $dumpvars(0, Testbench_TOP_BinarioBCD);

        clk = 0;
        reset = 1;
        init = 0;
        A = 0;

        #50;
        reset = 0;

        run_test(32'd20102238, 32'h20102238);
        run_test(32'd87654321, 32'h87654321);
        run_test(32'd99999999, 32'h99999999);

        #100;
        $finish;
    end

endmodule


//iverilog -s Testbench_TOP_BinarioBCD -o sim *.v
//gtkwave Testbench_TOP_BinarioBCD.vcd
