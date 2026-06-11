module Periferico_Raiz (
    input clk,
    input reset,

    input [31:0] d_in,
    input cs,
    input [4:0] addr,
    input rd,
    input wr,

    output reg [31:0] d_out
);

    reg [4:0] s;

    reg [31:0] A;
    reg init;

    wire [15:0] Resultado_wire;
    wire [31:0] Residuo_wire;
    wire DONE_wire;

    reg [15:0] Resultado_status;
    reg [31:0] Residuo_status;
    reg DONE_status;

    always @(*) begin
        if (cs) begin
            case (addr)
                5'h04: s = 5'b00001; // A
                5'h08: s = 5'b00010; // init
                5'h0C: s = 5'b00100; // Resultado
                5'h10: s = 5'b01000; // Residuo
                5'h14: s = 5'b10000; // DONE
                default: s = 5'b00000;
            endcase
        end
        else begin
            s = 5'b00000;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            A                <= 32'b0;
            init             <= 1'b0;
            Resultado_status <= 16'b0;
            Residuo_status   <= 32'b0;
            DONE_status      <= 1'b0;
        end
        else begin
            if (cs && wr) begin
                if (s[0])
                    A <= d_in;

                if (s[1]) begin
                    init <= d_in[0];

                    if (d_in[0] == 1'b1) begin
                        DONE_status      <= 1'b0;
                        Resultado_status <= 16'b0;
                        Residuo_status   <= 32'b0;
                    end
                end
            end

            if (DONE_wire) begin
                Resultado_status <= Resultado_wire;
                Residuo_status   <= Residuo_wire;
                DONE_status      <= 1'b1;

`ifdef BENCH
                
`endif
            end
        end
    end

    always @(posedge clk) begin
        if (reset) begin
        d_out <= 32'b0;
        end
        else if (cs && rd) begin
            case (addr)
                5'h0C: d_out <= {16'b0, Resultado_status};
                5'h10: d_out <= Residuo_status;
                5'h14: d_out <= {31'b0, DONE_status};
                default: d_out <= 32'b0;
            endcase
        end
    end


    TOP_Raiz U_TOP_RAIZ (
        .clk(clk),
        .rst(reset),
        .init(init),
        .A(A),
        .B(Resultado_wire),
        .Residuo(Residuo_wire),
        .done(DONE_wire)
    );

endmodule