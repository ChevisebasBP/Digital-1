module Control_BCDbinario (
    input clk,
    input reset,
    input init,
    input M,
    input C,
    output reg LD,
    output reg SH,
    output reg SUB3,
    output reg DEC,
    output reg DONE
);

    parameter START       = 3'b000;
    parameter SHIFT       = 3'b001;
    parameter CHECK_BCD   = 3'b010;
    parameter SUB3_STATE  = 3'b011;
    parameter DEC_COUNT   = 3'b100;
    parameter CHECK_COUNT = 3'b101;
    parameter END_STATE   = 3'b110;

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= START;
        end
        else begin
            case (state)
                START: begin
                    if (init)
                        state <= SHIFT;
                    else
                        state <= START;
                end

                SHIFT: begin
                    state <= CHECK_BCD;
                end

                CHECK_BCD: begin
                    if (M)
                        state <= SUB3_STATE;
                    else
                        state <= DEC_COUNT;
                end

                SUB3_STATE: begin
                    state <= DEC_COUNT;
                end

                DEC_COUNT: begin
                    state <= CHECK_COUNT;
                end

                CHECK_COUNT: begin
                    if (C)
                        state <= SHIFT;
                    else
                        state <= END_STATE;
                end

                END_STATE: begin
                    state <= START;
                end

                default: begin
                    state <= START;
                end
            endcase
        end
    end

    always @(*) begin
        LD   = 0;
        SH   = 0;
        SUB3 = 0;
        DEC  = 0;
        DONE = 0;

        case (state)
            START: begin
                LD   = 1;
            end

            SHIFT: begin
                SH   = 1;
            end

            CHECK_BCD: begin
                // Solo revisa M
            end

            SUB3_STATE: begin
                SUB3 = 1;
            end

            DEC_COUNT: begin
                DEC = 1;
            end

            CHECK_COUNT: begin
                // Solo revisa C
            end

            END_STATE: begin
                DONE = 1;
            end
        endcase
    end

endmodule