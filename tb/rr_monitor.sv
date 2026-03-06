class rr_monitor #(int N=4);

  virtual rr_if #(N) vif;

  mailbox #(rr_trans#(N)) mon2cov;
  mailbox #(rr_trans#(N)) mon2sb;

  mailbox #(bit [N-1:0]) gnt_mb;
  mailbox #(bit)         rst_mb;

  function new(virtual rr_if #(N) vif,
               mailbox #(rr_trans#(N)) mon2cov,
               mailbox #(rr_trans#(N)) mon2sb,
               mailbox #(bit [N-1:0]) gnt_mb,
               mailbox #(bit) rst_mb);
    this.vif = vif;
    this.mon2cov = mon2cov;
    this.mon2sb  = mon2sb;
    this.gnt_mb  = gnt_mb;
    this.rst_mb  = rst_mb;
  endfunction

  task run();
    rr_trans#(N) tr;

    forever begin
      @(vif.cb_mon);

      tr = new();
      tr.enable = vif.cb_mon.enable;
      tr.req    = vif.cb_mon.req;

      mon2cov.put(tr);
      mon2sb.put(tr);

      gnt_mb.put(vif.cb_mon.gnt);
      rst_mb.put(vif.cb_mon.rst_n);
    end
  endtask

endclass
