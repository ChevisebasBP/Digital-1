module ACC (
    input  wire        clk,
    input  wire        LD,
    input  wire        INC,
    
    output reg  [31:0] P
);

    always @(negedge clk) begin
        if (LD) begin
            // Al comenzar una nueva operación,
            // el contador de unos se inicializa en cero.
            P <= 32'b0;
        end
        else if (INC) begin
            // Se encontró un bit igual a 1.
            P <= P + 1'b1;
        end
    end

endmodule