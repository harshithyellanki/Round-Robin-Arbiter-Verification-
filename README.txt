# Round-Robin Arbiter Verification Environment

## Overview

This project implements a SystemVerilog verification environment for a parameterized Round-Robin Arbiter. The arbiter distributes access among multiple requesters using a rotating priority scheme to ensure fair access to a shared resource.

The objective of this project is to verify arbitration correctness, grant behavior, and request servicing using a structured class-based verification environment with constrained-random stimulus, monitoring, scoreboard checking, assertions, and functional coverage.

This repository demonstrates industry-style digital design verification methodology and modular testbench architecture.


## Design Description

The Round-Robin Arbiter DUT includes:

- Parameterized number of requesters
- Rotating priority pointer
- One-hot grant generation
- Registered grant outputs
- Enable-controlled arbitration

The arbiter scans the request vector starting from the current priority pointer and grants access to the first active requester. After issuing a grant, the priority pointer moves to the next requester to maintain fairness.

The grant output is registered, meaning the grant appears one clock cycle after the request evaluation.


## Verification Architecture

The verification environment follows a modular layered architecture and includes the following components.

### 1. Transaction Layer

Transaction objects represent arbiter stimulus including:

- Request vector
- Enable signal

These transactions are randomized to create different arbitration scenarios.


### 2. Stimulus Generation

Randomized stimulus generates different request patterns including:

- Single active requester
- Multiple simultaneous requests
- Full request vector activation
- Random enable behavior


### 3. Driver

The driver receives transactions and drives stimulus to the DUT interface.

It applies:

- Request vectors
- Enable signals
- Clock-synchronized stimulus


### 4. Monitor

The monitor observes DUT interface activity and captures:

- Request vectors
- Grant outputs
- Enable signals

Observed transactions are forwarded to the scoreboard and coverage components.


### 5. Scoreboard

The scoreboard implements a reference round-robin arbitration model.

It:

- Maintains an expected arbitration state
- Compares DUT grant outputs with expected results
- Flags mismatches


### 6. Assertions

SystemVerilog assertions verify protocol properties including:

- Grant must be one-hot
- Grant must correspond to a valid request
- No grant when arbitration is disabled
- Correct arbitration progression


### 7. Functional Coverage

Functional coverage tracks:

- Request vector patterns
- Grant distribution
- Enable states
- Arbitration scenarios

Coverage ensures the arbiter is exercised across a wide range of request combinations.


## Project Structure

```
rr_arbiter_project/
│
├── dut/                Round-Robin Arbiter RTL
├── tb/                 Testbench components
├── scripts/            Simulation scripts
├── modelsim.ini        ModelSim configuration
├── work/               Simulation library (generated)
├── transcript          Simulation transcript (generated)
└── README.md
```


## Simulation Instructions

This project is developed for use with QuestaSim / ModelSim.

All commands are run from the project root directory.


### Compile and Run (Batch Mode)

vsim -c -do "do run.do; vsim work.tb_top -do 'run -all; quit'; quit"

This command:

- Compiles RTL and testbench
- Launches the testbench
- Runs simulation
- Exits automatically


### Run Only (After Compilation)

vsim -c work.tb_top -do "run -all; quit"


### GUI Mode with Waveforms

vsim work.tb_top


## Verification Flow

1. Generate constrained-random request patterns.
2. Driver applies stimulus to the arbiter.
3. Monitor observes request and grant signals.
4. Scoreboard compares DUT grants with expected arbitration results.
5. Assertions validate protocol properties.
6. Functional coverage is updated.


## Key Verification Features

- Constrained-random stimulus
- Self-checking scoreboard
- Assertion-based protocol checking
- Functional coverage collection
- Script-based simulation automation


## Future Enhancements

- Conversion to full UVM environment
- Directed fairness tests
- Long-run arbitration fairness checking
- Regression automation
- Coverage report integration
