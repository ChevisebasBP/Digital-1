module A_process_BinarioBCD (
    input clk,
    input LD,
    input SH,
    input [31:0] A,
    output reg [31:0] A_out,
    output MSB_A
);

    assign MSB_A = A_out[31];

    always @(posedge clk) begin
        if (LD) begin
            A_out <= A;
        end
        else if (SH) begin
            A_out <= A_out << 1;
        end
        else begin
            A_out <= A_out;
        end
    end

endmodule