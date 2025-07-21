`timescale 1ns/1ps

module midi_volume_sender_tb;

    reg clk = 0;
    reg rst = 1;
    reg [15:0] distance_cm = 0;
    reg distance_ready = 0;
    reg uart_ready = 0;
    wire [7:0] midi_byte;
    wire midi_send;

    // Instanciar el DUT
    midi_volume_sender dut (
        .clk(clk),
        .rst(rst),
        .distance_cm(distance_cm),
        .distance_ready(distance_ready),
        .midi_byte(midi_byte),
        .midi_send(midi_send),
        .uart_ready(uart_ready)
    );

    // Clock: 10 ns
    always #5 clk = ~clk;

    initial begin
        $dumpfile("midi_volume_sender_tb.vcd");
        $dumpvars(0, midi_volume_sender_tb);

        #10 rst = 0;

        // Prueba 1: distancia corta (volumen máximo)
        #10 distance_cm = 4; distance_ready = 1;
        #10 distance_ready = 0;
        repeat (3) begin
            #20 uart_ready = 1;
            #10 uart_ready = 0;
        end

        // Prueba 2: distancia media
        #50 distance_cm = 35; distance_ready = 1;
        #10 distance_ready = 0;
        repeat (3) begin
            #20 uart_ready = 1;
            #10 uart_ready = 0;
        end

        // Prueba 3: distancia larga (volumen mínimo)
        #50 distance_cm = 70; distance_ready = 1;
        #10 distance_ready = 0;
        repeat (3) begin
            #20 uart_ready = 1;
            #10 uart_ready = 0;
        end

        #100 $finish;
    end
endmodule

