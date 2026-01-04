# Logism-CPU-Design

This project implements a custom 18-bit multi-cycle processor designed as part of a computer architecture course. The processor is first developed at the component and datapath level, then fully implemented in Verilog HDL and verified using ModelSim.

📌 Project Overview

Architecture: Multi-cycle processor

Data Width: 18 bits

Address Width: 12 bits

Registers: 16 general-purpose registers (R15 used as Stack Pointer)

Control: FSM-based Control Unit

Design Tools: Logisim, Verilog HDL, ModelSim

Assembler: Python-based assembler

🏗 Processor Components

Each component is implemented as a separate module:

Program Counter (PC)

Instruction Memory

Register File (2-read / 1-write)

Arithmetic Logic Unit (ALU)

Data Memory

Extend Unit (Sign / Zero)

Multiplexers

FSM-based Control Unit

Top-level Datapath Module

📜 Supported Instructions

The processor supports the following instruction groups:

Arithmetic / Logical: ADD, SUB, NAND, NOR, SRL, SRA

Immediate Operations: ADDI, SUBI, NANDI, NORI

Memory Access: LD, ST

Stack Operations: PUSH, POP

Control Flow: JUMP, JAL, CMOV

Immediate Load: LUI

🧩 Control Unit Design

Implemented as a Moore Finite State Machine

Separate states for:

Instruction Fetch

Decode

Execute

Memory Access

Write Back

Opcode decoding determines state transitions

Control signals are generated based solely on the current FSM state

🛠 Verilog Implementation

Each processor component is defined as an individual Verilog module

The assembler output (.hex) is loaded into Instruction Memory using $readmemh

The full datapath is connected in a top-level CPU module

🧪 Testing and Verification

A comprehensive ModelSim testbench is provided

Custom assembly programs test:

Arithmetic operations

Memory access

Stack behavior

Control flow instructions

Internal signals (FSM state, PC, registers, memory) are observed via waveforms

▶ How to Run

Assemble the test program:

python assembler.py


Load the generated program.hex into the instruction memory

Compile all Verilog modules in ModelSim

Run the testbench and observe waveforms

📈 Project Status

✔ Component Design Completed
✔ Datapath Implemented
✔ FSM Control Unit Designed
✔ Verilog HDL Implementation
✔ ModelSim Verification

📄 Notes

This project demonstrates a complete processor design flow from architectural planning to RTL-level implementation and simulation.
