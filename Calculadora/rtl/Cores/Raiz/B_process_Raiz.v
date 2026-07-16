module B_process_Raiz (
    input clk,
    input rst,
    input ld_init,
    input r0,
    input lsb_b,

    output reg [15:0] B_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        B_out <= 16'b0;
    end

    else if (ld_init) begin
        B_out <= 16'b0;
    end

    else if (r0) begin
        B_out <= {B_out[14:0], lsb_b};
    end
end

endmodule