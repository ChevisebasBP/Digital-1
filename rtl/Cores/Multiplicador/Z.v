module Z (
    input clk,
    input LD,
    input ADD_EN,
    input [31:0] A_process_out,

    output reg [31:0] Z_out
);

always @(posedge clk) begin
    if (LD) begin
        Z_out <= 32'b0;
    end
    else if (ADD_EN) begin
        Z_out <= Z_out + A_process_out;
    end
end

endmodule