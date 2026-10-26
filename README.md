# Dual-MCU Distributed Control Robotic Arm

https://github.com/user-attachments/assets/57c430d6-a159-4deb-b3c5-ea4f0ffdddad

An embedded software engineering project focused on developing a distributed master-slave microcontroller architecture to drive and monitor a robotic arm. This system was built during the 3rd semester of the Programmable Electronics Advanced Diploma (DEC) at Cégep Limoilou. The entire system architecture, distributed firmware, and hardware prototyping were successfully designed and executed within a strict 4-week timeline.

---

## System Architecture Overview

The core of this project lies in its distributed hardware control loop, offloading real-time peripheral handling from the main decision-making unit using an asynchronous serial link.

The DS89C450 MCU serves as the primary decision-making unit. It receives telemetry data streams from the secondary MCU, a PIC16F88. The PIC microchip continuously reads all hardware sensors and forwards their values via a dedicated UART link to the DS89C450. After processing the inputs, the DS89C450 transmits the specific target position commands back to the PIC for physical execution.

---

## Firmware & Software Architecture (/software)

### 1. Peripheral Handling & Servo Control Loop (PIC16F88 - Slave)
* Low-Level Development: Programmed extensively in Assembly (ASM) to maximize instruction timing accuracy, minimizing jitter across multiple simultaneous software-generated PWM signals.
* Data Acquisition: Configured the internal ADC registers to poll onboard sensors, including an analog load cell.
* Downstream Comms: Packed sensor telemetry packets into tight data payloads and streamed them asynchronously over the hardware UART bus back to the Master controller.

### 2. High-Level Decision Engine (DS89C450 - Master)
* State Machine Logic: Driven by an 8051-architecture high-speed MCU, running firmware developed primarily in C by two team members.
* Control Pipeline: Evaluated inbound UART telemetry from the PIC16F88, computed kinematics decisions, and returned the desired servo positions back to the slave chip over the serial bus.

---

## Hardware Engineering & Prototyping

* Analog Signal Conditioning: Since the mechanical assembly was out of scope, hardware prototyping focused on breadboard circuit design.
* Load Cell Interfacing: Designed and validated a small front-end analog amplifier circuit on a breadboard to condition low-voltage strain gauge signals from a load cell into measurable 0-5V logic levels for the PIC's ADC.

---

## Repository Directory Structure

```text
├── docs/                     # Datasheets of components and project demo video
├── software/                 # Distributed codebase
    ├── Dallas-Keil/          # High-level C code managing finite state machine logic (Keil IDE)
    ├── hex_demo_functions/   # Reference hex code provided for early hardware verification
    ├── PIC/                  # Low-level Assembly (ASM) code for peripheral control
    └── tests/                # Dedicated test scripts for both microcontrollers
└── README.md                 # This file
```

---

## Contributors & Credits
* Marie-Pier Morin – Developed the Master-side C firmware architecture and engineered the physical breadboard prototyping/circuit debugging.
* [FT511](https://github.com/FT511) – Engineered the analog data acquisition (ADC) scripts on the PIC16F88 and contributed to the Master-side C codebase.
* [Alexandre Dionne](https://github.com/Alexou1209) – Developed the low-level PIC16F88 Assembly (ASM) firmware, optimized multi-channel PWM generation, and supported cross-functional integration tasks.
