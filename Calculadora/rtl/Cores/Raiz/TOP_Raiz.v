module TOP_Raiz (
    input clk,
    input rst,
    input init,
    input [31:0] A,
    output [15:0] B,
    output [31:0] Residuo,
    output done
);

    wire ld_init;
    wire sh;
    wire dec;
    wire r0;
    wire lsb_b;
    wire lda2;

    wire [1:0] bits_bajan;

    wire [31:0] A_process_out;
    wire [31:0] TMP_out;
    wire [31:0] Resta_out;

    wire [15:0] B_process_out;

    wire [4:0] count_out;

    wire MSB;
    wire C;

    assign B = B_process_out;
    assign Residuo = A_process_out;

    A_process_Raiz modulo_A_process (
        .clk(clk),
        .rst(rst),
        .ld_init(ld_init),
        .sh(sh),
        .lda2(lda2),
        .bits_bajan(bits_bajan),
        .resta(Resta_out),
        .A_out(A_process_out)
    );

    Radicando_process modulo_Radicando_process (
        .clk(clk),
        .rst(rst),
        .ld_init(ld_init),
        .sh(sh),
        .A(A),
        .bits_bajan(bits_bajan)
    );

    B_process_Raiz modulo_B_process (
        .clk(clk),
        .rst(rst),
        .ld_init(ld_init),
        .r0(r0),
        .lsb_b(lsb_b),
        .B_out(B_process_out)
    );

    TMP modulo_TMP (
        .B_in(B_process_out),
        .TMP_out(TMP_out)
    );

    Restador_Raiz modulo_Restador (
        .A_in(A_process_out),
        .TMP_in(TMP_out),
        .Resta_out(Resta_out),
        .MSB(MSB)
    );

    Count_Raiz modulo_Count (
        .clk(clk),
        .rst(rst),
        .ld_init(ld_init),
        .dec(dec),
        .count_out(count_out)
    );

    Comp_count_Raiz modulo_Comp_count (
        .count_in(count_out),
        .C(C)
    );

    Control_Raiz modulo_Control_Raiz (
        .clk(clk),
        .rst(rst),
        .init(init),
        .MSB(MSB),
        .C(C),
        .ld_init(ld_init),
        .sh(sh),
        .dec(dec),
        .r0(r0),
        .lsb_b(lsb_b),
        .lda2(lda2),
        .done(done)
    );

endmodule