module Comp_count_Raiz (
    input [4:0] count_in,
    output C
);

assign C = (count_in == 0);

endmodule