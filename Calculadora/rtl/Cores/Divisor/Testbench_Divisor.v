`timescale 1ns/1ps

module Testbench_Divisor;

    parameter width = 31;

    reg clk;
    reg rst;
    reg init;

    reg  [width:0] Dividendo;
    reg  [width:0] DR;

    wire [width:0] Residuo;
    wire [width:0] Resultado;
    wire DONE;

    TOP_Divisor #(
        .width(width)
    ) DUT (
        .clk(clk),
        .rst(rst),
        .init(init),
        .Dividendo(Dividendo),
        .DR(DR),
        .Residuo(Residuo),
        .Resultado(Resultado),
        .DONE(DONE)
    );

    always #5 clk = ~clk;

    initial begin

        $dumpfile("divisor.vcd");
        $dumpvars(0, Testbench_Divisor);

        clk = 0;
        rst = 1;
        init = 0;

        Dividendo = 0;
        DR = 0;

        #20;
        rst = 0;

        // Prueba

        Dividendo = 32'd100;
        DR        = 32'd12;

        #10;
        init = 1;

        #10;
        init = 0;

        wait(DONE);

        #20;

        $display("Dividendo = %d", Dividendo);
        $display("Divisor   = %d", DR);
        $display("Cociente  = %d", Resultado);
        $display("Residuo   = %d", Residuo);

        #20;

        $finish;

    end

endmodule


//iverilog -s Testbench_Divisor -o sim *.v

//vvp sim

//gtkwave divisor.vcd
//iverilog -s Testbench_Periferico_Divisor -o sim *.v