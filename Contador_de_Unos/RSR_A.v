module RSR_A (
    input  wire        clk,
    input  wire [31:0] A,
    input  wire        LD,
    input  wire        SH,

    output reg  [31:0] A_process,
    output wire        z,
    output wire        LSB_A
);

    // Registro de desplazamiento de A
    always @(negedge clk) begin
        if (LD) begin
            // Carga inicial del número que se va a procesar
            A_process <= A;
        end
        else if (SH) begin
            // Desplazamiento de un bit hacia la derecha
            A_process <= A_process >> 1;
        end
    end

    // Bit menos significativo del número que se está procesando
    assign LSB_A = A_process[0];

    // z vale 1 solamente cuando A_process es igual a cero
    assign z = (A_process == 32'b0);

endmodule