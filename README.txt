Round-Robin Arbiter Verification

A SystemVerilog verification project for a parameterized Round-Robin Arbiter.
The project implements a modular class-based verification environment including randomized stimulus, driver/monitor components, a reference model, scoreboard checking, SystemVerilog assertions, and functional coverage.

This repository demonstrates ASIC/FPGA verification methodologies used in modern digital design flows.

Project Overview

A Round-Robin Arbiter distributes access to a shared resource among multiple requesters in a fair manner. Unlike fixed-priority arbiters, round-robin arbitration prevents starvation by rotating priority after each grant.

This project verifies a parameterized round-robin arbiter using a structured SystemVerilog verification environment.

Key Features

Parameterized number of requesters

One-hot grant generation

Rotating priority pointer

Registered output grants

Constrained random stimulus generation

Reference model based checking

Scoreboard comparison

SystemVerilog Assertions (SVA)

Functional coverage collection

QuestaSim simulation automation

Arbiter Design
Inputs
Signal	Description
clk	System clock
rst_n	Active-low reset
enable	Enables arbitration
req[N-1:0]	Request vector
Outputs
Signal	Description
gnt[N-1:0]	One-hot grant vector
Arbitration Behavior

Arbiter scans request lines starting from the current priority pointer

The first active request encountered receives the grant

Grant output is one-hot encoded

Pointer updates to the next requester

Grant is registered, so it appears one clock cycle later

Verification Architecture

Transaction
↓
Driver → DUT
↓
Monitor
├── Coverage
└── Scoreboard → Reference Model

Verification Components
Transaction (rr_trans.sv)

Represents randomized stimulus including:

Request vector

Enable signal

Constrained number of active requests

Driver (rr_driver.sv)

Receives transactions

Drives signals to the DUT interface

Monitor (rr_monitor.sv)

Observes DUT signals

Sends data to scoreboard and coverage

Reference Model (rr_ref_model.sv)

Implements the golden round-robin arbitration algorithm.

Scoreboard (rr_scoreboard.sv)

Compares:

DUT Grant
vs
Reference Model Grant

Accounting for 1-cycle registered latency.

Assertions (rr_assertions.sv)

Ensures:

Grant is onehot0

Grant corresponds to a valid request

No grant when disabled

Requests eventually get serviced

Coverage (rr_coverage.sv)

Functional coverage includes:

Enable ON/OFF

Number of active requests

Grant index

Cross coverage between request patterns and grants

Environment (rr_env.sv)

Integrates:

Driver

Monitor

Scoreboard

Coverage

Communication is done through mailboxes.

Top Testbench (tb_top.sv)

Instantiates DUT and interface

Instantiates assertions

Creates verification environment

Runs randomized tests

Prints PASS/FAIL summary

Repository Structure

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

README.md

Running Simulation

Navigate to the simulation directory:

cd sim

Run the script:

vsim -do run.do

Or inside Questa:

do run.do

Simulation Flow

The script:

Creates simulation library

Compiles DUT

Compiles testbench

Launches simulation

Adds waveforms

Runs simulation to completion

Expected Output

If correct:

TEST COMPLETE
SCOREBOARD ERRORS = 0
PASS

Tools Used

SystemVerilog

QuestaSim / ModelSim

Future Improvements

Possible extensions:

Directed tests

Parameter sweeps

Fairness verification

Automated regression

Full UVM implementation

Author

Harshith Yellanki

SystemVerilog verification project demonstrating constrained random testing, reference modeling, scoreboard checking, assertions, and functional coverage.
