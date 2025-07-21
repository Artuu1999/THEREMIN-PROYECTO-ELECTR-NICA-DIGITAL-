// top_module.v
module top_module (
    input clk,
    input rst,
    input echo1, echo2,
    output trigger1, trigger2,
    output tx
);
    wire [15:0] distancia_tono, distancia_volumen;
    wire listo_tono, listo_volumen;
    wire [7:0] midi_byte_note, midi_byte_vol;
    wire midi_send_note, midi_send_vol;
    wire uart_ready;
    reg [7:0] midi_byte_mux;
    reg midi_send_mux;

    ultrasonic_sensor sensor_tono (
        .clk(clk), .rst(rst),
        .echo(echo1), .trigger(trigger1),
        .distance_cm(distancia_tono),
        .distance_ready(listo_tono)
    );

    ultrasonic_sensor sensor_volumen (
        .clk(clk), .rst(rst),
        .echo(echo2), .trigger(trigger2),
        .distance_cm(distancia_volumen),
        .distance_ready(listo_volumen)
    );

    midi_note_sender note_midi (
        .clk(clk), .rst(rst),
        .distance_cm(distancia_tono),
        .distance_ready(listo_tono),
        .midi_byte(midi_byte_note),
        .midi_send(midi_send_note),
        .uart_ready(uart_ready)
    );

    midi_volume_sender volume_midi (
        .clk(clk), .rst(rst),
        .distance_cm(distancia_volumen),
        .distance_ready(listo_volumen),
        .midi_byte(midi_byte_vol),
        .midi_send(midi_send_vol),
        .uart_ready(uart_ready)
    );

    uart_tx uart (
        .clk(clk), .rst(rst),
        .data_in(midi_byte_mux),
        .send(midi_send_mux),
        .tx(tx),
        .ready(uart_ready)
    );

    always @(*) begin
        if (midi_send_note) begin
            midi_byte_mux = midi_byte_note;
            midi_send_mux = 1;
        end else if (midi_send_vol) begin
            midi_byte_mux = midi_byte_vol;
            midi_send_mux = 1;
        end else begin
            midi_byte_mux = 8'd0;
            midi_send_mux = 0;
        end
    end
endmodule
