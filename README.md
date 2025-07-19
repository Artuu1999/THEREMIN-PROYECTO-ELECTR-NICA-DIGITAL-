# THEREMIN (PROYECTO ELECTRÓNICA DIGITAL)
En el presente repositorio se expondrá en que conssitió el proyecto realizado en la aignatura de electrónica digital, mostrando el paso a paso realizado
- Dilan Mateo Torres Muñoz
- Arturo Moreno Covaría
- Nicolás Zarate Acosta
- 

Bienvenidos a nuestro repositorio del proyecto final de nuestra clase de electrónica digital de la Universidad Nacional de Colombia del semestre 2025-I, el cual consistía en el diseño y posterior implementación de  un theremin (instrumento musical), realizando una versión digital de este mismo mediante el uso de sensores ultrasónicos, FPGA y ESP32.

# Objetivos del proyecto
- Construir un diseño electrónico que detecte movimiento, en este caso que detecte el movimiento de la mano y la posición de ella mediante sensores ultrasónicos
- Diseñar un modelo que permita generar sonidos, con sus respectivas características (frecuencia y volumen) según la distancia detectada por el sensor.

# ¿Que es un theremin?
<img width="444" height="259" alt="image" src="https://github.com/user-attachments/assets/a56dd0b0-8218-48bc-96da-9a208ffc4796" />

Un theremin es un instrumento musical electrónico inventado por Léon Theremin, que se caracteriza por ser tocado sin contacto físico directo. Se controla mediante el movimiento de las manos alrededor de dos antenas, una para el tono y otra para el volumen, alterando campos electromagnéticos.

# Planteamiento
```mermaid
flowchart TB
  %% Theremin Digital - Flujo General (de arriba hacia abajo)
  start([Inicio])
  start --> RESET{Reset equipo}
  RESET -- Sí --> INIT[Sistema Inicializa]
  INIT --> SENSOR_INIT[Configura HCS & ESP32]
  SENSOR_INIT --> FPGA_INIT[Configura UART & Clocks FPGA]
  FPGA_INIT --> RUN[Ejecución]
  RESET -- No --> RUN

  subgraph Loop[Ejecución Continua]
    direction TB
    HCS[Sensor HCS] -->|Lectura ADC| ESP32[ESP32]
    ESP32 -->|Procesa distancia y escala fase| ESP32_PROC[Procesamiento]
    ESP32_PROC -->|Envía phase_inc por UART| FPGA[FPGA Colorlight 5A-75E]
    subgraph FPGA_COLORLIGHT
      direction TB
      REG_IF["Interfaz UART"] --> PHASE_ACC["Registrador de fase"]
      PHASE_ACC --> NCO["Acumulador de fase (NCO)"]
      NCO --> WAVE_LUT["Tabla de seno (LUT)"]
      WAVE_LUT --> PWM_GEN["Generador PWM"]
      PWM_GEN --> AUDIO_OUT["Audio PWM"]
    end
    AUDIO_OUT -->|Filtro Pasabajo| SPEAKER[Altavoz]
  end

  RUN --> Loop
```

## Requrimentos funcionales:
## Diagrama ASM/ Maquina de estados/ diagramas funcionales:
## Diagrama RTL del SoC y su mòdulo:
## Simulaciones:
## Video simulacion: 
## Logs de make log-prn, make log-syn
## ¿Còmo interactùa con entornos externos?
## Video del proyecto


