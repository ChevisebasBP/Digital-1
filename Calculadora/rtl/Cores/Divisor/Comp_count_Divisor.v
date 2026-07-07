module Comp_count_Divisor (

    input [5:0] count_out,

    output i

);

    assign i = (count_out != 6'd0);

endmodule