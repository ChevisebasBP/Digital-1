module Count_Raiz (
    input clk,
    input rst,
    input ld_init,
    input dec,
    output reg [4:0] count_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count_out <= 5'b0;
    end

    else if (ld_init) begin
        count_out <= 5'd16;
    end

    else if (dec) begin
        count_out <= count_out - 1;
    end
end

endmodule