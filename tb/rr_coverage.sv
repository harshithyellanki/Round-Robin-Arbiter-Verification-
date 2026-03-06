class rr_coverage #(int N=4);

  mailbox #(rr_trans#(N)) mon2cov;
  virtual rr_if #(N) vif;

  bit enable_s;
  bit [N-1:0] req_s;
  bit [N-1:0] gnt_s;

  int gnt_idx_s; // -1 = none, 0..N-1 = granted requester

  // Convert onehot grant vector to an index (assumes onehot0)
  function int onehot_to_idx(bit [N-1:0] v);
    if (v == '0) return -1;
    for (int i = 0; i < N; i++) begin
      if (v[i]) return i;
    end
    return -2; // should never happen if onehot0 holds
  endfunction

  covergroup cg @(posedge vif.clk);
    option.per_instance = 1;

    cp_enable: coverpoint enable_s {
      bins on  = {1};
      bins off = {0};
    }

    cp_req_count: coverpoint $countones(req_s) {
      bins none = {0};
      bins one  = {1};
      bins two  = {2};
      bins many = {[3:N]};
    }

    cp_gnt_count: coverpoint $countones(gnt_s) {
      bins zero = {0};
      bins one  = {1};
      illegal_bins multi = {[2:N]};
    }

    // Index-based grant coverage (Questa-friendly)
    cp_gnt_idx: coverpoint gnt_idx_s {
      bins none = {-1};
      bins each_idx[] = {[0:N-1]};
      illegal_bins bad = default;
    }

    cx_en_req:  cross cp_enable, cp_req_count;
    cx_req_gnt: cross cp_req_count, cp_gnt_idx;

  endgroup

  function new(virtual rr_if #(N) vif,
               mailbox #(rr_trans#(N)) mon2cov);
    this.vif = vif;
    this.mon2cov = mon2cov;
    cg = new();
  endfunction

  task run();
    rr_trans#(N) tr;
    forever begin
      mon2cov.get(tr);
      enable_s  = tr.enable;
      req_s     = tr.req;
      gnt_s     = vif.gnt;
      gnt_idx_s = onehot_to_idx(gnt_s);
      cg.sample();
    end
  endtask

endclass

