module B_process_Divisor #(
    parameter width = 31
)(
    input  wire           clk,
    input  wire           rst,
    input  wire           LD,
    input  wire [width:0] DR,

    output reg [width:0] B_out
);

    always @(posedge clk) begin

        if (rst) begin
            B_out <= 0;
        end

        else begin

            if (LD) begin
                B_out <= DR;
            end

        end

    end

endmodule
