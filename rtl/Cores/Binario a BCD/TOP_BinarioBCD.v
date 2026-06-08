module TOP_BinarioBCD (
    input clk,
    input reset,
    input init,
    input [31:0] A,
    output [31:0] BCD,
    output DONE
);

    wire LD;
    wire SH;
    wire ADD3;
    wire DEC;

    wire [31:0] A_out;
    wire MSB_A;

    wire [31:0] BCD_out;

    wire [7:0] M_digit;
    wire M;

    wire [5:0] count;
    wire C;

    A_process_BinarioBCD U1 (
        .clk(clk),
        .LD(LD),
        .SH(SH),
        .A(A),
        .A_out(A_out),
        .MSB_A(MSB_A)
    );

    BCD U2 (
        .clk(clk),
        .LD(LD),
        .SH(SH),
        .ADD3(ADD3),
        .MSB_A(MSB_A),
        .M_digit(M_digit),
        .BCD_out(BCD_out)
    );

    Comparador_BCD U3 (
        .BCD_in(BCD_out),
        .M_digit(M_digit),
        .M(M)
    );

    Count_BinarioBCD U4 (
        .clk(clk),
        .LD(LD),
        .DEC(DEC),
        .count(count)
    );

    Comp_count_BinarioBCD U5 (
        .count(count),
        .C(C)
    );

    Control_BinarioBCD U6 (
        .clk(clk),
        .reset(reset),
        .init(init),
        .M(M),
        .C(C),
        .LD(LD),
        .SH(SH),
        .ADD3(ADD3),
        .DEC(DEC),
        .DONE(DONE)
    );

    assign BCD = BCD_out;

endmodule