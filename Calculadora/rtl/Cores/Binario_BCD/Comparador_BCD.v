module Comparador_BCD (
    input [31:0] BCD_in,
    
    output [7:0] M_digit,
    output M
);

    assign M_digit[0] = (BCD_in[3:0]   > 4'd4);
    assign M_digit[1] = (BCD_in[7:4]   > 4'd4);
    assign M_digit[2] = (BCD_in[11:8]  > 4'd4);
    assign M_digit[3] = (BCD_in[15:12] > 4'd4);
    assign M_digit[4] = (BCD_in[19:16] > 4'd4);
    assign M_digit[5] = (BCD_in[23:20] > 4'd4);
    assign M_digit[6] = (BCD_in[27:24] > 4'd4);
    assign M_digit[7] = (BCD_in[31:28] > 4'd4);

    assign M = |M_digit;

endmodule