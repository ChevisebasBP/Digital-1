module TOP_Divisor #(
    parameter width = 31
)(
    input  wire           clk,
    input  wire           rst,
    input  wire           init,
    input  wire [width:0] Dividendo,
    input  wire [width:0] DR,

    output wire [width:0] Residuo,
    output wire [width:0] Resultado,
    output wire           DONE
);

    wire LD;
    wire SH;
    wire EN_Resta;
    wire EN_C;
    wire bit_c;
    wire DEC;

    wire MSB_A;
    wire MSB_r;
    wire i;

    wire [width:0] A_out;
    wire [width:0] B_out;
    wire [width:0] vAux_out;
    wire [width:0] Resta_out;
    wire [5:0]     count_out;

    A_process_Divisor #(
        .width(width)
    ) A_process_inst (
        .clk(clk),
        .rst(rst),
        .LD(LD),
        .SH(SH),
        .Dividendo(Dividendo),
        .A_out(A_out),
        .MSB_A(MSB_A)
    );

    B_process_Divisor #(
        .width(width)
    ) B_process_inst (
        .clk(clk),
        .rst(rst),
        .LD(LD),
        .DR(DR),
        .B_out(B_out)
    );

    vAux #(
        .width(width)
    ) vAux_inst (
        .clk(clk),
        .rst(rst),
        .LD(LD),
        .SH(SH),
        .EN_Resta(EN_Resta),
        .MSB_A(MSB_A),
        .Resta_in(Resta_out),
        .vAux_out(vAux_out)
    );

    Restador_Divisor #(
        .width(width)
    ) Restador_inst (
        .A(vAux_out),
        .B(B_out),
        .Resta_out(Resta_out),
        .MSB_r(MSB_r)
    );

    Resultado #(
        .width(width)
    ) Resultado_inst (
        .clk(clk),
        .rst(rst),
        .LD(LD),
        .EN_C(EN_C),
        .bit_c(bit_c),
        .Resultado_out(Resultado)
    );

    Count_Divisor Count_inst (
        .clk(clk),
        .LD(LD),
        .DEC(DEC),
        .count_out(count_out)
    );

    Comp_count_Divisor Comp_count_inst (
        .count_out(count_out),
        .i(i)
    );

    Control_Divisor control_inst (
        .clk(clk),
        .rst(rst),
        .init(init),
        .MSB_r(MSB_r),
        .i(i),
        .LD(LD),
        .SH(SH),
        .EN_Resta(EN_Resta),
        .EN_C(EN_C),
        .bit_c(bit_c),
        .DEC(DEC),
        .DONE(DONE)
    );

    assign Residuo = vAux_out;

endmodule