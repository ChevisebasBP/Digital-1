module TOP_Multiplicador (

    input reset,
    input clk, // Reloj
    input init,



// Multiplicando
    input [15:0] A,

    input [15:0] B, // Multiplicador

    output [31:0] Resultado,

    output DONE
);

// Señales 
wire LD;
wire ADD_EN;
wire SH;
wire DEC;

wire LSB_B_process;
wire C;

wire [31:0] A_process_out;
wire [15:0] B_process_out;
wire [31:0] Z_out;

wire [4:0] count_out;




A_process_Multiplicador A_process_inst (
    .clk(clk),
    .LD(LD),
    .SH(SH),
    .A(A),
    .A_process_out(A_process_out)
);


B_process_Multiplicador B_process_inst (
    .clk(clk),
    .LD(LD),
    .SH(SH),
    .B(B),
    .B_process_out(B_process_out),
    .LSB_B_process(LSB_B_process)
);


Z Z_inst (
    .clk(clk),
    .LD(LD),
    .ADD_EN(ADD_EN),
    .A_process_out(A_process_out),
    .Z_out(Z_out)
);


Count_Multiplicador Count_inst (
    .clk(clk),
    .LD(LD),
    .DEC(DEC),
    .count_out(count_out)
);


Comp_count_Multiplicador Comp_count_inst (
    .count_out(count_out),
    .C(C)
);


Control_Multiplicador Control_inst (
    .clk(clk),
    .reset(reset),
    .init(init),
    .C(C),
    .LSB_B_process(LSB_B_process),

    .ADD_EN(ADD_EN),
    .SH(SH),
    .DEC(DEC),
    .LD(LD),
    .DONE(DONE)
);


assign Resultado = Z_out;
endmodule