`timescale 1ns/1ps

module midi_note_sender_tb;

    reg clk = 0;
    reg rst = 1;
    reg [15:0] distance_cm = 0;
    reg distance_ready = 0;
    reg uart_ready = 0;
    wire [7:0] midi_byte;
    wire midi_send;

    // Instanciar el DUT (Device Under Test)
    midi_note_sender dut (
        .clk(clk),
        .rst(rst),
        .distance_cm(distance_cm),
        .distance_ready(distance_ready),
        .midi_byte(midi_byte),
        .midi_send(midi_send),
        .uart_ready(uart_ready)
    );

    // Reloj: 10ns por ciclo (100MHz)
    always #5 clk = ~clk;

    initial begin
        $dumpfile("midi_note_sender_tb.vcd");
        $dumpvars(0, midi_note_sender_tb);

        // Inicialización
        #10 rst = 0;

        // Simular una distancia de 20 cm con uart_ready listo
        #10 distance_cm = 16'd20;
            distance_ready = 1;
        #10 distance_ready = 0;

        // Simular disponibilidad de UART para los 3 bytes MIDI
        repeat (3) begin
            #20 uart_ready = 1;
            #10 uart_ready = 0;
        end

        // Simular otra distancia (mayor)
        #50 distance_cm = 16'd55;
            distance_ready = 1;
        #10 distance_ready = 0;

        repeat (3) begin
            #20 uart_ready = 1;
            #10 uart_ready = 0;
        end

        // Simular otra distancia (muy corta)
        #50 distance_cm = 16'd2;
            distance_ready = 1;
        #10 distance_ready = 0;

        repeat (3) begin
            #20 uart_ready = 1;
            #10 uart_ready = 0;
        end

        #100 $finish;
    end

endmodule

