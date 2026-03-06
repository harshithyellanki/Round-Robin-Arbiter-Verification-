module tb_top;
  import tb_pkg::*;

  parameter int N = 4;

  logic clk = 0;
  always #5 clk = ~clk;

  rr_if #(N) rif(clk);

  rr_arbiter #(.N(N)) dut (
    .clk(clk),
    .rst_n(rif.rst_n),
    .enable(rif.enable),
    .req(rif.req),
    .gnt(rif.gnt)
  );

  //rr_assertions #(.N(N)) sva(rif);
rr_assertions sva(rif);
  rr_env #(N) env;

  initial begin
    env = new(rif, 10000); // 10k randomized cycles
    env.run();

    #200000;

    $display("====================================");
    $display(" TEST COMPLETE");
    $display(" SCOREBOARD ERRORS = %0d", env.sb.err_count);
    $display("====================================");

    if (env.sb.err_count == 0)
      $display("PASS");
    else
      $display("FAIL");

    $finish;
  end

endmodule
