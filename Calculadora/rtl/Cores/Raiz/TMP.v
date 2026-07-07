module TMP (
    input [15:0] B_in,
    output [31:0] TMP_out
);

assign TMP_out = (({16'b0, B_in}) << 2) + 32'b1;

endmodule