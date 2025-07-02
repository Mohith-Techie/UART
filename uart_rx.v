module uart_rx(
    input wire clk,
    input wire rst,
    input wire rx,
    output reg [7:0] rx_data,
    output reg rx_done
);
   parameter CLK_PER_BIT = 434; // For 115200 baud with 50MHz clk

    reg [13:0] clk_count;
    reg [3:0] bit_index;
    reg [7:0] rx_shift;
    reg rx_busy;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rx_data <= 0;
            rx_done <= 0;
            clk_count <= 0;
            bit_index <= 0;
            rx_busy <= 0;
            rx_shift <= 0;
        end else begin
            rx_done <= 0;
            if (!rx_busy && !rx) begin
                // Start bit detected
                rx_busy <= 1;
                clk_count <= 0;
                bit_index <= 0;
                rx_shift <= 0;
            end else if (rx_busy) begin
                if (clk_count == (CLK_PER_BIT/2 - 1)) begin
                    // Sample in the middle of the start bit
                    clk_count <= clk_count + 1;
                end else if (clk_count < CLK_PER_BIT-1) begin
                    clk_count <= clk_count + 1;
                end else begin
                    clk_count <= 0;
                    if (bit_index < 8) begin
                        rx_shift <= { rx_shift[6:0], rx };
 // LSB-first
                        bit_index <= bit_index + 1;
                    end else begin
                        rx_data <= rx_shift;
                        rx_done <= 1;
                        rx_busy <= 0;
                    end
                end
            end
        end
    end
endmodule