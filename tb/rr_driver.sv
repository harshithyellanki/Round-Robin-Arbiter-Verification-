class rr_driver #(int N=4);

  virtual rr_if #(N) vif;
  mailbox #(rr_trans#(N)) gen2drv;

  function new(virtual rr_if #(N) vif,
               mailbox #(rr_trans#(N)) gen2drv);
    this.vif = vif;
    this.gen2drv = gen2drv;
  endfunction

  task reset_dut();
    vif.cb_drv.rst_n  <= 0;
    vif.cb_drv.enable <= 0;
    vif.cb_drv.req    <= '0;
    repeat (5) @(posedge vif.clk);
    vif.cb_drv.rst_n  <= 1;
    repeat (1) @(posedge vif.clk);
  endtask

  task run();
    rr_trans#(N) tr;

    forever begin
      gen2drv.get(tr);
      @(vif.cb_drv);
      vif.cb_drv.enable <= tr.enable;
      vif.cb_drv.req    <= tr.req;
    end
  endtask

endclass
