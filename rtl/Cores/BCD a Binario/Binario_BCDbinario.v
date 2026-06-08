module Binario_BCDbinario (
    input clk,
    input LD,
    input SH,
    input LSB_BCD,
    output reg [31:0] BIN_out
);

    always @(posedge clk) begin
        if (LD) begin
            BIN_out <= 32'd0;
        end
        else if (SH) begin
            BIN_out <= {LSB_BCD, BIN_out[31:1]};
        end
        else begin
            BIN_out <= BIN_out;
        end
    end

endmodule