module Control_Divisor (

    input  wire clk,
    input  wire rst,
    input  wire init,
    input  wire MSB_r,
    input  wire i,

    output reg  LD,
    output reg  SH,
    output reg  EN_Resta,
    output reg  EN_C,
    output reg  bit_c,
    output reg  DEC,
    output reg  DONE

);

    parameter START   = 3'b000;
    parameter SHIFT   = 3'b001;
    parameter RESTA   = 3'b010;
    parameter BIT_0   = 3'b011;
    parameter BIT_1   = 3'b100;
    parameter CHECK_I = 3'b101;
    parameter END1    = 3'b110;

    reg [2:0] state;

    always @(posedge clk or posedge rst) begin

        if (rst) begin
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
                    state <= RESTA;
                end

                RESTA: begin
                    if (MSB_r)
                        state <= BIT_0;
                    else
                        state <= BIT_1;
                end

                BIT_0: begin
                    state <= CHECK_I;
                end

                BIT_1: begin
                    state <= CHECK_I;
                end

                CHECK_I: begin
                    if (i)
                        state <= SHIFT;
                    else
                        state <= END1;
                end

                END1: begin
                    state <= START;
                end

                default: begin
                    state <= START;
                end

            endcase

        end

    end

    always @(*) begin

        LD       = 0;
        SH       = 0;
        EN_Resta = 0;
        EN_C     = 0;
        bit_c    = 0;
        DEC      = 0;
        DONE     = 0;

        case (state)

            START: begin
                LD = 1;
            end

            SHIFT: begin
                SH  = 1;
                DEC = 1;
            end

            RESTA: begin
            end

            BIT_0: begin
                EN_C  = 1;
                bit_c = 0;
            end

            BIT_1: begin
                EN_C     = 1;
                bit_c    = 1;
                EN_Resta = 1;
            end

            CHECK_I: begin
            end

            END1: begin
                DONE = 1;
            end

        endcase

    end

endmodule