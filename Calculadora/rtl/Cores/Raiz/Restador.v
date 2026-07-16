module Restador_Raiz (
    input [31:0] A_in,
    input [31:0] TMP_in,
    
    output [31:0] Resta_out,
    output MSB
);

assign Resta_out = A_in - TMP_in;

assign MSB = Resta_out[31];

endmodule