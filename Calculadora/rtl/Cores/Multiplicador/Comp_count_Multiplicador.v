module Comp_count_Multiplicador (
    input [4:0] count_out,
    output C
);

assign C = (count_out == 5'd0);

endmodule
