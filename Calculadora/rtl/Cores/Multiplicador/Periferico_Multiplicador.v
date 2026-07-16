module Periferico_Multiplicador (
    input clk,
    input reset,


    input [15:0] d_in,
    input cs,
    input [4:0] addr,
    input rd,
    input wr,

    output reg [31:0] d_out
);
    // Selector interno de registros
    reg [4:0] s;

    // Registros internos del periférico
    reg [15:0] A;
    reg [15:0] B;
    reg init;

    // Salidas directas del TOP
    wire [31:0] Resultado_top;
    wire DONE_top;

    // Registros de estado del periférico
    reg [31:0] Resultado_status;
    reg DONE_status;

    // Decodificador de direcciones
    always @(*) begin
        if (cs) begin
            case (addr)
                5'h04: s = 5'b00001; // A
                5'h08: s = 5'b00010; // B
                5'h0C: s = 5'b00100; // init
                5'h10: s = 5'b01000; // Resultado
                5'h14: s = 5'b10000; // DONE
                default: s = 5'b00000;
            endcase
        end
        else begin
            s = 5'b00000;
        end
    end

    // Escritura desde el procesador
    always @(posedge clk) begin
        if (reset) begin
            A    <= 16'b0;
            B    <= 16'b0;
            init <= 1'b0;
        end
        else begin
            if (cs && wr) begin

                if (s[0])
                    A <= d_in;

                if (s[1])
                    B <= d_in;

                if (s[2])
                    init <= d_in[0];

            end
        end
    end

    // Registro de resultado y DONE
    always @(posedge clk) begin

        if (reset) begin
            Resultado_status <= 32'b0;
            DONE_status      <= 1'b0;
        end
        else begin

            // Nueva operación
            if (cs && wr && s[2] && d_in[0]) begin
                DONE_status      <= 1'b0;
                Resultado_status <= 32'b0;
            end

            // Fin de operación
            if (DONE_top) begin
                Resultado_status <= Resultado_top;
                DONE_status      <= 1'b1;
            end

        end

    end

    // Lectura hacia el procesador
    always @(posedge clk) begin
        if (reset) begin
            d_out <= 32'b0;
        end
        else if (cs && rd) begin
            case (addr)
                5'h10: d_out <= Resultado_status;
                5'h14: d_out <= {31'b0, DONE_status};
                default: d_out <= 32'b0;
            endcase
        end
    end

    // Instancia del multiplicador
    TOP_Multiplicador u_mult (

        .reset(reset),
        .clk(clk),
        .init(init),

        .A(A),
        .B(B),

        .Resultado(Resultado_top),
        .DONE(DONE_top)

    );

endmodule