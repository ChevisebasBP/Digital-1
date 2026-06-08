module A_process_Raiz (
    input clk,
    input rst,
    input ld_init,
    input sh,
    input lda2,
    input [1:0] bits_bajan,
    input [31:0] resta,
    output reg [31:0] A_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        A_out <= 32'b0;
    end

    else if (ld_init) begin
        A_out <= 32'b0;
    end

    else if (lda2) begin
        A_out <= resta;
    end

    else if (sh) begin
        A_out <= (A_out << 2) | {30'b0, bits_bajan};
    end
end

endmodule