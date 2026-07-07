module Periferico_Divisor (
    input clk,
    input reset,

    input [31:0] d_in,
    input cs,
    input [4:0] addr,
    input rd,
    input wr,

    output reg [31:0] d_out
);

    reg [5:0] s;

    reg [31:0] Dividendo;
    reg [31:0] DR;
    reg init;

    wire [31:0] Residuo_wire;
    wire [31:0] Resultado_wire;
    wire DONE_wire;

    reg [31:0] Residuo_reg;
    reg [31:0] Resultado_reg;
    reg DONE_reg;

    always @(*) begin
        if (cs) begin
            case (addr)
                5'h04: s = 6'b000001; // Dividendo
                5'h08: s = 6'b000010; // DR
                5'h0C: s = 6'b000100; // init
                5'h10: s = 6'b001000; // Resultado
                5'h14: s = 6'b010000; // Residuo
                5'h18: s = 6'b100000; // DONE
                default: s = 6'b000000;
            endcase
        end
        else begin
            s = 6'b000000;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            Dividendo     <= 32'b0;
            DR            <= 32'b0;
            init          <= 1'b0;
            Resultado_reg <= 32'b0;
            Residuo_reg   <= 32'b0;
            DONE_reg      <= 1'b0;
        end
        else begin
            if (cs && wr) begin
                if (s[0])
                    Dividendo <= d_in;

                if (s[1])
                    DR <= d_in;

                if (s[2]) begin
                    init <= d_in[0];

                    if (d_in[0] == 1'b1) begin
                        DONE_reg      <= 1'b0;
                        Resultado_reg <= 32'b0;
                        Residuo_reg   <= 32'b0;
                    end
                end
            end

            if (DONE_wire) begin
                Resultado_reg <= Resultado_wire;
                Residuo_reg   <= Residuo_wire;
                DONE_reg      <= 1'b1;
            end
        end
    end

    

    always @(posedge clk) begin
        if (reset) begin
            d_out <= 32'b0;
        end
        else if (cs && rd) begin
            case (addr)
                5'h10: d_out <= Resultado_reg;
                5'h14: d_out <= Residuo_reg;
                5'h18: d_out <= {31'b0, DONE_reg};
                default: d_out <= 32'b0;
            endcase
        end
    end


    TOP_Divisor #(
        .width(31)
    ) u_div (
        .clk(clk),
        .rst(reset),
        .init(init),
        .Dividendo(Dividendo),
        .DR(DR),
        .Residuo(Residuo_wire),
        .Resultado(Resultado_wire),
        .DONE(DONE_wire)
    );

endmodule