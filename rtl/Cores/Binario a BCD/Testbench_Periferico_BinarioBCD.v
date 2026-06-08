`timescale 1ns / 1ps

module Testbench_Periferico_BinarioBCD;

    reg clk;
    reg reset;

    reg [31:0] d_in;
    reg cs;
    reg [4:0] addr;
    reg rd;
    reg wr;

    wire [31:0] d_out;

    reg [31:0] DONE;
    reg [31:0] Resultado_BCD;

    Periferico_BinarioBCD uut (
        .clk(clk),
        .reset(reset),
        .d_in(d_in),
        .cs(cs),
        .addr(addr),
        .rd(rd),
        .wr(wr),
        .d_out(d_out)
    );

    always #10 clk = ~clk;

    task write_reg;
        input [4:0] address;
        input [31:0] data;
        begin
            @(posedge clk);
            cs   = 1;
            wr   = 1;
            rd   = 0;
            addr = address;
            d_in = data;

            @(posedge clk);
            cs   = 0;
            wr   = 0;
            addr = 5'h00;
            d_in = 32'h00000000;
        end
    endtask

    task read_reg;
        input [4:0] address;
        output [31:0] data;
        begin
            @(posedge clk);
            cs   = 1;
            rd   = 1;
            wr   = 0;
            addr = address;

            #1;
            data = d_out;

            @(posedge clk);
            cs   = 0;
            rd   = 0;
            addr = 5'h00;
        end
    endtask

    task run_test;
        input [31:0] entrada;
        input [31:0] esperado;
        begin
            write_reg(5'h04, entrada);

            write_reg(5'h08, 32'd1);
            write_reg(5'h08, 32'd0);

            DONE = 32'd0;

            while (DONE[0] == 1'b0) begin
                read_reg(5'h10, DONE);
            end

            read_reg(5'h0C, Resultado_BCD);

            $display("----------------------------------");
            $display("PERIFERICO");
            $display("Entrada decimal = %0d", entrada);
            $display("Entrada binaria = %032b", entrada);
            $display("DONE            = %0d", DONE[0]);
            $display("Resultado BCD h = %h", Resultado_BCD);
            $display("Resultado BCD b = %032b", Resultado_BCD);
            $display("BCD esperado h  = %h", esperado);

            if (Resultado_BCD == esperado)
                $display("PRUEBA PERIFERICO OK");
            else
                $display("PRUEBA PERIFERICO ERROR");
        end
    endtask

    initial begin
        $dumpfile("Testbench_Periferico_BinarioBCD.vcd");
        $dumpvars(0, Testbench_Periferico_BinarioBCD);

        clk = 0;
        reset = 1;
        d_in = 0;
        cs = 0;
        addr = 0;
        rd = 0;
        wr = 0;
        DONE = 0;
        Resultado_BCD = 0;

        #50;
        reset = 0;

        run_test(32'd20102238, 32'h20102238);
        run_test(32'd87654321, 32'h87654321);
        run_test(32'd99999999, 32'h99999999);

        #100;
        $finish;
    end

endmodule

//iverilog -s Testbench_Periferico_BinarioBCD -o sim *.v
//gtkwave Testbench_Periferico_BinarioBCD.vcd