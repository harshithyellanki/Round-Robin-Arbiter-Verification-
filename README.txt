
# Round-Robin Arbiter Verification

A SystemVerilog verification project for a **parameterized Round-Robin Arbiter**.
The project implements a **modular class-based verification environment** (similar to UVM architecture) including randomized stimulus, driver/monitor components, a reference model, scoreboard checking, SystemVerilog assertions, and functional coverage.

This repository demonstrates core **ASIC/FPGA verification methodologies** used in modern digital design verification flows.

---

# Project Overview

A **Round-Robin Arbiter** distributes access to a shared resource among multiple requesters in a fair manner. Unlike fixed-priority arbiters, round-robin arbitration prevents starvation by rotating priority after each grant.

This project verifies a parameterized round-robin arbiter using a structured SystemVerilog verification environment.

## Key Features

* Parameterized number of requesters
* One-hot grant generation
* Rotating priority pointer
* Registered output grants
* Constrained random stimulus generation
* Reference model based checking
* Scoreboard comparison
* SystemVerilog Assertions (SVA)
* Functional coverage collection
* QuestaSim simulation automation

---

# Arbiter Design

## Inputs

| Signal       | Description         |
| ------------ | ------------------- |
| `clk`        | System clock        |
| `rst_n`      | Active-low reset    |
| `enable`     | Enables arbitration |
| `req[N-1:0]` | Request vector      |

## Outputs

| Signal       | Description          |
| ------------ | -------------------- |
| `gnt[N-1:0]` | One-hot grant vector |

## Arbitration Behavior

1. The arbiter scans request lines starting from the **current priority pointer**
2. The **first active request** encountered receives the grant
3. The grant output is **one-hot encoded**
4. After granting access, the pointer updates to the **next requester**
5. The grant output is **registered**, meaning the grant appears **one clock cycle after the request evaluation**

---

# Verification Architecture

The verification environment follows a **layered architecture similar to UVM**, implemented using SystemVerilog classes.

```
Transaction
    │
    ▼
Driver ──► DUT
    │
    ▼
Monitor
    │
    ├──► Coverage
    │
    └──► Scoreboard
            │
            ▼
       Reference Model
```

---

# Verification Components

## Transaction (`rr_trans.sv`)

Represents a randomized stimulus transaction including:

* Request vector
* Enable signal
* Constraints controlling the number of active requests

---

## Driver (`rr_driver.sv`)

The driver:

* Receives transactions
* Drives signals to the DUT through the interface

---

## Monitor (`rr_monitor.sv`)

The monitor:

* Observes DUT interface signals
* Sends observed transactions to

  * Coverage
  * Scoreboard

---

## Reference Model (`rr_ref_model.sv`)

Implements the **golden arbitration algorithm** used to compute expected grants.

---

## Scoreboard (`rr_scoreboard.sv`)

The scoreboard compares:

```
Observed DUT grant
vs
Expected grant from reference model
```

Because the DUT grant is **registered**, comparisons account for a **one-cycle latency**.

---

## Assertions (`rr_assertions.sv`)

SystemVerilog Assertions verify protocol correctness:

* Grant must be **onehot0**
* Grant must correspond to a **valid request**
* No grant when arbiter is disabled
* A request must eventually produce a grant

---

## Functional Coverage (`rr_coverage.sv`)

Coverage ensures the arbiter is exercised across scenarios such as:

* Enable ON / OFF
* Number of active requesters
* Grant index
* Cross coverage between request patterns and grants

---

## Environment (`rr_env.sv`)

The environment integrates:

* Driver
* Monitor
* Scoreboard
* Coverage

Communication between components is implemented using **mailboxes**.

---

## Top Testbench (`tb_top.sv`)

The top-level testbench:

* Instantiates the DUT and interface
* Instantiates assertions
* Creates the verification environment
* Runs randomized testing
* Reports final PASS/FAIL results

---

# Repository Structure

```
Round-Robin-Arbiter-Verification/

dut/
   rr_arbiter.sv

tb/
   rr_assertions.sv
   rr_coverage.sv
   rr_driver.sv
   rr_env.sv
   rr_if.sv
   rr_monitor.sv
   rr_ref_model.sv
   rr_scoreboard.sv
   rr_trans.sv
   tb_pkg.sv
   tb_top.sv

sim/
   run.do
   modelsim.ini
   transcript
   vsim.wlf
   work/

README.md
```

---

# Running the Simulation

This project is designed for **QuestaSim / ModelSim**.

## Step 1

Navigate to the simulation directory

```
cd sim
```

## Step 2

Run the simulation script

```
vsim -do run.do
```

Alternatively from the Questa console

```
do run.do
```

---

# What `run.do` Does

The script performs the following:

1. Creates the simulation library (`work`)
2. Compiles the DUT
3. Compiles interface and assertions
4. Compiles testbench package
5. Compiles the top testbench
6. Starts simulation
7. Adds waveform signals
8. Runs simulation to completion

---

# Expected Simulation Output

If the DUT behaves correctly the simulation prints:

```
====================================
TEST COMPLETE
SCOREBOARD ERRORS = 0
====================================
PASS
```

If mismatches occur the scoreboard increments the error count and the test reports **FAIL**.

---

# Tools Used

* SystemVerilog
* QuestaSim / ModelSim

---

# Future Improvements

Possible extensions:

* Directed testcases
* Parameter sweep testing
* Long-run fairness verification
* Regression automation
* Converting the environment to **UVM**
* Adding `.gitignore` to exclude simulation artifacts

---

# Author

**Harshith Yellanki**

SystemVerilog verification project demonstrating constrained random testing, reference modeling, scoreboard checking, assertions, and functional coverage.

