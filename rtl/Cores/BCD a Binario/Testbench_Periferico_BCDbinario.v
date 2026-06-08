`timescale 1ns / 1ps

module Testbench_Periferico_BCDbinario;

    reg clk;
    reg reset;
    reg cs;
    reg rd;
    reg wr;
    reg [4:0] addr;
    reg [31:0] d_in;

    wire [31:0] d_out;

    Periferico_BCDbinario uut (
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
        input [31:0] entrada_bcd;
        input [31:0] esperado_bin;

        reg [31:0] done_read;
        reg [31:0] result_read;
        integer timeout;

        begin
            $display("----------------------------------");
            $display("PERIFERICO BCD A BINARIO");
            $display("Entrada BCD h    = %h", entrada_bcd);

            write_reg(5'h04, entrada_bcd);

            write_reg(5'h08, 32'h00000001);
            write_reg(5'h08, 32'h00000000);

            done_read = 32'h00000000;
            timeout = 0;

            while (done_read[0] == 1'b0 && timeout < 200) begin
                read_reg(5'h10, done_read);
                timeout = timeout + 1;
            end

            read_reg(5'h0C, result_read);

            $display("DONE leído       = %h", done_read);
            $display("Resultado dec    = %0d", result_read);
            $display("Resultado hex    = %h", result_read);
            $display("Esperado dec     = %0d", esperado_bin);

            if (result_read == esperado_bin && done_read[0] == 1'b1)
                $display("PRUEBA PERIFERICO OK");
            else
                $display("PRUEBA PERIFERICO ERROR");

            // Verificación: DONE_reg debe quedarse en 1
            repeat (5) @(posedge clk);
            read_reg(5'h10, done_read);

            if (done_read[0] == 1'b1)
                $display("DONE_reg se mantiene OK");
            else
                $display("ERROR: DONE_reg no se mantuvo");

            @(posedge clk);
        end
    endtask

    initial begin
        $dumpfile("Testbench_Periferico_BCDbinario.vcd");
        $dumpvars(0, Testbench_Periferico_BCDbinario);

        clk = 0;
        reset = 1;
        cs = 0;
        rd = 0;
        wr = 0;
        addr = 5'h00;
        d_in = 32'h00000000;

        #50;
        reset = 0;

        
        run_test(32'h00000123, 32'd123);
        

        #100;
        $finish;
    end

endmodule

// iverilog -s Testbench_Periferico_BCDbinario -o sim *.v
// vvp sim
// gtkwave Testbench_Periferico_BCDbinario.vcd