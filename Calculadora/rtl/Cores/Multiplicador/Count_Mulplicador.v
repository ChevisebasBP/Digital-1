module Count_Multiplicador (
    input clk,
    input LD,
    input DEC,

    output reg [4:0] count_out
);

always @(posedge clk) begin
    if (LD) begin
        count_out <= 5'd16;
    end
    else if (DEC) begin
        count_out <= count_out - 1;
    end
end

endmodule
