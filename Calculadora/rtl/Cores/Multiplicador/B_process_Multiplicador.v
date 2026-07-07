module B_process_Multiplicador (
    input clk,
    input LD,
    input SH,
    input [15:0] B,

    output reg [15:0] B_process_out,
    output LSB_B_process
);

assign LSB_B_process = B_process_out[0];

always @(posedge clk) begin
    if (LD) begin
        B_process_out <= B;
    end
    else if (SH) begin
        B_process_out <= B_process_out >> 1;
    end
end

endmodule