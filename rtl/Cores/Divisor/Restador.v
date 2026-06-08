module Restador_Divisor #(
    parameter width = 31
)(
    input  wire [width:0] A,
    input  wire [width:0] B,

    output wire [width:0] Resta_out,
    output wire           MSB_r
);

    assign Resta_out = A - B;

    assign MSB_r = Resta_out[width];

endmodule
