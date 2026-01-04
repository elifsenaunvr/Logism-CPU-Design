# Logism-CPU-Design

# 🧠 Custom 18-bit Processor Design

This project implements a custom **18-bit multi-cycle processor** designed as part of a computer architecture course. The processor is developed at component and datapath level, then fully implemented in **Verilog HDL** and verified using **ModelSim**.

---

## 📌 Project Overview

- **Architecture:** Multi-cycle processor  
- **Data Width:** 18 bits  
- **Address Width:** 12 bits  
- **Registers:** 16 general-purpose registers (R15 used as Stack Pointer)  
- **Control Unit:** FSM-based (Moore FSM)  
- **Design Tools:** Logisim, Verilog HDL, ModelSim  
- **Assembler:** Python-based assembler  

---

## 🏗 Processor Components

Each component is implemented as a separate module:

- Program Counter (PC)
- Instruction Memory
- Register File (2-read / 1-write)
- Arithmetic Logic Unit (ALU)
- Data Memory
- Extend Unit (Sign / Zero)
- Multiplexers
- FSM-based Control Unit
- Top-level Datapath Module

---

## 📜 Supported Instructions

The processor supports the following instruction groups:

- **Arithmetic / Logical:** ADD, SUB, NAND, NOR, SRL, SRA  
- **Immediate Operations:** ADDI, SUBI, NANDI, NORI  
- **Memory Access:** LD, ST  
- **Stack Operations:** PUSH, POP  
- **Control Flow:** JUMP, JAL, CMOV  
- **Immediate Load:** LUI  

---

## 🧩 Control Unit Design

- Implemented as a **Moore Finite State Machine**
- Separate states for:
  - Instruction Fetch
  - Decode
  - Execute
  - Memory Access
  - Write Back
- Opcode decoding determines state transitions
- Control signals are generated based only on the current FSM state

---

## 🛠 Verilog Design Notes

- Each processor component is defined in a **separate Verilog module**
- Bit widths strictly follow the ISA specification
- Full datapath integration isn't implemented.

---

## 📄 Notes

This project follows an incremental processor design approach, starting from individual hardware components and progressing toward a complete processor implementation.
