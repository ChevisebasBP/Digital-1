module Comp_count_BinarioBCD (
    input [5:0] count,
    output C
);

    assign C = (count != 6'd0);

endmodule