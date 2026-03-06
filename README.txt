# Round-Robin Arbiter Verification Environment

## Overview

This project implements a complete SystemVerilog-based verification environment for a parameterized **Round-Robin Arbiter**. The arbiter distributes access among multiple requesters using a rotating priority scheme to ensure fair access to a shared resource.

The objective of this project is to verify arbitration correctness, grant behavior, and request servicing using a structured class-based verification environment with constrained-random stimulus, monitoring, scoreboard checking, assertions, and functional coverage.

This repository demonstrates industry-style digital design verification methodology and modular testbench architecture.



## Design Description

The Round-Robin Arbiter DUT includes:

- **Parameterized number of requesters**: Scalable bus width for various system sizes.
- **Rotating priority pointer**: Ensures fairness across all agents to prevent starvation.
- **One-hot grant generation**: Guarantees only one requester is served at a time.
- **Registered grant outputs**: Synchronized timing for stable downstream consumption.
- **Enable-controlled arbitration**: Support for global control and power management.

The arbiter scans the request vector starting from the current priority pointer and grants access to the first active requester. After issuing a grant, the priority pointer moves to the next requester to maintain fairness in the next arbitration cycle.

## Verification Architecture

The verification environment follows a modular layered architecture and includes:

### 1. Transaction Layer
- `arb_transaction` class modeling the request vector, enable signal, and observed grant vector.
- Includes randomization constraints to create diverse and stressful arbitration scenarios.

### 2. Stimulus Generation
- Constrained-random request generation to hit corner cases.
- Focus areas: Single active requester, multiple simultaneous requests, and full request vector activation.
- Random `enable` signal behavior to test arbitration gating logic.

### 3. Driver
- Receives transaction objects and drives stimulus to the DUT interface.
- Manages clock-synchronized driving of the `request` and `enable` signals.

### 4. Monitor
- Passively observes the DUT interface activity.
- Captures `req`, `gnt`, and `en` signals per clock cycle.
- Forwards observed transactions to the scoreboard and coverage components via mailboxes.

### 5. Scoreboard
- Implements a **Golden Reference Model** of the round-robin logic.
- Maintains an internal state of the expected priority pointer.
- Compares DUT grant outputs against predicted results and flags mismatches.

### 6. Assertions (SVA)
- **Grant One-Hot**: Verifies that no more than one grant is active at any time.
- **Legal Grant**: Verifies that a grant is only issued to an active request.
- **Enable Check**: Validates that no grants are issued when the arbiter is disabled.

### 7. Functional Coverage
- Coverage of request vector patterns and grant distribution.
- Monitoring of enable signal state transitions.
- Cross-coverage between requester IDs to ensure the rotation logic visits all ports.

## Project Structure

```text
rr_arbiter_project/
│
├── dut/                # Round-Robin Arbiter RTL
├── tb/                 # Testbench components (Driver, Monitor, Scoreboard, etc.)
├── scripts/            # Questa simulation scripts (.do files)
├── modelsim.ini        # ModelSim configuration
├── work/               # Simulation library (generated)
├── transcript          # Simulation transcript (generated)
└── README.md           # Project documentation
Simulation Instructions
This project is designed for use with QuestaSim / ModelSim.
All commands are executed from the project root directory.

Compile and Run (Batch Mode)
Bash
vsim -c -do "do scripts/run.do; run -all; quit"
This command:

Compiles the RTL and Testbench files.

Launches the testbench top-level module.

Runs the simulation to completion and exits automatically.

Run Only (After Compilation)
Bash
vsim -c work.tb_top -do "run -all; quit"
GUI Mode with Waveforms
Bash
vsim work.tb_top -do "add wave -r /*; run -all"
Verification Flow
Generate: Create constrained-random request patterns in the Generator.

Drive: Driver applies the stimulus to the arbiter via the Virtual Interface.

Monitor: The Monitor samples the request and grant signals on the clock edge.

Scoreboard: Compares the DUT's grant with the internal reference model.

Assertions: SVA monitors validate protocol properties in real-time.

Functional Coverage: Collection of metrics to ensure the verification plan is satisfied.

Key Verification Features
Constrained-random stimulus: Maximizes coverage of the arbiter's state space.

Self-checking scoreboard: Provides automated pass/fail reporting.

Assertion-based protocol checking: Catches logic and timing violations instantly.

Functional coverage collection: Quantifies the thoroughness of the verification.

Script-based automation: Streamlined flow for faster development cycles.

Future Enhancements
Conversion to full UVM (Universal Verification Methodology) environment.

Directed fairness tests for long-run statistical fairness analysis.

Integration of Regression automation for nightly builds.

Generation of HTML coverage reports for stakeholder review.
