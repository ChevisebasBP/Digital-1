module Control_BinarioBCD (
    input clk,
    input reset,
    input init,
    input M,
    input C,
    output reg LD,
    output reg SH,
    output reg ADD3,
    output reg DEC,
    output reg DONE
);

    parameter START       = 3'b000;
    parameter CHECK_BCD   = 3'b001;
    parameter ADD3_STATE  = 3'b010;
    parameter SHIFT       = 3'b011;
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
                        state <= CHECK_BCD;
                    else
                        state <= START;
                end

                CHECK_BCD: begin
                    if (M)
                        state <= ADD3_STATE;
                    else
                        state <= SHIFT;
                end

                ADD3_STATE: begin
                    state <= SHIFT;
                end

                SHIFT: begin
                    state <= DEC_COUNT;
                end

                DEC_COUNT: begin
                    state <= CHECK_COUNT;
                end

                CHECK_COUNT: begin
                    if (C)
                        state <= CHECK_BCD;
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
        LD    = 0;
        SH    = 0;
        ADD3  = 0;
        DEC   = 0;
        DONE  = 0;

        case (state)
            START: begin
                LD    = 1;
                SH    = 0;
                ADD3  = 0;
                DEC   = 0;
                DONE  = 0;
            end

            CHECK_BCD: begin
                LD    = 0;
                SH    = 0;
                ADD3  = 0;
                DEC   = 0;
                DONE  = 0;
            end

            ADD3_STATE: begin
                LD    = 0;
                SH    = 0;
                ADD3  = 1;
                DEC   = 0;
                DONE  = 0;
            end

            SHIFT: begin
                LD    = 0;
                SH    = 1;
                ADD3  = 0;
                DEC   = 0;
                DONE  = 0;
            end

            DEC_COUNT: begin
                LD    = 0;
                SH    = 0;
                ADD3  = 0;
                DEC   = 1;
                DONE  = 0;
            end

            CHECK_COUNT: begin
                LD    = 0;
                SH    = 0;
                ADD3  = 0;
                DEC   = 0;
                DONE  = 0;
            end

            END_STATE: begin
                LD    = 0;
                SH    = 0;
                ADD3  = 0;
                DEC   = 0;
                DONE  = 1;
            end
        endcase
    end

endmodule