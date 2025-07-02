# UART
"A Verilog implementation of a UART (Universal Asynchronous Receiver/Transmitter) with testbench and simulation.

---

## How It Works

- The **transmitter** takes an 8-bit data word, adds start and stop bits, and sends it serially.
- The **receiver** detects the start bit, samples the incoming bits, and reconstructs the original data.
- The **testbench** demonstrates a complete transmit-receive cycle and prints the received data.

---

##How to View
-Open .wdb files in vivado to see the simulations and waveforms of UART.
-Open .v files for the code to run it.
-pdf files are the block designs, synthesis results and schematics which are the results of the simulations 
.

## This project demonstrates:
- Digital design skills in Verilog
- Understanding of serial communication protocols
- Experience with FPGA simulation and testbench creation



