module A_process_Divisor #(
    parameter width = 31
)(
    input  wire             clk,
    input  wire             rst,
    input  wire             LD,
    input  wire             SH,
    input  wire [width:0]   Dividendo,

    output wire             MSB_A,
    output reg  [width:0]   A_out
);

    always @(posedge clk) begin

        if (rst) begin
            A_out <= 0;
        end

        else begin

            if (LD) begin
                A_out <= Dividendo;
            end

            else if (SH) begin
                A_out <= A_out << 1;
            end

        end

    end

    assign MSB_A = A_out[width];

endmodule