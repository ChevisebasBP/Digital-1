module Count_BCDbinario (
    input clk,
    input LD,
    input DEC,
    output reg [5:0] count
);

    always @(posedge clk) begin
        if (LD) begin
            count <= 6'd32;
        end
        else if (DEC) begin
            count <= count - 1'b1;
        end
        else begin
            count <= count;
        end
    end

endmodule