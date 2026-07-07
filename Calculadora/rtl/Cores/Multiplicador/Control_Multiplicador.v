module Control_Multiplicador (

    input clk,
    input reset,
    input init,
    input C,
    input LSB_B_process,

    output reg ADD_EN,
    output reg SH,
    output reg DEC,
    output reg LD,
    output reg DONE

);

// DEFINICIÓN DE ESTADOS

    parameter S_START = 3'b000;
    parameter S_CHECK = 3'b001;
    parameter S_ADD   = 3'b010;
    parameter S_SHIFT = 3'b011;
    parameter S_END   = 3'b100;

    reg [2:0] state;
    reg [5:0] count_done;

// MÁQUINA DE ESTADOS

    always @(posedge clk or posedge reset) begin

        if (reset) begin
            state      <= S_START;
            count_done <= 6'd0;
        end
        else begin

            case (state)

                S_START: begin
                    count_done <= 6'd0;

                    if (init)
                        state <= S_CHECK;
                    else
                        state <= S_START;
                end

                S_CHECK: begin
                    if (C)
                        state <= S_END;
                    else if (LSB_B_process)
                        state <= S_ADD;
                    else
                        state <= S_SHIFT;
                end

                S_ADD: begin
                    state <= S_SHIFT;
                end

                S_SHIFT: begin
                    state <= S_CHECK;
                end

                S_END: begin
                    count_done <= count_done + 1;

                    if (count_done > 6'd30)
                        state <= S_START;
                    else
                        state <= S_END;
                end

                default: begin
                    state <= S_START;
                end

            endcase
        end
    end

// LÓGICA DE SALIDAS

    always @(*) begin

        case (state)

            S_START: begin
                ADD_EN = 0;
                SH     = 0;
                DEC    = 0;
                LD     = 1;
                DONE   = 0;
            end

            S_CHECK: begin
                ADD_EN = 0;
                SH     = 0;
                DEC    = 0;
                LD     = 0;
                DONE   = 0;
            end

            S_ADD: begin
                ADD_EN = 1;
                SH     = 0;
                DEC    = 0;
                LD     = 0;
                DONE   = 0;
            end

            S_SHIFT: begin
                ADD_EN = 0;
                SH     = 1;
                DEC    = 1;
                LD     = 0;
                DONE   = 0;
            end

            S_END: begin
                ADD_EN = 0;
                SH     = 0;
                DEC    = 0;
                LD     = 0;
                DONE   = 1;
            end

            default: begin
                ADD_EN = 0;
                SH     = 0;
                DEC    = 0;
                LD     = 0;
                DONE   = 0;
            end

        endcase
    end

endmodule