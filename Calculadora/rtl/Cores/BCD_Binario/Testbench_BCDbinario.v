`timescale 1ns / 1ps

module Testbench_TOP_BCDbinario;

    reg clk;
    reg reset;
    reg init;
    reg [31:0] BCD;

    wire [31:0] BIN;
    wire DONE;

    TOP_BCDbinario uut (
        .clk(clk),
        .reset(reset),
        .init(init),
        .BCD(BCD),
        .BIN(BIN),
        .DONE(DONE)
    );

    always #10 clk = ~clk;

    task run_test;
        input [31:0] entrada_bcd;
        input [31:0] esperado_bin;
        begin
            BCD = entrada_bcd;

            @(posedge clk);
            init = 1;
            @(posedge clk);
            init = 0;

            wait(DONE == 1);
            #5;

            $display("----------------------------------");
            $display("TOP BCD A BINARIO");
            $display("Entrada BCD h       = %h", entrada_bcd);
            $display("Resultado BIN dec   = %0d", BIN);
            $display("Resultado BIN h     = %h", BIN);
            $display("Esperado BIN dec    = %0d", esperado_bin);

            if (BIN == esperado_bin)
                $display("PRUEBA TOP OK");
            else
                $display("PRUEBA TOP ERROR");

            @(posedge clk);
        end
    endtask

    initial begin
        $dumpfile("Testbench_TOP_BCDbinario.vcd");
        $dumpvars(0, Testbench_TOP_BCDbinario);

        clk = 0;
        reset = 1;
        init = 0;
        BCD = 0;

        #50;
        reset = 0;

        run_test(32'h00000000, 32'd0);
        run_test(32'h00000004, 32'd4);
        run_test(32'h00000015, 32'd15);
        run_test(32'h00000123, 32'd123);
        run_test(32'h00201022, 32'd201022);
        run_test(32'h20102238, 32'd20102238);
        run_test(32'h87654321, 32'd87654321);
        run_test(32'h99999999, 32'd99999999);

        #100;
        $finish;
    end

endmodule

// iverilog -s Testbench_TOP_BCDbinario -o sim *.v
// vvp sim
// gtkwave Testbench_TOP_BCDbinario.vcd