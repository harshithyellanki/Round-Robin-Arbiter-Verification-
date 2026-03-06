class rr_env #(int N=4);

  virtual rr_if #(N) vif;

  mailbox #(rr_trans#(N)) gen2drv = new();
  mailbox #(rr_trans#(N)) mon2cov = new();
  mailbox #(rr_trans#(N)) mon2sb  = new();

  mailbox #(bit [N-1:0])  gnt_mb  = new();
  mailbox #(bit)          rst_mb  = new();

  rr_driver     #(N) drv;
  rr_monitor    #(N) mon;
  rr_scoreboard #(N) sb;
  rr_coverage   #(N) cov;

  int unsigned num_transactions;

  function new(virtual rr_if #(N) vif, int unsigned num_transactions=5000);
    this.vif = vif;
    this.num_transactions = num_transactions;

    drv = new(vif, gen2drv);
    mon = new(vif, mon2cov, mon2sb, gnt_mb, rst_mb);
    sb  = new(vif, mon2sb, gnt_mb, rst_mb);
    cov = new(vif, mon2cov);
  endfunction

  task gen();
    rr_trans#(N) tr;
    for (int t = 0; t < num_transactions; t++) begin
      tr = new();
      if (!tr.randomize())
        $fatal("[GEN] Randomization failed");
      gen2drv.put(tr);
    end
  endtask

  task run();
    drv.reset_dut();

    fork
      drv.run();
      mon.run();
      sb.run();
      cov.run();
      gen();
    join_none
  endtask

endclass
