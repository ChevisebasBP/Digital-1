module TOP_BCDbinario (
    input clk,
    input reset,
    input init,
    input [31:0] BCD,
    output [31:0] BIN,
    output DONE
);

    wire LD;
    wire SH;
    wire SUB3;
    wire DEC;

    wire [31:0] BCD_out;
    wire LSB_BCD;

    wire [31:0] BIN_out;

    wire [7:0] M_digit;
    wire M;

    wire [5:0] count;
    wire C;

    BCD_process_BCDbinario U1 (
        .clk(clk),
        .LD(LD),
        .SH(SH),
        .SUB3(SUB3),
        .BCD(BCD),
        .BCD_out(BCD_out),
        .LSB_BCD(LSB_BCD),
        .M_digit(M_digit)
    );

    Binario_BCDbinario U2 (
        .clk(clk),
        .LD(LD),
        .SH(SH),
        .LSB_BCD(LSB_BCD),
        .BIN_out(BIN_out)
    );

    Comparador_BCDbinario U3 (
        .BCD_in(BCD_out),
        .M_digit(M_digit),
        .M(M)
    );

    Count_BCDbinario U4 (
        .clk(clk),
        .LD(LD),
        .DEC(DEC),
        .count(count)
    );

    Comp_count_BCDbinario U5 (
        .count(count),
        .C(C)
    );

    Control_BCDbinario U6 (
        .clk(clk),
        .reset(reset),
        .init(init),
        .M(M),
        .C(C),
        .LD(LD),
        .SH(SH),
        .SUB3(SUB3),
        .DEC(DEC),
        .DONE(DONE)
    );

    assign BIN = BIN_out;

endmodule