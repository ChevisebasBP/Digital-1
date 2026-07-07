module Count_Divisor (

    input clk,
    input LD,
    input DEC,

    output reg [5:0] count_out

);

    always @(posedge clk) begin

        if (LD) begin
            count_out <= 6'd32;
        end

        else if (DEC) begin
            count_out <= count_out - 1;
        end

    end

endmodule