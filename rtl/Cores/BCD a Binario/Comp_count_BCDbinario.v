module Comp_count_BCDbinario (
    input [5:0] count,
    output C
);

    assign C = (count != 6'd0);

endmodule