// midi_volume_sender.v
module midi_volume_sender (
    input clk,
    input rst,
    input [15:0] distance_cm,
    input distance_ready,
    output reg [7:0] midi_byte,
    output reg midi_send,
    input uart_ready
);
    typedef enum logic [1:0] {IDLE, SEND1, SEND2, SEND3} state_t;
    state_t state;
    reg [7:0] volume;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            midi_byte <= 0;
            midi_send <= 0;
        end else begin
            midi_send <= 0;
            case (state)
                IDLE: begin
                    if (distance_ready) begin
                        volume <= (distance_cm < 5) ? 127 :
                                  (distance_cm > 60) ? 0 :
                                  127 - ((distance_cm - 5) * 127 / 55);
                        state <= SEND1;
                    end
                end
                SEND1: if (uart_ready) begin midi_byte <= 8'hB0; midi_send <= 1; state <= SEND2; end
                SEND2: if (uart_ready) begin midi_byte <= 8'h07; midi_send <= 1; state <= SEND3; end
                SEND3: if (uart_ready) begin midi_byte <= volume; midi_send <= 1; state <= IDLE; end
            endcase
        end
    end
endmodule
