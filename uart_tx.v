// uart_tx.v
module uart_tx #(parameter CLK_FREQ = 50000000, BAUD_RATE = 31250) (
    input clk,
    input rst,
    input [7:0] data_in,
    input send,
    output reg tx,
    output reg ready
);
    localparam CLK_PER_BIT = CLK_FREQ / BAUD_RATE;
    reg [15:0] clk_count;
    reg [3:0] bit_index;
    reg [9:0] shift_reg;
    reg sending;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx <= 1;
            ready <= 1;
            clk_count <= 0;
            bit_index <= 0;
            shift_reg <= 0;
            sending <= 0;
        end else begin
            if (send && ready) begin
                shift_reg <= {1'b1, data_in, 1'b0};
                sending <= 1;
                ready <= 0;
                clk_count <= 0;
                bit_index <= 0;
            end else if (sending) begin
                if (clk_count == CLK_PER_BIT - 1) begin
                    clk_count <= 0;
                    tx <= shift_reg[0];
                    shift_reg <= {1'b0, shift_reg[9:1]};
                    if (bit_index == 9) begin
                        sending <= 0;
                        ready <= 1;
                    end else begin
                        bit_index <= bit_index + 1;
                    end
                end else begin
                    clk_count <= clk_count + 1;
                end
            end
        end
    end
endmodule
