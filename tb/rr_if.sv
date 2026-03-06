interface rr_if #(parameter int N=4) (input logic clk);

  logic rst_n;
  logic enable;
  logic [N-1:0] req;
  logic [N-1:0] gnt;

  // Driver clocking block: TB drives req/enable/rst_n, samples gnt
  clocking cb_drv @(posedge clk);
    output rst_n;
    output enable;
    output req;
    input  gnt;
  endclocking

  // Monitor clocking block: TB samples everything
  clocking cb_mon @(posedge clk);
    input rst_n;
    input enable;
    input req;
    input gnt;
  endclocking

endinterface
