module Contador_Unos (
    input  wire        clk,
    input  wire        reset,
    input  wire        init,
    input  wire [31:0] A,

    output wire [31:0] P,
    output wire        done
);

    // Señales que van desde el control hacia el datapath
    wire w_LD;
    wire w_INC;
    wire w_SH;

    // Señales que van desde el datapath hacia el control
    wire w_z;
    wire w_LSB_A;

    // Señal interna para observar el registro desplazado
    wire [31:0] w_A_process;


    // Registro de desplazamiento de A
    RSR_A rsr_a0 (
        .clk       (clk),
        .A         (A),
        .LD        (w_LD),
        .SH        (w_SH),
        .A_process (w_A_process),
        .z         (w_z),
        .LSB_A     (w_LSB_A)
    );


    // Acumulador que cuenta los bits en 1
    ACC acc0 (
        .clk (clk),
        .LD  (w_LD),
        .INC (w_INC),
        .P   (P)
    );


    // Unidad de control
    Control_Contador_Unos control0 (
        .clk   (clk),
        .reset (reset),
        .init  (init),
        .z     (w_z),
        .LSB_A (w_LSB_A),
        .LD    (w_LD),
        .INC   (w_INC),
        .SH    (w_SH),
        .done  (done)
    );

endmodule