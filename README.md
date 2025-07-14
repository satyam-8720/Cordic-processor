
# CORDIC+ Engine: Dual Mode Hardware Architecture for Trigonometric and Polar Computation

## 🔍 Overview
This upgraded CORDIC implementation supports **both rotation and vectoring modes** for computing:
- **sin(θ)**, **cos(θ)** (rotation mode)
- **magnitude** and **angle** from (x, y) (vectoring mode)

The design is written in synthesizable Verilog using **fixed-point arithmetic**, **FSM control**, and parameterized iteration depth.

## 🧠 Features
- Rotation and vectoring mode support
- FSM controlled start/done
- Fixed-point scaling (Q16.15)
- Synthesizable and pipelined-friendly
- Testbench with waveform output

## 🧪 Simulation
```bash
iverilog -o cordic_plus_tb cordic.v tb_cordic.v
vvp cordic_plus_tb
gtkwave cordic_plus.vcd
```

## ✅ Inputs
- `mode = 0` → Rotation Mode (input: angle)
- `mode = 1` → Vectoring Mode (input: x, y)

## 📄 Files
- `cordic_32bit.v` – Main RTL module (CORDIC+)
- `tb_cordic_32bit.v` – Testbench with angle and vector tests
- `cordic_plus.vcd` – Waveform dump

## 👥 Team Members and Name
 TRANSISTORS
-SATYAM CHAUHAN 2301EC38

## 📅 Submission
For LogicForge Digital Design Innovation Challenge (Sparkonics)
