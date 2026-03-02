# ECG Arrhythmia Detection — FPGA Hardware Accelerator
FPGA Hackathon 2026 | Biomedical Systems | Team Name

## Project Summary
Configurable low-latency 1D CNN accelerator for real-time
ECG arrhythmia detection implemented in Verilog RTL on
Zynq-7020 FPGA.

## Architecture
Input(300) → Conv1D(8f,k5) → MaxPool → Conv1D(16f,k5)
           → MaxPool → Dense(1152→16) → Dense(16→1)
           → Sigmoid → Secure Alert

## Key Results
- Accuracy     : 100% on test dataset
- Latency      : 1.44 ms (real-time budget: 4 ms)
- Speedup      : 35x over CPU
- LUT usage    : 4.3% of Zynq-7020
- Throughput   : 697 inferences/second

## How to Run Simulation (Vivado)
1. Open Vivado → Create Project
2. Add rtl/*.v as Design Sources
3. Add tb/*.v as Simulation Sources
4. Add weights/*.hex and test_data/test_input.hex
5. Set ecg_pipeline_top_tb as simulation top
6. Run Behavioral Simulation → Run All

## How to Run Simulation (ModelSim)
  vsim -c -do sim/run_all_modelsim.do

## File Structure
  rtl/       → Verilog RTL source files
  tb/        → Testbenches
  weights/   → INT8 quantized weight hex files
  model/     → Python training & quantization
  sim/       → Simulation scripts
  docs/      → Report, diagrams, screenshots
```

---

### Hackathon ZIP Submission Structure

When you zip for submission, include only these — keep it clean:
```
Team_Name_ECG_Accelerator.zip
├── rtl/              ← all 9 .v files
├── tb/               ← all 9 _tb.v files
├── weights/          ← all 9 .hex files
├── test_data/        ← test_input.hex
├── model/            ← Python training scripts
├── sim/              ← run scripts
├── docs/
│   └── technical_report.pdf
└── README.md
```

**Do NOT include:**
```
❌ vivado_project/   (too large, auto-generated)
❌ video/            (submit link separately)
❌ __pycache__/
❌ *.jou *.log       (Vivado log files)
