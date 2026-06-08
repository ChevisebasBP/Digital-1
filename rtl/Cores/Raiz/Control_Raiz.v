module Control_Raiz (
    input clk,
    input rst,
    input init,
    input MSB,
    input C,

    output reg ld_init,
    output reg sh,
    output reg dec,
    output reg r0,
    output reg lsb_b,
    output reg lda2,
    output reg done
);

parameter START     = 3'b000;
parameter SHIFT_DEC = 3'b001;
parameter CHECK_MSB = 3'b010;
parameter LOAD_2    = 3'b011;
parameter LOAD_0    = 3'b100;
parameter CHECK_C   = 3'b101;
parameter END1      = 3'b110;

reg [2:0] state;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= START;
    end

    else begin
        case (state)

            START: begin
                if (init)
                    state <= SHIFT_DEC;
                else
                    state <= START;
            end

            SHIFT_DEC: begin
                state <= CHECK_MSB;
            end

            CHECK_MSB: begin
                if (MSB)
                    state <= LOAD_0;
                else
                    state <= LOAD_2;
            end

            LOAD_2: begin
                state <= CHECK_C;
            end

            LOAD_0: begin
                state <= CHECK_C;
            end

            CHECK_C: begin
                if (C)
                    state <= END1;
                else
                    state <= SHIFT_DEC;
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
    ld_init = 0;
    sh      = 0;
    dec     = 0;
    r0      = 0;
    lsb_b   = 0;
    lda2    = 0;
    done    = 0;

    case (state)

        START: begin
            if (init)
                ld_init = 1;
        end

        SHIFT_DEC: begin
            sh  = 1;
            dec = 1;
        end

        CHECK_MSB: begin
        end

        LOAD_2: begin
            r0    = 1;
            lsb_b = 1;
            lda2  = 1;
        end

        LOAD_0: begin
            r0    = 1;
            lsb_b = 0;
            lda2  = 0;
        end

        CHECK_C: begin
        end

        END1: begin
            done = 1;
        end

    endcase
end

endmodule