module BCD (
    input clk,
    input LD,
    input SH,
    input ADD3,
    input MSB_A,
    input [7:0] M_digit,
    output reg [31:0] BCD_out
);

    always @(posedge clk) begin
        if (LD) begin
            BCD_out <= 32'd0;
        end
        else if (ADD3) begin
            BCD_out[3:0]   <= M_digit[0] ? BCD_out[3:0]   + 4'd3 : BCD_out[3:0];
            BCD_out[7:4]   <= M_digit[1] ? BCD_out[7:4]   + 4'd3 : BCD_out[7:4];
            BCD_out[11:8]  <= M_digit[2] ? BCD_out[11:8]  + 4'd3 : BCD_out[11:8];
            BCD_out[15:12] <= M_digit[3] ? BCD_out[15:12] + 4'd3 : BCD_out[15:12];
            BCD_out[19:16] <= M_digit[4] ? BCD_out[19:16] + 4'd3 : BCD_out[19:16];
            BCD_out[23:20] <= M_digit[5] ? BCD_out[23:20] + 4'd3 : BCD_out[23:20];
            BCD_out[27:24] <= M_digit[6] ? BCD_out[27:24] + 4'd3 : BCD_out[27:24];
            BCD_out[31:28] <= M_digit[7] ? BCD_out[31:28] + 4'd3 : BCD_out[31:28];
        end
        else if (SH) begin
            BCD_out <= {BCD_out[30:0], MSB_A};
        end
        else begin
            BCD_out <= BCD_out;
        end
    end

endmodule