`timescale 1ns/1ps

module bench();

// Testbench uses a 25 MHz clock
// Want to interface to 115200 baud UART
parameter tck              = 40;
parameter c_BIT_PERIOD     = 8680;

reg CLK;
reg i;
reg RESET;
wire LEDS;
reg  RXD = 1'b0;
wire TXD;


// Takes in input byte and serializes it 
task UART_WRITE_BYTE;
    input [7:0] i_Data;
    integer ii;
    begin
        // Send Start Bit
        RXD <= 1'b0;
        #(c_BIT_PERIOD);
        #1000;

        // Send Data Byte
        for (ii = 0; ii < 8; ii = ii + 1) begin
            RXD <= i_Data[ii];
            #(c_BIT_PERIOD);
        end

        // Send Stop Bit
        RXD <= 1'b1;
        #(c_BIT_PERIOD);
    end
endtask


SOC uut(
    .clk(CLK),
    .resetn(RESET),
    .LEDS(LEDS),
    .RXD(RXD),
    .TXD(TXD)
);


initial CLK <= 0;
always #(tck/2) CLK <= ~CLK;


reg [4:0] prev_LEDS = 0;
initial begin
    if (LEDS != prev_LEDS) begin
        $display("LEDS = %b", LEDS);
    end
    prev_LEDS <= LEDS;
end


integer idx;

initial begin

    $dumpfile("bench.vcd");
    $dumpvars(0, bench);

`ifndef SYNTH
    for (idx = 0; idx < 32; idx = idx + 1)
        $dumpvars(0, bench.uut.CPU.registerFile[idx]);

    for (idx = 1020; idx < 1025; idx = idx + 1)
        $dumpvars(0, bench.uut.RAM.MEM[idx]);
`endif

    #0   RXD   = 1;
    #0   RESET = 0;
    #80  RESET = 0;
    #160 RESET = 1;

    @(posedge CLK);
    #(tck * 60000);


    // 27 + 58
    UART_WRITE_BYTE(8'h32); // '2'
    #(tck * 1000);
    UART_WRITE_BYTE(8'h37); // '7'
    #(tck * 1000);
    UART_WRITE_BYTE(8'h0D); // ENTER
    #(tck * 60000);

    UART_WRITE_BYTE(8'h2B); // '+'
    #(tck * 40000);

    UART_WRITE_BYTE(8'h35); // '5'
    #(tck * 1000);
    UART_WRITE_BYTE(8'h38); // '8'
    #(tck * 1000);
    UART_WRITE_BYTE(8'h0D); // ENTER
    #(tck * 180000);


    // 100 - 37
    UART_WRITE_BYTE(8'h31); // '1'
    #(tck * 1000);
    UART_WRITE_BYTE(8'h30); // '0'
    #(tck * 1000);
    UART_WRITE_BYTE(8'h30); // '0'
    #(tck * 1000);
    UART_WRITE_BYTE(8'h0D); // ENTER
    #(tck * 60000);

    UART_WRITE_BYTE(8'h2D); // '-'
    #(tck * 40000);

    UART_WRITE_BYTE(8'h33); // '3'
    #(tck * 1000);
    UART_WRITE_BYTE(8'h37); // '7'
    #(tck * 1000);
    UART_WRITE_BYTE(8'h0D); // ENTER
    #(tck * 180000);


    // 16 * 13
    UART_WRITE_BYTE(8'h31); // '1'
    #(tck * 1000);
    UART_WRITE_BYTE(8'h36); // '6'
    #(tck * 1000);
    UART_WRITE_BYTE(8'h0D); // ENTER
    #(tck * 60000);

    UART_WRITE_BYTE(8'h2A); // '*'
    #(tck * 40000);

    UART_WRITE_BYTE(8'h31); // '1'
    #(tck * 1000);
    UART_WRITE_BYTE(8'h33); // '3'
    #(tck * 1000);
    UART_WRITE_BYTE(8'h0D); // ENTER
    #(tck * 180000);


    // 225 / 15
    UART_WRITE_BYTE(8'h32); // '2'
    #(tck * 1000);
    UART_WRITE_BYTE(8'h32); // '2'
    #(tck * 1000);
    UART_WRITE_BYTE(8'h35); // '5'
    #(tck * 1000);
    UART_WRITE_BYTE(8'h0D); // ENTER
    #(tck * 80000);

    UART_WRITE_BYTE(8'h2F); // '/'
    #(tck * 50000);

    UART_WRITE_BYTE(8'h31); // '1'
    #(tck * 1000);
    UART_WRITE_BYTE(8'h35); // '5'
    #(tck * 1000);
    UART_WRITE_BYTE(8'h0D); // ENTER
    #(tck * 220000);


    // sqrt(169)
    UART_WRITE_BYTE(8'h31); // '1'
    #(tck * 1000);
    UART_WRITE_BYTE(8'h36); // '6'
    #(tck * 1000);
    UART_WRITE_BYTE(8'h39); // '9'
    #(tck * 1000);
    UART_WRITE_BYTE(8'h0D); // ENTER
    #(tck * 80000);

    UART_WRITE_BYTE(8'h24); // '$'
    #(tck * 220000);


    @(posedge CLK);
    #(tck * 100000);
    $finish;

end

endmodule