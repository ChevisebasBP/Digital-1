module vAux #(
    parameter width = 31
)(
    input  wire           clk,
    input  wire           rst,
    input  wire           LD,
    input  wire           SH,
    input  wire           EN_Resta,
    input  wire           MSB_A,
    input  wire [width:0] Resta_in,

    output reg  [width:0] vAux_out
);

    always @(posedge clk) begin

        if (rst) begin
            vAux_out <= 0;
        end

        else begin

            if (LD) begin
                vAux_out <= 0;
            end

            else if (SH) begin
                vAux_out <= {vAux_out[width-1:0], MSB_A};
            end

            else if (EN_Resta) begin
                vAux_out <= Resta_in;
            end

        end

    end

endmodule