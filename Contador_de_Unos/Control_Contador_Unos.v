module Control_Contador_Unos (
    input  wire clk,
    input  wire reset,
    input  wire init,
    input  wire z,
    input  wire LSB_A,

    output reg  LD,
    output reg  INC,
    output reg  SH,
    output reg  done
);

    // Estados de la máquina
    localparam START     = 3'b000;
    localparam LOAD      = 3'b001;
    localparam CHECK_Z   = 3'b010;
    localparam CHECK_LSB = 3'b011;
    localparam ST_INC    = 3'b100;
    localparam SHIFT     = 3'b101;
    localparam END1      = 3'b110;

    reg [2:0] state;

    // Cambio de estado
    always @(posedge clk) begin
        if (reset) begin
            state <= START;
        end
        else begin
            case (state)

                START: begin
                    if (init)
                        state <= LOAD;
                    else
                        state <= START;
                end

                LOAD: begin
                    state <= CHECK_Z;
                end

                CHECK_Z: begin
                    if (z)
                        state <= END1;
                    else
                        state <= CHECK_LSB;
                end

                CHECK_LSB: begin
                    if (LSB_A)
                        state <= ST_INC;
                    else
                        state <= SHIFT;
                end

                ST_INC: begin
                    state <= SHIFT;
                end

                SHIFT: begin
                    state <= CHECK_Z;
                end

                END1: begin
                    if (init)
                        state <= END1;
                    else
                        state <= START;
                end

                default: begin
                    state <= START;
                end

            endcase
        end
    end

    // Salidas de control de cada estado
    always @(*) begin
        // Valores predeterminados
        LD   = 1'b0;
        INC  = 1'b0;
        SH   = 1'b0;
        done = 1'b0;

        case (state)

            START: begin
                LD   = 1'b0;
                INC  = 1'b0;
                SH   = 1'b0;
                done = 1'b0;
            end

            LOAD: begin
                LD   = 1'b1;
                INC  = 1'b0;
                SH   = 1'b0;
                done = 1'b0;
            end

            CHECK_Z: begin
                LD   = 1'b0;
                INC  = 1'b0;
                SH   = 1'b0;
                done = 1'b0;
            end

            CHECK_LSB: begin
                LD   = 1'b0;
                INC  = 1'b0;
                SH   = 1'b0;
                done = 1'b0;
            end

            ST_INC: begin
                LD   = 1'b0;
                INC  = 1'b1;
                SH   = 1'b0;
                done = 1'b0;
            end

            SHIFT: begin
                LD   = 1'b0;
                INC  = 1'b0;
                SH   = 1'b1;
                done = 1'b0;
            end

            END1: begin
                LD   = 1'b0;
                INC  = 1'b0;
                SH   = 1'b0;
                done = 1'b1;
            end

            default: begin
                LD   = 1'b0;
                INC  = 1'b0;
                SH   = 1'b0;
                done = 1'b0;
            end

        endcase
    end

endmodule