module Resultado #(
    parameter width = 31
)(
    input  wire clk,
    input  wire rst,
    input  wire LD,
    input  wire EN_C,
    input  wire bit_c,

    output reg [width:0] Resultado_out
);

    always @(posedge clk) begin

        if (rst) begin
            Resultado_out <= 0;
        end

        else begin

            if (LD) begin
                Resultado_out <= 0;
            end

            else if (EN_C) begin
                Resultado_out <= {Resultado_out[width-1:0], bit_c};
            end

        end

    end

endmodule