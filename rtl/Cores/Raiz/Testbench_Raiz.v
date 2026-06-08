`timescale 1ns / 1ps

module Testbench_Raiz();

    reg clk;
    reg rst;
    reg init;
    reg [31:0] A;

    wire [15:0] B;
    wire [31:0] Residuo;
    wire done;

    TOP_Raiz uut (
        .clk(clk),
        .rst(rst),
        .init(init),
        .A(A),
        .B(B),
        .Residuo(Residuo),
        .done(done)
    );

    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    initial begin
        rst = 1;
        init = 0;
        A = 32'd0;

        #30;
        rst = 0;

        #20;
        A = 32'd26;
        init = 1;

        #20;
        init = 0;

        wait(done == 1);

        $display("A        = %d", A);
        $display("B        = %d", B);
        $display("Residuo  = %d", Residuo);
        $display("DONE     = %d", done);

        #100;
        $finish;
    end

    initial begin
        $dumpfile("Raiz.vcd");
        $dumpvars(0, Testbench_Raiz);
    end

endmodule



//iverilog -s Testbench_Raiz -o sim *.v

//gtkwave Raiz.vcd