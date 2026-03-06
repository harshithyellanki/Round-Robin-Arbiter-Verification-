module rr_arbiter #(
  parameter int N = 4
) (
  input  logic         clk,
  input  logic         rst_n,
  input  logic         enable,
  input  logic [N-1:0] req,
  output logic [N-1:0] gnt
);

  logic [$clog2(N)-1:0] ptr_q, ptr_d;
  logic [N-1:0] gnt_d;

  logic found;
  int k;
  int idx;

  always_comb begin
    gnt_d = '0;
    ptr_d = ptr_q; // default assignment
    found = 1'b0;
    
    if (enable) begin
      for (k = 0; k < N; k++) begin
        idx = (ptr_q + k) % N;
        if (!found && req[idx]) begin
          gnt_d[idx] = 1'b1;
          ptr_d      = (idx + 1) % N;
          found      = 1'b1;
        end
      end
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      gnt   <= '0;
      ptr_q <= '0;
    end else begin
      gnt   <= gnt_d;
      ptr_q <= ptr_d;//ptr q will take the value of ptr d after one cycle 
    end
  end

endmodule
