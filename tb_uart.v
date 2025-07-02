`timescale 1ns / 1ps

module tb_uart;

    reg clk = 0;
    reg rst = 1;
    reg tx_start = 0;
    reg [7:0] tx_data = 8'h00;
    wire tx, tx_busy;
    wire [7:0] rx_data;
    wire rx_done;

    // 50 MHz clock
    always #10 clk = ~clk; // 20 ns period

    uart_tx #(.CLK_PER_BIT(434)) uut_tx (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    uart_rx #(.CLK_PER_BIT(434)) uut_rx (
        .clk(clk),
        .rst(rst),
        .rx(tx),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    initial begin
        $dumpfile("uart_wave.vcd");
        $dumpvars(0, tb_uart);
    end

    initial begin
        $display("UART Testbench Start");
        rst = 1;
        tx_start = 0;
        tx_data = 8'h00;
        #100;              // Hold reset for 100 ns
        rst = 0;           // De-assert reset
        #100;              // Wait 100 ns after reset

        // Transmit a byte
        tx_data = 8'hA5;
        tx_start = 1;
        #40;               // Hold tx_start high for 2 clock cycles (40 ns)
        tx_start = 0;

        // Wait for reception
        wait(rx_done);
        $display("Received: %h", rx_data);

        #100000;           // Wait to observe full transmission
        $finish;
    end
    initial begin
    #500;         // Wait until after reset and initial transmission
    force tx = 0; // Force tx (and thus rx) LOW (start bit)
    #100;         // Hold it LOW for 100 ns (5 clock cycles)
    release tx;   // Release tx, let it return to normal
end
always @(posedge clk) begin
    if (tx_start)
        $display("TB: tx_start asserted at %t", $time);
    if (tx_busy)
        $display("TB: tx_busy is HIGH at %t", $time);
end

always @(posedge rx_done) begin
    $display("TB: At time %t: Received %h", $time, rx_data);
end
always @(posedge clk) begin
    $display("TB: rx = %b at %t", tx, $time);
end
    always @(posedge rx_done) begin
        $display("At time %t: Received %h", $time, rx_data);
    end
endmodule