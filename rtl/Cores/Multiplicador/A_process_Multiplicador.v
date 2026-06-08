module A_process_Multiplicador (
    input clk,
    input LD,
    input SH,
    input [15:0] A,

    output reg [31:0] A_process_out
);

always @(posedge clk) begin
    if (LD) begin
        A_process_out <= {16'b0, A};
    end
    else if (SH) begin
        A_process_out <= A_process_out << 1;
    end
end

endmodule