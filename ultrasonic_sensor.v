// ultrasonic_sensor.v
module ultrasonic_sensor (
    input clk,
    input rst,
    input echo,
    output reg trigger,
    output reg [15:0] distance_cm,
    output reg distance_ready
);

    localparam CLK_FREQ = 50000000;      // 50 MHz
    localparam TRIG_PULSE_CYCLES = 500;  // 10 us
    localparam TIMEOUT_CYCLES = 30000000; // 0.6s timeout

    reg [31:0] timer;
    reg [31:0] pulse_width;
    reg echo_d, echo_dd;
    reg measuring;
    reg [8:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            trigger <= 0;
            distance_cm <= 0;
            distance_ready <= 0;
            timer <= 0;
            pulse_width <= 0;
            measuring <= 0;
            echo_d <= 0;
            echo_dd <= 0;
            state <= 0;
        end else begin
            echo_d <= echo;
            echo_dd <= echo_d;
            distance_ready <= 0;

            case (state)
                0: begin
                    trigger <= 1;
                    timer <= 0;
                    state <= 1;
                end
                1: begin
                    if (timer < TRIG_PULSE_CYCLES)
                        timer <= timer + 1;
                    else begin
                        trigger <= 0;
                        timer <= 0;
                        state <= 2;
                    end
                end
                2: begin
                    if (echo_dd && !echo_d) begin
                        timer <= 0;
                        measuring <= 1;
                        state <= 3;
                    end else if (timer > TIMEOUT_CYCLES) begin
                        state <= 0;
                    end else
                        timer <= timer + 1;
                end
                3: begin
                    if (!echo_dd && echo_d) begin
                        pulse_width <= timer;
                        measuring <= 0;
                        state <= 4;
                    end else if (timer > TIMEOUT_CYCLES) begin
                        state <= 0;
                    end else
                        timer <= timer + 1;
                end
                4: begin
                    distance_cm <= timer / 2900;
                    distance_ready <= 1;
                    state <= 0;
                end
            endcase
        end
    end
endmodule
