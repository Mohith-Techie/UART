module uart_tx(
    input wire clk,
    input wire rst,
    input wire tx_start,
    input wire [7:0] tx_data,
    output reg tx,
    output reg tx_busy
);
    parameter CLK_PER_BIT = 434; // For 115200 baud with 50MHz clk

    reg [13:0] clk_count;
    reg [3:0] bit_index;
    reg [9:0] tx_shift;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx <= 1'b1;
            tx_busy <= 0;
            clk_count <= 0;
            bit_index <= 0;
            tx_shift <= 10'b1111111111;
        end else begin
            if (tx_start && !tx_busy) begin
                tx_shift <= {1'b1, tx_data, 1'b0}; // {stop, data, start}
                tx_busy <= 1;
                bit_index <= 0;
                clk_count <= 0;
                tx <= 1'b0; // Start bit immediately
            end else if (tx_busy) begin
                if (clk_count < CLK_PER_BIT-1) begin
                    clk_count <= clk_count + 1;
                end else begin
                    clk_count <= 0;
                    bit_index <= bit_index + 1;
                    if (bit_index < 9) begin
                        tx <= tx_shift[bit_index+1];
                    end else begin
                        tx <= 1'b1; // Idle after stop bit
                        tx_busy <= 0;
                    end
                end
            end
        end
    end
endmodule