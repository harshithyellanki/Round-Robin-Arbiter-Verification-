Round Robin Arbiter Project (Non-UVM) - QuestaSim Ready

How to run:
1) cd rr_arbiter_project/sim
2) vsim -do run.do

Expected:
- Random stimulus generation
- Driver applies enable/req
- Monitor collects req/gnt
- Scoreboard checks DUT vs reference model
- Assertions check protocol correctness
- Coverage collects functional stats

PASS if scoreboard errors = 0
