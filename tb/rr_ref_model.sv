class rr_ref_model #(int N=4);

  int unsigned ptr;

  function new();
    ptr = 0;
  endfunction

  function void reset();
    ptr = 0;
  endfunction

  function bit [N-1:0] step(bit enable, bit [N-1:0] req);
    bit [N-1:0] gnt_exp;
    gnt_exp = '0;

    if (enable) begin
      bit found = 0;
      for (int k = 0; k < N; k++) begin
        int idx = (ptr + k) % N;
        if (!found && req[idx]) begin
          gnt_exp[idx] = 1'b1;
          ptr = (idx + 1) % N;
          found = 1;
        end
      end
    end

    return gnt_exp;
  endfunction

endclass
