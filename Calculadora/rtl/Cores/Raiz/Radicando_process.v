module Radicando_process (
    input clk,
    input rst,
    input ld_init,
    input sh,
    input [31:0] A,
    output [1:0] bits_bajan
);

reg [31:0] radicando_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        radicando_reg <= 32'b0;
    end

    else if (ld_init) begin
        radicando_reg <= A;
    end

    else if (sh) begin
        radicando_reg <= radicando_reg << 2;
    end
end

assign bits_bajan = radicando_reg[31:30];

endmodule