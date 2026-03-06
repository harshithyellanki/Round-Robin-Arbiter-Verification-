class rr_scoreboard #(int N=4);

  virtual rr_if #(N) vif;

  mailbox #(rr_trans#(N)) mon2sb;
  mailbox #(bit [N-1:0])  gnt_mb;
  mailbox #(bit)          rst_mb;

  rr_ref_model #(N) rm;
  int unsigned err_count;

  function new(virtual rr_if #(N) vif,
               mailbox #(rr_trans#(N)) mon2sb,
               mailbox #(bit [N-1:0]) gnt_mb,
               mailbox #(bit) rst_mb);
    this.vif = vif;
    this.mon2sb = mon2sb;
    this.gnt_mb = gnt_mb;
    this.rst_mb = rst_mb;
    rm = new();
    err_count = 0;
  endfunction

  task run();
  rr_trans#(N) tr_cur;
  rr_trans#(N) tr_prev;
  bit [N-1:0] gnt_obs;
  bit rst_n;
  bit [N-1:0] gnt_exp;
  bit have_prev = 0;

  forever begin
    mon2sb.get(tr_cur);
    gnt_mb.get(gnt_obs);
    rst_mb.get(rst_n);

    if (!rst_n) begin
      rm.reset();
      have_prev = 0;
      continue;
    end

    if (!have_prev) begin
      // First valid cycle after reset: capture inputs but don't compare yet
      tr_prev = tr_cur;
      have_prev = 1;
      continue;
    end

    // Compute expected grant for THIS cycle from previous cycle's inputs
    gnt_exp = rm.step(tr_prev.enable, tr_prev.req);

    if (gnt_obs !== gnt_exp) begin
      err_count++;
      $error("[SB] MISMATCH: prev_%s | exp=0x%0h obs=0x%0h ptr=%0d",
             tr_prev.sprint(), gnt_exp, gnt_obs, rm.ptr);
    end

    // Shift pipeline: current becomes previous for next cycle
    tr_prev = tr_cur;
  end
endtask


endclass
