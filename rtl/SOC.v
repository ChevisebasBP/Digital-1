`timescale 1ns / 1ps

module SOC (
    input        clk,
    input        resetn,
    output wire LEDS,
    input        RXD,
    output       TXD
);

   wire [31:0] mem_addr;
   reg  [31:0] mem_rdata;
   wire        mem_rstrb;
   wire [31:0] mem_wdata;
   wire [3:0]  mem_wmask;

   wire wr = |mem_wmask;
   wire rd = mem_rstrb;

   reg [7:0] cs;

   wire [31:0] RAM_rdata;
   wire [31:0] uart_dout;
   wire [31:0] Multiplicador_dout;
   wire [31:0] Divisor_dout;
   wire [31:0] Raiz_dout;
   wire [31:0] BinarioBCD_dout;
   wire [31:0] BCDBinario_dout;

   FemtoRV32 CPU (
      .clk(clk),
      .reset(resetn),
      .mem_addr(mem_addr),
      .mem_rdata(mem_rdata),
      .mem_rstrb(mem_rstrb),
      .mem_wdata(mem_wdata),
      .mem_wmask(mem_wmask),
      .mem_rbusy(1'b0),
      .mem_wbusy(1'b0)
   );

   bram RAM (
      .clk(clk),
      .mem_addr(mem_addr),
      .mem_rdata(RAM_rdata),
      .mem_rstrb(cs[0] & rd),
      .mem_wdata(mem_wdata),
      .mem_wmask({4{cs[0]}} & mem_wmask)
   );

   Periferico_Multiplicador U_MULT (
      .clk(clk),
      .reset(!resetn),
      .d_in(mem_wdata[15:0]),
      .cs(cs[1]),
      .addr(mem_addr[4:0]),
      .rd(rd),
      .wr(wr),
      .d_out(Multiplicador_dout)
   );

   Periferico_Divisor U_DIV (
      .clk(clk),
      .reset(!resetn),
      .d_in(mem_wdata),
      .cs(cs[2]),
      .addr(mem_addr[4:0]),
      .rd(rd),
      .wr(wr),
      .d_out(Divisor_dout)
   );

   Periferico_Raiz U_RAIZ (
      .clk(clk),
      .reset(!resetn),
      .d_in(mem_wdata),
      .cs(cs[3]),
      .addr(mem_addr[4:0]),
      .rd(rd),
      .wr(wr),
      .d_out(Raiz_dout)
   );

   Periferico_BinarioBCD U_BIN2BCD (
      .clk(clk),
      .reset(!resetn),
      .d_in(mem_wdata),
      .cs(cs[4]),
      .addr(mem_addr[4:0]),
      .rd(rd),
      .wr(wr),
      .d_out(BinarioBCD_dout)
   );

   peripheral_uart #(
      .clk_freq(26000000),
      .baud(115200)
   ) U_UART (
      .clk(clk),
      .rst(!resetn),
      .d_in(mem_wdata),
      .cs(cs[5]),
      .addr(mem_addr[4:0]),
      .rd(rd),
      .wr(wr),
      .d_out(uart_dout),
      .uart_tx(TXD),
      .uart_rx(RXD),
      .ledout(LEDS)
   );

   Periferico_BCDbinario U_BCD2BIN (
      .clk(clk),
      .reset(!resetn),
      .d_in(mem_wdata),
      .cs(cs[7]),
      .addr(mem_addr[4:0]),
      .rd(rd),
      .wr(wr),
      .d_out(BCDBinario_dout)
   );

   always @(*) begin
      case (mem_addr[31:16])
         16'h0000: cs = 8'b00000001; // RAM
         16'h0040: cs = 8'b00100000; // UART
         16'h0041: cs = 8'b00010000; // Binario a BCD
         16'h0042: cs = 8'b00001000; // Raiz
         16'h0043: cs = 8'b00000100; // Divisor
         16'h0044: cs = 8'b00000010; // Multiplicador
         16'h0045: cs = 8'b10000000; // BCD a Binario
         default:  cs = 8'b00000001; // RAM
      endcase
   end

   always @(*) begin
      case (cs)
         8'b00000001: mem_rdata = RAM_rdata;
         8'b00000010: mem_rdata = Multiplicador_dout;
         8'b00000100: mem_rdata = Divisor_dout;
         8'b00001000: mem_rdata = Raiz_dout;
         8'b00010000: mem_rdata = BinarioBCD_dout;
         8'b00100000: mem_rdata = uart_dout;
         8'b10000000: mem_rdata = BCDBinario_dout;
         default:     mem_rdata = RAM_rdata;
      endcase
   end


   `ifdef BENCH
      always @(posedge clk) begin
         if(cs[5] & wr ) begin
         $write("%c", mem_wdata[7:0]);
         $fflush(32'h8000_0001);
         end
      end
   `endif

   
endmodule